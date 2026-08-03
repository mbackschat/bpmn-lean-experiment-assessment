# Corrections log

This document tracks every claim in earlier versions of this record that a later review or a later commit falsified, plus its current disposition at commit `5b65954`. It exists so that a reader who saw the 29 or 30 July version can tell which warnings still apply.

Two patterns are worth noticing across the whole set. First, most findings were closed by *correcting an over-strong claim* rather than by changing behaviour — the code was usually doing something defensible and the sentence about it was too confident. Second, and newer: **three of the previous revision's own forward-looking claims turned out wrong, all in the same direction.** They assumed the next capsule would be the JUEL-delegated Exclusive Gateway, and the project shipped something else. Predictions about unbuilt work are the least reliable content in a document like this, and that is now measured rather than asserted.

## The four corrections carried from the original document

### 1 · "Mutation guards prove each comparison is live" — **RESOLVED as doctrine**

**Original claim.** Every new evidence projection ships with a seeded defect the comparison must catch, proving the comparison is live.

**What review found.** Most mutations are applied to a clone of the TypeScript core's *own* canonical output and then compared against the reference. Those prove only that the comparator is field-sensitive. They prove nothing about whether the CIB projector, retained evidence, Lean, or Temporal would surface a real behavioural difference. `TESTING-SPEC.md` described all of them as projection guards, which was imprecise.

**Current disposition.** The distinction is a named rule in `TESTING-SPEC.md`'s evidence-lane table, separating **comparator-side** from **verifier-side** mutations and stating outright that *"a comparator-side mutation establishes nothing about the evidence projection."* The pipeline description now also says which is which per case: comparator mutations are *"applied to an immutable clone of the semantic core's canonical result before comparison"*, while gateway selection substitutions, Message Signal payload and history substitution, direct-channel erasure, Event-race scheduler and core bypasses, scope bypass, and Error-propagation bypass are *"exercised at the Workflow definition/history boundary"*, and raw-to-canonical CIB projection is *"separately exercised by verifier-side mutations in the contract gate."*

The vocabulary now forces every future author to declare which kind they wrote — a better outcome than adding more mutations of the weaker kind. The mutation *count* also grew substantially with the new capsules, and the newer ones lean more heavily on the definition/history boundary than on comparator clones.

