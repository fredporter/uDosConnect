# uDOS-alpine Activation

Alpine is active as the lightweight runtime companion profile.

## Active Surfaces

- `apkbuild/` for package definitions
- `distribution/` for image and repo outputs
- `profiles/` for lean machine profiles
- `openrc/` for Alpine service integration
- `examples/basic-alpine-build.md` for the smallest walkthrough
- `docs/thin-gui-launcher-integration.md` for ThinUI handoff
- `scripts/run-alpine-checks.sh` for repo validation

## Validation Contract

Run:

```bash
bash scripts/run-alpine-checks.sh
```

This path verifies the packaging/profile surfaces and rejects tracked
private-path leakage.

## Boundary Rule

Alpine does not own canonical runtime semantics, broad host support outside the
Alpine lane, provider/control-plane logic, or the full browser command centre.
