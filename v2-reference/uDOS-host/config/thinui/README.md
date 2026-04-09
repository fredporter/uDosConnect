# ThinUI Defaults

ThinUI launch and focused panel defaults for Ubuntu-hosted local views.

## Surface profiles (uDOS-surface)

Host and launcher JSON can reference an **experience profile** from **`uDOS-surface/profiles/`** so ThinUI starts with the correct **mode**, **theme id**, and **`state.surface`** metadata (see `uDOS-surface/docs/surface-experience-layer.md`).

- Example launch scaffold: **`examples/thinui-ubuntu-gnome-launch.json`** (Classic Modern / `udos-default`, windowed-friendly).
- ThinUI CLI: `npm run demo -- --profile ubuntu-gnome` or `--surface-profile-file /path/to/uDOS-surface/profiles/ubuntu-gnome/surface.json` (sibling checkout).
- Optional env for host scripts and the lane-1 **ThinUI HTTP stub**: **`UDOS_SURFACE_REPO`**, **`UDOS_SURFACE_PROFILE_ID`**, **`UDOS_SURFACE_PROFILE_FILE`** — when set, **`GET /v1/status`** on the ThinUI aux port includes **`surface_profile_summary`** (id, layout, navigation, theme) when the JSON can be read.
- See also **`config/env/udos.env.example`** for commented **`UDOS_SURFACE_*`** variables.

Validation (family checkout): `python3 uDOS-surface/scripts/validate_surface_profiles.py`.