Detail: [02 §4](02-evidence-and-lanes.md#4--mutation-guards--evidence-that-the-evidence-works).

### 2 · "Lean re-derives lowering, so the lanes are decorrelated" — **RESOLVED as a prominent qualifier; the underlying correlation is unchanged**

**Original claim.** Lean recomputing the lowering decorrelates the Lean lane from a TypeScript translation bug.

**What review found.** True only for **checked graph → IL program**. The **BPMN XML → checked graph** step has a *single* producer, `packages/bpmn-source/src/checked-process-compiler.ts`, feeding Lean, the core, and Temporal. Lean has no XML parser. A misread element ID, attachment, mapping target, duration literal, or flow direction propagates identically into three of four targets.

**Current disposition.** The qualifier sits in paragraph two of `IMPLEMENTATION-MAP.md`'s **Current claim** — the first thing any reader encounters — with the exact mechanism spelled out.

**And it got sharper, not weaker.** That paragraph now adds a second clause the previous revision could not have written: *"Pinned CIB Seven can separate that defect only for a declared CIB profile whose exact source it executes; the standards-only Simple Boolean profile has no such source-level oracle and states that limitation explicitly."* Ten of the 28 registered pipeline cases are now standards-only. For those ten, the one lane that could catch an XML-to-graph misread **does not run at all**. This is a real widening of the residual, honestly recorded, and it is the single most important thing in this log.

Detail: [02](02-evidence-and-lanes.md#but-the-decorrelation-is-narrower-than-that-diagram-suggests), [06](06-typescript-core-correctness.md#1--a-shared-schema-frozen-input-contract--with-lean-re-deriving-it).

### 3 · "`active_wait_projection_orders_by_kind_then_element_id` locks kind-then-element ordering" — **NOW FULLY RESOLVED IN CODE**

**Original claim.** The theorem locks kind-then-element-ID ordering across implementations.

**What review found.** It proved the **kind half only** — the fixture had one wait per kind. Four implementations followed three different rules, and a correction recorded in `PLAN.md` as landed had reached Lean and the core but never the Java projector or the evidence verifier.

**Disposition in the 30 July revision.** Partly code, partly claim: three implementations were fixed to kind-then-element-ID, Lean still concatenated by kind with *no* within-kind sort, and the documentation was corrected to say so with a named premise and reopen trigger. That was recorded here as the right *shape* of resolution rather than a complete one.

**Current disposition — the reopen trigger fired, and the fix landed.** Adding the Message wait kind changed the closed wait-kind domain, which by owner decision 6 required exactly this to be reopened. The [Intermediate Catch Message capsule](../bpmn-lean-experiment/docs/capsules/INTERMEDIATE-CATCH-MESSAGE-SPEC.md) states the obligation in its own words: implementation *"must replace Lean's current within-kind program-order premise with an explicit element-ID sort, matching the TypeScript and CIB projectors,"* and explicitly declines the cheaper alternative because *"an order-coincidence theorem … would preserve the fragile ID-sorted-program premise that this domain change is required to reopen."*

`BpmnSemantics/SemanticProcess/Scenario.lean` now ends its projection with

```lean
  sortActiveWaitsByElementId taskWaits ++
    sortActiveWaitsByElementId messageWaits ++
    sortActiveWaitsByElementId timerWaits ++
    sortActiveWaitsByElementId effectWaits
```

and the fixture grew to four kinds with a **reverse-ordered same-kind pair** (`Z_UserTask` stored before `B_UserTask`), so the theorem now discriminates the element half as well as the kind half. Its docstring says exactly that: *"This four-kind lock makes a global element-ID sort disagree with semantic-kind order and reverses the two User Task definitions so the projection must also sort by element ID within a kind."* All four implementations now agree on both halves.

| Implementation | Rule today |
|---|---|
| `packages/semantic-core/src/scenario.ts` | kind rank, then element ID |
| `runners/…/CibSevenActiveWaitProjector.java` | kind rank, then element ID |
| `scripts/contract-cib-evidence-projection.ts` | kind rank, then element ID |
| `BpmnSemantics/SemanticProcess/Scenario.lean` | kind rank, then element ID — **fixed** |

**A fourth round closed the documentation behind the fix.** This review found that `PLAN.md`'s narrative paragraph still read *"Lean groups by kind with within-kind order following program operation order; this satisfies `PAR-PROJECT-01` only while admitted programs are ID-sorted and mixed or repeated same-kind waits are unreachable"* — correct when written, false once the trigger fired. Commit `e873ec7` replaced it with the discharged outcome: the reopen trigger fired, the Intermediate Catch Message capsule added element-ID sorting within all four kind groups plus the reverse-ordered fixture, *"All four projectors now order active waits by semantic kind rank and then element ID; the former ID-sorted-program premise no longer applies."*

Note that the paragraph was rewritten rather than deleted — it still records that the defect existed and was corrected in stages. Owner decision 6, which records the reopen requirement *as a decision*, was deliberately left untouched, because a decision record stays accurate even after the decision is discharged.

Detail: [01 §1.10](01-theorem-techniques.md#110-refusing-to-let-collection-order-become-semantics).

### 4 · "Layering verified: the core's host- and parser-independence is real" — **RESOLVED in code**

**Original claim.** A grep for host imports returns nothing, so the core has no host dependency.

**What review found.** The grep was too narrow. Host independence held; **layer** independence did not. A12 delegate bean names formed a closed union in the IL's `EffectDescriptor`; A12 data shapes were literal types enforced as admission predicates; the Camunda namespace and extension attribute names were pinned inside `CheckedNode`; and Lean's production `Lowering.lean` carried the same bean-name table. `CLAUDE.md` states plainly that A12 bean names and data shapes *"stay out of the BPMN core, Lean account, Semantic Process IL, and pure TypeScript semantic core."*

**Current disposition — fixed, and the predicted payoff arrived.** Commit `b0a4002` replaced them with profile-registered opaque identities (`urn:bpmn-lean:effect-protocol:activity-v1`, `urn:bpmn-lean:effect-operation:mapped-success-v1`, …). `IMPLEMENTATION-MAP.md`'s core row reads *"profile-registered opaque effect protocol/operation identities with no Camunda namespace, A12 bean, or target-model discriminator."*

The reviewer predicted that widening a vendor-neutral capsule would stop requiring edits to a closed union of product bean names in the semantic core. Six capsules have since closed — Inclusive Gateway, Event-Based Gateway, Call Activity, Receive Task, and both Sub-Process capsules — and none of them touched the effect descriptor. The prediction held.

Detail: [05](05-semantic-core-and-il.md#the-effect-descriptor-is-neutral--and-it-was-not-always), [08](08-swapping-temporal.md#reason-1--the-semantic-core-has-no-host-dependency-verifiably).

## Two further findings from the same review round

### 5 · Six canonical fields had no raw producer observation — **RESOLVED in code**

**What review found.** `outcome`, the `deployment` observation, per-command outcomes, `status`, `logicalTimeMs`, and `variables` had no raw producer observation at all — roughly half of each retained CIB result was adapter assertion validated against nothing.

**Current disposition.** Commit `08d8b84` added raw Process-instance count, engine-clock, and Process-variable observations, plus verifier-side tests binding status, logical time, and variables to raw state queries and binding canonical semantic instance identity to the answer-free start stimulus. The classification is now structural: a schema-depth test requires **all eleven top-level `stateObservation` fields and every nested field** to carry a fidelity label, so a new field cannot be added without a decision.

One caveat survives and the project states it itself: the verifier *"reuses the Java projector's ordering, raw-binding translation, activation, lifecycle-state, and empty-argument rules, so it checks raw-to-canonical consistency rather than independently deriving projection semantics"* — and `TESTING-SPEC.md` draws the consequence: such a verifier *"does not become another independent evidence lane."*

### 6 · A stale absent-column entry in the implementation map — **RESOLVED**

**What review found.** `IMPLEMENTATION-MAP.md` listed *"Saturation-certified executable path completeness and declarative acyclicity"* as **explicitly absent** while the same document recorded Stage 2d as accepted and `GraphReachabilityLaws.lean` contained the compiling theorems.

**Current disposition.** Corrected. Those results appear in the *implemented* column of the Lean row, and only the *optional* vertex-count fuel adequacy theorem remains listed as absent.

## Findings recorded in the 30 July revision's own review round

The previous revision reported five Exclusive Gateway probe gaps that did not hold against the tree, and they still do not. `CibSevenExclusiveGatewayJuelProbeTest` still exists with its fourteen tests covering declaration order, exact-profile first/second/default routing, first-true short circuit, both delimiters, presence/null/absence, non-Boolean and literal-text behaviour, syntax rejection, language-as-script routing, conditional-default rejection, runtime failure, and rollback.

**What changed is their status, not their content.** Those probes calibrated a *JUEL* compatibility account that was then deferred. They remain retained CIB probe evidence for a candidate overlay; they are not evidence for the Exclusive Gateway capsule that actually shipped, which uses a project-owned language CIB cannot execute. Nothing was invalidated — the lane was reclassified.

The three remaining open items from that round — the deployment-time validation transport, the disposition of a suspended evaluation after exhausted Activity attempts, and cross-SDK payload compatibility — are **all moot for the shipped capsule** and remain open only for the deferred JUEL architecture. See finding 7.

## Three claims this record itself got wrong

All three are forward-looking claims about the next capsule, made when the JUEL-delegated Exclusive Gateway was owner-approved and looked imminent. It was deferred the same day it was approved, in favour of the standards-first Simple Boolean language.

### 7 · "Implementation is blocked on approval of three Java dependencies" — **VOID**

[04](04-feasibility.md) said conditional routing was *"approved, unimplemented, blocked on explicit approval of three Java dependencies (`cibseven-juel`, `temporal-sdk`, a Jackson BOM)."* It was never blocked on that, because the implemented route needs none of them. The [Exclusive Gateway condition specification](../bpmn-lean-experiment/docs/capsules/EXCLUSIVE-GATEWAY-CONDITION-SPEC.md) closed with a dependency-free five-form language, evaluated independently in Lean and TypeScript, hosted through pure internal closure with **no evaluator Activity and no expression-specific Temporal Event**. The audited 38-jar graph remains approved and unadopted.

### 8 · "`choose` needs the core to suspend mid-command and resume on a receipt" — **VOID**

[05](05-semantic-core-and-il.md) predicted that the incoming `choose` operation would force a representation change, because *"`choose` needs the core to suspend mid-command and resume on a validated receipt, which neither `awaitEffect` nor any existing operation does."* With a pure total evaluator there is nothing to suspend. `choose` consumes one token and produces exactly one selected route inside ordinary bounded closure. The IL growth rules were not stressed at all by the operation that was supposed to be their first real test.

### 9 · "The Exclusive Gateway needs `rolledBack`, so the TypeScript result type must widen" — **VOID**

[05](05-semantic-core-and-il.md) also said `CommandResult.outcome` was about to grow past `Committed | Rejected` because the gateway capsule needed `rolledBack`. It did not. `packages/semantic-core/src/semantic-process-runtime.ts` still narrows `SemanticCommandOutcome` to two arms, and six further capsules have closed without widening it. Rollback was a property of the *delegated* design — a speculative continuation awaiting an external receipt — not of conditional routing as such.

**The transferable lesson.** All three errors came from treating an owner-approved-but-unbuilt design as a fact about the near future. The project's own rule is that *"a merely strategic assessment does not authorize implementation"*; the same scepticism applies to describing it. Claims about unbuilt work in this record should be read as "what the approved design implies", never as "what is about to exist".

## 10 · Four implemented specifications named a retired IL operation — **RESOLVED in code, and guarded**

**Found by this review, in the repository rather than in this record.** Chasing finding 3's leftover `PLAN.md` sentence turned up the same defect class in worse places: four *implemented specifications* still described `terminate` as a current IL operation, more than a week after it was removed and replaced by `reachNoneEnd` plus quiescent `completeScope`.

| Specification | Stale claim |
|---|---|
| `EXCLUSIVE-GATEWAY-CONDITION-SPEC.md` | "…three terminations. … Completing the accepted branch takes **one `terminate` transition**" |
| `INTERMEDIATE-CATCH-TIMER-SPEC.md` | "The admitted program contains `initiate`, `awaitTimer`, and `terminate`" |
| `PARALLEL-FORK-JOIN-SPEC.md` | listed `terminate` among the IL's current operations |
| `USER-TASK-INTERACTION-SPEC.md` | "the generic `initiate`/`terminate` operations" |

**One of them was wrong about numbers, not just vocabulary.** The Exclusive Gateway spec's neighbouring figures had been written against the pre-scope contract. Splitting `terminate` turned three none-End events into three `reachNoneEnd` operations *plus* one root `completeScope`, so the admitted operation count moved from eight to nine and branch completion from one internal transition to two. Both corrected figures are independently checked: `packages/semantic-core/src/semantic-process-profile.ts` lists exactly nine operation kinds for that profile — one `Initiate`, one `Choose`, three `AwaitUserTask`, three `ReachNoneEnd`, one `CompleteScope`. The correcting agent also recorded an honest limitation: the capsule's Lean module covers choice semantics but has **no fixture-level closure-count theorem**, so the counts rest on executable semantic-core evidence and the profile table alone.

**The root cause is more interesting than the five sites.** `scripts/pre-release-architecture.test.ts` *is* the guard for retired representation names — it already policed retired schema versions and the removed whole-topology `has*ExecutionSurface` predicates. It had two independent gaps:

1. its scan roots covered only `BpmnSemantics`, `packages/*/src`, `packages/*/test`, and `runners/cibseven/src` — **`docs/` was never scanned**, so retired vocabulary could persist in specifications indefinitely;
2. `terminate` was never added to the policed set when it was retired, so even the code scan would not have caught a reintroduction.

Both were closed in `e873ec7`, with red evidence for each gap separately — a stale mention in a capsule *and* one under `packages/semantic-core/src/` each passed the old guard and each fails now with file-and-line findings. The docs scan excludes `docs/archived/` and permits only the two exact removal-history contexts owned by the implementation map and the profile-parameterized admission spec, so a *new* stale mention still fails. Active code rejects the name with a narrow exact-line allowlist for three genuine Temporal SDK `handle.terminate(...)` call sites.

**Two residual narrownesses, both deliberate and worth knowing.** The docs check matches only the backticked `` `terminate` `` form, so an unbackticked prose mention would still pass — a false-positive trade against ordinary English like "terminate the process group". And the code allowlist matches exact trimmed lines, so reformatting an allowlisted SDK call breaks the gate; that fails loudly and is trivially fixed, which is the right direction for a guard to be brittle.

**Why this is the most useful entry in the log.** Findings 1–6 were caught by review of *claims*. This one was caught by review *of a document about the claims*, and it found four specification defects plus a two-gap hole in the executable guard that was supposed to prevent exactly this. `CLAUDE.md` requires every escaped issue to become "either a reusable review question or an executable guard" — here the escape became a guard, which is the stronger of the two options and closes the class rather than the instance.

## One asymmetry that closed on its own

[06](06-typescript-core-correctness.md) and [09](09-property-inventory.md) both named *"a stronger TypeScript program validator"* as the cheapest real gap, quoting `IMPLEMENTATION-MAP.md`'s line that *"TypeScript program validation remains weaker than the Lean graph backstop."* That sentence no longer appears anywhere in the docs. The [profile-parameterized admission work](../bpmn-lean-experiment/docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md) gave TypeScript *"topology-independent scoped structural program validation plus exact profile definition-scope/operation-kind cardinality"*, and Lean and TypeScript now reject unknown or mismatched profiles independently. The asymmetry was closed as a side effect of removing whole-topology admission predicates, not as its own work item.

## What the pattern suggests

Ten findings from external review; nine closed, one (the single XML producer) structural, prominently disclosed, and now *widened* by the arrival of ten standards-only cases with no oracle lane. Plus three self-inflicted errors, all forward-looking, all about the same deferred design.

The compliment stands: the code was mostly doing something defensible, and the project reliably chooses the honest conditional claim over the flattering unconditional one — visibly so when the wait-ordering reopen trigger fired and was honoured rather than argued away.

The dominant defect class is **documentation drift**: claims that were true when written and became false as the code moved. It accounts for findings 3, 6, and 10, and its distribution is now clear enough to name. The *authority* documents — `IMPLEMENTATION-MAP.md` above all — were right every time. What drifted were documents that narrate **history alongside state**, because a correct historical sentence and a stale current claim are indistinguishable in prose. `PLAN.md` drifted for exactly that reason, and four *specifications* drifted because nothing was checking their vocabulary at all.

Two countermeasures now exist and they work at different levels. The first is editorial and was already proven: put the qualifier in the authority document, give every conditional claim a named premise and a reopen trigger, and let the trigger actually fire — which is precisely what happened on finding 3, across three rounds, ending in a code fix rather than a re-worded excuse. The second is new and stronger: finding 10 converted the class into an **executable guard** over `docs/`, so retired vocabulary now fails a gate instead of waiting for a reader. `CLAUDE.md` asks that every escaped issue become "either a reusable review question or an executable guard"; getting the guard is the better outcome, and it is what closed the highest-yield finding in this log.

What remains uncovered is the part a guard cannot reach: a claim can use entirely current vocabulary and still be false, as the Exclusive Gateway's stale *step counts* were. Those were caught by re-deriving the figure from the profile table, not by matching a word. So the honest summary is that vocabulary drift is now mechanised, numeric drift is not, and the only defence against the second is the project's existing habit of attributing every published figure to the executable evidence that produced it.
