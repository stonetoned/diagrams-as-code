#!/usr/bin/env sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

sh -n dgrac scripts/*.sh tests/*.sh
python3 -m json.tool codemeta.json >/dev/null

version="$(cat VERSION)"
grep -F "DEFAULT_VERSION=\"$version\"" dgrac >/dev/null
grep -F "version: $version" CITATION.cff >/dev/null
grep -F "\"version\": \"$version\"" codemeta.json >/dev/null

test -f action.yml
test -f llms.txt
test -f docs/llms.txt
test -f docs/assets/dgrac-social-card.png
test ! -f jars/plantuml.jar

grep -F -- '--code-bg: #07101f' docs/assets/css/style.scss >/dev/null
grep -F '.highlighter-rouge .highlight' docs/assets/css/style.scss >/dev/null
grep -F '.highlight .nt { color: #7ee787; }' docs/assets/css/style.scss >/dev/null

if rg -n 'nosahama|/opt/projects/labs/dgrac' README.md docs llms.txt llms-full.txt AGENTS.md action.yml >/dev/null; then
  echo "stale repository identity or local path found" >&2
  exit 1
fi

if rg -n 'releases/latest|d2lang\.com/install\.sh' Dockerfile >/dev/null; then
  echo "Dockerfile contains an unpinned renderer download" >&2
  exit 1
fi

printf 'Static checks passed.\n'
