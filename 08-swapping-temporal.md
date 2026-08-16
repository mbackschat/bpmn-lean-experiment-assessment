# Could Temporal be swapped later?

> *Question: would it be feasible to exchange Temporal later with a different durable-execution engine?*

Feasible — and the project is in unusually good shape for it. Three structural reasons, all verifiable from the current tree. Read [07](07-temporal-adapter.md) first if you want to know what would actually be replaced.

Three couplings constrain the choice, and they are not equally hard. Two are about *API shape* — does a candidate platform offer this kind of call. The third is about *runtime scheduling behaviour*, and it is the only place where the project's correctness argument rests on a behavioural property of Temporal itself.

## Reason 1 — the semantic core has no host dependency, verifiably

Not just documented; measured. Running

```sh
rg -n "temporalio|bpmn-moddle|node:" packages/semantic-core/src/
```

returns **nothing** across all 62 core modules and 13,092 nonblank lines. No Temporal SDK, no BPMN parser, not even a Node.js built-in. `IMPLEMENTATION-MAP.md` lists "Temporal SDK" in the core's *explicitly absent* column, and the code agrees.

**Host independence and *layer* independence are different claims, and both hold.** The grep above establishes the first. The second is that no A12 delegate bean name, Camunda extension namespace, or target-model discriminator appears as a literal type or admission predicate in the core or in Lean's production lowering — effect protocols and operations are profile-registered URNs instead. That distinction is worth knowing because layer independence was once false while host independence was already true, so a grep for SDK imports would have reported a clean bill of health over a real leak. Roughly twenty capsules have closed since the descriptor became neutral and **none touched it** ([05](05-semantic-core-and-il.md#the-effect-descriptor-is-neutral)).

The decision that closed the more dangerous leak is recorded as "R5": current-state task projection, stimulus well-formedness, command identity, and same-stimulus comparison were all moved behind core-owned operations, so *"the Workflow now delegates instead of scanning trace history or maintaining policy copies."*

A thin, delegating Workflow is a replaceable Workflow, and the ratio is the measurement: `packages/temporal-adapter/workflow/src/workflow-implementation.ts` is **561 nonblank lines** hosting a twenty-four-operation IL, because most operations are internal closure the host never sees.

The adapter subsystem is six workspace packages, and the distribution is the point:

| Package | Nonblank `src` | Role |
|---|---:|---|
| `testkit` | 7,548 | ephemeral servers, deliberately-wrong Workflows, mutations, evidence extraction |
| `protocol` | 3,539 | contracts, identity, transport, host admission — **no Temporal SDK dependency** |
| `workflow` | 3,390 | production hosting: the Workflow, its schedulers, publication state |
| `client` | 2,460 | production ingress and lifecycle resolution |
| `runner` | 669 | the product command's composition |
| `worker` | 189 | bundling and Worker lifecycle |

Two readings matter here. **`protocol` carries no Temporal SDK dependency at all**, so a third of the production surface is already host-neutral by construction rather than by discipline. And **`testkit` alone is larger than all five production packages combined** — the deliberately-wrong Workflows, ephemeral servers, and history decoding outweigh the hosting they exist to check. That ratio is the real answer to "what would a swap cost", and the next section is why.

## Reason 2 — no history-compatibility debt exists

This is normally the thing that makes durable-execution platforms impossible to leave. In-flight instances replay against recorded histories, so their behaviour depends on the exact code shape that produced them. Over time you accumulate version markers and `patched()` branches, and every one is a permanent migration obstacle.

The pre-release policy forbids exactly that until a durable baseline is explicitly approved:

| Debt item | Status |
|---|---|
| Retained Event History fixtures | absent |
| Workflow version / patch branches | absent |
| Migration functions | absent |
| Deployment fallbacks | absent |
| Compatibility readers, embedded format counters | absent |

Every local gate *"starts clean state, replays histories produced during that gate, and discards the server state afterward."* So there is **nothing to migrate** — 62 histories are created, replayed, and thrown away per pipeline run.

The policy is not merely stated; it is guarded. A pre-release infrastructure guard rejects embedded format counters, retired representation names, and milestone compatibility paths. That is what makes atomic replacement possible at all: splitting `terminate` into `reachNoneEnd` plus `completeScope`, replacing the flat variable field with scoped variables, and replacing `MessageChannel` with a closed two-arm union each touched *every* producer, consumer, schema, fixture, and mutation in one change, with no parallel reader anywhere.

This is a deliberate, temporary state with a named exit. `PROJECT-DESIGN.md` lists five things the owner must approve before the first immutable release or persisted production history — which artefacts become immutable, the Event History baseline and version markers, migration/patching/rollback rules, retained replay fixtures and their provenance, and support windows. From that point on, history compatibility becomes mandatory evidence based on real retained state. **The window in which swapping is cheap is the window before that approval.**

