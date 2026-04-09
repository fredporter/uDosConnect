# Completion round launchers (macOS `.command`)

Double-click in Finder or run from a terminal. Paths assume **`uDOS-dev/workspaces/completion-launchers/`** lives inside a normal **`~/Code/uDOS-family/`** sibling layout.

| File | Action |
| --- | --- |
| `Open-Host-Command-Centre-GUI.command` | **`uDOS-host`**: runs `scripts/verify-command-centre-http.sh` (HTTP proof + “uDOS command centre” marker). |
| `Open-Shell-TUI.command` | **`uDOS-shell`**: runs `npm run go:run` (requires `npm ci` first). |
| `Run-v2-6-release-pass.command` | **`uDOS-dev`**: runs `scripts/run-v2-6-release-pass.sh` (workspace + Core binder spine test + ThinUI + host + roadmap status — requires sibling checkouts). |

See **`../completion-rounds-and-local-stack.md`** and **`../../docs/archive/v2/completion-rounds-v2-6-alignment.md`** for the full completion / PR contract and **family `v2.6`** spine mapping.
