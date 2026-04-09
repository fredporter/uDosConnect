# uDOS-docs Architecture

uDOS-docs is the family documentation surface.

## Main Areas

- `docs/` holds repo-level entry points
- `architecture/`, `wizard/`, `alpine/`, and `uhome/` organize family topics
- `wiki/` holds beginner-friendly family learning units
- `tests/` can validate documentation conventions or generated outputs
- `scripts/run-docs-checks.sh` is the activation validation entrypoint

## Rule

This repo explains the family. It should not become the owner of implementation
detail that belongs in component repos.
