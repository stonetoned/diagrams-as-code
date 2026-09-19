---
layout: default
title: "Diagram gallery"
description: "Compare architecture, UML, Mermaid, Graphviz, D2, and Python diagrams rendered by dgrac."
image: /assets/dgrac-social-card.png
---

# Diagram gallery

<div class="page-actions">
  <a href="{{ '/' | relative_url }}" class="button">Home</a>
  <a href="{{ '/cli.html' | relative_url }}" class="button">CLI reference</a>
  <a href="https://github.com/stonetoned/diagrams-as-code/tree/main/diagrams" class="button primary">View source</a>
</div>

Every preview below is generated from a text source in the repository and verified by `dgrac test`.

## Modern architecture and design

<div class="example-grid">
  <a class="example-card" href="{{ '/assets/examples/mermaid/architecture.png' | relative_url }}">
    <img src="{{ '/assets/examples/mermaid/architecture.png' | relative_url }}" alt="Mermaid service architecture diagram" loading="lazy" />
    <strong>Service architecture</strong><span>Mermaid</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/mermaid/sequence.png' | relative_url }}">
    <img src="{{ '/assets/examples/mermaid/sequence.png' | relative_url }}" alt="Mermaid order sequence diagram" loading="lazy" />
    <strong>Order sequence</strong><span>Mermaid</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/mermaid/er.png' | relative_url }}">
    <img src="{{ '/assets/examples/mermaid/er.png' | relative_url }}" alt="Mermaid entity relationship diagram" loading="lazy" />
    <strong>Entity relationship model</strong><span>Mermaid</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/mermaid/state.png' | relative_url }}">
    <img src="{{ '/assets/examples/mermaid/state.png' | relative_url }}" alt="Mermaid render lifecycle state diagram" loading="lazy" />
    <strong>Render lifecycle</strong><span>Mermaid</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/uml/deployment.png' | relative_url }}">
    <img src="{{ '/assets/examples/uml/deployment.png' | relative_url }}" alt="PlantUML Kubernetes deployment diagram" loading="lazy" />
    <strong>Production deployment</strong><span>PlantUML</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/d2/sequence.png' | relative_url }}">
    <img src="{{ '/assets/examples/d2/sequence.png' | relative_url }}" alt="D2 diagram rendering sequence" loading="lazy" />
    <strong>Render request sequence</strong><span>D2</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/dot/dependency.png' | relative_url }}">
    <img src="{{ '/assets/examples/dot/dependency.png' | relative_url }}" alt="Graphviz renderer dependency graph" loading="lazy" />
    <strong>Renderer dependencies</strong><span>Graphviz</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/py/complex.png' | relative_url }}">
    <img src="{{ '/assets/examples/py/complex.png' | relative_url }}" alt="Python diagrams distributed cloud architecture" loading="lazy" />
    <strong>Cloud architecture</strong><span>Python diagrams</span>
  </a>
</div>

## C4 and enterprise architecture

<div class="example-grid">
  <a class="example-card" href="{{ '/assets/examples/uml/test_c4.png' | relative_url }}">
    <img src="{{ '/assets/examples/uml/test_c4.png' | relative_url }}" alt="C4 container architecture example" loading="lazy" />
    <strong>C4 container model</strong><span>PlantUML</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/uml/test_c4_complex_enterprise.png' | relative_url }}">
    <img src="{{ '/assets/examples/uml/test_c4_complex_enterprise.png' | relative_url }}" alt="Complex enterprise C4 architecture" loading="lazy" />
    <strong>Enterprise C4 system</strong><span>PlantUML</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/d2/complex.png' | relative_url }}">
    <img src="{{ '/assets/examples/d2/complex.png' | relative_url }}" alt="D2 complex system architecture" loading="lazy" />
    <strong>Styled system architecture</strong><span>D2</span>
  </a>
  <a class="example-card" href="{{ '/assets/examples/dot/complex.png' | relative_url }}">
    <img src="{{ '/assets/examples/dot/complex.png' | relative_url }}" alt="Graphviz complex dependency layout" loading="lazy" />
    <strong>Complex graph layout</strong><span>Graphviz</span>
  </a>
</div>

Render any example locally with `./dgrac render --engine ENGINE --name NAME`.
