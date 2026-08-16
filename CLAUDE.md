# CLAUDE.md / AGENTS.md — bpmn-lean-experiment assessment

Authoring rules for this folder. [AGENTS.md](AGENTS.md) is a symlink to this file; keep one canonical guide and preserve the symlink.

[README.md](README.md) is the human-facing entry point: what the assessment is, what the project is, the contents index, and where to read more. It owns no rules. Everything an author needs is here.

## Before you start

**Read `scripts/` and run `sh scripts/check.sh` before the first edit, not only before the last one.** Three checks exist and they define most of what "correct" means here; a baseline run also tells you whether a revisit is owed and which documents are implicated, which is usually the fastest way to scope the work.

Do not assert what this folder does or does not contain without opening it. Every mistake worth guarding against in this record's history has the same shape: a claim about a mechanism, made without reading the mechanism.

| Check | Enforces |
|---|---|
| `check-links.sh` | file links, cross-document and self anchors, pinned cross-repo URLs — that each path exists at the baseline commit *and* that each pin names the current baseline |
| `check-prose.sh` | Rule 0 — no appended corrections section, no strikethrough, no changelog framing about this record's own past |
| `check-staleness.sh` | the README baseline is a real commit, and how far the described repository has moved since it |

A new guard is only trustworthy once a **planted violation** has been shown to fail it. That is the described repository's own rule and it applies here.

## Rule 0 — highest priority: write the present tense, never a changelog

**Owner decision, 16 August 2026. This overrides every other rule here and any habit carried in from the described repository.**

Every document describes **what is true now**. This is not a history of the project and not a history of this record. The reader wants the current picture; they do not care how it was arrived at.

The owner's wording is that corrections must never be **appended**. That is the shape to recognise: a section added at the end of a document, or a note added beside a paragraph, that tells the reader an earlier statement was wrong. Appending is the natural move when a claim turns out false, and it is banned precisely because it works — it leaves both sentences on the page and makes the reader adjudicate which one is current.

Concretely, and these are prohibitions rather than preferences:

- **No corrections log, no changelog, no revision history, no "what changed", "errata", "addendum", or "update" section**, whatever it is titled. If a statement became false, **rewrite it in place** and delete the old one. Do not annotate, do not strike through, do not keep the wrong version beside the right one.
- **No "new in this revision", "previously", "the last revision said", "this used to be", "now corrected", "⚠ Resolved", or "superseded"** as framing for this record's own past. Delete the frame and state the fact.
- **No comparison between versions of this record**, and no counts of how many of its own claims were wrong.
- **Do not narrate the project's chronology either.** "Six capsules closed in four days" is a changelog sentence. "Thirty bounded mechanisms are closed, each pinned to a literal" is the same information as a present-tense fact, and it is the one to write.

Two things are **not** history and stay:

1. **Provenance.** One exact baseline commit, its date, and the worktree state, because every figure is measured against it. That is what makes a figure checkable.
2. **The project's own recorded history where it is a current fact about the project.** The repository maintains a capsule cost ledger and a process assessment ledger; their contents are present-tense evidence about how the project works and belong here. The distinction is ownership: report *their* ledgers, keep none of your own.

When a statement here turns out to have been wrong, the correction is a **rewrite plus a one-line note to the user in the response** — never a durable artefact in the folder. The response is where a correction belongs, because the user reads it once and it does not persist to confuse the next reader.

`check-prose.sh` enforces the mechanical half: it rejects a heading whose whole text is a corrections, changelog, errata, addendum, revisions, or update section, rejects `~~strikethrough~~`, and rejects phrasing that points at this record's own past. It matches a section **structurally**, so renaming the heading does not evade it. What it cannot see is a paragraph that narrates chronology in fresh words; that half is on the author.

## Purpose and scope

**Purpose.** Explain why `bpmn-lean-experiment` is built the way it is, and how far along it honestly is, to someone who does not already know BPMN, Lean, or Temporal internals. The value is synthesis and judgement across boundaries the repository keeps separate, because each repository document is correctly narrow and nothing there is allowed to state the whole picture and what it is worth.

### In scope

- **Reasoning, not restatement** — why two hand-written transcriptions, why non-laws are mandatory, why an oracle reads bytes, why a host capability is not semantic admission, why a product may not read its own host's event log.
- **The boundary of every claim** — what a passing lane does and does not establish. This is the most valuable thing here and the easiest to get wrong.
- **Honest assessment** — feasibility, measured cost, residual correlation, and named open questions with their trade-offs.
- **Cross-cutting synthesis** — topics spanning several repository owners, which therefore have no single owner to consult.

### Out of scope

| Excluded | Why |
|---|---|
| **Changelogs and revision history**, of the project or of this record | Rule 0. A correct historical sentence and a stale current claim are indistinguishable in prose, which is how documentation drifts. |
| **Live inventories** — case catalogs, profile lists, evidence matrices, test counts | A hand-maintained copy of something the code owns *will* drift. The project deleted its own walkthrough surface (`e4402a5`) so no curated catalog could become a competing scope authority. |
| **Any claim not sourced from the repository or its executable evidence** | This folder must never be the place a fact originates. |
| **Predictions about unbuilt work presented as near-future fact** | An owner-approved design is "what the approved design implies", never "what is about to exist". This record has published such predictions and they were wrong. |
| **Aggregated support claims** — percentages, "supported" verdicts, merged denominators | The project keeps BPMN, CIB, A12, and platform coverage as separate denominators and never combines them. Neither does this folder. |
| **Advocacy** | The reader is deciding whether to trust the work. An assessment that flatters it is worthless to them. |
| **Repository changes** | This folder is a record. Defects it finds in the repo are *reported*, not fixed here. |

