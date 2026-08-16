# Background for newcomers

## What this project is trying to build

A **BPMN execution engine** that runs on **Temporal**, whose semantics are pinned down by a **formal proof assistant**, cross-checked against a **real production engine** — plus a **BPM platform product on top of it** that may consume that engine and may not reinterpret it.

Unpacking that sentence is most of the background you need. The platform has its own treatment in [18](18-the-bpm-platform.md); everything below is about the engine, because the engine is what the platform's claim rests on.

**BPMN 2.0.2** (Business Process Model and Notation) is an OMG standard for modelling business processes — the boxes-and-arrows diagrams with start events, tasks, gateways and end events. It has two halves: a *notation* half (what the diagram looks like) and an *execution* half (what an engine must actually do when it runs the process). The execution half is what this project targets, and the specific conformance class is called **Process Execution Conformance**.

The catch: BPMN's execution semantics are described in English prose across hundreds of pages, with genuine ambiguities. Different engines interpret the same diagram differently. So "implement BPMN" is not a well-defined task until you also decide *whose reading of BPMN* you are implementing.

**CIB Seven** is a real, open-source BPMN engine (a fork of Camunda 7, Apache-2.0). This project uses it as an **oracle** — a reference implementation you can run and observe to answer "what does a working engine actually do here?" It is not treated as automatically correct; disagreements with the standard get *classified* rather than resolved by majority vote. Two releases are pinned and kept strictly apart: `2.2.0` for most semantic profiles and `2.0.0` for the A12-facing ones.

