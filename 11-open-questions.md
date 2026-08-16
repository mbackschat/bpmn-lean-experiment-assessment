# Open questions

Seven questions the project has not settled. All of them are decisions rather than unknowns, which is a much better position than a technical wall — and the distribution has a shape worth naming up front: **the semantic and proof risks are largely resolved, and what remains is economics and sequencing.**

Two of the seven are settled and retained because their resolution is instructive. Two are answered for a bounded case. Three are genuinely open, and all three are about whether the project can afford its own standards at scale.

## 1 · Is a universal preservation theorem the right gate for widening admission? — **settled: no**

**Resolution: a targeted per-capsule preservation gate, approved 2026-07-30, replacing the staged universal programme.**

The programme it replaced is still in the tree: seven proof stages, ~2,500 nonblank experimental Lean lines, and stage sizes that did not amortise (229 → 127 → 276 → 298). That is a stop-and-reduce signal on the project's own reflection criterion, and the owner acted on it. Nothing was discarded — Stages 1–3b remain accepted, frozen experiments, and the graph-validation results *graduated* into production `programWellFormed`. The universal theorem retains an explicit reopen trigger: it becomes mandatory *"when a second capsule needs the same proposition or the targeted proof cannot isolate the risk without recreating the general bridge."*

**The sub-question that mattered — does the targeted gate stay local? — is answered yes**, across roughly twenty capsules and three shapes nobody had tested it against when it was written: cycles (which removed acyclicity as a *premise*, not merely as a restriction), cancellation, and publication completeness. The evidence is a family of theorems that a universal programme would never have produced: exact closure figures per mechanism, each paired with an *exhaustion* witness proving the figure is tight rather than merely sufficient. Where a genuinely new hazard appeared — the Inclusive Gateway's first *data-dependent* multiple-enabled state — the capsule closed a local activation-order equality rather than reaching for commutation. The reopen trigger has never fired.

**There is a second, unlooked-for confirmation.** The capability the seven stages were built to unlock — stop writing a compiler per topology — shipped anyway by a cheaper route once the theorem stopped gating it. The [profile-parameterized admission work](../bpmn-lean-experiment/docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md) removed the whole-topology predicates in ordinary implementation work, and an executable guard prohibits reintroducing one.

**What the gate did not fix**, and was never designed to, is question 6. Full account in [03](03-is-lean-goal-driven.md).

## 2 · Can one mechanism be generalised from a literal to a family?

**This is the central question of the whole project, and it is the one that has not moved.**

Thirty bounded mechanism slices have closed excellently; **zero horizontal generalisations of a mechanism have shipped.** Every implemented mechanism is pinned to a literal: `PT1S` only, exactly two balanced branches, two conditional flows plus one default, one error code, one protocol binding, one in-document called Process, one level of scope, one incident generation.

The cheap calibration point is unchanged and still untaken: **take the timer from `PT1S`-only to a general ISO-8601 duration subset.** It touches admission, lowering, Lean normalisation, the core, the CIB controlled clock, and the Temporal durable timer — every lane — while introducing no new semantic mechanism at all. That makes it close to a pure measurement of what generalisation costs across the stack.

**One partial answer exists and is easy to over-claim.** Admission *did* generalise: the graph-shape half is one topology-independent validator, and profile capability is the per-profile half, with an executable guard against a regression to whole-topology disjuncts. That is a real horizontal generalisation. But it generalised the *structural* dimension only. No profile admits a *family* of models; each still enumerates its mechanism kinds and cardinalities as a multiset. So the question stands, with its scope narrowed to the capability side. A second generalisation shipped alongside it — the execute/preserve/reject admission partition, which classifies *arbitrary* parsed material rather than an enumerated set — and it is the closest thing to a family admission in the repository, but it deliberately assigns no execution meaning to what it preserves.

