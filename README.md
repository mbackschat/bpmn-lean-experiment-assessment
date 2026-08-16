# bpmn-lean-experiment — an independent assessment

A reasoned assessment of [`bpmn-lean-experiment`](https://github.com/mbackschat/bpmn-lean-experiment): what it is, how it is built, what its evidence actually establishes, and how far along it honestly is.

It is written for someone who does not already know BPMN, Lean, or Temporal internals. Its value is synthesis across boundaries the repository deliberately keeps separate — each document there is correctly narrow, and nothing there is allowed to say "here is the whole picture, and here is what it is worth."

**This is not authoritative.** The project's own documents win every disagreement. Where a statement here conflicts with [docs/IMPLEMENTATION-MAP.md](../bpmn-lean-experiment/docs/IMPLEMENTATION-MAP.md), the implementation map is right and this repository has a bug.

**Version described:** commit `0adda45` (16 August 2026), clean worktree. The project moves at hundreds of commits a week, so treat everything here as dated and check [docs/IMPLEMENTATION-MAP.md](../bpmn-lean-experiment/docs/IMPLEMENTATION-MAP.md) and [docs/PLAN.md](../bpmn-lean-experiment/docs/PLAN.md) for current truth.

## Getting started

Clone both repositories side by side. Every link into the assessed project is relative and assumes a sibling checkout:

```sh
git clone https://github.com/mbackschat/bpmn-lean-experiment.git
git clone https://github.com/mbackschat/bpmn-lean-experiment-assessment.git
```

Those `../bpmn-lean-experiment/…` links do not resolve while browsing this repository on GitHub, because they deliberately point outside it. Read locally, or use [Where to read more](#where-to-read-more) to reach the project's documents on GitHub.

If you only read three documents: [00](00-background.md), then [18](18-the-bpm-platform.md) and [02](02-evidence-and-lanes.md).

## What the project is

Two MIT-licensed products in one repository.

**Product 1 is a BPMN 2.0.2 execution engine.** Exact BPMN bytes are admitted against a declared semantic profile, lowered to a project-owned intermediate language of twenty-four operations, evaluated by a Lean reference interpreter *and* by an independently written TypeScript core, hosted durably by a Temporal adapter that is forbidden to add BPMN meaning, and cross-checked against a pinned CIB Seven engine wherever a profile declares one. Thirty registered profiles, fifty-one differential cases, and 815 public Lean theorems support thirty bounded mechanisms — every one still pinned to a literal, and none closing a BPMN mechanism family.

**Product 2 is a BPM platform.** It consumes exactly four published engine operations — compile, start, observe committed state, submit a command — and may not reconstruct any semantic fact the engine did not publish. It provides definition deployment and versioning, scheduled and message-triggered starts, a human task inbox with structured forms, incident operations, Process search, semantic history and diagram overlays, flow-node metrics, and canonical audit export. Its functional MVP is complete on an explicitly **single-node** deployment, with no production scalability or capacity claim.

A third product — A12's own replacement of its workflow tooling, EUPL-1.2 — lives in another organisation's repository. It is a prioritisation lens here and never a dependency.

**The distinguishing claim** is that the BPMN meaning underneath the platform is machine-checked in Lean rather than asserted, and that the platform inherits that assurance because it consumes a published contract instead of reconstructing semantic facts. Most of this assessment is about how much of that claim is established, and where it stops.

## The short version

**What is strong.** Durable hosting of BPMN on Temporal, without letting Temporal define BPMN behaviour, is demonstrated rather than argued: one generic Workflow interprets every admitted model as data, timers fire from committed semantic state rather than from the fact that a host timer went off, host retries never become engine-visible retries, and a called Process is deliberately *not* a Child Workflow because that would make BPMN instance identity a Temporal identity. The claim boundaries are unusually honest — absences are documented more carefully than presences, coverage denominators are never merged, no percentage of BPMN is claimed anywhere, and an oracle disagreement is kept visible as a candidate deviation rather than absorbed.

**What is bounded.** Every implemented mechanism is a single instance, not a family: the literal `PT1S` only, exactly two balanced branches, one error code, one in-document called Process, one level of scope. All thirteen reusable BPMN mechanism families are disposed `unsupported` at family level in the project's own ledger. No horizontal generalisation of a mechanism has shipped.

**What is thin.** Twenty-seven of the fifty-one registered differential cases have **no oracle lane at all**, because their profiles declare none — so for most of the surface, the only lane that could catch a misread of the XML does not run. Lean and TypeScript are two transcriptions of one reviewed account, not two independent readings of BPMN, and the project says so. Product 2 has no Lean account, no oracle, and no differential lane.

**What is expensive.** Every new BPMN mechanism costs three to six thousand lines across seven layers plus a review cycle, and forty measured increments show no downward trend across families — though cost does fall measurably *within* a family. The BPM platform is the largest consumer of effort in the repository and contributes nothing to BPMN coverage, by design.

## Contents

| # | Document | What it answers |
|---|---|---|
| 0 | [Background for newcomers](00-background.md) | What BPMN, CIB Seven, A12, Temporal, and Lean are, and who is allowed to decide what |
| 1 | [How theorems are used](01-theorem-techniques.md) | Why formalise at all, and the proof techniques the project actually uses |
| 2 | [Evidence, lanes, and mutations](02-evidence-and-lanes.md) | What "evidence" means here, why it is not a test, and the rule that makes two lanes count as two |
| 3 | [Is the Lean work goal-driven?](03-is-lean-goal-driven.md) | Whether the proof effort pays, and how the per-capsule preservation gate performs |
| 4 | [Is the goal feasible?](04-feasibility.md) | Three goals with three different sets of odds, against forty measured cost increments |
| 5 | [The semantic core and the IL](05-semantic-core-and-il.md) | The packages, the twenty-four-operation IL, and what lowering does |
| 6 | [How the TypeScript core is written and checked](06-typescript-core-correctness.md) | It is not generated from Lean — so how is it produced, and what establishes that it is right? |
| 7 | [How the Temporal adapter works](07-temporal-adapter.md) | The durability layer, the problems it faces, and how each is solved |
| 8 | [Could Temporal be swapped later?](08-swapping-temporal.md) | Portability, and the couplings that constrain the choice |
| 9 | [Property inventory](09-property-inventory.md) | What is proven today, by category, with named representatives |
| 10 | [Case study — one process through every layer](10-case-study.md) | The smallest complete example, traced end to end |
| 11 | [Open questions](11-open-questions.md) | What is genuinely undecided |
| 13 | [Admission and profiles](13-admission-and-profiles.md) | The separate questions behind "is this model supported?" |
| 14 | [Scopes, quiescence, and cancellation](14-scopes-and-cancellation.md) | Definition scopes, quiescent completion, regional cancellation, called roots, boundary deadlines |
| 15 | [How the project governs its own claims](15-review-and-delegation.md) | The cold/warm review regime, its executable guard, and its attestation gap |
| 16 | [What you can actually run today](16-what-you-can-run.md) | The runner, the browser product, the pipeline, and their explicit non-claims |
| 17 | [How to review this project](17-how-to-review.md) | Ten traps, an eight-dimension evaluation framework, and eleven red flags |
| 18 | [The BPM platform](18-the-bpm-platform.md) | The second product: why it exists, the four operations it may use, and what it does to the assurance claim |
| 19 | [What the project measures about itself](19-process-self-measurement.md) | Two ledgers that measure the working method rather than the product |

Document numbers are permanent addresses, so the sequence has gaps where a topic was retired.

### Suggested paths

| If you are… | Read |
|---|---|
| new to the project | [00](00-background.md) → [16](16-what-you-can-run.md) → [18](18-the-bpm-platform.md) → [06](06-typescript-core-correctness.md) → [07](07-temporal-adapter.md) |
| assessing whether to trust the architecture | [17](17-how-to-review.md) → [02](02-evidence-and-lanes.md) → [15](15-review-and-delegation.md) → [19](19-process-self-measurement.md) → [11](11-open-questions.md) |
| interested in the semantics specifically | [05](05-semantic-core-and-il.md) → [13](13-admission-and-profiles.md) → [14](14-scopes-and-cancellation.md) → [10](10-case-study.md) |
| evaluating the formal-methods content | [01](01-theorem-techniques.md) → [09](09-property-inventory.md) → [03](03-is-lean-goal-driven.md) |
| evaluating it as a product | [18](18-the-bpm-platform.md) → [16](16-what-you-can-run.md) → [04](04-feasibility.md) |

## How to read the figures

Every number is measured against the single baseline commit above and names the artefact that produced it — a guarded catalog, a generated statistics block, or a direct count over the tracked tree. Where a figure is *derived* rather than published by the project, it says so at the point of use.

Not everything was read line by line: most individual capsule specifications are covered only through their implementation-map summaries, and the full Temporal research document, the competitive-landscape research, and the platform module sources were not read. Where a conclusion depends on something unread, it says so inline.

## Where to read more

Authoritative project documents, each with a single owner:

| Topic | Document |
|---|---|
| Contributor rules, boundaries, working method | [CLAUDE.md](../bpmn-lean-experiment/CLAUDE.md) |
| Mission, authority, product division, durable boundaries | [docs/PROJECT-DESIGN.md](../bpmn-lean-experiment/docs/PROJECT-DESIGN.md) |
| Repository layout, modular monolith, dependency direction, decision register | [docs/ARCHITECTURE.md](../bpmn-lean-experiment/docs/ARCHITECTURE.md) |
| Exact implemented and absent surfaces | [docs/IMPLEMENTATION-MAP.md](../bpmn-lean-experiment/docs/IMPLEMENTATION-MAP.md) |
| Current checkpoint, milestone ladder, ordered work, resume point | [docs/PLAN.md](../bpmn-lean-experiment/docs/PLAN.md) |
| Documentation registry — the index to everything else | [docs/README.md](../bpmn-lean-experiment/docs/README.md) |
| Commit-bounded capsule cost measurements | [docs/CAPSULE-COST-LEDGER.md](../bpmn-lean-experiment/docs/CAPSULE-COST-LEDGER.md) |
| Recorded process failures, their counts, and their dispositions | [docs/PROCESS-ASSESSMENT-LEDGER.md](../bpmn-lean-experiment/docs/PROCESS-ASSESSMENT-LEDGER.md) |
| IL contract, operation meanings, proof obligations, growth rules | [docs/SEMANTIC-PROCESS-IL-SPEC.md](../bpmn-lean-experiment/docs/SEMANTIC-PROCESS-IL-SPEC.md) |
| Topology-independent admission plus profile capability | [docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md](../bpmn-lean-experiment/docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md) |
| The execute / preserve / reject admission partition | [docs/PRESERVE-ONLY-ADMISSION-SPEC.md](../bpmn-lean-experiment/docs/PRESERVE-ONLY-ADMISSION-SPEC.md) |
| Gates, evidence lanes, review policy, test procedure | [docs/TESTING-SPEC.md](../bpmn-lean-experiment/docs/TESTING-SPEC.md) |
| Feature-by-feature Temporal witnesses, mutations, and replay coverage | [docs/TEMPORAL-TEST-EVIDENCE-MAP.md](../bpmn-lean-experiment/docs/TEMPORAL-TEST-EVIDENCE-MAP.md) |
| Production Temporal lifetime, ingress, and result contract | [docs/TEMPORAL-PROCESS-LIFECYCLE-SPEC.md](../bpmn-lean-experiment/docs/TEMPORAL-PROCESS-LIFECYCLE-SPEC.md) |
| The engine runner command and its host simulations | [docs/RUNNABLE-TEMPORAL-MVP-SPEC.md](../bpmn-lean-experiment/docs/RUNNABLE-TEMPORAL-MVP-SPEC.md) |
| The BPM platform's phase-one product contract | [docs/BPM-PLATFORM-PROPOSAL.md](../bpmn-lean-experiment/docs/BPM-PLATFORM-PROPOSAL.md) |
| Hands-on browser tutorial for the platform | [docs/BPM-PLATFORM-BROWSER-WALKTHROUGH.md](../bpmn-lean-experiment/docs/BPM-PLATFORM-BROWSER-WALKTHROUGH.md) |
| The first post-MVP scale-out roadmap | [docs/TEMPORAL-BPMN-EXECUTION-SCALABILITY-PROPOSAL.md](../bpmn-lean-experiment/docs/TEMPORAL-BPMN-EXECUTION-SCALABILITY-PROPOSAL.md) |
| Temporal platform facts and the mapping audit | [docs/research/TEMPORAL-EXECUTION-RESEARCH.md](../bpmn-lean-experiment/docs/research/TEMPORAL-EXECUTION-RESEARCH.md) |
| BPMN requirement families and dispositions | [docs/BPMN-REQUIREMENT-LEDGER.md](../bpmn-lean-experiment/docs/BPMN-REQUIREMENT-LEDGER.md) |
| CIB behaviour relative to BPMN | [docs/CIB-BPMN-RELATION-REGISTER.md](../bpmn-lean-experiment/docs/CIB-BPMN-RELATION-REGISTER.md) |
| The implemented project-owned condition language | [docs/SIMPLE-BOOLEAN-EXPRESSION-DECISION.md](../bpmn-lean-experiment/docs/SIMPLE-BOOLEAN-EXPRESSION-DECISION.md) |
| The deferred JUEL compatibility architecture | [docs/JUEL-EVALUATION-ARCHITECTURE-DECISION.md](../bpmn-lean-experiment/docs/JUEL-EVALUATION-ARCHITECTURE-DECISION.md) |
| Bounded feature meanings, laws, witnesses | [docs/capsules/](../bpmn-lean-experiment/docs/capsules/README.md) |
| The curated executable whole-model corpus | [model-corpus/](../bpmn-lean-experiment/model-corpus/README.md) |
| Superseded proposals and the retired handoff | [docs/archived/](../bpmn-lean-experiment/docs/archived/README.md) |
| The downstream adoption target itself (external, EUPL-1.2 — research input only, never a dependency) | [mgm-tp/a12-workflows](https://github.com/mgm-tp/a12-workflows) |

## Maintaining this repository

Authoring rules — scope, measurement discipline, document numbering, and the requirement that everything is written in the present tense — live in [CLAUDE.md](CLAUDE.md), also exposed through the [AGENTS.md](AGENTS.md) symlink. Read it before editing anything here.
