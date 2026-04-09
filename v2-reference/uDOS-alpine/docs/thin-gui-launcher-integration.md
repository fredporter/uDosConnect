# Alpine Thin GUI Launcher Integration

This document defines the v2.1 Round C integration path from Alpine launch surfaces into ThinUI.

## Purpose

Connect Alpine boot/profile lanes to ThinUI startup without moving semantic ownership out of core.

## Referenced Contract

- ../../uDOS-thinui/contracts/alpine-thin-gui.md

## Launch Payload Shape

```json
{
  "runtime": "thinui",
  "entryView": "boot-loader",
  "mode": "fullscreen",
  "themeId": "thinui-c64",
  "loaderId": "c64-boot-seq"
}
```

## Integration Sequence

1. Alpine launcher prepares initial payload from profile context.
2. ThinUI consumes payload as initial state hydrate input.
3. Theme resolver loads adapter by `themeId`.
4. First frame emits from ThinUI boot-loader lane.
5. Events flow back to caller; semantics remain core-owned.

## Validation

```bash
bash scripts/run-alpine-checks.sh
bash scripts/demo-thinui-launch.sh
```

Confirm docs + profiles + openrc surfaces remain consistent after integration updates.

## Boundary Rules

- Alpine may choose launch mode and default theme preference.
- Alpine does not define state semantics.
- Core remains semantic authority.
- ThinUI remains runtime render scaffold owner.

## Demo Payload

- `profiles/thinui-c64-launch.json`
- `scripts/demo-thinui-launch.sh`
