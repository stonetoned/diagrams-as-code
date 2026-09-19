#!/usr/bin/env sh
set -eu

engine="${1:-}"
name="${2:-}"
ext="${3:-}"

ROOT="${ROOT:-${DIAGRAMS_ROOT:-/diagrams}}"
OUTPUT_ROOT="${OUTPUT_ROOT:-${DGRAC_OUTPUT_ROOT:-/output}}"
PLANTUML_JAR="${PLANTUML_JAR:-/jars/plantuml.jar}"
KROKI_URL="${KROKI_URL:-https://kroki.io}"

[ -n "$engine" ] && [ -n "$name" ] || {
  echo "usage: render_one.sh <engine> <name> [ext]" >&2
  exit 2
}

require_file() {
  [ -f "$1" ] || {
    echo "source file not found: $1" >&2
    exit 1
  }
}

render_python() {
  input="$ROOT/py/$name.py"
  outdir="$OUTPUT_ROOT/py/$name"
  require_file "$input"
  mkdir -p "$outdir"
  (cd "$outdir" && python3 "$input")
  [ -s "$outdir/$name.png" ] || {
    echo "renderer did not create $outdir/$name.png" >&2
    exit 1
  }
}

render_plantuml() {
  input="$ROOT/uml/$name.$ext"
  output="$OUTPUT_ROOT/uml/$name.png"
  temporary="$output.tmp"
  require_file "$input"
  mkdir -p "$OUTPUT_ROOT/uml"
  trap 'rm -f "$temporary"' EXIT INT TERM
  java -jar "$PLANTUML_JAR" -tpng -pipe < "$input" > "$temporary"
  [ -s "$temporary" ] || { echo "PlantUML created an empty output" >&2; exit 1; }
  mv "$temporary" "$output"
  trap - EXIT INT TERM
}

render_mermaid() {
  input="$ROOT/mermaid/$name.$ext"
  output="$OUTPUT_ROOT/mermaid/$name.png"
  temporary="$output.tmp"
  require_file "$input"
  mkdir -p "$OUTPUT_ROOT/mermaid"
  trap 'rm -f "$temporary"' EXIT INT TERM
  curl -fsS --retry 3 --retry-all-errors --connect-timeout 10 --max-time 90 \
    -A "dgrac/${DGRAC_VERSION:-dev}" \
    -H 'Content-Type: text/plain' \
    --data-binary @"$input" \
    "${KROKI_URL%/}/mermaid/png" \
    -o "$temporary"
  [ -s "$temporary" ] || { echo "Kroki created an empty output" >&2; exit 1; }
  mv "$temporary" "$output"
  trap - EXIT INT TERM
}

render_dot() {
  input="$ROOT/dot/$name.$ext"
  output="$OUTPUT_ROOT/dot/$name.png"
  require_file "$input"
  mkdir -p "$OUTPUT_ROOT/dot"
  dot -Tpng "$input" -o "$output"
  [ -s "$output" ] || { echo "Graphviz created an empty output" >&2; exit 1; }
}

render_d2() {
  input="$ROOT/d2/$name.$ext"
  svg_file="$OUTPUT_ROOT/d2/$name.svg"
  png_file="$OUTPUT_ROOT/d2/$name.png"
  require_file "$input"
  mkdir -p "$OUTPUT_ROOT/d2"
  d2 "$input" "$svg_file"
  rsvg-convert --keep-aspect-ratio --width 1800 -o "$png_file" "$svg_file"
  [ -s "$svg_file" ] && [ -s "$png_file" ] || {
    echo "D2 created an empty output" >&2
    exit 1
  }
}

case "$engine" in
  py) render_python ;;
  puml|uml) ext="${ext:-puml}"; render_plantuml ;;
  mermaid) ext="${ext:-mmd}"; render_mermaid ;;
  dot) ext="${ext:-dot}"; render_dot ;;
  d2) ext="${ext:-d2}"; render_d2 ;;
  *) echo "unknown engine: $engine" >&2; exit 2 ;;
esac
