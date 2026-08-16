# What you can actually run today

## The question this answers

Everything else here is about whether the semantics are sound. This document answers a blunter question a newcomer asks early and the other documents never quite address: **if I clone this repository, what can I make happen?**

Four things, in increasing order of what they establish:

| | What it is | What it proves |
|---|---|---|
| `mvp:run` | one command that runs an admitted BPMN model on a Temporal server you supply | the engine path works end to end, for any registered profile |
| the browser walkthrough | the full product: deploy a file, claim a task, fill a form, inspect an instance | a person can operate the thing |
| `test:pipeline` | the 51-case differential/refinement catalog | every implemented profile agrees across its declared targets |
| `verify.sh` | the complete gate | everything, including Lean, CIB, and hygiene |

## The MVP command

```sh
./scripts/pnpm.sh run mvp:run -- examples/temporal-mvp/user-task-discovery-completion.json
```

That is the whole interface: one command, one config file. This example runs the `None Start → User Task "Approve" → None End` model from [the case study](10-case-study.md) against a Temporal server at `localhost:7233`, installs `requestTitle`, waits, submits `decision: "approved"` plus an explicit null `reviewNote`, and reports the completed receipt.

**There is one such config per registered profile** — 32 of them, plus `unsupported.json` for the negative path — each reusing the registered scenario's BPMN source unchanged. The command drives them all through *one* interaction driver keyed to the interactions each instance publishes, rather than through a per-model script. A profile carrying a race gets two examples, because one declared plan cannot reach both arms of it.

The config is worth reading in full because its *shape* is the product contract:

```json
{
  "kind": "runnableTemporalMvp",
  "bpmn": {
    "file": "../../scenarios/user-task-discovery-completion/process.bpmn",
    "sourceId": "sequential-user-task-process",
    "semanticProfile": "cibseven-2.2.0-user-task-process-data-draft",
    "limits": { "maxBytes": 1048576, "parserDeadlineMs": 1000 }
  },
  "process": {
    "instanceId": "MvpDemo_1",
    "initialVariables": [
      { "name": "requestTitle", "value": { "kind": "string", "value": "Review invoice 42" } }
    ]
  },
  "temporal": {
    "address": "localhost:7233", "namespace": "default",
    "taskQueue": "bpmn-mvp", "identity": "bpmn-mvp-command"
  },
  "dummyUserTask": {
    "elementId": "UserTask_Approve", "delayMs": 3000,
    "inputVariableNames": ["requestTitle"],
    "submittedValues": [
      { "name": "decision", "value": { "kind": "string", "value": "approved" } },
      { "name": "reviewNote", "value": { "kind": "null" } }
    ]
  }
}
```

Five things in that file are architectural statements rather than configuration:

