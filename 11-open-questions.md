# Open questions

The 29 July version of this record closed with three open questions; the 30 July revision added two. This revision **closes two, answers one with evidence, sharpens one, and adds two new ones** — and the two new ones are the most interesting, because they are about the project's own process rather than about BPMN.

All of them are decisions rather than unknowns, which remains a much better position than a technical wall.

## 1 · Is the run-level preservation theorem the right gate for widening admission? — **DECIDED 2026-07-30, and the replacement now has evidence**

**Resolution: no. The staged programme was superseded and replaced by a targeted per-capsule preservation gate.**

Seven proof stages, ~2,400 experimental Lean lines, and stage sizes not amortising (229 → 127 → 276 → 298) made this a stop-and-reduce signal on the project's own reflection criterion. Nothing was discarded — Stages 1–3b remain accepted, frozen experiments, and the graph-validation results *graduated* into production `programWellFormed`. The universal theorem retains an explicit reopen trigger.

**The live sub-question — "does the targeted gate stay local?" — is now answered: yes.** Six capsules closed under it and none needed a general bridge. The evidence is a family of theorems that did not exist before: exact closure figures per mechanism (three steps for Simple Boolean, four for Inclusive, two for Event-race arming, 3/3/2 for Call Activity) each paired with an *exhaustion* witness proving the figure is tight rather than merely sufficient. Where a genuinely new hazard appeared — the Inclusive Gateway's first *data-dependent* multiple-enabled state — the capsule closed a local activation-order equality rather than reaching for commutation. The reopen trigger never fired, and no capsule complained that it should have.

**There is also a second, unlooked-for confirmation.** The capability the seven stages were built to unlock — stop writing a compiler per topology — shipped anyway, by a different and cheaper route, once the theorem stopped gating it. The [profile-parameterized admission work](../bpmn-lean-experiment/docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md) removed the whole-topology predicates in ordinary implementation work, and an executable guard now prohibits reintroducing one.

Full account in [03](03-is-lean-goal-driven.md). What replaced this as the live cost question is question 6.

## 2 · Can one mechanism be generalised from a literal to a family? — **UNCHANGED**

This is now the central question of the whole project, and it is the one that did not move.

Sixteen bounded mechanism slices have closed excellently; **zero horizontal generalisations shipped.** Every implemented mechanism is still pinned to a literal: `PT1S` only, exactly two balanced branches, two conditional flows plus one default, one error code, one protocol binding, one in-document called Process, one level of scope, `string`-or-`null` values only.

The cheap calibration point named in the original is still the right one and still untaken: **take the timer from `PT1S`-only to a general ISO-8601 duration subset.** It touches admission, lowering, Lean normalisation, the core, the CIB controlled clock, and the Temporal durable timer — every lane — while introducing no new semantic mechanism at all. That makes it close to a pure measurement of what generalisation costs across the stack.

**One partial answer arrived, and it is worth reading carefully because it is easy to over-claim.** Admission *did* generalise: the graph-shape half is now one topology-independent validator, and profile capability is the per-profile half. That is a real horizontal generalisation, and the executable guard against a seventh whole-topology disjunct means it cannot regress. But it generalised the *structural* dimension only. No profile admits a *family* of models; each still enumerates its mechanism kinds and cardinalities. So the question stands, with its scope narrowed to the capability side.

**Two cautions, one carried forward and one new.** The previous revision warned that the Exclusive Gateway would not be this measurement — correct, and it was even less so than expected, since it shipped as a dependency-free language rather than the predicted cross-runtime integration. The new caution is larger: **six capsules have now been added without anyone attempting the generalisation**, and each addition makes the eventual measurement harder to read, because "what does generalising cost" gets confounded with "what does generalising cost *now that seventeen operations and four wait kinds exist*". The cheap calibration point is getting less cheap by attrition rather than by decision.

## 3 · Can the IL absorb scopes as a layer rather than a rewrite? — **LARGELY ANSWERED for one level**

The 30 July revision recorded the variable-scope half and called the hard half untested. **The hard half has now been done.**

