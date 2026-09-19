# Contributing to dgrac

Thanks for improving dgrac. Focused bug fixes, renderer improvements, documentation corrections, and clear real-world diagram examples are welcome.

## Before opening a pull request

1. Create a focused branch.
2. Keep host requirements limited to Docker; Make may be used for convenience only.
3. Add or update a regression test when behavior changes.
4. Run:

   ```bash
   make test
   make docs-build
   ```

5. Update the README, agent documentation, completions, and action metadata if the CLI contract changes.

## Example quality

- Use a descriptive filename.
- Keep diagrams understandable without private business context.
- Never include credentials, internal hostnames, personal data, or proprietary architecture.
- Prefer a small example that teaches one useful design pattern.

## Commit and pull-request guidance

Use an imperative summary such as `fix: preserve custom Kroki endpoint`. Explain user impact and verification in the pull request. Generated files under `output/` must not be committed.

By contributing, you agree that your contribution is released under the repository's [CC0-1.0 license](LICENSE).
