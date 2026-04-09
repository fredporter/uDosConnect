# Themes Roadmap

- keep the token, adapter, theme, and skin layers portable across surfaces
- expand working adapters only after the boundary and validation rules remain
  clear
- prove cross-surface primitive reuse before adding more surface-specific
  styling complexity
- keep validation and compatibility evidence visible as the surface map grows

## Upstream fork rollout (fredporter)

Four submodules under `vendor/forks/`: **c64css3**, **NES.css**, **svelte-notion-kit**,
**bedstead** (Teletext50), per `docs/theme-fork-rollout.md`.

- Optional: copy built teletext fonts into `vendor/fonts/teletext50/` with README
  (license from bedstead `COPYING`).
- Extract tokens from forked CSS into `thinui-c64`, `thinui-nes-sonic`,
  `thinui-teletext` without leaking upstream selectors into Core.
- **GTX forms:** evolve `src/adapters/forms/` + `gtx-form-default` with Tailwind /
  Svelte hosts — not a fifth GitHub theme fork.
- Optional: wire ThinUI demo to consume built outputs from `uDOS-themes` once a
  publish path exists.