### Priorities, in order

1. **The scope of each claim is correct.** A well-bounded stale figure is recoverable; a confidently over-broad claim misleads. Fix scope errors first.
2. **Every figure names the artefact that produced it.** See rule 4 below.
3. **Everything is present tense.** Rule 0.
4. Prose quality — genuinely last.

## Hard rules, repeated here only because violating them is silent

1. **This folder is never authoritative.** `../bpmn-lean-experiment/docs/IMPLEMENTATION-MAP.md` wins every disagreement. If a statement here conflicts with it, this folder has a bug.
2. **Never edit the repository from this folder's task.** Defects found in `bpmn-lean-experiment` are *reported* to the user with enough evidence to act on. Fixing them is a separate, separately scoped task under that repository's `CLAUDE.md`.
3. **Re-measure; never carry a figure forward.** State one exact baseline commit and measure everything against it.
4. **Attribute every figure to the artefact that produced it.** Vocabulary and inventory drift are caught by executable guards in the repository, and numeric drift is guarded only for the two repository documents whose figures have an executable owner. **Every figure here is unguarded**, so attribution is the only defence.
5. **Verify agent reports before relaying them.** Re-run the gate, re-derive the disputed number from source. A report claiming a figure is not the figure.

## Measurement method

- **Counts come from the guarded catalog, not from prose.** Registered profiles from `profiles/*/profile.json`; CIB-backed versus standards-only from each profile's `oracle` field; pipeline cases from `pipelineCases` in `packages/differential/test/pipeline-cases.ts`; IL operations from `SemanticOperationKind` cross-checked against `contracts/schemas/semantic-process.schema.json`; theorem and language counts from the project README's generated publication-statistics block.
- **Line counts are nonblank counts over the tracked tree** at the baseline commit, and say so. Do not mix them with the generated block's tokei "code" figures, which exclude comments.
- **A derived figure must be labelled derived** at the point of use, with its derivation stated — for example, replay totals folded from the catalog's `replaySelection` fields.
- **Never leave the described repository dirty.** If a scratch script is needed to count something, run it from the scratchpad or delete it and confirm `git status --porcelain` is empty.

## Mechanics

- **Markdown style:** one paragraph per line, no hard wrapping at a fixed column.
- **Links, and this rule has two halves:**
  - **Within this folder** — relative Markdown links (`[05](05-semantic-core-and-il.md#the-packages-and-the-flow)`), so they open in a viewer and resolve on GitHub.
  - **Into the assessed repository** — absolute GitHub URLs **pinned to the baseline commit**: `https://github.com/mbackschat/bpmn-lean-experiment/blob/<baseline>/<path>`. Never `../bpmn-lean-experiment/…`, which resolves only in a sibling checkout and is dead for every reader on GitHub. Pinning rather than `blob/main` is what makes a quotation checkable: the sibling repository moves hundreds of commits a week, and an unpinned link can point at a file that has since changed or been deleted.
  - The one deliberate exception is the README's "check for current truth" pointer, which targets `blob/main` on purpose. Keep it that way.
  - **When re-baselining, rewrite every pinned URL to the new commit.** It is a single mechanical pass and the record is wrong without it.
- **Numbering:** document numbers are permanent addresses. Append new documents (`20-`, `21-`, …). **Never renumber**, and never reuse a retired number — inbound links and anchors break silently. Gaps in the sequence are expected and fine.
- **Anchors:** GitHub-style, and the rule is *remove, then hyphenate*. Lowercase; **delete** every character that is not alphanumeric, space, or hyphen — including `.`, `·`, `—`, `,`, `?`; then turn each remaining space into `-`. So `## 9.2 Proven today — by category` is `#92-proven-today--by-category`: the `.` vanishes and the em dash leaves the two spaces that become `--`. Verify cross-document anchors after editing any heading; renaming a heading silently breaks every inbound link.
- **When a topic outgrows its host document, add a document** rather than inflating an existing one past its question. Prefer deleting a stale section to half-updating it: a section that is 60% current is worse than an absent one.
- **End every document with its residual** — what it has *not* established.
- **Do not activate the `linear-walkthrough` skill and do not invoke `showboat`.** Author Markdown directly. The repository deleted its own generated walkthrough surface (`e4402a5`) so no second explanatory artefact could become a competing scope authority; the same reasoning applies here.

## Before finishing

**Run `sh scripts/check.sh` and report its output.** Exit 3 from the staleness half means "a revisit is owed", not a failure; anything else non-zero is.

Then check the things no script can, and report the result:

- **no figure contradicts `IMPLEMENTATION-MAP.md`**, and each one names the artefact that produced it. This is the largest unguarded surface here: `check-prose.sh` catches changelog *framing* and `check-links.sh` catches a dead *path*, but **nothing detects a stale number**. A figure can use entirely current vocabulary, sit in a well-formed sentence, and be wrong — the described repository guards its own figures only where a number has an executable owner, and none of this record's do. Re-derive, never carry forward;
- Rule 0 holds in substance, not only in vocabulary. The guard rejects the appended-section shape outright and matches unambiguous self-referential phrasing; it cannot see a paragraph that narrates chronology in fresh words;
- the described repository's worktree is still clean;
- **when re-baselining, every pinned cross-repo URL names the new commit.** `check-links.sh` fails if one does not, so this is guarded — but it is a mechanical pass over every document, so plan for it rather than discovering it.
