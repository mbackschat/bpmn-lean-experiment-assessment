#!/bin/sh
# Verifies every internal link in this record resolves.
#
# Three link classes are checked:
#   1. cross-document file links            ](07-temporal-adapter.md)
#   2. cross-document and self anchors      ](07-temporal-adapter.md#challenge-1--…) and ](#in-scope)
#   3. pinned links into the described repository
#                                           ](https://github.com/…/blob/<sha>/docs/PLAN.md)
#
# Anchors use GitHub's algorithm: lowercase, DELETE every character that is not
# alphanumeric, space, hyphen, or underscore, then replace spaces with hyphens.
# A "." or "·" is removed rather than turned into a separator, so
# "## 9.2 Proven today — by category" is "#92-proven-today--by-category":
# the "." vanishes, and the em dash leaves the two spaces that become "--".
# Getting that wrong is the most common defect in this record's history.
#
# Exit 0 when every link resolves, 1 otherwise. No dependencies beyond POSIX
# sh, grep, and sed.

set -eu

cd "$(dirname "$0")/.."

anchors=$(mktemp)
findings=$(mktemp)
trap 'rm -f "$anchors" "$findings"' EXIT

# One "<file>#<anchor>" line per heading in every tracked Markdown file.
for f in *.md; do
  grep -h '^#\{1,6\} ' "$f" \
    | sed 's/^#* //' \
    | tr 'A-Z' 'a-z' \
    | sed 's/[^a-z0-9 _-]//g; s/ /-/g' \
    | sed "s|^|$f#|"
done | sort -u > "$anchors"

# 1 · cross-document file links
grep -oh '](\([0-9][0-9]-[a-z0-9-]*\.md\|README\.md\|CLAUDE\.md\|AGENTS\.md\))' *.md \
  | sed 's/^](//; s/)$//' | sort -u \
  | while read -r target; do
      [ -e "$target" ] || echo "broken file link: $target" >> "$findings"
    done

# 2a · cross-document anchors
grep -oh '](\([0-9][0-9]-[a-z0-9-]*\.md\|README\.md\)#[a-z0-9_-]*' *.md \
  | sed 's/^](//' | sort -u \
  | while read -r target; do
      grep -qxF "$target" "$anchors" || echo "broken anchor: $target" >> "$findings"
    done

# 2b · self anchors, resolved against the containing file
for f in *.md; do
  grep -oh '](#[a-z0-9_-]*' "$f" | sed 's/^](#//' | sort -u \
    | while read -r a; do
        grep -qxF "$f#$a" "$anchors" || echo "broken self anchor: $f#$a" >> "$findings"
      done
done

# 3 · pinned links into the described repository.
#
# Cross-repo links are absolute GitHub URLs pinned to the measurement baseline,
# because a relative sibling path is dead for every reader on GitHub. Two things
# are checked, and the second is the one that rots silently: each pinned path
# must exist AT that commit, and each pin must name the CURRENT baseline, so a
# re-baseline cannot leave stale pins behind.
#
# A relative sibling link is now a defect rather than a supported form.
grep -oh '](\.\./bpmn-lean-experiment/[A-Za-z0-9/._-]*' *.md | sed 's/^](//' | sort -u \
  | while read -r p; do
      echo "relative cross-repo link (must be a pinned GitHub URL): $p" >> "$findings"
    done

project=${BPMN_PROJECT_ROOT:-../bpmn-lean-experiment}
baseline=$(sed -n 's/^\*\*Version described:\*\* commit \[`\([0-9a-f]\{7,40\}\)`\].*/\1/p' README.md | head -1)

if [ -z "$baseline" ]; then
  echo "no measurement baseline found in README.md" >> "$findings"
  echo "  expected: **Version described:** commit [\`<sha>\`](…)" >> "$findings"
elif [ ! -d "$project/.git" ]; then
  echo "check-links: cannot verify pinned paths — no repository at $project"
  echo "  set BPMN_PROJECT_ROOT to the bpmn-lean-experiment checkout"
else
  pinned=0
  for pin in $(grep -oh 'https://github\.com/mbackschat/bpmn-lean-experiment/blob/[A-Za-z0-9._-]*/[A-Za-z0-9/._-]*' *.md | sort -u); do
    rest=${pin#https://github.com/mbackschat/bpmn-lean-experiment/blob/}
    ref=${rest%%/*}
    path=${rest#*/}
    # blob/main is the one deliberate exception: the README's "current truth" pointer.
    [ "$ref" = "main" ] && continue
    pinned=$((pinned + 1))
    if [ "$ref" != "$baseline" ]; then
      echo "pin is not the current baseline $baseline: $ref/$path" >> "$findings"
    fi
    git -C "$project" cat-file -e "$ref:$path" 2>/dev/null \
      || echo "pinned path missing at $ref: $path" >> "$findings"
  done
  echo "check-links: $pinned pinned cross-repo path(s) verified at $baseline"
fi

if [ -s "$findings" ]; then
  echo "check-links: FAIL"
  sort -u "$findings" | sed 's/^/  /'
  exit 1
fi

echo "check-links: ok ($(wc -l < "$anchors" | tr -d ' ') headings indexed)"
