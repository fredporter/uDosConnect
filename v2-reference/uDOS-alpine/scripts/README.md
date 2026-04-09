# Scripts

`scripts/` is the checked-in execution and validation lane for `uDOS-alpine`.

Current script surfaces include:

- `build-apk.sh` for deterministic package-root staging and tarball generation
- `run-alpine-checks.sh` for repo activation validation
- `demo-thinui-launch.sh` for the C64-style ThinUI launcher handoff demo

Boundary rule:

- keep Alpine packaging and profile validation here
- keep ThinUI launch payload demos here
- keep broader deployment bootstrap in `sonic-screwdriver`
