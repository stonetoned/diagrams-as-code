---
layout: default
title: "dgrac CLI reference"
description: "Commands, options, configuration, output paths, and CI examples for the dgrac diagrams-as-code CLI."
---

# CLI reference

<div class="page-actions">
  <a href="{{ '/' | relative_url }}" class="button">Home</a>
  <a href="{{ '/gallery.html' | relative_url }}" class="button">Gallery</a>
  <a href="https://github.com/stonetoned/diagrams-as-code" class="button primary">GitHub</a>
</div>

## Commands

| Command | Purpose |
|---|---|
| `dgrac render` | Render one source by engine and name |
| `dgrac render-all` | Discover and render every supported source |
| `dgrac test` | Render all sources and verify expected artifacts |
| `dgrac list` | List discovered sources; `--json` provides machine output |
| `dgrac doctor` | Verify Docker and bundled renderer versions |
| `dgrac version` | Print the installed version |

## Render one diagram

```bash
dgrac render --engine mermaid --name architecture
dgrac render -e puml -n deployment -o ./artifacts
dgrac render -e d2 -n sequence
```

Options:

- `-s`, `--source`, `--source-dir`: diagram source root.
- `-o`, `--output`, `--out`, `--output-dir`: generated artifact root.
- `-e`, `--engine`: `py`, `puml`, `uml`, `mermaid`, `dot`, or `d2`.
- `-n`, `--name`: source filename without its extension.
- `-x`, `--ext`, `--inputext`: explicit source extension.
- `--image`: prebuilt renderer image.
- `--kroki-url`: Mermaid-compatible Kroki endpoint.

## Configuration

```bash
export DGRAC_SOURCE_DIR="$PWD/architecture"
export DGRAC_OUTPUT_DIR="$PWD/generated"
export DGRAC_KROKI_URL="http://localhost:8000"
dgrac test
```

Set `DGRAC_IMAGE` to use a prebuilt image. Set `DGRAC_BUILD=never` to prevent a local source checkout from rebuilding its image.

## Output paths

```text
output/py/<name>/<name>.png
output/uml/<name>.png
output/mermaid/<name>.png
output/dot/<name>.png
output/d2/<name>.svg
output/d2/<name>.png
```

## Privacy

Python diagrams, PlantUML, Graphviz, and D2 run with container networking disabled. Mermaid source is posted to `DGRAC_KROKI_URL`; use a trusted self-hosted Kroki instance for confidential diagrams.