The [ordinary embedded Sub-Process capsule](../bpmn-lean-experiment/docs/capsules/EMBEDDED-SUBPROCESS-COMPLETION-SPEC.md) introduced a canonical **definition-scope forest** in both the checked graph and the IL with exact node, flow, operation, and control-place ownership; **runtime scope occurrences** owning tokens and all four wait kinds; and — the part that shows it was a rewrite rather than an extension — it **removed `terminate`** in favour of `reachNoneEnd` plus quiescent `completeScope`, because reaching an end event and completing a scope are only the same thing in a flat model. The [Error propagation capsule](../bpmn-lean-experiment/docs/capsules/SUBPROCESS-ERROR-PROPAGATION-SPEC.md) then added regional cancellation of a child occurrence subtree with monotonic counter and root-work preservation.

That is parent chains, ownership resolution, interruption propagation, and token cancellation across a subtree — four of the five things previously listed as untested. All four have Lean relations, laws, non-laws (`regional_interruption_is_not_global_cancellation`, stranded-child non-resumability), independent TypeScript behaviour, four CIB-backed schedules, and Temporal evidence with **zero Child Workflow or cancellation events**.

**What that establishes:** the representation replacement was performed on the genuinely hard case and the proofs survived it. Cost was `+5266/-1698` then `+3370/-398`, and the second was cheaper because it reused the first — the ledger's own stated expectation, met.

**What it does not establish:** *depth and repetition*. Arbitrary nesting, repeated activation of one definition scope, loops that re-enter a scope, concurrent occurrences of the same child definition, and Event Sub-Processes remain absent. Every scope law assumes at most one level and one activation — nothing in `enterScope`'s shape prevents a second occurrence of the same child, but every closure bound and law assumes there is not one. Loops and multi-instance Activities are where this gets tested properly.

And note the asymmetry that survived: definition scopes nest one level, **variable scopes still do not nest at all**. `IMPLEMENTATION-MAP.md` still lists as absent *"variable-scope traversal, shadowing, or variable scope kinds beyond the implemented effect-local slice."* Those two dimensions were deliberately kept separate and only one grew.

