#!/usr/bin/env sh
set -eu

ROOT="${ROOT:-${DIAGRAMS_ROOT:-/diagrams}}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
count=0

render() {
  engine="$1"
  name="$2"
  ext="$3"
  "$SCRIPT_DIR/render_one.sh" "$engine" "$name" "$ext"
  count=$((count + 1))
}

for path in "$ROOT/py/"*.py; do
  [ -f "$path" ] || continue
  [ "$(basename "$path")" = "icons.py" ] && continue
  render py "$(basename "$path" .py)" py
done

for path in "$ROOT/uml/"*.puml "$ROOT/uml/"*.uml; do
  [ -f "$path" ] || continue
  filename="$(basename "$path")"
  render puml "${filename%.*}" "${filename##*.}"
done

for path in "$ROOT/mermaid/"*.mmd; do
  [ -f "$path" ] || continue
  render mermaid "$(basename "$path" .mmd)" mmd
done

for path in "$ROOT/dot/"*.dot; do
  [ -f "$path" ] || continue
  render dot "$(basename "$path" .dot)" dot
done

for path in "$ROOT/d2/"*.d2; do
  [ -f "$path" ] || continue
  render d2 "$(basename "$path" .d2)" d2
done

[ "$count" -gt 0 ] || {
  echo "no diagram sources found under $ROOT" >&2
  exit 1
}

printf 'Rendered %s diagrams.\n' "$count"
