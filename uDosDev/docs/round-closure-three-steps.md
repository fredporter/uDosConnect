# Round closure — three mandatory steps (Workspaces 01 and 02)

**A round is not closed until all three steps are complete.** Automated green and terminal-only cycles are necessary but **not sufficient**.

**Step 3 is never optional.** `curl` checks and HTML substring tests prove wiring; they **do not** replace a human **seeing the rendered GUI** in a real browser.

**Terminal demos:** scripts such as `demo-first-run-setup.sh` and the Ubuntu phase of `runtime-spine-workspace-tui.sh` must surface an **operator-readable layer** (prose derived from scaffolds), not only raw JSON. JSON remains the machine contract; humans read the summary first (`scripts/lib/human_readable_demo.py`).

---

## Workspace 01 — runtime spine

| Step | Name | What you do |
| --- | --- | --- |
| **1** | **Automated verification** | From `uDOS-host`: `bash scripts/run-ubuntu-checks.sh` **and** `bash scripts/verify-command-centre-http.sh` both pass. |
| **2** | **Full workspace cycle (terminal)** | `bash scripts/runtime-spine-round-proof.sh` through its automated parts (HTTP verify + `runtime-spine-workspace-tui.sh`), or run those pieces separately to the same effect. |
| **3** | **Final GUI render** | In a **browser**, open the **uDOS command centre** page and **confirm you see the rendered UI** (e.g. the **“uDOS command centre”** heading). Start the server with `bash scripts/serve-command-centre-demo.sh` (localhost) or `bash scripts/serve-command-centre-demo-lan.sh` (LAN). **Operator runbook:** `docs/command-centre-browser-preview.md`. For **production-style Workspace 01 sign-off**, prefer a **second device** on the LAN when you can. **Record** completion in `uDOS-dev/@dev/notes/rounds/` or `@dev/notes/devlog.md`. |

If step 3 is not done and recorded, **Workspace 01 stays open** — even if steps 1–2 passed on a server with no display.

Detail and LAN persistence: `@dev/pathways/runtime-spine-workspace-round-closure.md`, `uDOS-host/docs/lan-command-centre-persistent.md`.

---

## Workspace 02 — foundation and distribution

The **same three-step shape** applies. Lane-2 specifics for steps 1–2 will grow with Sonic, Ventoy, and install scripts; this file states the **non-negotiable third step** from the start.

| Step | Name | What you do |
| --- | --- | --- |
| **1** | **Automated verification** | `bash uDOS-host/scripts/foundation-distribution-workspace-proof.sh` (Sonic `run-sonic-checks.sh`, Ubuntu checks + command-centre HTTP verify, `uDOS-core`, `uDOS-plugin-index`, `uDOS-alpine`, `uDOS-docs`, `uDOS-dev`; proof exports `SONIC_SCREWDRIVER_ROOT` for dev checks). |
| **2** | **Integration / terminal proof** | Same script chain as step 1 for this lane, or `bash uDOS-host/scripts/foundation-distribution-round-proof.sh` for automated gates plus the step-3 reminder. |
| **3** | **Final GUI render** | Operator **visually** confirms a **documented GUI surface** for the milestone. **Until Sonic/Ventoy (or another lane-2 product) defines a different primary operator GUI**, the regression anchor remains the **uDOS command centre**: same scripts as Workspace 01 (`serve-command-centre-demo.sh` / `serve-command-centre-demo-lan.sh`) so the family-visible HTML does not regress while install work proceeds. **Step-by-step browser preview:** `docs/command-centre-browser-preview.md`. When a new primary GUI exists, update this table and `docs/cursor-focused-workspaces.md` § Workspace 02. **Record** sign-off. |

If step 3 is not done and recorded, **Workspace 02 stays open**.

---

## Related links

- `docs/cursor-focused-workspaces.md` — Workspace 01 and 02 exit gates
- `docs/cursor-execution.md` — lane order and discipline
- `docs/runtime-spine.md` — lane-1 narrative and proof table
- `contracts/udos-web/command-centre-static-demo.v1.json` — listen defaults for the command-centre demo
