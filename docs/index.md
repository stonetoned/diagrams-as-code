---
layout: default
title: "dgrac — Diagrams as Code"
description: "Render architecture diagrams with Python diagrams, PlantUML, Mermaid, Graphviz, and D2 through one tested CLI."
image: /assets/dgrac-social-card.png
---

<img class="hero-card" src="{{ '/assets/dgrac-social-card.png' | relative_url }}" alt="dgrac — five diagram languages converging into a rendered architecture diagram" />

<div class="page-actions">
  <a href="https://github.com/stonetoned/diagrams-as-code" class="button primary">View on GitHub</a>
  <a href="{{ '/gallery.html' | relative_url }}" class="button">Explore examples</a>
  <a href="{{ '/cli.html' | relative_url }}" class="button">CLI reference</a>
</div>

## One workflow, five engines

`dgrac` renders Python diagrams, PlantUML, Mermaid, Graphviz DOT, and D2 without making you maintain five local toolchains. It is designed for architecture-as-code, cloud diagrams, C4 models, UML, sequence diagrams, ER models, state machines, and CI-generated technical documentation.

```bash
git clone https://github.com/stonetoned/diagrams-as-code.git
cd diagrams-as-code
./dgrac doctor
./dgrac render --engine mermaid --name architecture
```

<div class="feature-grid">
  <div><strong>Reproducible</strong><br />Pinned, checksum-verified renderers in one Docker image.</div>
  <div><strong>Lean</strong><br />No bundled browser. D2 SVG becomes PNG with librsvg.</div>
  <div><strong>Safe defaults</strong><br />Read-only source mounts and offline rendering where possible.</div>
  <div><strong>Automation-ready</strong><br />CLI, Make shortcuts, JSON discovery, and a GitHub Action.</div>
  <div><strong>Agent-friendly</strong><br />llms.txt, full retrieval context, and verified agent instructions.</div>
  <div><strong>Useful examples</strong><br />Architecture, C4, deployment, sequence, ER, state, and dependency designs.</div>
</div>

## Choose the right renderer

| Need | Recommended engine |
|---|---|
| Cloud-provider and infrastructure icons | Python diagrams |
| UML, C4, component, deployment | PlantUML |
| Markdown-friendly flowchart, ER, state, sequence | Mermaid |
| Dependency graphs and layout control | Graphviz DOT |
| Modern architecture styling and SVG | D2 |

## Render and verify everything

```bash
./dgrac list --json
./dgrac render-all
./dgrac test
```

Mermaid uses a Kroki endpoint. Set `DGRAC_KROKI_URL` to your self-hosted Kroki instance when diagrams are confidential. Every other bundled engine renders with container networking disabled.

## Use it in CI

```yaml
- uses: actions/checkout@v7
- uses: stonetoned/diagrams-as-code@v0
  with:
    command: test
    source: diagrams
    output: output
```

[Read the complete README](https://github.com/stonetoned/diagrams-as-code#readme) or start with the [CLI reference]({{ '/cli.html' | relative_url }}).