- **`semanticProfile` is mandatory.** You do not hand the engine a BPMN file and ask what it makes of it. You declare which reviewed meaning you are invoking, and the file is admitted against *that*. A document outside the named profile returns typed pre-start rejection.
- **`limits` are explicit.** A byte cap and a parser settlement deadline, in the config, because parsing untrusted XML is a real attack surface — see the caveat below.
- **`temporal.address` is yours.** The command *"does not start an embedded or ephemeral Temporal server, choose frontend ports, or bind a server port."* A connection failure reports the supplied address and stays an infrastructure failure. The BPMN Worker owns no server lifecycle at all — a boundary most engine demos blur.
- **`inputVariableNames` is a projection selector, not a dump.** The actor reads only the names it asks for; absent and unselected names stay absent, and Activity-local scope is never exposed.
- **`{ "kind": "null" }` is a value, not an omission.** The closed `string | null` union again ([10](10-case-study.md#106-layer-3--the-answer-free-scenario)).

**Exit codes are classified, not collapsed** — and the classification mirrors the semantic boundaries the rest of the project defends:

| Code | Meaning |
|---:|---|
| `0` | `Completed` — the Process reached semantic completion |
| `1` | `InfrastructureFailure` — Temporal unreachable, Worker died; *not* a semantic outcome |
| `2` | `AdmissionRejected` — the model is outside the declared profile, refused before any connection |
| `3` | `ExecutionRefused` — reached the core and was semantically refused |
| `64` | `ConfigurationRejected` — the config file itself is malformed |

`1`, `2`, and `3` being distinct is the whole point. "It didn't work" is three different facts with three different owners, and a product that returns one code for all of them has already lost the distinction the engine is built to preserve.

A second maintained example, `unsupported.json`, exists to demonstrate the negative path: it returns typed source-admission rejection **without opening a connection**.

## The dummy actor, and why it is described so defensively

The config's `dummyUserTask` block simulates a person filling in a form. The specification is unusually emphatic that this is *not* a feature:

> The dummy actor is an explicit MVP host profile, **not BPMN User Task meaning and not CIB human-resource compatibility**.

What it actually does: observes exactly one active task, waits a configured non-blocking delay, checks **the same sole task is still the only one**, then submits the configured values through the real production completion Update. It refuses zero tasks, multiple tasks, an unexpected task, an unavailable task, or a changed task.

The re-check after the delay is the part that earns its place. Without it, the actor would submit against a task it observed some seconds ago — exactly the stale-completion hazard that `UTASK-REFUSE-02` and the content-bound Update identity exist to catch. The actor is written to *not* be the thing that discovers those guards.

Absent, and listed as absent: UI, form rendering, identity, authorization, assignment, human-resource semantics, and a task inbox. `CLAUDE.md` names the same boundary at mission level — the actor is *"an explicit host simulation, not a UI, task inbox, form engine, identity layer, or human-resource semantic claim."*

The reason for that much emphasis is straightforward: a demo that submits form values is one screenshot away from being described as "BPMN user task support with forms", and the project would rather over-disclaim than let that happen.

## What `mvp:run` does and does not establish

**Does.** It uses the *same* source compiler, IL program, semantic core, production Workflow, Update boundary, and replay-safe code as the evidence path. The spec forbids the shortcut explicitly: a model-specific Workflow or a generated TypeScript file is *"not an MVP shortcut."* So the command exercises the real architecture, not a demo path beside it.

**Does not.** One model, one instance, one foreground process. Multi-process deployment, packaging, daemon supervision, authentication, TLS, Temporal Cloud administration, production retention, and horizontal scaling are all out of scope and stated as such. And it is emphatically **not a release**: the spec's status line reads *"Implemented current pre-release product contract … not an immutable release or production-history baseline."*

**One caveat that deserves visibility.** BPMN parsing runs before Workflow start with a byte limit and a parser settlement deadline — but `IMPLEMENTATION-MAP.md` lists *"synchronous parser CPU isolation"* as explicitly absent, and `CLAUDE.md` states the consequence: the current timeout *"cannot preempt synchronous parser CPU; production untrusted uploads still require a bounded Worker or process."* So the deadline bounds a Promise, not a busy parser. For a local demo with your own file that is fine. For anything accepting uploads it is not, and the project says so rather than letting the presence of a `parserDeadlineMs` field imply protection it does not provide.

## The 51-case catalog

```sh
./scripts/pnpm.sh run test:pipeline
```

This is the real demonstration. One run: every registered profile compiled from exact bytes, executed by Lean, the semantic core, and Temporal (twice, isolated), compared against retained CIB evidence for the 24 cases that declare a CIB target, with a seeded semantic mutation per case, **62 disposable histories replayed**, **102 isolated Workflow executions**, and clean teardown. Those two totals are derived from the catalog's case count and `replaySelection` fields; the generated pipeline report is the authority.

Two design decisions make it worth more than a test suite.

**The catalog is derived, not curated.** Every implemented profile artefact must be referenced by a registered answer-free scenario, every registered scenario must have exactly one pipeline case, and every retained CIB projection must be content-bound to its scenario — all guarded. So you cannot demonstrate a flattering subset; the demonstration *is* the implemented surface.

**There is deliberately no second explanatory artefact.** Commit `e4402a5` (`refactor(mvp): remove walkthrough surface`) deleted a human-readable walkthrough and its fragment machinery *"so no curated catalog or second explanatory artifact can become a competing scope authority."* The generated pipeline report is the demonstration; `IMPLEMENTATION-MAP.md` is the claim boundary. That deletion is also why *this folder* has a charter forbidding live inventories — the same failure mode, one directory over.

There is deliberately no reviewer-facing guide standing beside it. Navigation lives in the project's [documentation registry](https://github.com/mbackschat/bpmn-lean-experiment/blob/0adda45/docs/README.md), which routes every task to the document that owns it.

## What the milestone explicitly is not

The MVP's own closure states its boundary, and it is the sentence a reader most needs when deciding what a green pipeline means:

> This is an end-to-end architecture and evidence milestone, **not a BPMN Process Execution conformance percentage or a broad CIB compatibility claim.**

Concretely, after a fully green pipeline: 1 of 50 A12 models admits unchanged at the static boundary, 0 of 50 execute through an adoption adapter, all thirteen BPMN mechanism families remain `unsupported` at family level, no percentage of BPMN is claimed, and **27 of the 51 cases have no oracle lane at all** because their profiles declare none ([02](02-evidence-and-lanes.md#for-most-of-the-surface-that-lane-does-not-run)).

## Running the gates

If you want to reproduce any of this, the ordering matters, because several gates need inputs a fresh machine does not have:

```sh
nvm install && nvm use
./scripts/setup-external-sources.sh verify     # pinned external inputs; ../oss is not presumed
./scripts/pnpm.sh install --frozen-lockfile
./scripts/doctor.sh verify                    # read-only: hashes every dependency owner
./scripts/verify.sh                            # the complete gate
```

Three practical notes. `doctor.sh` *"inventories every declared external pin, dependency owner, and cache even when the selected scope does not require all of them"*, so it will tell you what is missing before a lane fails obscurely. The **`adoption` scope is separate and optional** — it is the only lane touching A12 source, and `verify` is deliberately complete for the MIT engine without it. And in a managed sandbox, host port-binding authorization must be requested *before* the first Temporal gate: an ephemeral-server startup error containing `Operation not permitted` or `EPERM` means the sandbox denied the listener and is **not** evidence of a port collision or a failing semantic test.

Faster loops, if you do not want the full gate: `test:semantic` (Lean plus core), `test:temporal`, `test:bpmn-source`, `test:contracts`.

## The honest summary

What exists is a **working engine for thirty bounded mechanisms, plus a browser product on top of it**, demonstrated end to end from exact bytes through durable execution, replay, and a human completing a form, with every claim's boundary written down.

What does not exist is generality. Every mechanism is pinned to a literal, all thirteen BPMN mechanism families are disposed `unsupported` at family level, and a new family costs 3,000–6,500 lines across seven layers plus a review cycle ([04](04-feasibility.md#the-cost-curve-measured)).

Both halves are load-bearing. A reader who takes only the first will overestimate what this is; a reader who takes only the second will miss that the hard architectural risks — durable hosting, representation replacement, scope semantics — are the ones that have actually been retired.
