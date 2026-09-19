#!/usr/bin/env sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
DGRAC="$ROOT/dgrac"
VERSION="$(cat "$ROOT/VERSION")"
tests=0

assert_contains() {
  haystack="$1"
  needle="$2"
  case "$haystack" in
    *"$needle"*) ;;
    *) echo "expected output to contain: $needle" >&2; exit 1 ;;
  esac
  tests=$((tests + 1))
}

assert_fails_with() {
  expected="$1"
  shift
  if output="$("$@" 2>&1)"; then
    echo "expected command to fail: $*" >&2
    exit 1
  fi
  assert_contains "$output" "$expected"
}

assert_contains "$("$DGRAC" --help)" "render-all"
assert_contains "$("$DGRAC" -h)" "DGRAC_KROKI_URL"
[ "$("$DGRAC" --version)" = "$VERSION" ] || { echo "version mismatch" >&2; exit 1; }
tests=$((tests + 1))
[ "$("$DGRAC" version)" = "$VERSION" ] || { echo "version command mismatch" >&2; exit 1; }
tests=$((tests + 1))

json="$("$DGRAC" list --source "$ROOT/diagrams" --json)"
assert_contains "$json" '"mermaid"'
assert_contains "$json" '"architecture"'
assert_contains "$json" '"deployment"'
printf '%s' "$json" | python3 -c 'import json,sys; data=json.load(sys.stdin); assert data["engines"]["d2"]'
tests=$((tests + 1))

assert_fails_with "unknown engine" "$DGRAC" render --engine nope --name example
assert_fails_with "invalid diagram name" "$DGRAC" render --engine dot --name '../escape'
assert_fails_with "unknown option" "$DGRAC" list --wat

printf 'CLI tests passed: %s assertions.\n' "$tests"
