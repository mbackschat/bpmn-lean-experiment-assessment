# How to review this project

## Why this lives here rather than in the repository

The project already has a **governed** review protocol: `TESTING-SPEC.md` fixes the cold-reviewer isolation rule, the neutral packet, the `VERDICT:` output contract, and the receipts an infrastructure guard validates ([15](15-review-and-delegation.md)). What follows is not that. It is an *informal* checklist for someone deciding whether to trust the work — closer to a reading aid than to a governed stage.

Those two things must not sit side by side in the project's `docs/`. A second, unenforced "evaluation framework" next to the enforced one is precisely the competing-authority pattern that has produced real documentation defects in this project's tree ([13](13-admission-and-profiles.md#why-the-capability-table-is-guarded-rather-than-trusted)). Here it cannot be mistaken for the governed protocol, because this whole record is non-authoritative by construction.

**Use the repository's own protocol if you are performing a governed review.** Use this if you are forming a judgement.

## Ten things to know before evaluating

These are the misreadings most likely to produce a wrong verdict, and every one of them is a real trap rather than a hypothetical.

1. **A capsule `-SPEC.md` means its bounded contract is implemented.** A profile artefact may still say `draft` because the project has no production release or history baseline. Draft is about release status, not about whether the semantics exist.
2. **`supported` in the requirement ledger can mean a bounded reviewed slice.** Read the owning capsule and its exclusions before generalising it to a whole BPMN construct.
3. **CIB absence in a standards-only target set is deliberate, not a missing test** — when no CIB relationship was selected for the exact proposition. **Twenty-seven of the 51 registered cases are in this position**, so it is the majority rather than the exception, and [02](02-evidence-and-lanes.md#for-most-of-the-surface-that-lane-does-not-run) works through what it costs.
4. **Lean is authoritative for the selected operational account after checked-source admission** — and it does not parse XML, prove TypeScript, or prove Temporal refinement. [01](01-theorem-techniques.md#113-what-theorems-deliberately-do-not-do) is explicit about the boundary.
5. **TypeScript/Lean equality is not majority-vote evidence for the interpretation.** Two transcriptions of one reviewed account can agree and both be wrong; normative reasoning and genuinely independent oracle observation are separate lanes ([06](06-typescript-core-correctness.md#the-distinction-that-does-all-the-work-two-kinds-of-independence)).
6. **Temporal Event History is host evidence.** Workflow Tasks, Activity attempts, Timer commands, Signals, and Update events are not BPMN semantic state unless the public contract explicitly projects a consequence ([07](07-temporal-adapter.md#challenge-2--temporal-commands-are-not-bpmn-transitions)).
7. **Expected results are physically separate from neutral scenarios.** A scenario carries commands and requested observation fields, never the oracle answer.
8. **A mutation is meaningful only when it changes the proposition being claimed** and fails at an approved public or admission boundary. Where it is injected decides what it establishes ([02 §4](02-evidence-and-lanes.md#4--mutation-guards--evidence-that-the-evidence-works)).
9. **A `by decide` theorem over one fixture is a finite lock, not a general theorem.** Check hypotheses and quantification before relying on a theorem's name — the project has renamed a theorem for exactly this reason ([01 §1.10](01-theorem-techniques.md#110-refusing-to-let-collection-order-become-semantics)).
10. **The repository is pre-release.** Do not infer deployment compatibility, retained-history compatibility, migration, packaging, hardening against hostile XML CPU, or production operations ([16](16-what-you-can-run.md)).

## The evaluation framework

Eight dimensions. They are deliberately separate because a project can be strong in one and empty in another, and a single verdict would hide which.

### A · Claim and scope

- Can the main claim be stated in one bounded sentence?
- Do `Status`, the requirement ledger, the profile, the capsule, the implementation map, and the plan describe the *same* boundary?
- Are required, optional, and excluded shapes explicit?
- Does any public wording silently promote a structured or exact slice into general BPMN support?

### B · Normative and compatibility basis

- Are the cited BPMN clauses, tables, CMOF, and XSD facts applicable to the exact source shape?
- Is every interpretation or source conflict recorded rather than hidden in code?
- If CIB participates, is the relationship classified and bound to a pinned release, configuration, observation boundary, and fidelity label?
- Is CIB *absent* when it offers no independent evidence for the selected standard proposition?

### C · Source admission and lowering

- Does admission reject the nearest unsupported adjacent shape, including unknown keys and parser warnings?
- Are identity, multiplicity, declaration order, namespace resolution, scope ownership, and source provenance preserved where semantically relevant?
- Are order-insensitive collections canonicalised while intentionally ordered constructs preserve their order?
- Does Lean independently recompute lowering and reject artefact disagreement?
- Can a declaration permutation or reference-changing fixture expose a fixture constant or a positional-pairing bug?

### D · Semantic account and formal evidence

- Is the declarative transition relation distinct from the evaluator?
- Does evaluator soundness cover *every* constructor of the new transition family?
- Do reusable theorems have meaningful hypotheses and results, rather than proving one serialised outcome?
- Are concrete `by decide` witnesses described honestly?
- Is the nearest realistic non-law or negative witness executable?
- Are closure bounds and newly reachable multiple-enabled states checked explicitly?

### E · Independent TypeScript core

- Does the core implement the same invariant matrix without adding extra admission or counter premises?
- Does it remain pure, deterministic, serialisable, and free of CIB and Temporal imports?
- Are semantic variants closed and exhaustively switched?
- Do wrong, stale, duplicate, and malformed inputs preserve or fail state exactly as specified?
- Does canonical observation depend only on admitted definition, committed runtime state, and explicitly applied stimuli?

### F · Temporal refinement

- Is each durable Timer, Signal, Update, Activity, cancellation, or race derived from *committed core state*?
- Is host address separate from semantic occurrence identity where required?
- Are duplicate delivery, command-identity conflict, Worker absence, result recovery, terminal receipt, and replay covered?
- Does the adapter fail closed for unsupported concurrent host mechanisms or coalesced readiness?
- Does a bypass mutation prove Workflow code cannot skip the core while preserving the claimed trace?
- Are unrelated host event families asserted *absent* when the capsule claims mechanism reuse?

### G · Differential and retained evidence

- Is the scenario answer-free and content-bound to exact BPMN bytes and profile identity?
- Does each target relation match the actual claim, rather than forcing every target into exact equality?
- Does every case have a seeded mutation with an exact expected disagreement path?
- Are raw producer facts distinguished from canonical projection decisions?
- Are terminal empty states avoided as the sole evidence for collection behaviour?

### H · Governance, maintainability, and cost

- Are proposal, checkpoint, closure, correction-audit, and graduation receipts valid for material semantic work?
- Did implementation lanes own disjoint files and run focused gates while root ran the complete gate once?
- Are modules cohesive and below the source-hygiene boundaries, without comment deletion or line-compression tricks?
- Does the cost ledger compare the measured direction honestly against a real baseline?
- Are the plan, implementation map, profile and scenario registries, and document registry synchronised? — this is the dimension where the project's own defects have actually been found, and where its guards are newest ([19](19-process-self-measurement.md))

## Red flags that merit a required finding

Each of these is a pattern, not a guess — several have occurred in this repository and were caught.

- A BPMN element is accepted because an optional field happens to be absent, with no closed discriminant or exact key check.
- A target derives identity, branch choice, deadline, correlation, or expected output from a **fixture constant** rather than from source or runtime state.
- Lean and TypeScript both pass because the same incorrectly lowered artefact **erased the discriminator** before either target saw it.
- A Temporal timer, Activity, Signal, Update, or scheduler order decides a BPMN-visible result the core did not select.
- A mutation changes a hidden microstep but not an approved public observation or admission result.
- A theorem *name* claims exactness, determinism, liveness, or equivalence beyond its proposition and hypotheses.
- A CIB field is labelled `engine-observed` although the adapter invented or normalised it.
- A bounded slice is summarised as full element support, CIB compatibility, or Process Execution conformance.
- A new runtime record is omitted from quiescence, interruption cleanup, ordering, serialisation, or replay review.
- A new operation kind escapes a closed host-capability or evaluator classification because one switch is not exhaustive.
- **A specification restates an invariant the authority document owns**, and the two have diverged. Nothing lexical is wrong; only cross-document reading finds it ([15 § the blind spot](15-review-and-delegation.md#the-blind-spot-review-is-diff-scoped-and-invariants-are-not)).

## Where to run things

Executable commands, gate selection, and the route to each owning document stay in the project's own [documentation registry](../bpmn-lean-experiment/docs/README.md) and [TESTING-SPEC.md](../bpmn-lean-experiment/docs/TESTING-SPEC.md), because paths and commands belong with the files they address. [16](16-what-you-can-run.md) covers what those commands establish and what they do not.
