# Agent instructions

This repository is the canonical source for `dgrac`, a Docker-powered multi-engine diagrams-as-code CLI.

## Work safely

- Keep the CLI POSIX `sh`; validate it with `sh -n dgrac`.
- Do not add host runtime dependencies beyond Docker. Make remains optional.
- Preserve the source layout: `py`, `uml`, `mermaid`, `dot`, and `d2` directly below the configured diagram root.
- Treat `output/` as generated. Do not commit it.
- Do not hand-edit generated gallery PNGs. Use `make refresh-docs` after an intentional example change.
- Never send private Mermaid source to public Kroki without the user's knowledge. Use `DGRAC_KROKI_URL` for a self-hosted endpoint.
- Keep renderer downloads version-pinned and checksum-verified in the Dockerfile.

## Verify changes

Run the smallest relevant check first, then the full suite:

```bash
make test-cli
make test-static
make test
make docs-build
```

For one example:

```bash
./dgrac render --engine mermaid --name architecture
```

## Add examples

Place a top-level file in the matching engine directory. `render-all` discovers it automatically. Prefer descriptive names such as `sequence`, `deployment`, or `dependency` over numeric variants. Keep examples useful, legible, and small enough to understand without external context.

## Documentation contracts

When commands, engines, paths, or environment variables change, update `README.md`, `llms.txt`, `llms-full.txt`, completions, `action.yml`, and tests together. Do not claim that llms.txt guarantees AI indexing or citations.
