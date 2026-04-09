# Sonic Hooks

Hook scripts consumed by `sonic-screwdriver` during live boot, install, and
first-run handoff.

Current hook surfaces:

- `preinstall.sh`
- `postinstall.sh`
- `live-env.sh`

These hooks remain Ubuntu-owned image/install surfaces. Sonic invokes them but
does not redefine their contents.
