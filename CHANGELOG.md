# Changelog

All notable changes are documented here.

## Unreleased

### Changed

- Improved dark-mode code contrast across the documentation site.
- Added an end-to-end smoke test for the packaged GitHub Action to CI and release gates.
- Removed an unconfigured security badge and obsolete Pages setup notes from customer-facing documentation.

## [0.2.0] - 2026-09-19

### Added

- Installable standalone CLI backed by a versioned container image.
- Dynamic example discovery and verification.
- Machine-readable JSON listing, llms.txt, full RAG context, CodeMeta, and citation metadata.
- GitHub Action integration, CI, release automation, and dependency updates.
- Modern architecture, sequence, ER, state, deployment, and dependency examples.
- Self-hosted Kroki configuration.

### Changed

- Pinned PlantUML and D2 downloads with SHA-256 verification.
- Replaced Chromium-based D2 conversion with lean `rsvg-convert`.
- Hardened runtime containers with read-only sources, dropped capabilities, and restricted networking.
- Rebuilt the documentation and gallery for the `stonetoned` organization.

## [0.1.1] - 2025-08-05

- Added the `dgrac` CLI, shell completions, documentation gallery, and versioned installs.
