# Scopes, quiescence, and cancellation

## Three different things called "scope"

The word is overloaded, and conflating any two of them makes the rest of this document unreadable. The project keeps them strictly apart:

| Concept | What it owns | Nests? |
|---|---|---|
| **Definition scope** | *Static* ownership in the checked graph and IL: which nodes, Sequence Flows, operations, and control places belong to which Process or embedded Sub-Process | one level today; existing profiles are one rooted tree, the Call profile adds a second parentless root |
| **Runtime scope occurrence** | *Dynamic* ownership: which occurrence owns which tokens and waits, so a child can complete while its parent continues | one root plus at most one level of parent-linked child, or one occurrence-linked called root |
| **Variable scope** | Runtime *data* ownership: one Process scope (public) plus private Activity-local scopes keyed by complete effect occurrence | **no — not at all** |

The third row is the surprise. Definition and runtime scopes grew a level; variable scopes did not. `IMPLEMENTATION-MAP.md` still lists as absent *"variable-scope traversal, shadowing, or variable scope kinds beyond the implemented effect-local slice."* A child Sub-Process does **not** get its own variable scope. Those two dimensions were deliberately decoupled, and only one moved.

Why that decoupling is defensible: BPMN's *structural* nesting and BPMN's *data visibility* rules are separate concerns with separate ambiguities, and coupling them would have meant deciding both in one capsule. It is also a real limitation — a Sub-Process-local variable is not expressible today.

## The change that proves it was a rewrite, not an extension

`terminate` was removed.

That single fact carries most of the story. A flat Process can conflate two things that a Process with a child scope cannot:

- **a none End Event was reached** — an event occurrence, recorded;
- **this scope is finished** — a *quiescence* judgement about an entire owned region.

In a one-scope model those coincide, so one opcode looked sufficient. Once a child scope exists, a child's End Event must not end the Process, and the child must complete only when nothing it owns is still live. So:

| Before | After |
|---|---|
| `terminate` | `reachNoneEnd` — records the end occurrence |
| | `completeScope` — fires **only on quiescence**, removes the child, emits exactly one parent-owned continuation |
| — | `enterScope` — child entry structure |
| — | `invokeProcess` / `returnProcess` — the called-Process pair |

Read against the IL's own growth rules ([05](05-semantic-core-and-il.md#two-things-worth-flagging-about-the-il)), the notable thing is what was *not* done: no flag was added to `terminate`, and no `terminateChild` opcode appeared. The repair was to notice that one operation was two mechanisms and split it — the same *"no universal `event` operation with a bag of flags"* rule applied to an operation that already existed.

One consequence is easy to miss and is quoted in the lowering table: a child scope's None Start Event becomes **entry structure**, not a second `initiate`. There is exactly one root initiation per program. A child scope beginning is not a Process beginning, and the IL refuses to let the two look alike.

## Quiescence is the load-bearing idea

"When is a child scope finished?" is the question the whole capsule turns on, and the answer is deliberately strong:

> exact child completion only after the owned region has **no token, no wait, and no child occurrence**

Three separate emptiness conditions, not one. A region with no tokens but a live wait is not finished. A region with no waits but a stranded child occurrence is not finished either — and that case has its own non-law, **stranded-child non-resumability**, proving a parent cannot complete over a surviving child.

The laws that pin this down are worth reading as a set, because each refutes a different plausible shortcut:

| Law | Refutes |
|---|---|
| `first_child_end_does_not_complete_scope` | "the child's End Event completes the child" |
| `outer_task_completes_root_scope` | conflating child completion with root completion |
| `child_completion_order_has_same_parent_observation` | order-dependence leaking to the parent |
| generic nonquiescent-completion refusal | completing a scope with anything still owned |
| stranded-child non-resumability | a parent proceeding over a surviving child occurrence |

The first is the sharpest. With two child branches, one branch reaching its End Event is the moment a naive implementation would complete the scope — and the theorem says it must not, because the sibling is still live.

## Regional cancellation: the hard half

Ordinary completion is the cooperative case. The [Error propagation capsule](../bpmn-lean-experiment/docs/capsules/SUBPROCESS-ERROR-PROPAGATION-SPEC.md) added the uncooperative one: an Error End Event inside the child, one exact-code handler attached to the directly enclosing Sub-Process, and **atomic cancellation of the child occurrence subtree**.

What "atomic" has to mean here is precise:

- the child occurrence subtree is removed across **every runtime owner kind** — tokens, User Task waits, Message subscriptions, timers, effects, selected-branch records, races, call records;
- **monotonic counters are preserved.** Activation counters do not roll back. A cancelled task's activation number is spent forever, so a later command carrying the old activation cannot succeed;
- **root-owned work survives.** Cancellation is *regional*, and `regional_interruption_is_not_global_cancellation` is the checked non-law making that explicit;
- the **normal child output becomes unreachable**, not merely unused — `throw_precedes_unreachable_normal_completion`;
- exactly one parent-owned boundary continuation is emitted.

