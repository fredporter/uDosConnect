# Foundation and distribution (Workspace 02)

Canonical spec for **install, packaging, bootstrap, path ownership**, and the
**Sonic / Ventoy** boundary relative to core uDOS. Execution order and
three-step round closure: `docs/cursor-execution.md`, `docs/round-closure-three-steps.md`,
pathway `@dev/pathways/foundation-distribution-workspace-round-closure.md`.

**Operator-facing narrative** (Wizard entry, GUI-first, Sonic master menu,
organic stack growth, Sonic global + user device DB): read
**`docs/family-first-run-operator-flow.md`** alongside this file. Below stays the
**implementation** topology; the other doc is the **product story**.

## Install and packaging topology

1. **Source tree:** operators clone the public family layout (convention
   **`~/Code/uDosGo/`** for the integration monorepo and **`~/Code/uDosConnect/`** for governance, docs, and `v2-reference`; see **`uDosConnect/docs/family-workspace-layout.md`**) and sibling repos as documented in
   `uDOS-host/docs/linux-first-run-quickstart.md`.
2. **First-entry installer:** **`sonic-screwdriver`** is the **first** surface for
   deployment planning, USB/media workflows, and recovery-oriented bootstrap.
   Run `bash scripts/first-run-preflight.sh` then the starter CLI (`sonic` /
   `sonic start`) per that repo’s README.
3. **Always-on runtime:** after hardware/OS baseline, **`uDOS-host`** owns the
   long-lived command-centre host; bootstrap continues with
   `scripts/linux-family-bootstrap.sh` where applicable.
4. **Lean profile:** **`uDOS-alpine`** is an optional Core-aligned profile; it
   does not replace Ubuntu as the canonical command-centre owner.

## Path standard (`~/.udos/`)

Managed runtime and state live under the **home-relative** layout defined in
[`docs/archive/cursor-handover-plan.md`](archive/cursor-handover-plan.md) (archived) and implemented by `uDOS-host/scripts/lib/runtime-layout.sh`:

| Area | Path (under `$HOME`) |
| --- | --- |
| Managed runtime root | `~/.udos/` |
| Shared Python envs | `~/.udos/envs/` |
| Service / daemon state | `~/.udos/state/` |
| Logs | `~/.udos/logs/` |
| Cache / temp | `~/.udos/cache/`, `~/.udos/tmp/` |
| Tools / launchers | `~/.udos/tools/`, `~/.udos/bin/` |
| Vault | `~/.udos/vault/` |
| Memory / session artefacts | `~/.udos/memory/` |
| Mirrored libraries / downloads | `~/.udos/library/` |
| Sync staging | `~/.udos/sync/` |

**LAN library / prefetch (offline-first):** `~/.udos/library/` is the canonical
**on-disk home** for **mirrored** payloads the family stages while **online** —
packages, update artifacts, release bundles, optional model weights (see below),
and other **documented** mirror content — so **uDOS-host** (and peers on the LAN)
can **install and repair without the wide internet**. See
`docs/udos-host-platform-posture.md` § **Offline-first survival posture** and
`docs/family-first-run-operator-flow.md` (lean install vs library-host profile).
**Sonic** remains the natural lane for **plan → prefetch → stage** before apply;
the host **serves** and **retains** what must survive **grid-down** scenarios.
**Retention** (how many ISO generations, max library size, partition separation)
must respect **runtime disk headroom** — see `docs/udos-host-platform-posture.md`
§ **System health, disk budget, and retention**.

**Repo cleanliness:** git trees hold templates, contracts, and automation only.
Runtime payloads, secrets, large downloads, and generated logs belong under
`~/.udos/` unless a repo explicitly documents checked-in fixtures.

## Standalone Sonic versus full uDOS entry

| Mode | Entry | Hands off to |
| --- | --- | --- |
| **Sonic-only** | `sonic-screwdriver` preflight + CLI/API/UI for planning and media | Does not redefine Core semantics; consumes released contracts |
| **Full uDOS** | Sonic for deploy lane + `uDOS-host` for always-on runtime | `uDOS-core` contracts, Wizard orchestration, registries |

