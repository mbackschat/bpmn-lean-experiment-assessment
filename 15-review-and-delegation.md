# How the project governs its own claims

## The problem this solves

Every other document here is about keeping *implementations* honest — theorems, oracles, mutations, replay. This one is about a different failure mode: **the author of a semantic claim is also the person best placed to convince themselves it is fine.**

That risk is specific to this project's shape rather than generic. The capsule *prescribes* the microstate inventory and the closure bound, so Lean and TypeScript are two transcriptions of one reviewed account ([06](06-typescript-core-correctness.md#the-distinction-that-does-all-the-work-two-kinds-of-independence)). Account-level independence has to come from somewhere else — normative review and pinned-CIB observation. If the *review* of the account is also performed by whoever chose it, the last independent lane collapses, and no amount of differential testing detects it because all targets faithfully implement the same wrong reading.

So the review regime is not process hygiene. It is the mechanism protecting the one lane that theorems cannot.

## Cold, and what cold actually means

A **cold** review is performed by a reviewer with **no shared conversation history** with the author — recorded as `fork-turns-none`. The bar is deliberately high, and the disqualifications are enumerated rather than left to judgement:

> a warm author thread, a full-history fork, an agent that helped implement the target, or an earlier review conversation does not count.

Two further requirements are easy to skip and both matter:

- **Same model, same reasoning effort as the author.** Explicitly: *"Do not substitute a generic or general worker tier, a cheaper model, or a lower-effort configuration."* A reviewer weaker than the author is theatre — it will approve anything the author could construct.
- **A neutral prompt.** The review packet carries the immutable diff inventory, routed section hashes, and gate digests, and *"must not disclose the author's diagnosis, preferred verdict, or expected findings."* Telling the reviewer what you think is wrong is how you get told you were right.

**The lifecycle has three governed stages**, and materiality is content-defined rather than filename-defined — a cross-cutting root specification is governed by the same rule as a capsule when it selects BPMN meaning, a profile or CIB relationship, a representation, admission capability, a transition family, a proof boundary, or a Temporal refinement claim:

| Stage | When | Cold? |
|---|---|---|
| Proposal review | before owner approval or any implementation | always |
| Semantic checkpoint review | after the first green implementation checkpoint, *if* the capsule changes a wire contract, checked graph or IL, runtime or public observation, admission capability, transition family, proof boundary, or scope/cancellation/concurrency behaviour | conditional |
| Closure review | before graduating a proposal to a specification | cold by default; warm only under the continuity rule below |

Routine refactors and mechanical corrections that cannot change those claims do **not** open a cycle. That exemption is what keeps the regime from taxing every commit — and it is also the judgement call most likely to be got wrong in the project's favour, which is why the exemption is stated as a content test rather than a size test.

## Warm review, and why the exceptions are the interesting part

Four cases permit a warm reviewer. Each exists because cold review would be *worse*, not merely more expensive:

1. **The same cold reviewer audits corrections to its own findings.** Finding continuity is the point — a fresh reviewer would have to rediscover the findings before it could check they were closed, and might close a different set.
2. **A non-governing preflight** on draft work before the immutable target exists, with no receipt and no independence claim.
3. **Routine non-material refactor review** by an agent that did not implement the files.
4. **Guarded warm closure continuity** by the exact approved checkpoint reviewer.

The fourth is the one with real machinery behind it, and it is a good piece of engineering. Warm closure is allowed only when the *semantic content did not change* between the approved checkpoint and the closure target — and that is checked mechanically rather than asserted:

```sh
node scripts/semantic-review-manifest.ts \
  --baseline <approved-checkpoint-commit> \
  --target <closure-target> \
  --capsule docs/capsules/<CAPSULE>-PROPOSAL.md \
  --account "<semantic-rules heading>" \
  --contract "<public-contract heading>" \
  --exclusions "<exclusions heading>" \
  --evidence "<evidence-strategy heading>"
```

It hashes the complete capsule and every selected section, *"exits `0` only when all selected boundaries are byte-identical, and exits `2` when any selected boundary changed."* A changed fingerprint forces a new `fork-turns-none` closure reviewer.

**And the manifest states its own limit**, which is the detail that makes it trustworthy: *"The manifest cannot prove that the author selected every material section; the checkpoint reviewer independently checks selection completeness and records the digest in the review report."* A tool that hashes whatever you point it at cannot know you pointed it at everything. Rather than pretend otherwise, the residual is assigned to a human-role check and the digest is recorded so the choice is auditable.

## What is executable, and where the attestation gap is

`scripts/independent-review-policy.test.ts` enforces the parts Git can actually verify:

