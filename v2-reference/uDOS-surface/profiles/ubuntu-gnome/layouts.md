# ubuntu-gnome — layout specification (v0.1)

## Default layout mode

**split** — Primary ThinUI or document surface plus optional side panel (navigation, binder context, status). Exact pixel geometry is host/window-manager territory; this profile requires:

- A **primary** content region owned by ThinUI when the surface is active.
- At least one **secondary** region may host chrome, lists, or metadata without obscuring the primary binding target.

## Supported layout modes (declared)

| Mode | Use on ubuntu-gnome |
| --- | --- |
| `single` | Optional: distraction-free single column when panels are collapsed. |
| `split` | Default for daily driver and dev-adjacent work. |
| `focus` | Maps to ThinUI fullscreen takeover; hides or minimizes secondary panels. |
| `overlay` | Modals, transient sheets; must not permanently replace primary layout contract. |
| `grid` | Optional dashboard-style card grid for family health / library summaries (future). |
| `ambient` | Out of scope for v0.1 on this profile (see uhome-tv). |

## GNOME integration notes

- **Windowed:** ThinUI may run as a dedicated application window; profile expects standard GNOME decorations unless Classic Modern host profile says otherwise.
- **Fullscreen:** ThinUI fills the display; ESC or explicit chord returns to windowed per `session-rules.md`.

## Non-goals (v0.1)

- Defining exact GTK theme or shell extension layout (host profile + themes repos).
- Replacing Mutter behaviour; profile expresses **expectations** for ThinUI host adapters.
