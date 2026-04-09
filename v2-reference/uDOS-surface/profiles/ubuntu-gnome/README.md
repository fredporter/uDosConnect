# Profile: ubuntu-gnome

**Intent:** Desktop-native uDOS experience within **GNOME** on the uDOS-host (Ubuntu baseline). This is the **first** profile we implement against real host + ThinUI work.

## Characteristics

- Windowed default, optional **fullscreen takeover** for focused work (ThinUI-first).
- **Keyboard-first**; controller-capable where UCI / family controller spec applies.
- **Multi-panel** layouts (`split` / `panel` navigation) for operator and dev-adjacent flows.
- Integrates with GNOME shell / launcher for launch and handoff (host-owned scripts; profile describes expectations).
- Acts as the **daily driver** surface for uDOS on Linux desktop.

## Files in this directory

| File | Purpose |
| --- | --- |
| `surface.json` | Machine-readable profile (schema v0.1 starter) |
| `layouts.md` | Layout modes and panel structure for this profile |
| `input-mapping.json` | Keyboard + controller binding intents (implementation consumes via UCI/Core as wired) |
| `session-rules.md` | Fullscreen, multi-window, state restore |

## Boundaries

- **Does not** define GTK/Qt widgets or theme tokens — see **uDOS-themes** and **Classic Modern** pack in **uDOS-docs**.
- **Does not** own binder semantics — **uDOS-core**.
- **ThinUI** renders; this profile **configures** how it is hosted on GNOME.

## Related

- `docs/surface-experience-layer.md`
- `uDOS-docs/docs/classic-modern-mvp-0.1/docs/classic-modern-host-profile.md`
- **ThinUI:** consumes this profile as built-in `ubuntu-gnome` (`uDOS-thinui/src/surface/surface-profile.ts` mirrors `surface.json`); run `npm run demo -- --profile ubuntu-gnome` or Vite demo `?profile=ubuntu-gnome`.
