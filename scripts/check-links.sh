#!/bin/sh
# Verifies every internal link in this record resolves.
#
# Three link classes are checked:
#   1. cross-document file links            ](07-temporal-adapter.md)
#   2. cross-document and self anchors      ](07-temporal-adapter.md#challenge-1--…) and ](#in-scope)
#   3. links into the described repository  ](../bpmn-lean-experiment/docs/PLAN.md)
#
# Anchors use GitHub's algorithm: lowercase, drop every character that is not
# alphanumeric, space, hyphen, or underscore, then replace spaces with hyphens.
# A "." or "·" inside a heading therefore collapses to a single separator, so
# "## 9.2 Proven today — by category" is "#92-proven-today--by-category".
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

# 3 · links into the described repository, which must be a sibling checkout
grep -oh '\.\./bpmn-lean-experiment/[A-Za-z0-9/._-]*' *.md | sort -u \
  | while read -r p; do
      [ -e "$p" ] || echo "missing repository path: $p" >> "$findings"
    done

if [ -s "$findings" ]; then
  echo "check-links: FAIL"
  sort -u "$findings" | sed 's/^/  /'
  exit 1
fi

echo "check-links: ok ($(wc -l < "$anchors" | tr -d ' ') headings indexed)"
