# bpmn-lean-experiment — architecture, assurance, and feasibility

**A beginner-oriented walkthrough, assembled from a Q&A session and re-verified against the current tree.**

## Purpose, and the charter that drives updates

**Purpose.** This repository explains *why* [`bpmn-lean-experiment`](https://github.com/mbackschat/bpmn-lean-experiment) is built the way it is, and *how far along it honestly is*, to someone who does not already know BPMN, Lean, or Temporal internals. It is a **reasoned assessment**, not a manual and not an authority. Its value is synthesis and judgement across boundaries the repository deliberately keeps separate — because each repository document is correctly narrow, and nothing there is allowed to say "here is the whole picture, and here is what it is worth".

> **Clone both side by side.** Every link into the described project is relative and assumes a sibling checkout:
>
> ```sh
> git clone https://github.com/mbackschat/bpmn-lean-experiment.git
> git clone https://github.com/mbackschat/bpmn-lean-experiment-assessment.git
> ```
>
> Those `../bpmn-lean-experiment/…` links do not resolve while browsing this repository on GitHub, because they deliberately point outside it. Read the record locally, or use the [Where to read more](#where-to-read-more) table to reach the project's documents on GitHub.

**It is never authoritative.** The repository's own documents win every disagreement, always. Where a statement here conflicts with [docs/IMPLEMENTATION-MAP.md](../bpmn-lean-experiment/docs/IMPLEMENTATION-MAP.md), the implementation map is right and this folder has a bug. Nothing here may be the sole source of any claim.

**Three readers.** A *newcomer* needs [00](00-background.md), then [06](06-typescript-core-correctness.md) and [07](07-temporal-adapter.md). A *returning reader* needs [12](12-corrections-log.md) and [What changed](#what-changed-since-the-30-july-version) to learn which earlier warnings still apply. A *reviewer* deciding whether to trust the architecture needs [02](02-evidence-and-lanes.md), [04](04-feasibility.md), and [11](11-open-questions.md).

### In scope

- **Reasoning, not restatement** — why two hand-written transcriptions, why non-laws are mandatory, why an oracle reads bytes, why a host capability is not semantic admission.
- **The boundary of every claim** — what a passing lane does and does not establish. This is the single most valuable thing here and the easiest to get wrong.
- **Honest assessment** — feasibility, measured cost, residual correlation, and named open questions with their trade-offs.
- **Falsification history** — every claim an earlier revision got wrong, and its disposition. [12](12-corrections-log.md) is where this folder's credibility lives.
- **Cross-cutting synthesis** — topics that span several repository owners and therefore have no single owner to consult.

### Out of scope

| Excluded | Why |
|---|---|
| **Live inventories** — case catalogs, profile lists, evidence matrices, test counts | A hand-maintained copy of something the code owns *will* drift. The project removed its own walkthrough surface (`e4402a5`) so no curated catalog could become a competing scope authority, and `CLAUDE.md` requires counts to be derived from the guarded catalogs. [13](13-admission-and-profiles.md#one-inventory-drift-found-while-writing-this-document--since-resolved) records a live example of exactly this failure inside the repo. |
| **Any claim not sourced from the repository or its executable evidence** | This folder must never become the place a fact originates. |
| **Predictions about unbuilt work presented as near-future fact** | Three claims were falsified this way in one revision ([12](12-corrections-log.md#three-claims-this-record-itself-got-wrong)). An owner-approved design is *"what the approved design implies"*, never "what is about to exist". |
| **Aggregated support claims** — percentages, "supported" verdicts, merged denominators | The project keeps BPMN, CIB, and A12 coverage as three separate denominators and never combines them. Neither does this folder. |
| **Advocacy** | The reader is deciding whether to trust the work. An assessment that flatters it is worthless to them. |
| **Repository changes** | This folder is a record. Defects it finds in the repo are *reported*, not fixed here. |

### What matters most, in priority order

1. **The scope of each claim is correct.** A well-bounded stale figure is recoverable; a confidently over-broad claim misleads. Fix scope errors first.
2. **[12](12-corrections-log.md) is complete and current.** A returning reader must be able to tell which warnings still apply.
3. **Every quoted figure names the artefact that produced it.** Vocabulary drift is now caught by an executable guard in the repo; **numeric drift is not**, and attribution is the only defence.
4. **What changed since the last revision is explicit**, including what did *not* change.
5. Prose quality — genuinely last.

### Update discipline

- **Re-measure against one exact commit; never carry a figure forward.** Record that commit, and record any later commits you checked but did not re-baseline against.
- **Quote the repository for contracts**; paraphrasing a contract is how a boundary silently widens.
- **When this record was wrong, add it to [12](12-corrections-log.md)** rather than silently editing. The falsification history is the deliverable, not an embarrassment.
- **Prefer deleting a stale section to half-updating it.** A section that is 60% current is worse than an absent one.
- **When a topic outgrows its host document, add a document.** Append a number; do not renumber, because inbound links and anchors break. Do not inflate an existing document past its question.
- **State the residual.** Every document should end knowing what it has *not* established.

> ### Project version this record describes
>
> | | |
> |---|---|
> | **Repository** | `bpmn-lean-experiment`, branch `main` |
> | **Commit** | `2a29e94` — `fix(admission): synchronize profile capability documentation` |
> | **Commit date** | 3 August 2026 |
> | **Worktree** | clean |
> | **This revision written** | 3 August 2026 |
> | **Measurement baseline** | `5b65954` (3 August 2026, 00:10) — see note below |
> | **Previous revisions** | `93943f5` (30 July 2026) · `362f91f` (29 July 2026) |
>
> Every figure, quotation, file path, and line count below was measured against `5b65954`. Three commits landed afterwards and were each checked against this record:
>
> | Commit | Effect on this record |
> |---|---|
> | `eda0140` — isolate publication statistics | renamed the statistics generator; no figure quoted here changed (still 327 public theorems, 26 supporting lemmas) |
> | `e873ec7` — guard retired semantic vocabulary | corrected five documentation-drift sites **this review found**; see [12 §10](12-corrections-log.md#10--four-implemented-specifications-named-a-retired-il-operation--resolved-in-code-and-guarded) |
> | `2a29e94` — synchronize profile capability documentation | corrected two further drift defects **this review found**, including one where a specification contradicted the authority document; see [13](13-admission-and-profiles.md#one-inventory-drift-found-while-writing-this-document--since-resolved) |
>
> None changed a semantic claim or an executable admitted set, so no figure below was restated. Two of those three commits fixed defects that this review itself surfaced — the folder working as intended, and the reason [12](12-corrections-log.md) is the document to read first on a return visit.
>
> The repository moves fast — 173 commits landed in the four days before the baseline — so treat any statement here as *dated*, and check [docs/IMPLEMENTATION-MAP.md](../bpmn-lean-experiment/docs/IMPLEMENTATION-MAP.md) and [docs/PLAN.md](../bpmn-lean-experiment/docs/PLAN.md) for current truth.

## Revision history

The original single document was written on 29 July 2026 against commit `362f91f`. A second revision re-measured it against `93943f5` (30 July 2026). **This third revision re-measures every figure against `5b65954` (3 August 2026)**, after 173 further commits, and adds four documents ([13](13-admission-and-profiles.md)–[16](16-what-you-can-run.md)) for topics that outgrew their hosts.

The four days between the second and third revisions were the densest in the project's history: three new gateway/call capsules, two Sub-Process capsules, a Receive Task capsule, the first runnable product command, and a formalised independent-review regime all landed. Authoritative repository documents are indexed under [Where to read more](#where-to-read-more).

## Reading order

| # | Document | What it answers |
|---|---|---|
| 0 | [Background for newcomers](00-background.md) | What BPMN, CIB Seven, A12, Temporal, and Lean are, and who is allowed to decide what |
| 1 | [How theorems are used](01-theorem-techniques.md) | Why formalise at all, and the proof techniques the project actually uses |
| 2 | [Evidence, lanes, and mutations](02-evidence-and-lanes.md) | What "evidence" means here, why it is not a test, and the rule that makes two lanes count as two |
| 3 | [Is the Lean work goal-driven?](03-is-lean-goal-driven.md) | The proof-cost question, its resolution on 2026-07-30, **and how the replacement gate performed across six subsequent capsules** |
| 4 | [Is the goal feasible?](04-feasibility.md) | Three goals with three different sets of odds — **now with measured per-capsule cost data** |
| 5 | [The semantic core and the IL](05-semantic-core-and-il.md) | The four packages, the **seventeen**-operation IL, and what lowering does |
| 6 | [How the TypeScript core is written and checked](06-typescript-core-correctness.md) | It is not generated from Lean — so how is it produced, and what establishes that it is right? |
| 7 | [How the Temporal adapter works](07-temporal-adapter.md) | The durability layer, the **fourteen** problems it faces, and how each is solved |
| 8 | [Could Temporal be swapped later?](08-swapping-temporal.md) | Portability, and the **three** couplings that constrain the choice |
| 9 | [Property inventory](09-property-inventory.md) | What is proven today, by category, with named representatives |
| 10 | [Case study — one process through every layer](10-case-study.md) | The smallest complete example, traced end to end |
| 11 | [Open questions](11-open-questions.md) | What is genuinely undecided now |
| 12 | [Corrections log](12-corrections-log.md) | Every claim the reviews falsified, and its current disposition |
| 13 | **[Admission and profiles](13-admission-and-profiles.md)** | **New.** The four separate questions behind "is this model supported?", and the one generalisation that shipped |
| 14 | **[Scopes, quiescence, and cancellation](14-scopes-and-cancellation.md)** | **New.** The largest semantic addition of this window: definition scopes, quiescent completion, regional cancellation, called roots |
| 15 | **[How the project governs its own claims](15-review-and-delegation.md)** | **New.** The cold/warm review regime, its executable guard, its attestation gap, and the delegated-implementation protocol |
| 16 | **[What you can actually run today](16-what-you-can-run.md)** | **New.** The MVP command, the dummy actor, the 28-case catalog, and their explicit non-claims |
| 17 | **[How to review this project](17-how-to-review.md)** | **New.** Ten traps, an eight-dimension evaluation framework, and eleven red flags — moved here from the project's own reviewer guide |

### Suggested paths

| If you are… | Read |
|---|---|
| new to the project | [00](00-background.md) → [16](16-what-you-can-run.md) → [06](06-typescript-core-correctness.md) → [07](07-temporal-adapter.md) |
| returning after the 30 July revision | [12](12-corrections-log.md) → [What changed](#what-changed-since-the-30-july-version) → [04](04-feasibility.md) → the four new documents |
| assessing whether to trust the architecture | [17](17-how-to-review.md) → [02](02-evidence-and-lanes.md) → [15](15-review-and-delegation.md) → [04](04-feasibility.md) → [11](11-open-questions.md) |
| interested in the semantics specifically | [05](05-semantic-core-and-il.md) → [13](13-admission-and-profiles.md) → [14](14-scopes-and-cancellation.md) → [10](10-case-study.md) |
| evaluating the formal-methods content | [01](01-theorem-techniques.md) → [09](09-property-inventory.md) → [03](03-is-lean-goal-driven.md) |

If you only read three: [00](00-background.md), then [06](06-typescript-core-correctness.md) and [07](07-temporal-adapter.md).

## What changed since the 30 July version

173 commits landed between `93943f5` and `5b65954`. Nine of them changed conclusions in the previous revision.

| Change | Effect on the previous revision |
|---|---|
| **The reviewer Proto-MVP milestone closed** at `4f2fe61` — 28 registered scenarios, 18 CIB-backed and 10 standards-only, 30 disposable histories, 56 isolated Workflow executions | Every "ten scenarios / twelve histories / twenty executions" figure in the previous revision is superseded |
| **Three new mechanism capsules closed**: [Inclusive Gateway](../bpmn-lean-experiment/docs/capsules/INCLUSIVE-GATEWAY-SPEC.md), [Event-Based Gateway](../bpmn-lean-experiment/docs/capsules/EVENT-BASED-GATEWAY-SPEC.md), [Call Activity](../bpmn-lean-experiment/docs/capsules/CALL-ACTIVITY-SPEC.md) | [04](04-feasibility.md) and [09](09-property-inventory.md) rewritten; the IL grew from seven operations to seventeen |
| **Two Sub-Process capsules closed** — ordinary completion and direct-parent Error propagation — introducing definition scopes and runtime scope occurrences | **Open question 3 moves from "partly answered" to "largely answered for one level"** — see [11](11-open-questions.md) |
| **The Exclusive Gateway shipped standards-first, not JUEL-delegated.** A project-owned [Simple Boolean language](../bpmn-lean-experiment/docs/SIMPLE-BOOLEAN-EXPRESSION-DECISION.md) is parsed and evaluated independently in Lean and TypeScript; JUEL is deferred and unadopted | **Open question 4 of the previous revision is obsolete as posed**; [00](00-background.md)'s expression-ownership section was wrong and is rewritten |
| **Lean's within-kind wait ordering was fixed** — `sortActiveWaitsByElementId` now runs per kind group, and the four-kind fixture carries a reverse-ordered same-kind pair | **Correction 3 is now fully closed in code**, not merely honestly qualified — see [12](12-corrections-log.md) |
| **A runnable product command shipped** — [the MVP](../bpmn-lean-experiment/docs/RUNNABLE-TEMPORAL-MVP-SPEC.md) runs the same generic Workflow against a caller-owned Temporal service with a simulated form actor | New material in [07](07-temporal-adapter.md) |
| **A commit-bounded [capsule cost ledger](../bpmn-lean-experiment/docs/CAPSULE-COST-LEDGER.md) now exists** with twelve measured increments | [04](04-feasibility.md)'s "the cost never falls" worry stops being a prediction and becomes a measurement |
| **The independent-review regime became executable** — cold/warm rules, same-model/same-effort sub-agent reviewers, receipts validated as `HEAD` ancestors by an infrastructure guard from immutable baseline `f1ef362` | Now has its own document, [15](15-review-and-delegation.md); cost discussed in [03](03-is-lean-goal-driven.md) and [11 §7](11-open-questions.md#7--is-the-review-regimes-cost-proportional-to-its-yield--new) |
| **Whole-topology admission predicates were removed and prohibited** — one topology-independent validator plus per-profile capability, with host capability split out as a separate pre-start question | Now has its own document, [13](13-admission-and-profiles.md); it is the only horizontal generalisation in the repository |
| **The supplied architecture handoff was retired to `docs/archived/`**, and the compositional-admission proposal moved there too | The previous revision's "not read line by line" list shrank accordingly |

## Provenance

All figures are measured against commit `5b65954` ("docs(readme): omit kotlin statistics"), 3 August 2026, on a clean worktree.

**Read directly for this revision:** `CLAUDE.md`, `docs/PROJECT-DESIGN.md`, `docs/IMPLEMENTATION-MAP.md` (complete), `docs/PLAN.md` (complete), `docs/TESTING-SPEC.md`, `docs/CAPSULE-COST-LEDGER.md`, `docs/PROTO-MVP-REVIEWER-GUIDE.md`, `docs/RUNNABLE-TEMPORAL-MVP-SPEC.md`, `docs/JUEL-EVALUATION-ARCHITECTURE-DECISION.md`, `docs/research/A12-WORKFLOWS-COMPATIBILITY-LEDGER.md`, the complete `packages/semantic-core/src`, `packages/temporal-adapter/src/workflow-implementation.ts` and `host-admission.ts`, `BpmnSemantics/SemanticProcess/Scenario.lean`, `BpmnSemantics/SemanticProcess/Fixtures.lean`, `BpmnSemantics/SequentialUserTask.lean`, the scenario and profile registries, and the generated repository-statistics block in `README.md`.

**Line counts and declaration counts** come from the repository's own generated statistics block plus direct nonblank counts over the tracked tree, not from estimates.

**Still not read line by line:** the individual capsule specs other than through their implementation-map summaries, and the full Temporal research document. Where a conclusion depends on something unread, it says so inline.

## Where to read more

Authoritative project documents, each with a single owner:

| Topic | Document |
|---|---|
| Contributor rules, boundaries, working method | [CLAUDE.md](../bpmn-lean-experiment/CLAUDE.md) |
| Mission, authority, durable boundaries, two kinds of independence | [docs/PROJECT-DESIGN.md](../bpmn-lean-experiment/docs/PROJECT-DESIGN.md) |
| Exact implemented and absent surfaces | [docs/IMPLEMENTATION-MAP.md](../bpmn-lean-experiment/docs/IMPLEMENTATION-MAP.md) |
| Current checkpoint, ordered work, resume point | [docs/PLAN.md](../bpmn-lean-experiment/docs/PLAN.md) |
| Reviewer-facing tour of the closed Proto-MVP | [docs/PROTO-MVP-REVIEWER-GUIDE.md](../bpmn-lean-experiment/docs/PROTO-MVP-REVIEWER-GUIDE.md) |
| Commit-bounded capsule cost measurements | [docs/CAPSULE-COST-LEDGER.md](../bpmn-lean-experiment/docs/CAPSULE-COST-LEDGER.md) |
| IL contract, operation meanings, proof obligations, growth rules | [docs/SEMANTIC-PROCESS-IL-SPEC.md](../bpmn-lean-experiment/docs/SEMANTIC-PROCESS-IL-SPEC.md) |
| Topology-independent admission plus profile capability | [docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md](../bpmn-lean-experiment/docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md) |
| Gates, evidence lanes, review policy, test procedure | [docs/TESTING-SPEC.md](../bpmn-lean-experiment/docs/TESTING-SPEC.md) |
| Production Temporal lifetime, ingress, and result contract | [docs/TEMPORAL-PROCESS-LIFECYCLE-SPEC.md](../bpmn-lean-experiment/docs/TEMPORAL-PROCESS-LIFECYCLE-SPEC.md) |
| The runnable product command and its dummy form actor | [docs/RUNNABLE-TEMPORAL-MVP-SPEC.md](../bpmn-lean-experiment/docs/RUNNABLE-TEMPORAL-MVP-SPEC.md) |
| Temporal platform facts and the mapping audit | [docs/research/TEMPORAL-EXECUTION-RESEARCH.md](../bpmn-lean-experiment/docs/research/TEMPORAL-EXECUTION-RESEARCH.md) |
| BPMN requirement families and dispositions | [docs/BPMN-REQUIREMENT-LEDGER.md](../bpmn-lean-experiment/docs/BPMN-REQUIREMENT-LEDGER.md) |
| CIB behaviour relative to BPMN | [docs/CIB-BPMN-RELATION-REGISTER.md](../bpmn-lean-experiment/docs/CIB-BPMN-RELATION-REGISTER.md) |
| The implemented project-owned condition language | [docs/SIMPLE-BOOLEAN-EXPRESSION-DECISION.md](../bpmn-lean-experiment/docs/SIMPLE-BOOLEAN-EXPRESSION-DECISION.md) |
| The deferred JUEL compatibility architecture | [docs/JUEL-EVALUATION-ARCHITECTURE-DECISION.md](../bpmn-lean-experiment/docs/JUEL-EVALUATION-ARCHITECTURE-DECISION.md) |
| Bounded feature meanings, laws, witnesses | [docs/capsules/](../bpmn-lean-experiment/docs/capsules/README.md) |
| Superseded proposals and the retired handoff | [docs/archived/](../bpmn-lean-experiment/docs/archived/README.md) |
| Documentation registry | [docs/README.md](../bpmn-lean-experiment/docs/README.md) |
| The downstream adoption target itself (external, EUPL-1.2 — research input only, never a dependency) | [mgm-tp/a12-workflows](https://github.com/mgm-tp/a12-workflows) |
