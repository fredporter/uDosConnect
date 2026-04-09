# uDOS ThinUI unified workspace (inbox entry)

Binder-native unified workspace shell: one **#binder** object rendered as Board, Table, Docs, Calendar, Social, Ops, and Editor modes.

## Where it lives (canonical)

Implementation is in **`uDOS-thinui`**, not in this inbox folder.

| Area | Path |
|------|------|
| Workspace types + parser | `uDOS-thinui/src/workspace/` |
| Bundled demo binder JSON | `uDOS-thinui/src/workspace/demo-binder.json` |
| Example copy (same payload) | `uDOS-thinui/examples/demo-binder.json` |
| Browser shell demo | `uDOS-thinui/demo/workspace.html`, `workspace.css`, `workspace-main.ts` |
| Multi-page Vite build | `uDOS-thinui/vite.config.ts` (`workspace` entry) |

## Run the demo

From a checkout of `uDOS-thinui`:

```bash
npm install
npm run dev:workspace
```

Or open `http://localhost:5179/workspace.html` after `npm run dev`.

## Architecture note

See `docs/architecture.md` in this folder for a short boundary summary. The full product brief is the message thread / family roadmap that spawned this work.

## Inbox folder role

This directory is only an **index**: it must not drift into a second codebase. Extend **`uDOS-thinui`** for UI and contracts; keep core semantics in **`uDOS-core`** when you wire the real bridge.
