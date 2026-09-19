# Security policy

## Supported versions

Security fixes are applied to the latest release and the `main` branch.

## Reporting a vulnerability

Please use GitHub's private vulnerability reporting feature for this repository. Do not open a public issue for an unpatched vulnerability or include working exploit details in public discussions.

Include the affected version, impact, reproduction steps, and any suggested remediation. Maintainers will acknowledge a complete report as soon as practical and coordinate disclosure after a fix is available.

## Rendering untrusted input

Diagram source is executable or parser input for third-party renderers. Review untrusted Python diagrams before rendering them. dgrac mounts source read-only, drops Linux capabilities, enables `no-new-privileges`, and disables container networking for every engine except Mermaid. Mermaid source is sent to the configured Kroki endpoint; use a trusted self-hosted endpoint for confidential content.
