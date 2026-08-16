#!/bin/sh
# Reports how far this record has drifted from the repository it describes.
#
# This is the check that makes the update protocol self-triggering: instead of
# remembering to revisit the record, run this and it says whether a revisit is
# owed and which sections are implicated.
#
# The dependency direction is one-way and deliberate. This record reads the
# repository; the repository knows nothing about this record. That mirrors how
# the documents themselves link, and it is why moving this record into the
# repository's docs/ tree was rejected — see README's charter.
#
# The baseline commit is parsed from README.md's "Version described" line, so
# there is one source of truth for it, shared with check-links.sh. Override the
# repository location with BPMN_PROJECT_ROOT when it is not at the default
# sibling path.
#
# Exit 0 when the record is current, 3 when it has drifted. Drift is a report,
# not a failure: it is normal between revisions and is meant to be readable.

set -eu

cd "$(dirname "$0")/.."

project=${BPMN_PROJECT_ROOT:-../bpmn-lean-experiment}

if [ ! -d "$project/.git" ]; then
  echo "check-staleness: SKIP — no repository at $project"
  echo "  set BPMN_PROJECT_ROOT to the bpmn-lean-experiment checkout"
  exit 0
fi

baseline=$(sed -n 's/^\*\*Version described:\*\* commit \[`\([0-9a-f]\{7,40\}\)`\].*/\1/p' README.md | head -1)

if [ -z "$baseline" ]; then
  echo "check-staleness: FAIL — no measurement baseline found in README.md"
  echo "  expected: **Version described:** commit [\`<sha>\`](…)"
  exit 1
fi

if ! git -C "$project" cat-file -e "$baseline^{commit}" 2>/dev/null; then
  echo "check-staleness: FAIL — baseline $baseline is not a commit in $project"
  exit 1
fi

head_sha=$(git -C "$project" rev-parse --short HEAD)
behind=$(git -C "$project" rev-list --count "$baseline..HEAD")

if [ "$behind" -eq 0 ]; then
  echo "check-staleness: ok — baseline $baseline is current with $head_sha"
  exit 0
fi

echo "check-staleness: DRIFTED"
echo "  baseline $baseline is $behind commit(s) behind $head_sha"
echo

# Owner documents whose change most likely invalidates a section here, with the
# record sections that restate or depend on them.
printf '%s\n' \
  "docs/IMPLEMENTATION-MAP.md|02 04 05 06 07 09 13 14 — the authority for every claim boundary" \
  "docs/PLAN.md|03 04 11 — sequencing, cost, open questions" \
  "docs/TESTING-SPEC.md|02 15 — evidence lanes and the review regime" \
  "docs/PROJECT-DESIGN.md|00 06 08 — authority model and two kinds of independence" \
  "docs/SEMANTIC-PROCESS-IL-SPEC.md|05 13 — IL contract and growth rules" \
  "docs/PROFILE-PARAMETERIZED-ADMISSION-SPEC.md|13 — admission and profile capability" \
  "docs/CAPSULE-COST-LEDGER.md|03 04 11 — measured cost per capsule" \
  "docs/RUNNABLE-TEMPORAL-MVP-SPEC.md|16 — the runnable product surface" \
  "docs/capsules|05 09 14 — per-feature semantics" \
  "packages/semantic-core/src|05 06 13 — core contracts and line counts" \
  "packages/temporal-adapter|07 08 — adapter size and hosting" \
  "profiles|02 13 — registered profile set" \
  "scenarios|02 10 — the registered case catalog" \
| while IFS='|' read -r path sections; do
    n=$(git -C "$project" rev-list --count "$baseline..HEAD" -- "$path")
    [ "$n" -eq 0 ] && continue
    printf '  %-46s %3s commit(s)  →  %s\n' "$path" "$n" "$sections"
  done

echo
echo "  Re-measure against $head_sha, then update README's version box."
echo "  Per the charter: never carry a figure forward; attribute each to its artefact."
exit 3