**And the measurement is getting harder to read, by attrition rather than by decision.** There are now **four separate `PT1S`-pinned capsules** — the Intermediate Catch Timer and three boundary-Timer loci. A duration family would have to reach all four, so "what does generalising cost" is increasingly confounded with "what does generalising cost *now that four siblings pin the same literal*". That cuts both ways: the measurement is less clean, and it is also more valuable, because it would double as a test of whether a generalisation composes across siblings that were built one at a time.

## 3 · Can the IL absorb scopes as a layer rather than a rewrite? — **answered for one level**

It could not be absorbed as a layer, and it was not: the representation was **replaced**, and the proofs survived the replacement.

The [ordinary embedded Sub-Process capsule](../bpmn-lean-experiment/docs/capsules/EMBEDDED-SUBPROCESS-COMPLETION-SPEC.md) introduced a canonical **definition-scope forest** in both the checked graph and the IL with exact node, flow, operation, and control-place ownership; **runtime scope occurrences** owning tokens and every wait kind; and — the part that shows it was a rewrite rather than an extension — it **removed `terminate`** in favour of `reachNoneEnd` plus quiescent `completeScope`, because reaching an end event and completing a scope are only the same thing in a flat model. The [Error propagation capsule](../bpmn-lean-experiment/docs/capsules/SUBPROCESS-ERROR-PROPAGATION-SPEC.md) then added regional cancellation of a child occurrence subtree with monotonic counter and root-work preservation, and Terminate End later added selected-occurrence cancellation over every represented owner family.

**What that establishes:** the replacement was performed on the genuinely hard case, with Lean relations, laws, non-laws, independent TypeScript behaviour, CIB-backed schedules, and Temporal evidence containing **zero Child Workflow or cancellation events**.

**What it does not establish:** *depth and repetition*. Arbitrary nesting, repeated activation of one definition scope, loops that re-enter a scope, concurrent occurrences of the same child definition, and Event Sub-Processes remain absent. Nothing in `enterScope`'s *type* prevents naming the same child twice; what prevents it is that **every law and closure bound assumes there is not one**. The exact closure figures are per-mechanism constants, and a re-enterable scope has no constant.

And note the asymmetry that survived: definition scopes nest one level, **variable scopes do not nest at all**. `IMPLEMENTATION-MAP.md` lists as absent *"variable-scope traversal, shadowing, or variable scope kinds beyond the implemented effect-local slice"*. Those two dimensions were deliberately decoupled and only one moved, so a Sub-Process-local variable is not expressible. See [14](14-scopes-and-cancellation.md).

## 4 · How do two expression languages coexist for one BPMN mechanism?

The implemented path is a project-owned [Simple Boolean language](../bpmn-lean-experiment/docs/SIMPLE-BOOLEAN-EXPRESSION-DECISION.md): one immutable URI, five total Boolean forms, `string | null` Process-scope context, **parsed and evaluated independently in Lean and in the TypeScript core**, hosted entirely inside pure internal closure with no evaluator Activity and no expression-specific Temporal Event. The [JUEL architecture](../bpmn-lean-experiment/docs/JUEL-EVALUATION-ARCHITECTURE-DECISION.md) remains owner-selected as *the* CIB compatibility approach, with its 38-jar graph audited and **unadopted**.

**The reasoning behind that split is worth understanding, because it reframes a trade rather than resolving it.** Delegating expression truth to a pinned runtime avoids creating a permanent second source of truth for expression semantics — correct, for JUEL. What it misses is that a *closed, total, five-form* language is small enough to transcribe twice and prove things about, so it does not create a rival truth account; it creates a bounded one with laws (`first_true_ignores_tail`, `selected_output_owned`). The answer was not "delegate or duplicate" but **"pick a language small enough that duplication is safe."**