The counter-preservation point is the one that would be easiest to get wrong and hardest to notice. Rolling activation counters back on cancellation would look tidy and would silently make replayed or retried commands from before the throw acceptable again. In a durable host that is a correctness bug, and it is the same concern that drives [07 challenge 4](07-temporal-adapter.md#challenge-4--duplicate-and-retried-commands).

**The best-named theorem in the repository lives here:** `sibling_first_has_same_public_recovery_not_same_history`. It asserts an equality *and* an inequality in one statement — two command orders reach the same **public** recovery state while differing in hidden End-occurrence counts. That is precisely the boundary the entire comparison architecture rests on, turned into a checked proposition instead of a convention. Most projects would have proved the equality and mentioned the difference in a comment.

## Call Activity: a second root, not a child

A called Process is *not* a nested scope, and the distinction is structural:

| | Embedded Sub-Process | Call Activity |
|---|---|---|
| Definition scope | child, parent-linked | **second, parentless root** |
| Runtime occurrence | parent-linked child | occurrence-linked parentless root |
| Semantic instance identity | same Process instance | **one distinct called instance** |
| IL | `enterScope` + `completeScope` | paired `invokeProcess` + `returnProcess` |

So the definition forest genuinely became a *forest* rather than a deeper tree — existing profiles keep one rooted tree, and the Call profile adds one distinct parentless called root.

Two properties are doing the real work. The called instance identity is **UTF-8-length-prefixed**, with `delimiter_and_non_ascii_identity_uses_utf8_lengths` proving the prefix counts bytes rather than code points — otherwise a multi-byte or delimiter-bearing process name could forge a colliding identity. And the caller's User Task identity is **derived from the owner**, so a caller-shaped command cannot complete a called task: `caller_identity_cannot_complete_called_task`.

The hosting refusal matters as much as the semantics. A BPMN Call Activity looks *exactly* like a Temporal Child Workflow, and the project refused that mapping — the called Process runs inside the same Workflow, and histories are asserted to contain **zero Child Workflow or cancellation events**. The reason is identity: a Child Workflow would make the called instance's identity a *host* identity, so BPMN semantic instance identity would derive from Temporal. Closure review found the two addresses confused anyway, and commit `4eaa0eb` separated them ([08](08-swapping-temporal.md#reason-3--host-identity-and-host-outcomes-are-already-typed-apart-from-semantics)). A seam broken once and repaired with a permanent identity-erasure guard is a seam you can trust more than one never loaded.

## Hidden state, and the two obligations it creates

Every mechanism here introduces runtime state that is **not publicly observable**: scope occurrences, selected-branch records, races, call records. That creates a pair of obligations that are easy to confuse and must both be met:

1. a **non-projection** theorem — the state never enters the canonical observation;
2. a **discriminator** — its effects are nonetheless detectable *through* the public surface.

Meeting only the first gives you state nobody can verify. Meeting only the second breaks the observation contract. The Call Activity witness is the cleanest instance: the called identity is never projected, yet erasing it **inverts the Query identity**, so the erasure is caught through a surface that never exposes the value.

The corresponding negative witnesses are unusually careful. `duplicate_identity_record_with_one_otherwise_valid_disables_return` keeps one record *genuinely valid* so the theorem cannot pass by everything being broken — hypothesis hygiene applied to a negative witness. `zero_activation_record_is_nonresumable_and_has_no_return` and `called_scope_alias_is_nonresumable_and_has_no_return` prove that a corrupted hidden association leaves the process **stuck rather than guessing**, which is the right failure direction for a durable engine.

## What one level bought, and what repetition would break

**Bought — and this answers the structural worry that opened [04](04-feasibility.md#the-structural-worry-about-flat-state-and-how-it-turned-out):** parent chains, ownership resolution, interruption propagation, and token cancellation across a subtree all exist, with Lean relations, reusable laws, non-laws, independent TypeScript behaviour, four CIB-backed schedules, and Temporal evidence. The representation replacement was performed on the genuinely hard case and the proofs survived it. Cost was `+5266/-1698` then `+3370/-398`, the second cheaper because it reused the first.

**Not bought:** depth and repetition. Explicitly absent are *"arbitrary or repeated nesting, loops that reactivate one definition scope, and concurrent occurrences of the same child definition"*, plus Event Sub-Processes, Transactions, compensation, general cancellation, and handler search beyond one direct parent.

The shape of that gap is worth stating precisely, because "one level" undersells the difficulty of the next step. Nothing in `enterScope`'s *type* prevents a second occurrence of the same child definition — it carries a `childScopeId` and could name the same one twice. What prevents it is that **every law and every closure bound assumes there is not one.** The exact closure figures of [09 category K](09-property-inventory.md#92-proven-today--by-category-with-representatives) are per-mechanism constants; a scope that can be re-entered has no constant. Quiescence is currently decidable by inspecting one region; with concurrent occurrences of one definition it becomes a question about *which* occurrence.

So loops and multi-instance Activities are not "more of the same". They are where the current shape genuinely stops, and they are also where the adapter's single-host-driven-wait bound ([13](13-admission-and-profiles.md#host-capability-is-not-semantic-admission)) starts binding, since repetition tends to produce concurrent waits.

## The one thing to take away

The flat-to-scoped replacement is the closest thing this project has to evidence that its assurance discipline can absorb a **representation change** rather than only accumulate features. Three atomic replacements sit behind it — the `terminate` split, flat variables to scoped variables, `MessageChannel` to a closed union — each touching every producer, consumer, schema, fixture, and mutation with no parallel reader anywhere. That is only possible under the pre-release policy forbidding compatibility paths ([08](08-swapping-temporal.md#reason-2--no-history-compatibility-debt-exists)), and it is the strongest argument for closing that window later rather than sooner ([11 §5](11-open-questions.md#5--what-happens-to-the-pre-release-freedom-when-the-first-durable-baseline-lands))).
