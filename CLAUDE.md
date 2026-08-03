# CLAUDE.md / AGENTS.md — bpmn-lean-experiment assessment record

Guidance for any agent editing this folder. [AGENTS.md](AGENTS.md) is a symlink to this file; keep one canonical guide and preserve the symlink.

## The charter lives in README.md, not here

The purpose, in-scope and out-of-scope lists, update priorities, and update discipline for this folder are owned by **[README.md § Purpose, and the charter that drives updates](README.md#purpose-and-the-charter-that-drives-updates)**. Read that section in full before editing anything, and do not restate it here.

That split is deliberate and is the folder's own subject matter: two copies of one rule is the precondition for drift, and this record exists partly because a repository specification restated an invariant the authority document owned and then diverged from it. See [12 §10](12-corrections-log.md) and [15 § The blind spot](15-review-and-delegation.md#the-blind-spot-review-is-diff-scoped-and-invariants-are-not).

## Hard rules, repeated here only because violating them is silent

1. **This folder is never authoritative.** `../bpmn-lean-experiment/docs/IMPLEMENTATION-MAP.md` wins every disagreement. If a statement here conflicts with it, this folder has a bug.
2. **Never edit the repository from this folder's task.** Defects found in `bpmn-lean-experiment` are *reported* to the user, with enough evidence to act on. Fixing them is a separate, separately scoped task in the repository, under that repository's `CLAUDE.md`.
3. **Re-measure; never carry a figure forward.** Every revision states one exact baseline commit and measures against it. Record later commits you checked but did not re-baseline against.
4. **Attribute every figure to the artefact that produced it.** Vocabulary and inventory drift are now caught by executable guards in the repository; **numeric drift is not**. Attribution is the only defence, and this record has already published wrong counts once.
5. **Verify agent reports before relaying them.** Re-run the gate, re-derive the disputed number from source. A report claiming a figure is not the figure.
6. **When this record was wrong, add it to [12](12-corrections-log.md).** Do not silently edit. The falsification history is the deliverable.

## Mechanics

- **Markdown style:** one paragraph per line, no hard wrapping at a fixed column. Regular relative Markdown links for other project documents so they open in a viewer.
- **Numbering:** append new documents (`17-`, `18-`, …). **Never renumber** — inbound links and anchors break silently.
- **Anchors:** GitHub-style. A `.` or `·` in a heading collapses to a single `-`, so `## 9.2 Proven today — by category` is `#92-proven-today--by-category`. Verify cross-document anchors after editing headings; several have been wrong.
- **Do not activate the `linear-walkthrough` skill and do not invoke `showboat`.** Author Markdown directly. The repository deleted its own generated walkthrough surface (`e4402a5`) so no second explanatory artefact could become a competing scope authority; the same reasoning applies here.

## Before finishing a revision

Check, and report the result:

- every cross-document anchor, file link, and `../../Projects/…` path resolves;
- no figure contradicts `IMPLEMENTATION-MAP.md`;
- [12](12-corrections-log.md) covers every claim this revision falsified, including this record's own;
- the README version box names the exact commit, and lists later commits checked but not re-baselined against.