- approval is read **only** from a document's owned `## Status` section — prose elsewhere does not count;
- every commit SHA in a receipt must resolve to a real object **and be an ancestor of `HEAD`**, so a receipt cannot cite a rebased-away or fabricated target;
- the pre-policy grandfather set is derived from immutable baseline `f1ef362` — and *"An agent or contributor may not approve, append, rebase, or replace that exception set"*;
- proposal, checkpoint, correction-audit, closure, and graduation boundaries each block until their receipt exists;
- local Markdown anchors are validated, so a receipt cannot point at a heading that does not exist.

**The gap is stated by the project itself, and it is the right way to have a gap.** For the sub-agent transition, recording `fork-turns-none` attests both context isolation and the absence of a model or effort override — and `CLAUDE.md` says plainly: *"Git cannot independently verify either runtime fact."*

So the strongest guarantee in the regime rests on an attestation. That is unavoidable — no repository artefact can prove which conversation history a reviewer had — and the honest move is exactly what was done: enforce mechanically everything that can be enforced, and say clearly which single fact is attested rather than checked. A regime that claimed to verify isolation would be worse, because the claim would be false.

## Does it find anything?

Yes, and the useful evidence is that findings changed the *code*, not just the prose:

| Capsule | Outcome |
|---|---|
| Call Activity closure | `APPROVE WITH REQUIRED EDITS` — a missing production refusal/retry witness and a wrong history count; the correction separated host from semantic task addresses, fixing a real identity confusion in the seam most at risk ([14](14-scopes-and-cancellation.md#call-activity-a-second-root-not-a-child)) |
| Receive Task checkpoint | required checked-source and observation-evidence corrections; audited and closed |
| Inclusive Gateway | corrections at proposal, checkpoint, *and* closure — all three audits passed without material redesign |
| Event-Based Gateway | corrections at all three stages, likewise |

Note the pattern: proposal-stage findings changed *designs*, closure-stage findings changed *evidence*. Both matter, but the Call Activity case is the strongest single datapoint, because a Child-Workflow-versus-semantic-identity confusion is precisely the class that differential testing cannot catch — all four targets would agree, since the confusion lives in the host binding rather than in the semantics.

## The delegated-implementation protocol

The project also formalises how *implementation* work is handed to sub-agents, and the contract is unusually specific about what a delegation must contain:

> the exact invariant algorithm, one adversarial counterexample that must fail before the correction, the cross-target invariant matrix of required facts and explicit non-requirements, the files it may own, the files it must not touch, and the proportionate focused gates.

And the operative sentence: *"A desired outcome without the deciding algorithm and realistic wrong case is not a sufficient delegation contract."*

That single rule encodes most of what goes wrong with delegation. An agent given a goal will produce something that satisfies the goal as it understood it; an agent given a goal *plus a case that must fail first* has to demonstrate it reproduced the actual problem before claiming to have solved it.

Three structural rules follow:

- **Disjoint file ownership** between concurrent agents, with the root integrator owning shared integration points, lifecycle and status documentation, commits, and the repository-wide full gate. Implementation agents run **only** their focused gates.
- **Three mandatory safe-boundary reports** — *Red reproduced*, *Root mechanism implemented*, *Focused gates green* — each stating observed evidence rather than intent. Plus an anti-pattern named explicitly: *"Do not poll a long-running build merely for activity."*
- **No self-review.** *"do not ask two active agents to edit the same owner or use an implementation agent as its own independent reviewer."* A new lane gets a new task-shaped agent; only the correction-audit protocol preserves a thread.

**This document's own session is a worked example.** A drift class was found here, a delegation contract was minted with red evidence required for two separate guard gaps, the resulting work was verified independently rather than accepted on report — I re-ran the guard and re-derived the disputed operation count from the profile table — and the agent's own honest limitation (no Lean closure-count theorem for that capsule, so counts rest on semantic-core evidence) was preserved rather than smoothed over. The protocol worked, including the part where the report's numbers had to be checked before being believed.

## The blind spot: review is diff-scoped, and invariants are not

The regime described above found real defects at every stage. It also missed a class entirely, and the miss is structural rather than a lapse — which makes it the most useful thing in this document.

**The evidence.** `docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md` asserted, for *every* selected profile, that admission establishes *"one rooted definition-scope tree."* The Call Activity capsule made that false by adding a second, parentless called root. Between them, the Inclusive Gateway, Event-Based Gateway, and Call Activity capsules ran **nine governed review stages** — three each, proposal, checkpoint, closure, plus correction audits. Not one flagged the contradiction. Checked against Git: **none of those capsules' commits touched the admission specification at all.** Its last prior update was `7226733`, before all three landed.

**Why cold review could not have caught it.** A review packet carries *"the immutable diff inventory, routed section hashes"* and the reviewer inspects *"the exact target diff and implementation."* That is the right design for the question "is this change sound?" — and it structurally cannot see a document the change did not touch. The contradiction lived in an **unchanged** file. A perfect reviewer, reading everything in the packet with maximum skill, would still not have been routed to it.

So this is not a reviewer-quality problem, and no amount of same-model/same-effort discipline fixes it. It is a **scoping** problem: the unit of review is a diff, and the unit of the defect is an invariant asserted in two places.

**Three compounding causes:**

1. **No executable dependency ran from the specification to the code it describes.** Every behavioural gate stayed green because the spec had no dependency on the profile registry. Nothing pulled it forward, and nothing failed when it fell behind.
2. **A cross-cutting document *restated* an invariant the authority document owns.** `CLAUDE.md`'s own discipline is one owner per fact, with others linking to it. `IMPLEMENTATION-MAP.md` owns the implemented boundary; the admission spec restated it in prose. Two statements of one fact is the precondition for divergence, so the drift is downstream of a doc-discipline violation rather than of a review failure.
3. **The retirement of a name had no checklist.** When `terminate` was removed, it was never added to the guard's prohibited-fragment list, and the guard scanned only code. Two independent omissions in one retirement.

**Why a documentation review found them instead.** The reading mode is different in a way worth naming. Governed review reads *within* one diff for correctness. Writing a synthesis reads *across* many documents for coherence — and a synthesis author has a forcing function a reviewer lacks: a contradiction between two sources **blocks the writing**. You cannot explain admission consistently while one document says tree and another says forest, so you must resolve it. The reviewer of a Call Activity diff has no such obstruction.

That suggests **cross-document coherence is a distinct review dimension with no owner anywhere** — not in the capsule lifecycle, not in the milestone reflection, and not in the executable gates. The reflection checklist comes closest, asking authors to inspect *"document placement, stale status"*, but it applies per capsule to that capsule's documents rather than sweeping the cross-cutting owners a capsule invalidated.

**What has been done about it.** Two guards now exist where prose previously relied on readers: retired vocabulary fails a gate across `docs/`, and every registered profile must appear in the admission specification's capability table. Both convert a class into a gate rather than fixing an instance, which is the stronger of the two options `CLAUDE.md` permits. And a reusable review question was formulated for the routing gap:

> Which cross-cutting owner documents state an invariant or inventory changed by this capsule, and does the immutable review target update or explicitly preserve each one?

**What remains unguarded, and cannot easily be.** A stale *number* stated in current vocabulary against a fully populated table. The Exclusive Gateway's operation and step counts were exactly that: nothing lexical was wrong, the table was complete, and only re-deriving each figure from the capability data exposed them. Vocabulary drift is now mechanised; inventory drift is now mechanised; **numeric drift is not**, and attribution to the producing artefact is the only available defence.

## The cost, and the honest uncertainty about it

Every material capsule carries two or three review cycles, each with a committed immutable target and an audited receipt. That is real effort arriving where the measured cost per mechanism is already 3,000–6,500 lines ([04](04-feasibility.md#the-cost-curve-measured)).

The project has priced some of it in, and the reductions are genuine rather than cosmetic: stage-specific review focus, static findings before CPU-heavy gates, target-bound neutral review packets, deferral of routine focused gates to the correction audit when a blocking finding already exists, one *combined* checkpoint-and-closure review for a genuinely single-lane atomic closure, and deletion of a temporary pending-lane barrier once its purpose was served.

**But nobody can currently say whether the yield justifies the cost, and the reason is structural.** The [capsule cost ledger](../bpmn-lean-experiment/docs/CAPSULE-COST-LEDGER.md) measures nonblank code and documentation churn — explicitly *not* *"proof strength, test independence, JSON evidence volume, generated output, or wall time."* Review effort is none of the things it counts. Elapsed time is `Unknown` on every row for want of reliable timestamps, which is the correct refusal and leaves the question unanswerable from the instrument.

Worse for measurement, review-infrastructure work and feature work land in the same measured ranges: Call Activity's `+5801` absorbs one unrelated review-process commit, and the ledger says so rather than subtracting it. Honest for attribution, unhelpful for isolating the regime's cost.

So [11 §7](11-open-questions.md#7--is-the-review-and-governance-regimes-cost-proportional-to-its-yield) carries this as an open question rather than a complaint. The yield is demonstrated. The cost is real. The ratio is unmeasured, and the project's own reflection checklist — *"remove one identified process weight before starting the next capsule when the measured cost did not fall"* — is being honoured with removals smaller than the increases.

## What to take from this

The regime is best understood as **the assurance architecture applied to the project's own reasoning**. The same moves recur: name the boundary of what a lane establishes; refuse to count a correlated source twice; require a case that must fail before the fix; make the enforceable part executable and state plainly which residual is attested rather than checked.

Its distinguishing feature is that the residual is *disclosed*. A regime asserting that its reviews are provably independent would be less trustworthy than one that enumerates the four cases where warm review is valid, builds a hash-bound manifest for the riskiest of them, states that the manifest cannot prove section-selection completeness, and admits that Git cannot verify context isolation at all.
