# The BPM platform — the second product, and what it does to the assurance claim

## The question this document answers

Everything else here is about whether the BPMN semantics are sound. This document asks a different question, and it is the one a reader who has followed the record so far should be asking: **the whole architecture exists to keep BPMN meaning out of the host — so what happens when you put a product on top of it?**

The short version: the boundary held, it is now executable rather than argued, and it cost more than the engine did. All three halves matter.

## Why there is a second product at all

The engine was never the deliverable. [00](00-background.md) records the eventual business goal — replacing [A12 Workflows](https://github.com/mgm-tp/a12-workflows) — and A12 is a *product* built on a BPM platform, not on a semantic core. The owner's division makes that explicit:

| # | Product | Owner | Licence | Depends on |
|---|---|---|---|---|
| 1 | BPMN execution engine | this project | MIT | Temporal |
| 2 | BPM platform on Temporal | this project | MIT | product 1 |
| 3 | A12 Workflows replacement | A12 | EUPL-1.2 | product 2 |

The licence direction is the load-bearing part. [PROJECT-DESIGN.md](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/PROJECT-DESIGN.md#product-division) states it flatly: **"product 2 must never take an EUPL dependency"**, or the separation it exists to provide is gone. Product 3 lives in another organisation's repository under a reciprocal licence, so its boundary is a *distribution* boundary. Products 1 and 2 share this repository, and that choice needs its own defence.

### Why one repository, argued from the project's own rules

The obvious instinct is that a product consuming a published contract should live behind a distribution boundary. The project argues the opposite, and the argument is worth reading because it is derived from an existing rule rather than from convenience:

> A change to a published observation ripples through the checked graph, the Lean account, the semantic core, the adapter, the schemas, and then the platform's read models and surfaces, and [the pre-release evolution policy](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/PROJECT-DESIGN.md#pre-release-evolution-policy) requires that such a change replace every producer, consumer, fixture, schema, and test **atomically**.

Two repositories would make that impossible for the engine-to-platform contract. It would need either lockstep releases or a version-tolerant reader — and the second is exactly what the pre-release policy forbids before an immutable baseline exists. So sharing one tree is the option *consistent with the project's own rules*, not a shortcut around them. [08](08-swapping-temporal.md#reason-2--no-history-compatibility-debt-exists) explains what that policy buys; this is the same freedom being spent on a different boundary.

The cost of that choice is that the repository wall is gone, so the boundary has to be executable instead. It is:

- a guard fails when a product-1 tree references `platform/`;
- when a platform package deep-imports an engine internal path instead of its public entry point;
- when a platform package imports Temporal Event History APIs **at all**;
- when a production JUEL Worker appears under the external-oracle `runners/` tree;
- and the engine's complete gate must keep passing with the platform tree absent, which is what demonstrates the engine is still self-contained.

Each prohibited class carries a planted violation in the guard's own tests, which is this repository's standing rule for guards ([02](02-evidence-and-lanes.md#4--mutation-guards--evidence-that-the-evidence-works)).

## The four operations, and the two rules that make the assurance transfer

The engine publishes exactly four kinds of semantic consumption. Nothing else of that kind crosses:

```text
compile exact bytes against a selected profile
start an admitted program
observe committed canonical state
submit a command
```

That is a *taxonomy of permitted consumption*, deliberately not a portability interface — [08](08-swapping-temporal.md) is where the difference matters. Product 2 reaches the concrete Temporal client only through one foundation package, `platform/foundation/engine-gateway`, which owns one lazy reusable connection.

Two rules turn "the platform inherits the engine's assurance" from a slogan into a checkable property, and **without both of them the claim is simply false**:

> **Occurrence identity is taken, never constructed.** The platform answers a published interaction by submitting the identity that interaction carried. No product code assembles a task, subscription, activation, or Call identity.
>
> **A missing fact is a stop condition, not a workaround.** When the platform needs something the engine does not publish, it files an engine requirement and stops. It does not derive the fact from Temporal Event History, from a state difference, or from its own store.

The second rule is the one that would be quietly broken by any ordinary product team, because the workaround is always available and always cheap. Two engine requirements were filed and closed under their own governed cycles rather than worked around:

| # | What the platform needed | How it was answered |
|---|---|---|
| E1 | a committed per-transition record in the public contract | the [committed execution publication capsule](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/capsules/COMMITTED-EXECUTION-PUBLICATION-SPEC.md) — a full engine capsule with Lean proofs |
| E2 | a profile admission capability for User Task assignment and form metadata, plus a public projection carrying it | the [User Task metadata capsule](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/capsules/USER-TASK-ASSIGNMENT-FORM-METADATA-SPEC.md) |

E1 is the sharper case. The platform needed instance history, and the obvious source — Temporal Event History — was sitting right there, already durable, already ordered. The rule forbade it, so the engine grew a publication contract instead: the semantic core and Lean each retain exact unnumbered transition and public-position facts, the Workflow alone assigns contiguous revisions, and Product 2 validates each page against its transactionally retained head before applying a contiguous suffix. The projection **rebuilds to identical content from revision zero**, and a seeded gap is detected rather than skipped.

The reason to spend a full engine capsule on that rather than read the Event History is stated in [07 challenge 2](07-temporal-adapter.md#challenge-2--temporal-commands-are-not-bpmn-transitions): Event order reflects Workflow Task scheduling and host retries, not BPMN token movement. A history built from it would look right and be a different thing.

### The one genuinely new assurance mechanism

Sharing a tree also makes one check possible that separate repositories would not, and it is the best argument for the arrangement:

> for every registered scenario, the platform's projected task set must equal the engine's published open User Tasks, and its projected history must be complete with respect to the engine's committed transition records.

That converts "the platform reconstructs no semantic fact" from a rule into a test. It is the same move the rest of the project makes everywhere else — replace a convention with an executable discriminator — applied to a boundary that would normally be defended by code review alone.

## The milestone ladder as an acceptance contract

The platform's acceptance gates are **showcase milestones**, not a separate artefact. That decision matters more than it looks: a milestone closes only when its executable gate is green *and* [IMPLEMENTATION-MAP.md](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/IMPLEMENTATION-MAP.md) records the exact surface it reached, so a demo cannot close one.

Two boundaries hold across the whole ladder, and a milestone demonstrable only by violating either **has not been reached**: the engine must still build and verify with no platform package present, and the platform must reach the engine only through narrowed public entry points.

| Milestone | Demo it had to produce | What it forced on the *engine* |
|---|---|---|
| **M0** shipped floor | none — a baseline for later gates to differ from | — |
| **M1** a third party deploys their own BPMN file | someone who is not us uploads bytes we have never seen, gets a per-element verdict, and starts an instance when admitted | the execute/preserve/reject admission split, multi-root definitions, per-element rejection diagnostics carrying element identity |
| **M2** the file runs its real shape | a third-party model with a loop and a real start trigger executes | cyclic control flow replacing the acyclicity precondition; Message Start, Timer Start, Terminate End, configured Task |
| **M3** real work with real data | a person picks a task from an inbox, fills a form whose fields are not all strings, submits, and the process continues on the value entered | the Boolean value domain; E2 assignment/form metadata |
| **M4** it survives going wrong | a failing Service Task raises an incident an operator can see, retry, and cancel | incidents as a *semantic* outcome distinct from Temporal retries; incident-gated root cancellation |
| **M5** it can be operated and explained | an operator replays what a finished instance did, sees where a running one stands on the diagram, and exports the history | E1 committed publication; flow-node occurrence lifecycle publication |
| **M6** useful structured Human Work | a reviewer completes six field kinds and picks Approve / Request changes / Abort, and the process follows the matching gateway route | generic safe integers and ordered string lists, admitted only for one User Task completion profile |

Read that right-hand column as the real finding. **The platform selects the engine's roadmap.** [PROJECT-DESIGN.md](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/PROJECT-DESIGN.md#cib-seven-220-breadth-ordering) makes that explicit as a tie-breaker — when candidates are equal in standards value, reach, and risk, "the one the BPM platform's next showcase milestone needs wins" — but the ladder does more than break ties. Cycles, incidents, cancellation, publication, and a widened value domain are all mechanisms the standards roadmap would reach eventually, pulled forward because a milestone needed them.

Whether that is good is genuinely arguable. It produces a coherent product and closes several high-risk semantic families early. It also means the engine's ordering is driven by what a demonstrable capability needs, and [04](04-feasibility.md) is where the consequence for OMG conformance lands.

### Two exit gates worth quoting

The gates are written to be hard to satisfy accidentally, and two of them show the discipline:

**M3.** *"no platform component constructs an occurrence identity; every engine state-changing action is authorized against the exact published occurrence; platform claim and audit state remains distinct from BPMN meaning."*

**M5.** *"History is built only from committed publication, never from Event History or state differencing; the projection rebuilds to the same content from scratch; Worker replacement and platform restart do not corrupt it; and a seeded gap is detected rather than silently skipped."*

Neither is a feature test. Both are tests that the boundary this document is about did not leak.

## Where the boundary was most tempted: forms

M6 is the best worked example in the platform, because forms are precisely the place where product pressure pushes schema into semantics. A form has field kinds, requiredness, visibility rules, option sets, validation, and actions. Every one of those is a rule about *what the user may submit*, and every engine that has ever shipped a form builder has ended up with some of it inside the process model.

The split the project chose:

```text
exact admitted BPMN source bytes retained by Definitions
    |
    +--> Product 1  checked graph -> IL -> semantic core -> Temporal
    |
    +--> Product 2  definition-source projection boundary
                        |
                 immutable HumanTaskCatalogV1
                        |
                 Zod validation and canonical patch computation
                        |
                 existing content-bound completion command
```

Both products independently project the **same digest-bound bytes**. The Semantic Process program is executable authority; the Human Task catalog is Product 2 definition metadata with *no semantic authority*, joined to an open task only through the exact deployed definition version and the engine-published BPMN element ID. Product 1 receives one generic atomic variable patch and knows nothing about the catalog, fields, labels, requiredness, actions, visibility, Zod, or computations.

The engine's share of M6 is exactly two new *generic* value kinds — non-negative safe integers and ordered string lists — admitted only for the selected User Task completion profile. That is the whole semantic cost of a six-field-kind form with three conditional actions.

Two details make this more than an architecture diagram.

**The catalog rides a standard BPMN hook rather than an invented one.** BPMN 2.0.2 gives `UserTask` an optional list of `Rendering` extension hooks, deliberately leaves their content undefined, and states that a User Task can be deployed even when an implementation does not support its rendering methods. The project extension sits under that hook, the semantic compiler admits and preserves it as **execution-neutral source** without parsing it, and a rendering-present versus rendering-absent program-equality test is required evidence. So a model with a form and the same model without one lower to the same program.

**The limitation is disclosed rather than papered over.** The specification says plainly that "Abort writes `resolution = aborted`" is guaranteed by the Product 2 completion route, **not by every possible engine client**. A model needing that mapping enforced independently of its user interface would need standard BPMN DataOutput and Data Association semantics — and *"must not solve that requirement by importing Zod or form actions into the semantic core."* Naming the gap and refusing the cheap fix is the same move as challenge 13's fail-closed refusal in [07](07-temporal-adapter.md#challenge-13--coalesced-readiness--the-one-that-fails-closed).

## What the platform is not allowed to implement

Two capabilities are listed in the platform proposal as things the platform **exposes and cannot implement**, because both are semantic transitions: **instance cancellation and incidents**. That is why M4 is an engine milestone wearing a product name — Stage 1 and Stage 2 are engine capsules with Lean proofs and CIB evidence, and only Stage 3 is the Operations console.

The corresponding negative rule appears in the M4 exit gate: *"the platform exposes no retry count that is a Temporal attempt."* [07 challenge 5](07-temporal-adapter.md#challenge-5--host-retries-versus-engine-visible-retries) is the engine-side half of the same sentence; here it is enforced at a screen.

Host-level detail is deliberately not reimplemented either. The console links out to Temporal's own UI for Event History, Workflow retries, and Activity attempts: **BPMN facts come from our surfaces, host facts from Temporal's.** That is a product decision that also happens to keep the Event-History prohibition easy to hold, because there is no reason for a platform screen to want that data.

## The size of it, and the cost

Nonblank measurement over the tracked tree at the baseline commit:

| Tree | Nonblank TypeScript |
|---|---:|
| `packages/` — product 1 engine, `src` plus `test` | 102,574 |
| `platform/` plus `showcase/` — product 2 and its acceptance gates | 72,994 |

Product 2 stands at roughly seven-tenths of the engine's size. And the [capsule cost ledger](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/CAPSULE-COST-LEDGER.md), with forty measured increments, makes the shape clearer than the totals do:

```text
nonblank code additions per measured increment — the six largest are five platform
increments and one engine capsule that exists to serve the platform

A12 add-on product boundary       +16959   (13,794 of it frozen legacy source)
Committed execution publication   +13750   ← engine capsule, filed by Product 2 as E1
Product 2 human work              +13689
Product 2 incident operations     +13373
Flow-node occurrence metrics      +12836
Product 2 definition scheduling    +8606
Product 2 Message Start ingress    +7506
Product 2 structured Human Work    +6520
Service Task incident cancellation +6438   ← engine capsule for M4
Service Task incident and retry    +6038   ← engine capsule for M4
Resumption-bounded cyclic flow     +5795   ← engine capsule for M2
Bounded Call Activity              +5801
Product 2 Process-instance search  +4802
Product 2 operator history/audit   +3608
```

The honest reading has two parts and they point in opposite directions.

**Product 2 is now the dominant cost centre, and it buys no BPMN coverage.** The four largest non-A12 rows are platform or platform-driven. [PROJECT-DESIGN.md](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/PROJECT-DESIGN.md#what-the-platform-may-consume) keeps platform coverage as a third denominator that never merges with the BPMN or CIB ones, and the platform proposal states the consequence: **"No product lane is an independent semantic evidence lane."** So thirteen thousand lines of human work moved the BPMN denominator by zero.

**But the reuse curve inside the platform is real, and it is the only place in this repository where cost has fallen repeatedly.** The ledger's own comparisons record it row by row: incident operations came in *below* human work by reusing the confirmed-publication lifecycle, identity policy, audit boundary, and UI kit; flow-node metrics came in below both; operator history and audit export came in at `+3608` against a `+4802` comparator by reusing the existing audit events, outboxes, registry, authorization policy, canonical JSON mechanism, and Process-detail shell; structured Human Work fell by 7,169 lines against human work. Five consecutive platform increments where the measured cost fell, against an engine curve that [04](04-feasibility.md#the-cost-curve-measured) shows flat.

That contrast is the most interesting number in this document. Ordinary product work amortises; new semantic mechanisms do not. It is evidence about what kind of work the repository is now doing, and a reason to read a large platform increment as cheaper than an engine increment of the same size.

## What the platform's evidence actually establishes

This is where a reader should be most careful, because the platform's gates are green and its assurance is the thinnest in the repository.

| Lane | What passage establishes | What it does not |
|---|---|---|
| Server and module tests | the platform's own services behave as specified | nothing about BPMN meaning |
| Live Temporal showcases | the real production server, Worker, client, and browser compose over a real Temporal service | not a semantic lane; the composition reuses already-evidenced components |
| Chromium journeys at 1280 and 1600 px | an offered user workflow completes, with each mutation's false precondition separately locked | nothing about the engine's correctness |
| Cross-product agreement | the platform's projected tasks equal the engine's published open tasks for every registered scenario | that the engine's published set is right |

There is **no Lean account of Product 2, no oracle, and no differential lane.** The pinned CIB Seven engine has a Cockpit and a Tasklist, and the project deliberately does not use them as behavioural oracles: [PROJECT-DESIGN.md](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/PROJECT-DESIGN.md#source-grounded-product-2-interaction-design) requires inspecting the comparable CIB capability as *interaction-design* input before selecting a material UI surface, and is explicit that CIB Seven remains "a functional and interaction-design reference for Product 2, not a semantic authority, dependency, or visual theme."

That is the correct call — a CIB screen is not evidence about a BPMN proposition — but it leaves Product 2 supported by exactly the kinds of evidence the rest of this record spends its time qualifying. A reader who trusts the engine's claims because of [02](02-evidence-and-lanes.md) should not extend that trust to the platform on the same grounds. The platform's claim is narrower and different: *it reconstructs no semantic fact*, and that one claim is tested.

One useful sign that the discipline is being applied anyway: the process ledger records two Product 2 findings that became executable guards after a green gate concealed a real defect — an unclaimed task could open an editable completion form and receive misleading recovery advice, because every fixture began already claimed; and UI/UX precedent was postponed until after implementation twice, so browser evidence became the first comparison with an established product rather than verification of an informed design. Both are now gates. [19](19-process-self-measurement.md) is about that instrument.

## The boundary that is *not* held: scale

The functional MVP is complete and **explicitly single-node**, with no production scalability or capacity claim. `IMPLEMENTATION-MAP.md` lists the absence precisely: *"Horizontal Product 2 deployment: persistence, artifacts, repair, and Temporal Query aggregation remain node-local."*

Concretely, the platform's read models are `node:sqlite`, its artifact store is the local filesystem, its recovery is in-process, and some request-time reads fan out to Temporal Queries — which [07 challenge 9](07-temporal-adapter.md#challenge-9--query-is-not-a-durable-fact) already establishes are not durable facts. Every one of those is fine for one node and none of them survives two.

That is the first post-MVP work, and it is owner-approved rather than speculative: PostgreSQL 18, asynchronous repository ports with local SQLite and shared PostgreSQL adapters, exact-byte admitted-source storage, bounded background recovery, monotonic suffix projections, and projection-backed reads — closing *"with concurrent multi-replica correctness evidence before making any performance or capacity claim."*

Two things about that plan are worth flagging while it is unbuilt — as *what the approved design implies* rather than as near-future fact, because an owner-approved design is not a description of what exists:

- It is the first time the project takes a **stateful external dependency** it does not control the lifecycle of. Every gate today starts clean state and discards it ([08](08-swapping-temporal.md#reason-2--no-history-compatibility-debt-exists)); a migration-checksum contract is the first artefact in the tree that must survive its own gate.
- The resume point explicitly forbids the incremental path: *"Replace repository ports and every producer, consumer, fake, and test atomically with one asynchronous contract; do not retain parallel synchronous and asynchronous service paths."* That is the pre-release policy being spent again, deliberately, on the largest replacement so far — and it is a good illustration of why [11 §5](11-open-questions.md#5--what-happens-to-the-pre-release-freedom-when-the-first-durable-baseline-lands) matters more now than it did.

## The residual

**What the platform establishes.** That a product can be built on this engine without acquiring semantic authority, that the two rules protecting the assurance claim survive contact with an inbox, an operations console, incidents, history, metrics, audit export, and a structured form, and that the "missing fact is a stop condition" rule was honoured twice at the cost of two full engine capsules rather than worked around once.

**What it does not.** That the platform is correct in any sense the engine is correct. There is no second implementation of it, no oracle for it, and no theorem about it. Its assurance is ordinary software assurance — tests, journeys, and guards — sitting on top of a semantic core that has considerably more.

**And the thing worth watching.** The platform is where product pressure enters a repository that has so far been able to refuse everything inconvenient. It refused Event History, it refused to construct an occurrence identity, it refused to put form schema into the core, and it refused a capacity claim it had no evidence for. Four refusals is a good record. The fifth will arrive when a real adopter needs something the engine does not publish and the answer is still supposed to be "file a requirement and stop".
