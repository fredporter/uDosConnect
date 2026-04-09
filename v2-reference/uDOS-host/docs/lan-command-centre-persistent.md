# LAN command-centre — stay running between rounds

After a successful **physical Linux install** (`docs/linux-first-run-quickstart.md`), you may want the lane-1 **static command-centre** to remain **reachable on the local network** while you switch Cursor workspaces (e.g. **cursor-02**). This is **continuity for your lab host**, not a hardened production edge.

## Behaviour

- Listens on **`0.0.0.0`** and **`UDOS_WEB_PORT`** (default **7107** per `scripts/lib/udos-web-listen.sh`).
- Same static root as the demo: `examples/command-centre-demo/` (via **`scripts/udos-web.sh`** / `runtime_daemon_httpd.py`).
- **`GET /health.json`** on the same port returns JSON with `"service":"udos-web"` for quick LAN probes.
- **No TLS, no auth** — use only on a network you trust (home lab / VLAN).

## Quick run (foreground)

From `uDOS-host`:

```bash
bash scripts/serve-command-centre-demo-lan.sh
```

On another machine: `http://<ubuntu-host-LAN-IP>:7107/`

## Stay up after SSH disconnect (systemd user service)

Install and start:

```bash
bash scripts/install-command-centre-demo-lan-user-service.sh --now
```

Check:

```bash
systemctl --user status udos-command-centre-demo-lan.service
journalctl --user -u udos-command-centre-demo-lan.service -f
```

Remove:

```bash
bash scripts/install-command-centre-demo-lan-user-service.sh --remove
```

### Boot without interactive login

User units run only while a user session exists unless **linger** is enabled:

```bash
loginctl enable-linger "$USER"
```

(Reversible: `loginctl disable-linger "$USER"`.)

## Firewall

If **`ufw`** is active:

```bash
sudo ufw allow 7107/tcp comment 'uDOS command-centre demo LAN'
sudo ufw reload
```

Adjust the port if you override **`UDOS_WEB_PORT`**.

## Bootstrap hook

After a green **`linux-family-bootstrap.sh`** run, install the user service in one step:

```bash
export UDOS_BOOTSTRAP_INSTALL_LAN_SERVICE=1
bash scripts/linux-family-bootstrap.sh
```

Or run **`install-command-centre-demo-lan-user-service.sh --now`** manually afterward.

## Relation to production `udos-web`

Checked-in **`config/systemd/udos-web.service`** targets the full host install (`udos-web.sh` stub today). This LAN unit is **demo-only** and tied to the **repo path** on your machine—appropriate for the **physical litmus** and **multi-round** dev host, not for Sonic-driven `/opt/udos` installs until you promote the same pattern there.
