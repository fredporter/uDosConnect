# Forms Adapter

Maps GTX-form primitives into step-based flows across browser, ThinUI, and TUI
surfaces.

This is **not** one of the four third-party **theme forks** (c64css3, NES.css,
svelte-notion-kit, bedstead). It is a **first-class uDOS surface** with theme pack
`gtx-form-default`, composed with **Tailwind** and **Svelte** (or other hosts) in
consuming apps — similar in spirit to Typeform-style steps, not a separate GitHub
theme repo. See the **GTX forms** section in `docs/theme-upstream-index.md`.

Implemented surface:

- `gtx-form-prototype.mjs` defines the first setup-story prototype
- `index.mjs` renders browser, ThinUI, and TUI step views and submission state