**What remains genuinely open** is the cost of that choice and the shape of its successor. The implemented language claims **zero** A12 adoption coverage — none of the 16 retained A12 condition occurrences uses its URI — so the standards-first choice bought a clean semantic account and no progress on goal 2. When a CIB or A12 expression-compatibility claim is actually needed, JUEL returns with three dormant open items intact: the deployment-time validation transport, the disposition of a suspended evaluation after exhausted attempts, and cross-SDK payload compatibility. Plus a fourth that is new and unaddressed: **how two expression languages coexist for the same BPMN mechanism without the semantic core acquiring a language selector.** `PROJECT-DESIGN.md` anticipates it — a second language must arrive as *"another language result to that BPMN mechanism through a separately approved compatibility capsule"* — but no capsule has tested whether that composes.

## 5 · What happens to the pre-release freedom when the first durable baseline lands?

A great deal of the project's agility comes from a policy that will end by design: no retained Event History fixtures, no Workflow patch branches, no migration functions, no compatibility readers, no deployment fallbacks. Every gate starts clean state and discards it.

**The atomic replacements are the strongest illustration of what that policy is worth.** Splitting `terminate` into `reachNoneEnd` plus `completeScope`; replacing the flat variable field with scoped variables; replacing `MessageChannel` with a closed two-arm union across TypeScript, Lean, three schemas, Java, artefacts, and Temporal command identity. Each replaced *every* producer and consumer in one change with no parallel reader anywhere — and a pre-release infrastructure guard rejects embedded format counters, retired representation names, and compatibility paths so the policy cannot erode quietly. **None of those three would be a single change after a durable baseline.** Each would need version markers, migration evidence, and retained histories.

`PROJECT-DESIGN.md` names five approvals that close this window: which artefacts become immutable, the Event History and version-marker baseline, migration/patching/rollback rules, retained replay fixtures and their provenance, and support windows with removal criteria.

**Why this is more pressing than it looks.** A functional MVP exists with a browser product on top of it, and the distance between "we have a product someone could run" and "someone has data in a Workflow we must not break" is one deployment. The approved next increment makes it sharper still: the [shared persistence work](../bpmn-lean-experiment/docs/BPM-PLATFORM-SHARED-PERSISTENCE-AND-PROJECTION-PROPOSAL.md) introduces PostgreSQL with **checksum-bound migrations** — the first artefact in the tree that must survive its own gate — and its resume point explicitly forbids the incremental path: *"Replace repository ports and every producer, consumer, fake, and test atomically with one asynchronous contract; do not retain parallel synchronous and asynchronous service paths."* That is the pre-release freedom being spent again, deliberately, on the largest replacement so far.

The question is sequencing rather than design: **how much semantic breadth should exist before that window closes?** "As much as possible first" is easy to argue; the counter-argument is that a system with no users has no forcing function for durability decisions, and those decisions get harder to make well in the abstract the longer they wait. Worth deciding deliberately rather than discovering.

## 6 · Does the cost per mechanism fall, and if not, what is the plan?

**This is the binding constraint.** The [capsule cost ledger](../bpmn-lean-experiment/docs/CAPSULE-COST-LEDGER.md) records forty measured increments, and the engine picture is:

| Kind of increment | Nonblank code additions |
|---|---|
| data and tooling increments | 289 – 1,760 |
| **a new BPMN mechanism family** | **3,000 – 6,500** |
| the second or third member of an existing family | falls measurably — `+5521` → `+3970` → `+3578` across the three boundary Timers |

Thirteen mechanism families remain disposed `unsupported` in the project's own ledger.

**The proof lane is not the bottleneck.** Question 1 established that proof obligations are local and proportional. The bottleneck is breadth: source admission, wire schemas, Lean, the core, Temporal, differential artefacts, six owner documents, and a review cycle per capsule.

**Reuse works where a seam exists**, and the ledger attributes each fall to a named mechanism rather than to a smaller feature — a scheduler parameterised over a host-family descriptor, with the copied module *deleted* rather than left beside a third. **But reuse is not enough, because each family opens a new seam.** Call Activity reused everything available and still cost 5,801 lines, because a second root definition, a distinct semantic instance identity, and paired invoke/return are genuinely new.

