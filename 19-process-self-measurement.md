# What the project measures about itself

*[15](15-review-and-delegation.md) covers how the project reviews its claims. This covers something different: two ledgers that measure the project's own **working method**, one of which has no equivalent in any repository I have read.*

## Two instruments, measuring two different things

| Instrument | Denominator | What it refuses to measure |
|---|---|---|
| [Capsule cost ledger](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/CAPSULE-COST-LEDGER.md) | reproducible nonblank code and documentation churn per closed increment, commit-bounded | *"semantic value, proof strength, test independence, JSON evidence volume, generated output, or wall time"* |
| [Process assessment ledger](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/PROCESS-ASSESSMENT-LEDGER.md) | observed weaknesses in **how** work was carried out, separately from whether its claims were sound | defects a gate rejected — *"the guard already worked"* |

The first holds **forty** measured increments and is treated in [04](04-feasibility.md#the-cost-curve-measured) and [11 §6](11-open-questions.md#6--does-the-cost-per-mechanism-fall-and-if-not-what-is-the-plan). The second is the subject of this document.

## The process ledger, and the rule that gives it teeth

Its stated reason for existing is precise about the failure it closes:

> [The capsule reflection](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/CLAUDE.md) already requires turning each escaped issue into a reusable review question or an executable guard, and [the closure review](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/TESTING-SPEC.md) repeats that requirement. **Neither kept a record**, so a finding could be answered with fresh prose, forgotten, and repeated — and a repeat was indistinguishable from a first occurrence.

That last clause is the whole design. A process rule that fires once looks identical to one that fires every time, and prose cannot tell you which you have. The ledger makes recurrence *countable*, and then attaches a consequence to the count:

> A finding recorded a second time **refutes its own prose disposition**: the rule existed and did not bind. The second occurrence therefore requires an **executable guard**, not a better-worded reminder.

Dispositions are a closed set of four, and one of them is the interesting one:

| Disposition | Meaning | Admissible at |
|---|---|---|
| `executable guard` | a gate now rejects the class, not only the reported instance | any count |
| `review question` | added to the self-assessment questions or a reviewer prompt | **one instance only** |
| `accepted risk` | understood, not worth a guard, explicitly tolerated | **one instance only** |
| `unguardable` | *no repository fact can detect the class*, so no gate can enforce it | any count, but must state why |

And — the part that makes this more than a good intention — [an executable check](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/scripts/document-reviewability.test.ts) enforces it: **a row at two or more instances whose disposition is not `executable guard` fails the infrastructure gate.** The ledger about escaped process failures is itself guarded against becoming an unenforced list.

Checked against the current tree, the rule is honoured exactly. Thirty-seven rows, one hundred and seventeen recorded instances:

| Disposition | Rows | Instances |
|---|---:|---:|
| `executable guard` | 26 | 78 |
| `unguardable` | 3 | 31 |
| `review question` | 8 | 8 |

Every one of the eight `review question` rows sits at exactly one instance. Nothing has escaped the escalation rule by being re-worded.

## The `unguardable` disposition is the honest part

Three rows carry it, and they hold 31 of the 117 instances — more than a quarter of everything the project has recorded about its own working method. They are worth naming, because they are a taxonomy of the errors an agent-driven repository actually makes:

| Instances | The class |
|---:|---|
| **17** | *"A checklist item was corrected only where attention already was, leaving its siblings unaudited."* One obligation stated in several places; each correction fixes the copy that was on screen. |
| **7** | *"Which module or conjunct enforced a behavior was asserted without opening or probing it, and the claim was wrong."* |
| **7** | *"A verification claim was made without establishing both the exact gate invocation's own result and the scope that invocation exercised."* |

Each row states why no gate can reach it, and the reasoning is specific rather than a shrug. For the second: *"no repository fact distinguishes a prose or comment sentence that names the right conjunct from one that names a neighbouring conjunct of the same predicate, because both compile and both leave the test green."* For the third: *"no repository fact can observe which output an agent read or how broadly the result was described."*

That is exactly the shape of disclosure this record credits elsewhere — [15](15-review-and-delegation.md#what-is-executable-and-where-the-attestation-gap-is) on `fork-turns-none` attestation, [02](02-evidence-and-lanes.md#5--fidelity-labels--how-strongly-does-this-observation-actually-support-the-claim) on fidelity labels. Enforce everything enforceable, then say plainly which single fact is attested rather than checked.

**The 17-instance row deserves singling out**, because it is the most-repeated recorded failure in the repository and its root cause is a rule the project already has. `CLAUDE.md`'s documentation discipline is *one owner per fact, with others linking to it.* The row's own diagnosis: *"The root cause is stating one obligation in several places, so each correction collapses the duplication instead of synchronizing it."* Several instances landed **inside a correction for that same mechanism**, and one landed in the ledger's own commit — the entry notes drily that the commit "incremented the partial-measurement row correctly and left this one untouched while committing three fresh instances of it, which is the mechanism applying to the ledger itself."

There is a prescription and it is one command — grep the corrected phrase across `docs/` before committing — and the row records that running it *afterwards* found all three in one pass. A cheap countermeasure that nobody runs at the right moment is a fair description of the whole class.

## What the counts actually say

Read the top of the distribution and a pattern is hard to miss. The three largest rows — 17, 16, and 10 instances — are all about **reporting rather than building**:

- correcting one copy of a fact and not its siblings (17);
- a new guard's first formulation failing to reject the defect it was written for, *"only found by seeding that exact defect"* (16);
- a comparative claim about a maintained table written without reading the column it compares against (10).

None of those is a semantic error. Not one produced a wrong BPMN outcome. They are errors of *epistemic hygiene*: claiming more than was measured, checking one position of a class and calling it coverage, correcting the instance in view.

That should adjust how a reader weighs the rest of this record. The engine's semantic claims are protected by four independent targets, seeded mutations, and cold review. The claims *about* those claims — counts, ranks, coverage, "this guard catches that" — are protected by nothing comparable, and this ledger is what happens when someone measures that gap honestly.

The 16-instance guard row is the sharpest single lesson in either ledger:

> Seeding one form of a defect certifies that form only, so a guard over a syntactic class needs a case per **position** of the class. […] Enumerating values is what feels like coverage; enumerating positions is what the class requires.

Its instances read as a small tragedy of competence: a `decide +kernel` scanner whose prefix alternation missed `cases outcome <;> decide`; a `cancelActivity` refusal matching only the double-quoted attribute so `cancelActivity='1'` stayed admitted; a scenario-to-profile containment check that reduced references to their numeral and let `Table 13.2` authorise `Clause 13.2`; a reference-target rule installed in two of four source readers. Each was written by someone who had just learned the lesson from the previous one.

## What it says about the two ledgers together

The cost ledger measures what work *cost*. The process ledger measures what the work *got wrong on the way*. Neither measures what it was *worth*, and the project says so in both documents. That leaves a specific, disclosed hole:

> The cost ledger measures nonblank code and documentation churn — explicitly not *"proof strength, test independence, JSON evidence volume, generated output, or wall time."* Review effort is none of the things it counts.

Elapsed time is `Unknown` on **all forty** rows, for want of reliable timestamps. That is the correct refusal — an invented duration would be worse than an absent one — and it means [11 §7](11-open-questions.md#7--is-the-review-and-governance-regimes-cost-proportional-to-its-yield) still cannot be answered from the instruments. What *did* change is that the question is now half-instrumented rather than un-instrumented: the process ledger counts what review and reflection **caught**, even though nothing counts what they cost.

The yield side reads well. Rows credited to closure and checkpoint reviewers include a formal assurance claim whose theorems restated a helper's output without connecting the operation and stimulus branches; an aggregate boundary described as exhaustive whose tests exercised only interior populations; a derived fact and its supposed independent oracle sharing the same constructors and owner resolver, so *"one wrong owner or Process identity could make both sides agree and pass"*. That third one is a correlated-lane defect of exactly the kind [02](02-evidence-and-lanes.md#evidence-lanes-and-the-rule-that-makes-them-count) exists to name, found by review rather than by any gate.

## Does the reflection rule work?

`CLAUDE.md` requires the project to **"remove one identified process weight before starting the next capsule when the measured cost did not fall."** Across forty rows the rule is genuinely binding, and the ledger records all three outcomes:

- **Cost fell, so no removal was compelled** — and the row says so rather than manufacturing one. Message Start, configured Task, parallel metadata composition, incident operations, flow-node metrics, operator history, per-element diagnostics, non-interrupting boundary Timer.
- **Cost rose, so a weight was removed and named.** The interrupting Activity boundary Timer removed a duplicated host readiness-and-schedulability shape copied from the event-race scheduler *"under an explicit plan instruction"*, which had produced a lost-command defect whose symptom pointed somewhere else. Preserve-only admission removed the practice of installing a document-wide admission rule inside each profile source reader. The Sub-Process boundary Timer removed **the per-capsule diary that `PLAN.md`'s resume point had become** — a section every capsule paid to append to and nobody pruned.
- **Cost rose and no removal was possible**, recorded as a reason rather than a deletion. Cyclic control flow: *"deleting one of those independent mechanisms or evidence lanes would weaken the reviewed claim rather than simplify its delivery."*

That third case is what makes the rule credible. A reflection rule that always produces a removal is a rule producing theatre.

**And the honesty about contaminated measurements is the best feature of the ledger.** Three rows carry an explicit warning that their range absorbs unrelated work, each declining to subtract:

- Call Activity's `+5801` absorbs one review-process commit — *"a conservative upper bound … rather than a pure feature attribution; no subtraction is used to make the comparison look cheaper."*
- The Sub-Process boundary Timer's documentation figure of `+428` has eighteen of its forty commits from an unrelated Lean kernel-decide and memory episode; the closure review measured that contribution at `+137`, so the capsule's own figure is nearer `291` against a `363` comparator — *"documentation did not actually rise"*, stated as an inference the reader must not read as a clean attribution.
- The A12 boundary's `+16959` deliberately includes 13,794 additions of frozen legacy source, because *"subtracting them would make the retained evidence obligation disappear from the cost record."*

A ledger that argues against its own convenience three times is worth more than one with tidier numbers.

## The uncomfortable reading

Something has to be said plainly about what these 117 instances describe, because a reader will otherwise infer it and infer it wrongly.

This is a repository built almost entirely by coding agents under a governed protocol. The process ledger is therefore not a record of one careless contributor; it is a **measurement of a working method**, taken by that method, at very high throughput. The classes it names — asserting which conjunct enforces a behaviour, reading a gate's result from a summary, correcting the copy in view, certifying one syntactic position and calling it a class, borrowing a total from a report instead of measuring it — are recognisably human errors too. What is different is the *rate*, and the fact that somebody wrote them down with counts.

Two readings are available and both are defensible:

**The pessimistic one.** A hundred and seventeen recorded process failures, three classes that no gate can reach, and the largest class landing repeatedly inside corrections for itself. That is a lot of rework, and the guards exist because the discipline alone did not hold.

**The optimistic one, and the one I find more persuasive.** Every one of those 117 was *found* — by a gate, a reviewer, or the author's own self-assessment — and 78 of them are now behind an executable guard that closes the class rather than the instance. The comparison that matters is not against a hypothetical error-free process; it is against the ordinary case, where the same errors occur, nobody counts them, and a repeated one is indistinguishable from a first.

The project's own framing sits closer to the second and does not oversell it: the ledger exists *"to make recurrence visible and therefore actionable"*, and a row is retained after its guard lands because *"removing it would hide the recurrence history that justified the guard."*

## Where this touches the rest of this record

Three connections, and one of them closes a loop this record opened.

**[15](15-review-and-delegation.md) ends on the observation that vocabulary drift and inventory drift are mechanised while *numeric* drift is not, leaving attribution as the only defence.** The process ledger's ten-instance row is exactly that class — *"a comparative claim about a maintained table was written without reading the column it compares against"* — and it carries **two executable guards**: [cost-ledger rank claims](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/scripts/capsule-cost-comparison.test.ts) and [recomputed graduated-specification headroom figures](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/scripts/document-reviewability.test.ts). So a slice of numeric drift *was* mechanised, for the two documents where a claim's referent is machine-readable. The row is candid that the rest cannot be: free-form comparative prose stays a review obligation because *"nearest recorded"* cannot be read as nearest-in-value without churning historical rows on a contested reading.

That is the correct partial answer, and it sharpens rather than removes the warning: **numeric drift is guarded exactly where the number has an executable owner, and nowhere else.** Every figure in *this* record is in the "nowhere else" category, which is why the charter requires each one to name the artefact that produced it.

**[11 §7](11-open-questions.md#7--is-the-review-and-governance-regimes-cost-proportional-to-its-yield) asked whether the review regime's cost is proportional to its yield.** One row now bounds the worst case directly: a correction-audit loop ran three rounds with nothing terminating it, because each round closed its predecessor's findings while introducing a new required defect — *"the cost was roughly 640,000 reviewer tokens on one planning document, and the owner stopped it rather than any rule."* The bound is now explicit at two audits per stage. That is the first hard number anyone has attached to review cost in this project, and it arrived as a failure report rather than as a metric.

**[13](13-admission-and-profiles.md) and [15](15-review-and-delegation.md) described a blind spot: review is diff-scoped, and invariants are not.** The ledger's six-instance row on restated live status facts is the same mechanism measured from the inside, and its recorded correction is stronger than re-synchronisation — *"the correction removes the duplicated claims rather than re-synchronizing them"*, with an added instance noting that a copy was nonetheless re-synchronised twice before anyone deleted it.

## The residual

**What these instruments establish.** That the project measures its own cost reproducibly, records its own process failures with counts, attaches an executable consequence to recurrence, and enforces that consequence with a gate. That is a rare thing to find in a repository, and it is the reason several conclusions elsewhere in this record can be stated as measurements rather than impressions.

**What they do not.** Neither ledger measures value, and both say so. Nothing measures review effort, wall time, or whether a proof was worth writing. And the process ledger's own denominator excludes the largest category of all — *"A defect that a gate rejected is not a finding: the guard already worked"* — so it counts escapes, not errors. The ratio between them is unknown and unknowable from the tree.

**The thing worth watching.** The three `unguardable` rows are all about *claiming*, and their counts are among the highest. The project cannot gate them and knows it. What stands in their place is eight self-assessment questions answered at each capsule closure and session handoff, of which the operative one is question 8 — *"For each correction I made, which other copies of the corrected fact did I open? Name the files and sections I actually read, not the intent to have been thorough."* Demanding the file names rather than the intent is the right shape for a question that has to do a guard's job. Whether it is enough is the open part, and after 17 recorded instances the honest answer is: not yet.