Sonic **does not** own the always-on command-centre HTML/runtime; `uDOS-host`
does. Sonic **does** own `take profile → manifest → verify → stage → apply`.

## Docker and family runtime decision

**Decision (2026-04-01):** do **not** adopt Docker as the long-term family
runtime substrate. Build and use a **shared uDOS-native service/resource layer**
for what Docker commonly provides (packaged service startup, dependency
isolation policy, health probes, lifecycle control), with aggressive migration in
post-08 work.

### Posture

- **Canonical runtime:** host/systemd + `udos-*` service contracts under
  `uDOS-host` and family scripts/contracts.
- **Docker:** **transitional compatibility only** for third-party stacks while
  replacement lanes land. No new Tier-1 feature should require Docker as a hard
  prerequisite.
- **Governance:** when Docker is temporarily used, the owning repo must document
  exit criteria and migration target to the shared uDOS-native lane.

### Migration intent (aggressive)

1. Prioritize shared command/service entry (`udos-commandd` + family CLI lane)
   and consistent health/status probes across services.
2. Migrate low-risk and Tier-1-facing runtime paths first.
3. Keep third-party compose overlays only where upstream coupling still forces
   it, with explicit deprecation notes.

Minimum contract for this lane:

- `docs/shared-runtime-resource-contract.md`

## Local-language intelligence (e.g. GPT4All-class models)

- **Plan:** host **optional** local inference under `~/.udos/library/` (model
  weights) and `~/.udos/state/` (runtime caches), with **explicit** opt-in and
  resource policy documented per product repo when features land.
- **Fallback:** Wizard/provider routes remain the default when local models are
  absent or disabled. No silent network calls from Core.

## Distro and image dependency order

```text
uDOS-core (contracts)
    → uDOS-plugin-index / registries as needed
    → sonic-screwdriver (planning, media, apply)
    → uDOS-host (always-on command centre + materialized ~/.udos/)
    → uDOS-alpine (optional lean profile; same contract consumption)
sonic-ventoy (when present): boot templates and menu assets ← sonic-screwdriver only
```

## Sonic and Ventoy split (adjacent family)

- **`sonic-screwdriver`:** orchestrates deployment and consumes Ventoy-compatible
  assets through its own scripts and tests.
- **`sonic-ventoy`:** owns boot-template and menu-extension **artifacts**; does
  not own deployment orchestration or runtime semantics.
- Core uDOS completion **does not** require the Ventoy repo to be checked out;
  when the sibling exists at `../sonic-family/sonic-ventoy` (see
  `cursor-02-foundation-distribution.code-workspace`), Sonic’s CI/smoke tests
  cover the integration contract.

## Automated verification (Workspace 02 step 1)

From `uDOS-host` (family root layout as in the pathway):

```bash
bash scripts/foundation-distribution-round-proof.sh
```

This runs repo checks for Sonic (if present), `uDOS-host`, `uDOS-core`,
`uDOS-plugin-index`, `uDOS-alpine`, `uDOS-docs`, and `uDOS-dev`, plus
command-centre HTTP verification. The proof script exports
`SONIC_SCREWDRIVER_ROOT` to the same Sonic checkout used for pytest so
`uDOS-dev/scripts/run-dev-checks.sh` can resolve the v2.3 workflow demo fixture.

## Browser preview (step 3 for this lane)

Workspace 01 and 02 require a **real browser** check of the command-centre demo.
See **`docs/command-centre-browser-preview.md`** for URLs, port overrides, LAN,
and SSH port-forwarding.

## Related

- `docs/archive/cursor-handover-plan.md` — home path standard (archived narrative)
- `docs/family-split-prep.md` — core vs Sonic vs uHOME
- `docs/repo-family-map.md` — ownership table
- `uDOS-host/docs/config-layout.md` — repo vs `~/.udos/` config split
- `@dev/notes/roadmap/v2-family-roadmap.md` § Engineering backlog — Docker
  replacement track status
- `docs/shared-runtime-resource-contract.md` — replacement capability baseline