## Reason 3 — host identity and host outcomes are already typed apart from semantics

These are stated invariants, not intentions:

- *"Definition identity, semantic instance identity, and host-runtime identity remain distinct."*
- *"Temporal transport retries remain distinct from CIB-visible retries and incidents."*
- The typed `semantic` / `processClosed` / `processUnknown` ingress result is explicitly adapter-owned and *"kept outside semantic outcomes."*
- Query and canonical result projections are verified to contain no Workflow ID, Run ID, or Update ID.

Those are the seams you would cut along, and they already exist — with tests asserting the absence of host identity in projections, which is stronger than a convention.

**The Call Activity capsule stress-tested this seam and found a real bug in it**, which is better evidence than the invariant surviving untested. A BPMN Call Activity is the one construct where host and semantic identity are most tempting to conflate: the obvious hosting is a Child Workflow, and then the called Process's identity *is* a Temporal identity. The project refused that mapping and hosted the called Process inside the same Workflow — and its closure review still found the two addresses confused in the lifecycle owner. Commit `4eaa0eb` (`fix(temporal): separate host and task addresses`) fixed it, and an identity-erasure mutation now guards the class permanently. A seam that has been broken once and repaired with a guard is a seam you can trust more than one that has never been loaded.

Worth adding: `applyStimulus` — one stimulus in, committed state plus observation out — is a **pure state-machine step**. That is the most portable shape possible for a durable host to drive. A callback-based or event-sourced core would have been far harder to move.

## What would actually be rebuilt

```mermaid
flowchart LR
    subgraph KEEP["Reusable unchanged"]
        K1["Lean — entirely"]
        K2["semantic-core<br/>(13,092 lines)"]
        K3["CIB oracle lane"]
        K4["checked graph + IL + schemas"]
        K5["30 profiles, 51 cases,<br/>retained CIB evidence"]
        K6["tuple encoder +<br/>deterministic SHA-256"]
    end
    subgraph SMALL["Rewritten — modest"]
        S1["Workflow function<br/>and semantic loop"]
        S2["handler registration<br/>and draining"]
        S3["Activity definition<br/>and retry policy"]
        S4["client / starter / MVP command"]
        S5["instance-ID derivation"]
        S6["host-capability predicate"]
    end
    subgraph BIG["Re-earned — the real cost"]
        B1["focused host tests"]
        B2["102 isolated executions"]
        B3["62 replayed histories"]
        B4["explicit schedules: ordered, post-terminal,<br/>concurrent, worker-down-at-timer,<br/>worker-down-at-effect, worker-down-in-both<br/>race directions, worker-down-after-throw"]
        B5["~12 bypass mutations, incl. the<br/>barrier and SDK-premise ones"]
        B6["readiness batching + fail-closed<br/>ordering argument — <b>from scratch</b>"]
    end
```

The dominant cost is **evidence, not code**, and the gap is wide. Proving "the runner never delivers a timer stimulus, the Workflow derives it from committed state, and the execution history contains the exact timer mechanism" is a claim *about Temporal's history format*. You cannot port that; you re-earn it against the new host. Same for the bypass mutations, which are the only thing standing between "the durable mechanism was used" and "the result happened to be right".

Box `B6` is new and is the one that would genuinely hurt. See the third coupling below.

A pleasant irony in the "keep" column: the hand-rolled deterministic SHA-256 and canonical tuple encoder exist *only* because Temporal Workflows cannot call native crypto without breaking determinism. They are host-neutral, and they would remain useful anywhere.

## The three couplings that would constrain your choice

### 1 · Update-shaped command ingress

The production lifecycle is built on **Temporal Updates**: content-bound Update IDs, `REJECT_DUPLICATE`, accepted-handler draining, and retained-Update-first result resolution with retention-bounded recovery.

Abstractly, that is: *a synchronous request into a running instance, deduplicated, whose result is durably re-readable afterwards.*

Durable-execution platforms diverge sharply on exactly this axis:

| Ingress style | Fit |
|---|---|
| Durable RPC into keyed objects with idempotency keys (Restate-style virtual objects) | Maps well — arguably better, since per-key serialisation hands you ordering you currently arrange by hand |
| Idempotency-keyed workflow invocation (DBOS-style) | Maps with moderate work; the "re-read a previous command's result" story differs |
| Fire-and-forget external events only | Forces a genuine protocol change — returning a semantic outcome synchronously is not a primitive there |

Two related pieces would need re-deciding rather than porting. "Retention-bounded accepted-result recovery" is a policy borrowed from Temporal's retention semantics; it is already correctly classified as adapter-owned rather than BPMN semantics, but every platform answers "how long can I fetch a completed command's result" differently. And the `processClosed` / `processUnknown` distinction exists precisely *because* Temporal cannot tell "never existed" from "expired" — a platform with different retention behaviour might collapse or refine that union.

