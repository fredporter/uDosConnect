# Family workspace layout (planning spine)

This is the **canonical disk layout** for uDos family planning and tooling. Other docs may use `<repo-root>` or `~` where a machine-neutral placeholder is required; for **human planning**, assume these paths.

## Base

All checkouts below are rooted at **`~/Code/`** (or an equivalent single parent directory on your machine — keep **one** base so relative links and workspaces stay portable).

## Two fixed ideas

1. **Runnable integration** — the Host / ThinUI / Hivemind monorepo **always** lives at:

   **`~/Code/uDosGo/`**

   Treat this as the only “live” integration tree for implementation work. On GitHub: **[uDosGo](https://github.com/fredporter/uDosGo)**; local folder name **`uDosGo`** is the family convention. **Alternative bucket (same remote):** some workspaces keep the clone at **`~/Code/apps/uDosGo/`** — use the same `git` remote; adjust relative paths to **`uDosConnect`** (`../../uDosConnect` from repo root). **`npm run validate:usxd:sibling`** still finds **`~/Code/tool-family/UniversalSurfaceXD`** from that layout.

2. **Everything else in the family bundle** — governance, public docs, archived v2 module snapshots (except groovebox — see below), shared bash/Python helpers, and future extension submodules — lives **under** the **`uDosConnect`** repository:

   **`~/Code/uDosConnect/`**  
   **`~/Code/uDosConnect/uDosDev/`** — Task, dev process v4, governance  
   **`~/Code/uDosConnect/uDosDocs/`** — public documentation corpus  
   **`~/Code/uDosConnect/v2-reference/`** — read-only historical module trees (partial; **`uDOS-groovebox`** removed — use **[GrooveBox888](https://github.com/fredporter/GrooveBox888)** at **`~/Code/GrooveBox888/`**)  
   **`~/Code/uDosConnect/scripts/`** — shared family scripts  

   Optional extra clones that participate in checks (for example **`uDOS-wizard`**) should live **inside** this tree when you follow the spine, e.g. **`~/Code/uDosConnect/uDOS-wizard/`**, so paths like `../uDOS-wizard` from `uDosDev/` resolve predictably.

## Typical sibling (not inside uDosConnect)

**[UniversalSurfaceXD](https://github.com/fredporter/UniversalSurfaceXD)** — surface language, interchange JSON, browser lab — usually sits next to the base as **`~/Code/UniversalSurfaceXD`**. Multi-root workspaces often open **`uDosGo`**, **`uDosConnect`**, and **UniversalSurfaceXD** together; it is **not** required to nest UniversalSurfaceXD under `uDosConnect/`.

## Diagram

```text
~/Code/
  uDosGo/                 ← integration monorepo (always this name/location)
  uDosConnect/          ← this repo (governance, docs, v2-reference, scripts)
    uDosDev/
    uDosDocs/
    v2-reference/         ← archived snapshots (groovebox → GrooveBox888 sibling)
    scripts/
  GrooveBox888/         ← optional; standalone groovebox repo
    …                     ← optional sibling clones used by family checks
  UniversalSurfaceXD/     ← optional; usual layout for the lab repo
```

## Related

- [`shared-resources-architecture.md`](shared-resources-architecture.md) — `~/.udos` runtime layout (separate from Git checkouts).  
- **Pre-v5 program order (PRE5-R01–R07):** [`uDosDev/docs/future/PRE_V5_ROADMAP_SINGLE_LANE_v1.md`](../uDosDev/docs/future/PRE_V5_ROADMAP_SINGLE_LANE_v1.md) — single table; full exit criteria in [`PRE_V5_ROADMAP_AND_EXECUTION_ROUNDS_v1.md`](../uDosDev/docs/future/PRE_V5_ROADMAP_AND_EXECUTION_ROUNDS_v1.md) §4.  
- Root [`README.md`](../README.md) — what this repository contains.
