# Command centre — browser preview (Workspaces 01 and 02)

Use this when a Cursor round requires **step 3 — final GUI render**: you must
**see** the page in a real browser (`curl` and automated HTML substring checks
do **not** satisfy this step). See `docs/round-closure-three-steps.md`.

## What you are checking

After the server starts, the page must show:

- A top-level heading **“uDOS command centre”**
- Supporting text such as **“Static host demo — Ubuntu runtime spine (lane 1)”**

That content is served from `uDOS-host/examples/command-centre-demo/index.html`.

## Default URL and port

Defaults live in `uDOS-host/scripts/lib/udos-web-listen.sh`:

- **Bind:** `127.0.0.1` (localhost-only)
- **Port:** `7107`

So on the **same machine** that runs the server, open:

```text
http://127.0.0.1:7107/
```

You can also try `http://localhost:7107/` on most systems.

Override the port if something else already uses `7107`:

```bash
export UDOS_WEB_PORT=7108
bash scripts/serve-command-centre-demo.sh
```

Then open `http://127.0.0.1:7108/`.

## Option A — same machine (simplest)

1. Open a terminal.
2. Go to the **uDOS-host** repo root (the directory that contains `scripts/`).

   ```bash
   cd /path/to/your/uDOS-family/uDOS-host
   ```

3. Start the demo server (it keeps running until you stop it):

   ```bash
   bash scripts/serve-command-centre-demo.sh
   ```

4. The script prints a line like **`open: http://127.0.0.1:7107/`** — use that URL.
5. In a normal browser (Safari, Chrome, Firefox, Edge, etc.), open that URL.
6. Confirm you **see** the **uDOS command centre** page (not a connection error).
7. Stop the server with **Ctrl+C** in the terminal when finished.

**Headless / SSH-only hosts:** use **port forwarding** from your laptop (for example `ssh -L 7107:127.0.0.1:7107 user@host`), then open `http://127.0.0.1:7107/` in the browser **on the laptop**.

## Option B — another device on your LAN

Use this when you want a phone/tablet/second PC to load the page, or when the
policy asks for LAN proof.

1. On the Ubuntu host, from `uDOS-host`:

   ```bash
   bash scripts/serve-command-centre-demo-lan.sh
   ```

2. Find this machine’s LAN IP (Linux examples):

   ```bash
   hostname -I | awk '{print $1}'
   ```

3. On the **other device’s** browser, open:

   ```text
   http://<LAN-IP>:7107/
   ```

   (Replace `<LAN-IP>` and use `UDOS_WEB_PORT` if you changed the port.)

4. Confirm the same **uDOS command centre** heading and demo text.
5. **Ctrl+C** on the host to stop.

**Security:** binding to all interfaces is for **trusted lab networks** only. Do
not expose to the public Internet without TLS and proper access control. More
context: `uDOS-host/docs/lan-command-centre-persistent.md`.

## After you have seen the page

Record completion where the round asks you to (for example
`@dev/notes/rounds/cursor-02-foundation-distribution-2026-03-30.md` for
Workspace 02, or `@dev/notes/devlog.md`).

## Related

- Pathway (Workspace 02): `@dev/pathways/foundation-distribution-workspace-round-closure.md`
- Pathway (Workspace 01): `@dev/pathways/runtime-spine-workspace-round-closure.md`
- Contract: `uDOS-host/contracts/udos-web/command-centre-static-demo.v1.json`