### 2 · Signal-shaped fire-and-forget ingress, with a project-owned result ledger

**This one *reduces* coupling rather than adding it.**

Message delivery arrives as a Temporal **Signal** — fire-and-forget, no return value. Since BPMN delivery has a semantic outcome the caller needs, the adapter built its own ordered durable **result ledger** beside it, readable through a Query and recoverable from the completed receipt.

That is the bottom row of the table above, already solved with project-owned code. The interesting consequence for portability is that a platform offering *only* fire-and-forget events — the row marked "forces a genuine protocol change" — is now substantially less scary than it was, because the outcome-returning layer exists as adapter code rather than as a platform feature. Whichever ingress a new host provides, one of the two patterns already has a project-owned answer.

### 3 · The pinned SDK's activation-batching behaviour — the sharp one

**Genuinely new, and qualitatively different from the other two.** Couplings 1 and 2 are about *API shape*: does the platform offer this kind of call? This one is about *runtime scheduling behaviour*, which is a much harder thing to check a replacement against.

The Event-Based Gateway must commit exactly one winner when a Message and a Timer compete. The hazard is that both readiness callbacks can arrive in the **same Workflow activation**, and callback order within an activation is a host scheduling detail. Letting it decide would make Temporal choose a BPMN outcome.

The adapter's answer tags every callback with the current activation, requires a microtask drain to close that activation before classifying the batch, and **fails closed** with typed `BpmnEventRaceOrderingUnavailable` if both competitors are in it — rather than picking a winner by any rule.

The correctness of that mechanism rests on a behavioural premise: *the installed SDK really does deliver these callbacks in one activation, and a microtask drain really does close it.* The project handled this the right way — it pinned the premise with a direct job-level witness against the installed SDK, and made **removing the premise a failing mutation**, alongside mutations for removing the barrier, imposing a fixed priority, and bypassing core selection.

For a swap, that means:

- the mechanism is **not portable as designed**. A different host's concurrency model may batch differently, not batch at all, or expose no activation concept — in which case fail-closed detection has to be re-derived from that host's actual semantics, not adapted from this one;
- but the *contract* is portable, and it is the valuable part: **coalesced readiness must be detected and refused, never silently ordered.** A new host needs its own answer to "how do I know two things became ready together?", and the project already knows that question must be answered rather than assumed;
- and the guard set ports as a specification. "Removing the ordering premise must fail" is host-independent even when the premise itself is not.

This is the first place the project depends on Temporal's behaviour rather than its API, and it is worth saying plainly that it is a real constraint. It is also handled about as well as such a dependency can be: named, tested, and mutation-guarded rather than assumed.

### And one coupling that was retired before it arrived

A fourth coupling would exist under the delegated JUEL architecture: a **Java** Activity Worker on a dedicated task queue for the pinned CIB runtime, plus a transport for deployment-time expression validation, adding a cross-SDK payload contract to the swap surface.

None of it exists. Conditional routing is implemented with a project-owned Boolean language evaluated inside pure core closure, and JUEL is deferred with its dependency graph audited and unadopted. The swap surface is smaller as a result, and the reason generalises: choosing a dependency-free total language over delegating to a pinned runtime removes a portability coupling as a side effect of a semantics decision.

## What to do now: nearly nothing

Do **not** build a host-abstraction layer. There is no second host consumer, and the project's own rule is to name a concrete consumer before generalising.

Two cheap, worthwhile things, both documentation-only:

1. **State the ingress requirements as host capabilities**, not as lists of Temporal features — *"synchronous, deduplicated, durably-resolvable command ingress with a re-readable result"* for coupling 1, and *"at-least-once event ingress"* for coupling 2, since the result ledger is already project-owned. That turns a future migration question from "how do we emulate Updates?" into "does this platform provide the capability?".
2. **State the ordering requirement as a host capability too**, which is the newer and more valuable one: *"a way to observe that two external readiness signals arrived together, so coalesced readiness can be refused rather than ordered."* Right now that requirement is expressed as an activation-tagging implementation plus a pinned-SDK premise. A replacement host would need the requirement, not the implementation — and the requirement is the thing nobody would think to look for unless it was written down.

Both are framing, and framing now is the one place where a sentence saves real work later.

> **Confidence note.** `TEMPORAL-PROCESS-LIFECYCLE-SPEC.md`, `workflow-implementation.ts`, `host-admission.ts`, and `event-race-readiness-scheduler.ts` were read in full for this assessment. The activation-batching coupling described above is only visible by reading the scheduler module — it is not stated as a portability constraint anywhere in the project's own documents — which is why the third coupling is the one most likely to be missed by someone evaluating a migration from the specifications alone. The remaining unread surface is the full Temporal research document; its open-decisions list is summarised in [07](07-temporal-adapter.md) and [11](11-open-questions.md).
