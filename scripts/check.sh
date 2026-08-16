#!/bin/sh
# Runs every check for this record. Invoke before finishing a revision.
set -eu
cd "$(dirname "$0")/.."
status=0
sh scripts/check-links.sh || status=1
sh scripts/check-prose.sh || status=1
sh scripts/check-staleness.sh || { rc=$?; [ "$rc" -eq 3 ] || status=1; }
exit "$status"
