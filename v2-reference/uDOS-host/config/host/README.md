# Host surface defaults (lane 1)

Checked-in JSON here seeds **`GET /host/budget-status`** and **`GET /host/providers`** on **udos-web**.

Operators may overlay **`~/.udos/state/host/budget-status.json`** or **`providers.json`** to extend or replace fields (shallow merge for budget; `providers` array replaced when overlay defines it).

See `docs/config-layout.md` for mutable state under `~/.udos/state/`.
