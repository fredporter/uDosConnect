# uDOS-surface — experience orchestration layer

**One-liner:** uDOS-surface defines how uDOS is experienced across devices and environments. It configures layout, navigation, input, and session behaviour, and delegates rendering to **uDOS-thinui**.

This document is the **canonical spec** for that layer. It complements `architecture.md`, which still describes the **browser operator UI** (`apps/surface-ui`, `wizard/`) in this repository. Over time, profile contracts here should drive how ThinUI is hosted on each host; the browser app may consume the same profile vocabulary where appropriate.

---

## Definition

**uDOS-surface** (experience sense) is the **presentation orchestration** layer that defines how uDOS is experienced within a host environment (device, OS, or mode).

It sits between:

- **uDOS-core** outputs (binders, workflows, feeds), and  
- **uDOS-thinui** (rendering engine).

```
uDOS-core (binders, workflows, MCP, …)
        ↓
uDOS-surface (experience orchestration)
        ↓
uDOS-thinui (rendering engine)
        ↓
Host environment (GNOME, browser, kiosk, TV, mobile)
```

---

## Core responsibility

uDOS-surface answers:

- How should this feel on this device?
- How does the user navigate?
- What input model is active?
- Fullscreen, windowed, or ambient?
- How is ThinUI hosted and configured?

---

## Scope — owns

1. **Surface profiles** — Named environments (e.g. `ubuntu-gnome`, `uhome-tv`, `mdc-mobile`, `dev-console`). Each profile defines a complete UX contract. Initial implementations live under `profiles/<id>/`.

2. **Layout modes** — How UI is structured at runtime: `single` (MDC-style scroll), `split` (dev panels), `grid` (dashboard/cards), `focus` (fullscreen task), `overlay` (modal layers), `ambient` (passive display, TV/signage).

3. **Navigation models** — e.g. `stack` (mobile), `panel` (desktop), `radial` (controller), `command-palette` (universal), `spatial` (future grid/layer).

4. **Input abstraction** — Per-surface input: keyboard, touch, controller, hybrid. Aligns with the family universal controller / UCI contracts where applicable.

5. **Session and mode management** — Windowed vs fullscreen, kiosk, takeover, background/ambient, multi-session handling.

6. **ThinUI hosting rules** — How ThinUI is mounted, layout constraints, theme selection (referencing **uDOS-themes**), component density (mobile vs TV vs desktop).

7. **Device awareness** — Screen size, DPI/scale, input capability, performance constraints (declarative in profile; detection may live in host or shell).

---

## Scope — does not own

| Concern | Owner |
| --- | --- |
| UI components | uDOS-thinui |
| Themes / tokens | uDOS-themes |
| Workflows / binders | uDOS-core |
| Business / product logic | Products (uHOME, MDC, Sonic, …) |
| Host disk/runtime policy | uDOS-host (legacy repo folder `uDOS-host`) |

---

## Rules for implementers

**Rule 1 — No layout/navigation/device policy inside ThinUI as product truth**  
ThinUI should not unilaterally define layout mode, navigation style, or device-specific behaviour; it receives constraints from the active **surface profile** (or a default profile when none is loaded).

**Rule 2 — No rendering in surface profiles**  
Profile specs do not draw components, define visual styles, or build widgets. They **contract** behaviour; ThinUI **renders**.

**Rule 3 — Surface profile = experience contract**  
Every profile should make explicit: primary user, device class, dominant input, dominant layout, session mode, and ThinUI hosting parameters.

---

## Initial profiles (v0.1)

| Profile | Intent |
| --- | --- |
| **ubuntu-gnome** | Desktop-native uDOS within GNOME; first concrete implementation. See `profiles/ubuntu-gnome/`. |
| **uhome-tv** | Ten-foot UI; controller-first; fullscreen; ambient modes. Scaffold later. |
| **mdc-mobile** | Single-document scroll; touch-first; minimal chrome. Scaffold later. |
| **dev-console** | Split panes, logs + binder + output; command-heavy; dense. Scaffold later. |

---

## Machine-readable contracts

- **Surface profile:** `contracts/surface-profile.v0.1.schema.json` — validates `surface.json` shape.
- **Input mapping:** `contracts/surface-input-mapping.v0.1.schema.json` — validates `input-mapping.json` (Shell / UCI intents).
- **Example instance:** `profiles/ubuntu-gnome/surface.json`
- **CI / local check:** `python3 scripts/validate_surface_profiles.py` (stdlib structural checks; schemas are normative for editors and future validators).

---

## Related

- `architecture.md` — browser operator UI and broker edges in **this** repo  
- `profiles/` — profile directories  
- **`uDOS-thinui`** — first runtime consumer: built-in `ubuntu-gnome` profile and `udos-default` theme (`src/surface/surface-profile.ts`; `npm run demo -- --profile ubuntu-gnome`)  
- `uDOS-dev/docs/gui-system-family-contract.md` — host vs Wizard vs surface vocabulary  
- `uDOS-docs/docs/classic-modern-mvp-0.1/` — Classic Modern host + ThinUI alignment  