So: the encouraging half and most of the hard half are answered; what remains is a smaller and more ordinary risk than "will the representation hold at all". See [04](04-feasibility.md#the-flat-state-concern-now-largely-answered-for-one-level).

## 4 · Is delegating expression truth to the pinned CIB runtime the right trade? — **OBSOLETE AS POSED**

The previous revision described the approved Exclusive Gateway capsule as handing exact expression source to the `org.cibseven.bpm.juel` runtime behind a Java Temporal Activity, and listed three genuinely open items: the deployment-time validation transport, the disposition of a suspended evaluation after exhausted attempts, and cross-SDK payload compatibility.

**None of that shipped.** Conditional routing shipped standards-first, with a project-owned [Simple Boolean language](../bpmn-lean-experiment/docs/SIMPLE-BOOLEAN-EXPRESSION-DECISION.md): one immutable URI, five total Boolean forms, `string | null` Process-scope context, **parsed and evaluated independently in Lean and in the TypeScript core**, hosted entirely inside pure internal closure with no evaluator Activity and no expression-specific Temporal Event. The [JUEL architecture](../bpmn-lean-experiment/docs/JUEL-EVALUATION-ARCHITECTURE-DECISION.md) remains owner-selected as *the* CIB compatibility approach, with its 38-jar graph audited and **unadopted**. All three open items belong to it and are dormant.

**Why the pivot is interesting rather than merely a schedule change.** The delegated design was chosen because writing an expression evaluator to gain coverage creates a permanent second source of truth for expression semantics. That reasoning is still correct — for JUEL. What it missed is that a *closed, total, five-form* language is small enough to transcribe twice and prove things about, so it does not create a rival truth account; it creates a bounded one with laws (`first_true_ignores_tail`, `selected_output_owned`). The trade was reframed rather than resolved: instead of "delegate or duplicate", the answer was "pick a language small enough that duplication is safe".

It also removed a portability coupling as a side effect ([08](08-swapping-temporal.md#and-one-coupling-that-was-retired-before-it-arrived)) and voided three of this record's own claims ([12](12-corrections-log.md#three-claims-this-record-itself-got-wrong)).

**The question that replaces it, and it is real:** the shipped language claims **zero** A12 adoption coverage — none of the 16 retained A12 condition occurrences uses its URI. So the standards-first choice bought a clean semantic account and *no* progress on goal 2. When a CIB or A12 expression-compatibility claim is actually needed, JUEL returns with all three open items intact, plus a new one: how two expression languages coexist for the same BPMN mechanism without the semantic core acquiring a language selector. `PROJECT-DESIGN.md` anticipates this — a second language must arrive as *"another language result to that BPMN mechanism through a separately approved compatibility capsule"* — but no capsule has tested whether that composes.

## 5 · What happens to the pre-release freedom when the first durable baseline lands? — **UNCHANGED, and more urgent**

A great deal of the project's current agility comes from a policy that will end by design: no retained Event History fixtures, no Workflow patch branches, no migration functions, no compatibility readers, no deployment fallbacks. Every gate starts clean state and discards it.

**Four days of atomic replacements are the strongest possible illustration of what that policy is worth.** `terminate` → `reachNoneEnd` + `completeScope`; the flat variable field → scoped variables; `MessageChannel` → a closed two-arm union across TypeScript, Lean, three schemas, Java, artefacts, and Temporal command identity. Each replaced *every* producer and consumer in one change with no parallel reader anywhere — and a pre-release infrastructure guard rejects embedded format counters, retired representation names, and compatibility paths so the policy cannot erode quietly.

None of those three would be a single change after a durable baseline. Each would need version markers, migration evidence, and retained histories.

`PROJECT-DESIGN.md` names five approvals that end this window: which artefacts become immutable, the Event History and version-marker baseline, migration/patching/rollback rules, retained replay fixtures and their provenance, and support windows with removal criteria.

**Why it became more urgent rather than less.** A runnable product command now exists, pointing at a caller-owned Temporal service. Nothing about it is a release — the spec says so plainly — but the distance between "we have a command a user could run" and "someone has data in a Workflow we must not break" is one deployment. The question is still sequencing rather than design: **how much semantic breadth should exist before that window closes?** Arguing "as much as possible first" is easy; the counter-argument is that a system with no users has no forcing function for the durability decisions, and those decisions get harder to make well in the abstract the longer they wait.

Worth deciding deliberately rather than discovering.

## 6 · Does the cost per mechanism fall, and if not, what is the plan? — **NEW, and now the binding constraint**

The previous revision worried that the cost never falls. The [capsule cost ledger](../bpmn-lean-experiment/docs/CAPSULE-COST-LEDGER.md) — created in this window, which is the right response to a complaint about unmeasurability — turns the worry into a measurement, and the measurement is not encouraging:

| Capsule | Code churn |
|---|---:|
| Inclusive Gateway | `+3123/-151` |
| Sub-Process Error propagation | `+3370/-398` |
| Receive Task | `+3805/-788` |
| Event-Based Gateway | `+4606/-63` |
| Embedded Sub-Process | `+5266/-1698` |
| **Call Activity** | **`+5801/-392`** |

Every genuinely new BPMN mechanism sits between 3,100 and 5,800 lines, with no downward trend and the largest figure most recent. Roughly forty mechanisms remain.

**The proof lane is no longer the bottleneck.** Question 1 established that proof obligations are now local and proportional. The bottleneck moved to breadth: source admission, wire schemas, Lean, the core, Temporal, differential artefacts, six owner documents, and a review cycle per capsule.

**Reuse demonstrably works where a seam exists.** Receive Task reused the entire Message Signal/ledger/bundle seam; Sub-Process Error came in below the completion foundation; Call Activity reused the whole User Task Update host and added no host mechanism. The ledger records these as intended.

**But reuse is not enough, because each mechanism opens a *new* seam.** Call Activity reused everything available and still cost 5,801 lines, because a second root definition, a distinct semantic instance identity, and paired invoke/return are genuinely new. That is the shape of the problem: the flat curve is not a reuse failure, it is the cost of novelty.

`CLAUDE.md`'s reflection checklist demands *"remove one identified process weight before starting the next capsule when the measured cost did not fall."* It is being honoured — the Receive Task closure removed a repeated Message-hosting weight — but the removals are small relative to the increases. **The open question is whether any lever exists that changes the slope rather than shaving it**, and only two candidates are visible: generalising a mechanism once (question 2, untaken), and admitting families rather than shapes (unproposed). Neither is scheduled.

This is not a crisis; it is an arithmetic problem stated honestly by the project's own instrument. A project that builds the tool showing its costs are not falling is telling you something reliable ([04](04-feasibility.md#the-cost-curve-finally-measured)).

## 7 · Is the review regime's cost proportional to its yield? — **NEW**

An executable independent-review regime arrived in this window and it is a genuine advance in rigour: cold proposal review, a conditional semantic-checkpoint review, and a governed closure review, each with a committed immutable target and a receipt whose SHAs an infrastructure guard resolves as `HEAD` ancestors from immutable baseline `f1ef362`. Cold reviewers are spawned with no shared conversation history (`fork-turns-none`) and must inherit the author's model and reasoning effort — no cheaper tier may substitute. Warm review is permitted only in named cases, chiefly the same reviewer auditing corrections to its own findings.

**It yields real defects.** The Call Activity closure review returned APPROVE WITH REQUIRED EDITS and caught a missing production refusal/retry witness plus a wrong history count; the correction commit separated host from semantic task addresses — a genuine identity bug in exactly the seam most at risk ([08](08-swapping-temporal.md#reason-3--host-identity-and-host-outcomes-are-already-typed-apart-from-semantics)). The Receive Task and Inclusive Gateway checkpoints each required corrections that landed. The regime is not ceremony.

**It is also cost, arriving precisely when the cost curve is already flat.** Every capsule now carries two or three review cycles with committed targets and audited receipts, and the governance documents themselves are substantial. The project has priced some of it in — stage-specific review focus, static findings before CPU-heavy gates, target-bound neutral review packets, one combined checkpoint/closure review for genuinely single-lane closures, and a deleted temporary pending-lane barrier — which is the reflection checklist working on the review regime itself.

**What is genuinely open** is whether that is enough, and the honest answer is that nobody can tell yet, because the instrument does not measure it. The cost ledger measures *code and documentation churn*, explicitly not *"proof strength, test independence, JSON evidence volume, generated output, or wall time"* — and review effort is none of the things it counts. Elapsed time is recorded as `Unknown` for every row for want of reliable timestamps, which is the correct refusal but leaves the question unanswerable from the ledger.

Two sub-questions worth naming:

- **Attribution.** Call Activity's range absorbs one unrelated review-process commit, and the ledger says so rather than subtracting it. That is the right call for honesty and the wrong shape for measurement: review-infrastructure work and feature work are landing in the same measured ranges.
- **The `fork-turns-none` attestation.** The guard verifies that a receipt *records* context isolation and no model override; `CLAUDE.md` states plainly that *"Git cannot independently verify either runtime fact."* So the strongest guarantee in the regime rests on an attestation, and the project says so. That is the honest position, and it is also the one place where the executable guard is weaker than it looks.

## The shape of all seven

None of these is a technical wall. Two are closed, one is largely answered, one was reframed rather than resolved, and three are cost or sequencing questions.

The distribution moved in a specific direction, and it is worth stating: **the semantic and proof risks have largely resolved, and what remains is economics.** Questions 1 and 3 were the frightening ones two revisions ago — will the proof programme ever pay, will the representation survive scopes — and both went well. Questions 6 and 7 are new and are both about whether the project can afford its own standards at forty-mechanism scale.

That the questions can be posed this precisely is downstream of the thing worth crediting most: the project refuses to fake its own numbers, keeps three coverage denominators separate, documents absences more carefully than presences, deleted its own vacuous theorems, declares six profiles to have no oracle lane rather than manufacturing one, and built the cost instrument that now shows its costs are not falling. The supersession recorded in question 1 was only possible *because* seven stages of honest cost data existed to look at. Question 6 exists on the same basis, and will presumably be answered the same way.
