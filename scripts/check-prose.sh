#!/bin/sh
# Enforces Rule 0: this record is written in the present tense and is never a
# changelog of itself.
#
# Rule 0 is the highest-priority authoring rule and the easiest to violate,
# because appending is what a careful author reaches for when a claim turns out
# to be wrong: add a "Corrections" section at the end, strike the old figure
# through, mark the paragraph resolved. Every one of those leaves the reader
# deciding which sentence is current, which is exactly what the owner ruled out.
#
# Three classes, because they fail differently:
#
#   1. SECTION — a heading whose whole text is a corrections/changelog/errata
#      section. This is the shape the owner objected to by name, so it is
#      matched structurally rather than by phrasing: the ban is on appending a
#      section, whatever words it uses. Whole-heading match only, so
#      "Update-shaped command ingress" and "no history-compatibility debt"
#      keep passing.
#   2. STRIKETHROUGH — keeping the wrong version beside the right one.
#   3. PHRASING — prose that refers to this record's own past.
#
# The phrasing set is deliberately narrow. It matches only wording that refers
# unambiguously to THIS record's past, never to the described project's history
# — "the owner superseded the staged programme" is a current fact about the
# project and must keep passing. A guard that fires on correct prose gets
# disabled, so precision matters more than reach in class 3. Class 1 carries
# the reach instead, because a section heading is unambiguous.
#
# CLAUDE.md and AGENTS.md are excluded: they state the rule and must quote the
# banned forms to do so.
#
# Exit 0 when clean, 1 otherwise. No dependencies beyond POSIX sh and grep.

set -eu

cd "$(dirname "$0")/.."

findings=$(mktemp)
trap 'rm -f "$findings"' EXIT

# Class 1. Anchored at both ends: the heading must BE the banned section, not
# merely contain one of these words. A trailing date or parenthetical is
# tolerated because "## Update (16 August 2026)" is the same section.
section_re='^#{1,6}[[:space:]]+[*_[:space:]]*(what.?s?[[:space:]]+(changed|new)|correction|corrections|correction[[:space:]]+log|corrections[[:space:]]+log|changelog|change[[:space:]]+log|change[[:space:]]+history|changes|errata|erratum|addendum|addenda|amendment|amendments|revision|revisions|revision[[:space:]]+(history|notes|log)|version[[:space:]]+history|update|updates|update[[:space:]]+log|history[[:space:]]+of[[:space:]]+this[^|]*|new[[:space:]]+in[[:space:]]+this[^|]*|previously|superseded)[*_:[:space:]]*(\(.*\))?[[:space:]]*$'

# Class 3. One pattern per line, matched literally and case-insensitively.
patterns='previous revision
last revision
this revision
earlier revision
earlier version of this
an earlier version
earlier draft
third revision
fourth revision
revision history
corrections log
correction:
what changed since
changed since the
in this window
formerly
originally
this used to
now corrected
⚠ resolved
⚠ update
⚠ correction
⚠ a prediction
⚠ item'

for f in *.md; do
  case "$f" in
    CLAUDE.md|AGENTS.md) continue ;;
  esac

  grep -inE -- "$section_re" "$f" 2>/dev/null \
    | sed "s|^|$f:|; s|$| <<< appended section (Rule 0)|" >> "$findings" || true

  grep -n -- '~~' "$f" 2>/dev/null \
    | sed "s|^|$f:|; s|$| <<< strikethrough (Rule 0)|" >> "$findings" || true

  echo "$patterns" | while IFS= read -r p; do
    [ -n "$p" ] || continue
    grep -in -- "$p" "$f" 2>/dev/null \
      | sed "s|^|$f:|; s|$| <<< '$p'|" >> "$findings" || true
  done
done

if [ -s "$findings" ]; then
  echo "check-prose: FAIL — self-referential history found (Rule 0)"
  echo "  Rewrite the claim in the present tense and delete the old one."
  echo "  Never append a corrections section, strike a figure through, or"
  echo "  annotate a paragraph as superseded."
  sort -u "$findings" | cut -c1-160 | sed 's/^/  /'
  exit 1
fi

echo "check-prose: ok (Rule 0: no appended corrections, no changelog framing)"
