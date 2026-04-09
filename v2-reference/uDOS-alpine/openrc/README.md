# OpenRC

Service definitions and startup integration for Alpine boot handoff.

Current checked-in surfaces:

- `udos-thinui-launcher.initd` for a boot-safe ThinUI launcher service shell
- `udos-thinui-launcher.confd` for local overrides

The service boundary is intentionally small:

- Alpine owns the service start lane
- the checked-in profile remains the source for the initial launch payload
- ThinUI owns render behavior after handoff
