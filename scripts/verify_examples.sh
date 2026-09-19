#!/usr/bin/env sh
set -eu

ROOT="${ROOT:-${DIAGRAMS_ROOT:-/diagrams}}"
OUTPUT_ROOT="${OUTPUT_ROOT:-${DGRAC_OUTPUT_ROOT:-/output}}"
checked=0
status=0

check_file() {
  path="$1"
  if [ ! -s "$path" ]; then
    echo "missing or empty: $path" >&2
    status=1
  fi
  checked=$((checked + 1))
}

for path in "$ROOT/py/"*.py; do
  [ -f "$path" ] || continue
  [ "$(basename "$path")" = "icons.py" ] && continue
  name="$(basename "$path" .py)"
  check_file "$OUTPUT_ROOT/py/$name/$name.png"
done

for path in "$ROOT/uml/"*.puml "$ROOT/uml/"*.uml; do
  [ -f "$path" ] || continue
  filename="$(basename "$path")"
  check_file "$OUTPUT_ROOT/uml/${filename%.*}.png"
done

for path in "$ROOT/mermaid/"*.mmd; do
  [ -f "$path" ] || continue
  check_file "$OUTPUT_ROOT/mermaid/$(basename "$path" .mmd).png"
done

for path in "$ROOT/dot/"*.dot; do
  [ -f "$path" ] || continue
  check_file "$OUTPUT_ROOT/dot/$(basename "$path" .dot).png"
done

for path in "$ROOT/d2/"*.d2; do
  [ -f "$path" ] || continue
  name="$(basename "$path" .d2)"
  check_file "$OUTPUT_ROOT/d2/$name.svg"
  check_file "$OUTPUT_ROOT/d2/$name.png"
done

[ "$checked" -gt 0 ] || {
  echo "no diagram sources found under $ROOT" >&2
  exit 1
}

[ "$status" -eq 0 ] && printf 'Verified %s generated artifacts.\n' "$checked"
exit "$status"