**[A12 Workflows](https://github.com/mgm-tp/a12-workflows)** is a product (`release/2025.06`, EUPL-1.2) built on top of CIB Seven. Replacing it is the project's eventual business goal, which makes it a useful prioritisation lens: whatever BPMN features A12's real models use are worth implementing first. It is deliberately kept *outside* the repository's dependency and licence boundary — inspectable as research, never linked or vendored.

**Temporal** is a *durable execution* platform. You write ordinary-looking code; Temporal makes it survive crashes, restarts, and machine failures by recording every step and replaying it. This is a natural fit for long-running business processes — a process instance might wait three days for a human approval, and Temporal keeps that wait alive without you managing any state yourself. See [07](07-temporal-adapter.md) for what that costs.

**Lean 4** is a proof assistant: a programming language whose type checker can also verify mathematical proofs. You write definitions (which can be executed like ordinary programs) and theorems about them (which are checked by a small trusted "kernel"). If a theorem does not actually follow from its assumptions, the build fails. This is the tool the project uses to make its BPMN interpretation *precise* rather than merely *implemented*.

## Who is allowed to decide what

```mermaid
flowchart TB
    subgraph AUTH["Authority model"]
        direction TB
        A["<b>1. BPMN 2.0.2 standard</b><br/>authoritative for syntax, metamodel,<br/>and Process Execution Conformance"]
        B["<b>2. Semantic profile</b> (immutable, versioned)<br/>compatibility authority for one declared target"]
        C["<b>3. Lean reference interpreter</b><br/>formal authority for that profile's<br/>explicit operational meaning"]
        D["<b>4. Pinned CIB Seven engine</b><br/>executable behavioural oracle"]
        E["<b>5. Pure TypeScript semantic core</b><br/>independent transcription — no CIB,<br/>no Temporal dependency"]
        F["<b>6. Temporal adapter</b><br/>durability only —<br/>defines no BPMN behaviour"]
        A --> B --> C
        B --> D
        C -.->|"same reviewed account,<br/>independent transcription"| E
        E --> F
    end
```

The critical rule is item 6: **Temporal provides durability and hidden orchestration work without defining BPMN behaviour.** Everything about how the system is layered follows from wanting that to stay true.

The dashed edge from Lean to the semantic core is the one people misread. It is *not* generation, extraction, or a proof — it is two hand-written transcriptions of one reviewed account. [06](06-typescript-core-correctness.md) is entirely about what that does and does not buy.

Not every profile uses every authority. Of the 30 registered semantic profiles, **16 declare `oracle: null`** — BPMN 2.0.2 normative authority with no CIB execution target at all. Every profile whose identifier begins `bpmn-2.0.2-` is in that set. For those, box 4 is deliberately empty, and that is the majority position rather than an exception. It has consequences for how much independent evidence exists; [02](02-evidence-and-lanes.md) works through them.

The BPM platform is deliberately **not** a seventh box. It consumes the engine's published contract through exactly four operations and has authority over nothing above it, so it does not appear in an authority model at all. See [18](18-the-bpm-platform.md).

## Four layers with one-way dependency

Beyond the authority model there is a *product* layering, and conflating the two is the most common way to get this project wrong:

```text
A12 Workflows replacement                        (product 3 — A12's, EUPL-1.2, separate repository)
        ↓ consumes as a published MIT artefact
BPM platform on Temporal                         (product 2 — this repository, MIT)
        ↓ consumes exactly four published operations
selected CIB Seven compatibility profiles
        ↓ refine or extend
vendor-neutral BPMN 2.0.2 execution core         (product 1 — this repository, MIT)
        ↓ hosted by
Temporal durability and effect infrastructure
```

Lower layers never import or encode assumptions from a higher one. Concretely: A12 bean names, Camunda extension namespaces, CIB job/retry/incident mechanics, Temporal attempt counters, and — since product 2 exists — form schemas, task priorities, claim state, and audit records all stay out of the BPMN core, the Lean account, the IL, and the TypeScript core.

The boundary is held by profile-registered opaque identities rather than by convention: effect protocols and operations are URNs such as `urn:bpmn-lean:effect-protocol:activity-v1`, and no Camunda namespace, A12 bean name, or target-model discriminator appears in the core or in Lean's production lowering. See [05](05-semantic-core-and-il.md#the-effect-descriptor-is-neutral) for why the neutral form is load-bearing rather than stylistic.

The licence direction matters as much as the dependency direction: **product 2 must never take an EUPL dependency**, or the separation it exists to provide is gone. Product 3 is therefore a separate repository owned by another organisation, while products 1 and 2 share this one — an arrangement [18](18-the-bpm-platform.md#why-one-repository-argued-from-the-projects-own-rules) argues from the project's own atomic-change policy rather than from convenience.

**Four** coverage denominators are tracked separately and may never be combined into one percentage: reviewed BPMN Process Execution requirements, CIB profile coverage, A12 adoption coverage, and closed platform showcase milestones. Success in one is never evidence for another, and platform milestones are explicitly not a semantic evidence lane.

## One more piece: who owns expression languages

BPMN says a `FormalExpression` names its expression language. It does not say what that language is or how it evaluates. This project's answer, recorded in [PROJECT-DESIGN.md](../bpmn-lean-experiment/docs/PROJECT-DESIGN.md#profile-selected-expression-evaluation), splits into two architectures, and only one of them is implemented.

**The implemented path is a project-owned language.** The [Simple Boolean expression decision](../bpmn-lean-experiment/docs/SIMPLE-BOOLEAN-EXPRESSION-DECISION.md) selects one immutable language URI naming a closed, total, read-only grammar of exactly five Boolean forms over Process-scope `string | null` bindings. **Lean and the TypeScript core each parse and evaluate it independently.** The source boundary rejects the whole language before Workflow start, the checked graph keeps both the exact source text and the typed expression, Lean reparses the source when it checks lowering, and the core evaluates only the typed expression during bounded internal closure. No Activity, no evaluator receipt, no suspension.

The point is not that the project wanted its own expression language. The point is that a *dependency-free total* language of five forms is small enough to transcribe twice and prove things about, so conditional routing became an ordinary capsule instead of a cross-runtime integration. Omitted language selection stays BPMN's XPath default and is rejected outright rather than silently reinterpreted.

**The delegated path exists but is deferred.** The [JUEL evaluation decision](../bpmn-lean-experiment/docs/JUEL-EVALUATION-ARCHITECTURE-DECISION.md) would hand exact expression text plus an approved context to the pinned CIB JUEL runtime behind a Java Temporal Activity, and bind the content-bound result back to the core. It is owner-selected as *the* CIB compatibility architecture, its 38-jar dependency graph is audited, and none of it is adopted — no Java evaluator module, no dependency, no wire contract. It reopens only when a CIB compatibility claim actually needs it.

Two honesty rules survive both paths. Under delegation, CIB and a project JUEL Worker would share one implementation and therefore form **one correlated truth account**, not two agreeing implementations. And under the implemented standards path, the trade runs the other way: Lean and TypeScript genuinely evaluate independently, but **CIB has no opinion at all**, so the Simple Boolean profile has no oracle lane and says so.

## Glossary

| Term | Meaning in this project |
|---|---|
| **Semantic profile** | An immutable, versioned document recording exactly which features, exclusions, observation boundary, oracle revision, and environment a compatibility claim covers. A profile ID is semantic authority, not a label. **Thirty** are registered today; **sixteen** are standards-only, declaring `oracle: null`. |
| **Capsule** | A bounded unit of semantic work — one feature, closed across every evidence lane, with its own spec document and a required section structure. **Thirty-two** capsule documents exist under `docs/capsules/`. |
| **Product 1 / product 2 / product 3** | The engine (MIT, here), the BPM platform (MIT, here), and A12's replacement (EUPL-1.2, elsewhere). Dependency and licence both run one way. See [18](18-the-bpm-platform.md). |
| **Showcase milestone** | Product 2's acceptance gate. A milestone closes only when its executable gate is green *and* the implementation map records the exact surface reached. M0–M6 are closed; together they are the functional MVP. |
| **Semantic core** | The pure TypeScript component. The retired architecture handoff called it a "reducer"; this project renamed it to avoid a Redux association. Its public transition is `applyStimulus`. |
| **Oracle** | An external implementation you observe to learn real behaviour. Here: a pinned CIB Seven build. |
| **Evidence lane** | One independent way of supporting a claim. Two lanes count as two *only if their failure modes are uncorrelated*. |
| **Differential testing** | Running the same input through several independent implementations and requiring their observable results to agree. |
| **Refinement** | "The host faithfully implements the semantic model" — the host may do more (retries, replays), but must not change any publicly visible semantic outcome. |
| **Replay** | Re-running a recorded Temporal execution history against the code to prove it is deterministic and history-compatible. **Sixty-two** histories are replayed per full pipeline run, derived from the catalog's `replaySelection` fields. |
| **Token** | Petri-net style marker. A token on a Sequence Flow means "control is here". Parallel processes have several at once. |
| **Control place** | The IL's name for a token container. One per admitted BPMN Sequence Flow. |
| **Stimulus** | An explicit external input: start the process, complete a task, deliver a message, fire a timer, complete an effect. Nothing happens without one. |
| **Closure** | After a stimulus commits, the engine fires *automatic* internal steps until it reaches a wait. Bounded by a fuel limit (currently 8). |
| **Definition scope** | A *static* ownership region in the checked graph and IL — which nodes, flows, operations, and control places belong to which Process or embedded Sub-Process. Existing profiles form one rooted tree; the Call Activity profile adds a second, parentless called root. |
| **Runtime scope occurrence** | The *dynamic* counterpart: one root occurrence plus at most one level of parent-linked child occurrence, or one occurrence-linked called root. Tokens and waits are owned by a scope occurrence, which is what makes child completion, regional cancellation, and `terminateScope` expressible. |
| **Managed operation** | An IL operation the Temporal adapter must actively schedule against a deadline. Four classes exist and the host admits **at most one across all four**, checked before Workflow creation. See [13](13-admission-and-profiles.md#host-capability-is-not-semantic-admission). |
| **Publication** | The engine's committed per-transition and current-position record, served by a pure cursor Query and consumed by the platform's projection. It exists because reading Temporal Event History for history was forbidden. |
| **Variable scope** | Runtime *data* ownership, deliberately separate from definition scopes. Still exactly two kinds: one Process scope (public) and private Activity-local scopes keyed by complete effect occurrence. Variable-scope traversal, shadowing, and nesting do not exist. |
| **Effect** | A committed intent to perform external work. The core owns the intent; a Temporal Activity performs it; the core validates the result. |
| **Event race** | The Event-Based Gateway mechanism: competing Message and Timer catches armed atomically under one race identity, exactly one winner committed, every loser withdrawn. |
| **Receipt** | A content-bound result from outside the core that the core validates against the exact pending request before applying it. |
| **Preflight** | A mandatory Temporal hosting/refinement review completed *before* production Lean or TypeScript code for a new transition family. |
| **Host capability** | A separate, pre-start check asking whether the *adapter* can host a program's reachable wait set — distinct from whether the program is semantically well-formed. Failing it is a typed `rejected` result before Workflow creation, never a crash. |
| **Canonical observation** | The single agreed public view of state — status, active waits, open tasks/messages/timers/effects, variables, enabled interactions, logical time. This, and only this, is what implementations are compared on. |
| **Law** | A theorem that holds for *all* inputs satisfying stated hypotheses. |
| **Non-law** | A theorem proving that a tempting-but-wrong alternative reading is **false**. A required lane, not a bonus. |
| **`by decide`** | A Lean tactic that proves a statement by having the trusted kernel *compute* the answer on concrete values. Great for fixtures; no substitute for a law. |
| **Soundness** | "everything the code does is permitted". The direction this project proves. |
| **Completeness** | "everything permitted is found by the code". Not claimed without a separate theorem. |
| **Separating witness** | An input on which two candidate readings give *different publicly observable* results. If they differ only internally, it is not a witness. |
| **Saturation certificate** | A checked closure property (every edge leaving a set lands back inside it) used instead of "I searched and found nothing" — see [01 §1.6](01-theorem-techniques.md#16-certificates-instead-of-bounded-search). |
| **Fidelity label** | How strongly an oracle observation supports a claim: `engine-observed`, `adapter-derived`, `adapter-decided`, or `not-claimed`. |
| **Comparator-side / verifier-side mutation** | A seeded defect applied to a clone of a target's own canonical result (proves the comparator is field-sensitive) versus one applied to retained raw producer observations (proves the evidence projection is live). Not interchangeable. |
| **`processClosed` / `processUnknown`** | Adapter-owned lifecycle results for a command addressed after Workflow closure. Deliberately *not* semantic outcomes. |
| **Cold / warm review** | A governed independent review by a sub-agent with no shared conversation history (`fork-turns-none`) versus one by an agent that already has context. Cold is the default for anything that selects BPMN meaning; warm is permitted only in named cases such as the same reviewer auditing its own findings' corrections. |
| **Trust base** | What you must believe for a proof to mean something — here, the Lean kernel plus the axioms a declaration actually uses. |
| **IL** | Intermediate Language. A small, typed, serializable representation between "parsed BPMN" and "running semantics". **Twenty-four** operations today, counted from `SemanticOperationKind`. |
