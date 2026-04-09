# Systemd Templates

Checked-in `systemd` unit templates for the Ubuntu command centre.

These are starter templates only. Host-installed units should be rendered into
`/etc/systemd/system/` during setup or Sonic-driven install.

The current core set now includes `udos-gitd.service` for the host-owned local
repo store and Git or GitHub execution surface.

**Lane-1 demo on the LAN (lab / round continuity):** not installed to
`/etc/systemd/system` by default. Use **`scripts/install-command-centre-demo-lan-user-service.sh`**
to generate a **`systemd --user`** unit (bind `0.0.0.0`, default port 7107). See
`docs/lan-command-centre-persistent.md`.