`CLAUDE.md`'s reflection checklist demands *"remove one identified process weight before starting the next capsule when the measured cost did not fall"*, and it is being honoured with specific, executed removals rather than gestures ([03](03-is-lean-goal-driven.md#what-the-reflection-checklist-demands)). **The open question is whether any lever changes the slope rather than shaving it**, and only two candidates are visible: generalising a mechanism once (question 2, untaken), and admitting families rather than shapes (unproposed). Neither is scheduled.

This is not a crisis; it is an arithmetic problem stated honestly by the project's own instrument.

## 7 · Is the review and governance regime's cost proportional to its yield?

The regime is a genuine advance in rigour: cold proposal review, a conditional semantic-checkpoint review, and a governed closure review, each with a committed immutable target and a receipt whose SHAs an infrastructure guard resolves as `HEAD` ancestors. Cold reviewers are spawned with no shared conversation history (`fork-turns-none`) and must inherit the author's model and reasoning effort — no cheaper tier may substitute.

**It yields real defects, and they change code rather than prose.** A closure review caught a confusion between host and semantic task addresses in exactly the seam most at risk. Another caught a derived fact and its supposed independent oracle sharing the same constructors and owner resolver, so *"one wrong owner or Process identity could make both sides agree and pass"* — a correlated-lane defect of precisely the kind no gate detects. Another caught a formal assurance claim whose theorems restated a helper's output without connecting the operation and stimulus branches.

**It is also cost, arriving where cost is already high.** Every material capsule carries two or three review cycles with committed targets and audited receipts, and the governance documents themselves are substantial.

**What is genuinely open** is the ratio, and the honest answer is that nobody can compute it, because the instrument does not measure it. The cost ledger measures code and documentation churn, explicitly not *"proof strength, test independence, JSON evidence volume, generated output, or wall time"* — and review effort is none of those. Elapsed time is `Unknown` on all forty rows.

Three sub-questions worth naming:

- **Attribution.** Review-infrastructure work and feature work land in the same measured ranges, and the ledger flags this rather than subtracting. Honest for attribution, unhelpful for isolating the regime's cost.
- **The one hard number is a failure report.** A correction-audit loop ran three rounds with nothing terminating it, at *"roughly 640,000 reviewer tokens on one planning document"*, and **the owner stopped it rather than any rule**. The bound is now explicit at two audits per stage. That is the only quantified review cost in the project, and it arrived as an overrun.
- **The `fork-turns-none` attestation.** The guard verifies that a receipt *records* context isolation and no model override; `CLAUDE.md` states plainly that *"Git cannot independently verify either runtime fact."* So the strongest guarantee in the regime rests on an attestation, and the project says so. That is the honest position, and it is also the one place where the executable guard is weaker than it looks.

The yield side is now partly instrumented by the [process assessment ledger](../bpmn-lean-experiment/docs/PROCESS-ASSESSMENT-LEDGER.md), which counts what review and self-assessment actually caught — 117 recorded instances across 37 finding classes, 78 of them now behind an executable guard. It counts catches, not costs, so it halves the question rather than answering it. See [19](19-process-self-measurement.md).

## The shape of all seven

None is a technical wall. Two are settled, two are answered for a bounded case, and three are cost or sequencing questions.

**The semantic and proof risks have largely resolved, and what remains is economics.** Questions 1 and 3 were the frightening ones — will the proof programme ever pay, will the representation survive scopes — and both went well. Questions 6 and 7 are about whether the project can afford its own standards at forty-family scale, and question 5 is about spending a freedom that is finite by design.

That the questions can be posed this precisely is downstream of the thing worth crediting most: the project refuses to fake its own numbers, keeps four coverage denominators separate, documents absences more carefully than presences, deleted its own vacuous theorems, declares sixteen profiles to have no oracle lane rather than manufacturing one, and built both instruments that now show its costs are not falling and its process failures repeat. The supersession recorded in question 1 was only possible *because* seven stages of honest cost data existed to look at. Question 6 exists on the same basis, and will presumably be answered the same way.
