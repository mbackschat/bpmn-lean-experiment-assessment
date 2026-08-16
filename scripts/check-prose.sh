#!/bin/sh
# Enforces Rule 0: this record is written in the present tense and is never a
# changelog of itself.
#
# Rule 0 is the highest-priority authoring rule and was the easiest to violate,
# because changelog framing is what a careful author reaches for when a claim
# turns out to be wrong: annotate it, mark it resolved, note what it used to
# say. Every one of those leaves the reader deciding which sentence is current.
#
# The pattern set is deliberately narrow. It matches only phrasing that refers
# unambiguously to THIS record's own past, never phrasing about the described
# project's history — "the owner superseded the staged programme" is a current
# fact about the project and must keep passing. A guard that fires on correct
# prose gets disabled, so precision matters more than reach here.
#
# CLAUDE.md and AGENTS.md are excluded: they state the rule and must quote the
# banned forms to do so.
#
# Exit 0 when clean, 1 otherwise. No dependencies beyond POSIX sh and grep.

set -eu

cd "$(dirname "$0")/.."

findings=$(mktemp)
trap 'rm -f "$findings"' EXIT

# One extended-regex alternation per line, so a pattern can be added or removed
# without touching the loop. Matched case-insensitively.
patterns='previous revision
last revision
this revision
earlier revision
earlier version of this
third revision
fourth revision
revision history
corrections log
what changed since
changed since the
in this window
⚠ resolved
⚠ update
⚠ correction
⚠ a prediction
⚠ item'

for f in *.md; do
  case "$f" in
    CLAUDE.md|AGENTS.md) continue ;;
  esac
  echo "$patterns" | while IFS= read -r p; do
    [ -n "$p" ] || continue
    grep -in -- "$p" "$f" 2>/dev/null \
      | sed "s|^|$f:|; s|$| <<< '$p'|" >> "$findings" || true
  done
done

if [ -s "$findings" ]; then
  echo "check-prose: FAIL — changelog framing found (Rule 0)"
  echo "  Rewrite the claim in the present tense and delete the old one."
  sort -u "$findings" | cut -c1-160 | sed 's/^/  /'
  exit 1
fi

echo "check-prose: ok (Rule 0: no changelog framing)"
