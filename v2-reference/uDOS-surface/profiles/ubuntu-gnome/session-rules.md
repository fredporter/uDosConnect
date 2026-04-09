# ubuntu-gnome — session rules (v0.1)

## Windowed vs fullscreen

- **Default session:** windowed multi-window allowed (`multiWindow: true` in `surface.json`).
- **Focus session:** ThinUI may request fullscreen; host should honour **one** primary ThinUI fullscreen surface per physical display unless product spec says otherwise.
- **Exit fullscreen:** Must be discoverable (F11 or ESC policy aligned with ThinUI + GNOME).

## Kiosk

- **Not** the default for ubuntu-gnome. Kiosk-style lockdown is a **different profile** or explicit operator flag on host scripts.

## State restore

- `restoreState: true` — On relaunch, restore last known layout mode (windowed vs fullscreen) and panel visibility **where** the host + ThinUI persist state under `~/.udos/` contracts. Implementation detail belongs to ThinUI + host, not this markdown file.

## Multi-session

- Multiple ThinUI instances may exist only if Core/session policy allows; profile does not forbid multiple windows but designates **one** primary binding context per workspace semantics (align with uDOS-workspace when wired).

## Takeover mode

- Optional future flag: temporary fullscreen takeover for presentations or demos; document in host runbooks when implemented.
