# How the uDOS family fits together (reader map)

**Public library copy.** This page is a **short mirror** of the control-plane
index so you do not have to open **`uDOS-dev`** first. The **canonical** version
(with the same tables, maintained in lockstep) lives in **`uDOS-dev`**:

- [`uDOS-dev/docs/family-operator-organisation-map.md`](../../uDOS-dev/docs/family-operator-organisation-map.md)

**Start here on this site:** [`onboarding.md`](onboarding.md) — then use the
links below when you want the full story.

There is **no single “family home” git repository** for your chosen install
folder; you pick where clones live. Runtime layout under **`~/.udos/`** is
described in the foundation doc linked below.

## Recommended reading order

1. **[`onboarding.md`](onboarding.md)** — use / learn / build; first-run pointers.
2. **[`uDOS-dev` first-run flow](https://github.com/fredporter/uDOS-dev/blob/main/docs/family-first-run-operator-flow.md)** — Wizard-led journey, intent profiles (e.g. media-only vs minimal tools), plain language, offline preparation, disk vs library.
3. **[`uDOS-dev` host posture](https://github.com/fredporter/uDOS-dev/blob/main/docs/udos-host-platform-posture.md)** — **uDOS-host** naming, Linux and macOS, Windows scope, LAN/offline library, health and disk budget, Wizard as health **dashboard** (delegates to the host).
4. **[`uDOS-dev` foundation / paths](https://github.com/fredporter/uDOS-dev/blob/main/docs/foundation-distribution.md)** — **`~/.udos/`** layout, Sonic vs host, keeping the local library from starving runtime.

*If your checkout includes **`uDOS-dev`** next to **`uDOS-docs`**, use the relative
link at the top instead of GitHub `blob` URLs.*

## Who owns which screen?

- **[`uDOS-dev` GUI contract](https://github.com/fredporter/uDOS-dev/blob/main/docs/gui-system-family-contract.md)** — ThinUI, browser workspace, Wizard, command-centre demo; Wizard **delegation** and family health UI role.
- **[Ownership table](https://github.com/fredporter/uDOS-dev/blob/main/docs/workspace-08-exit-evidence.md)** (section 1) — host, Core, Wizard, Shell, this docs hub, and siblings.

## Health, cleanup, feeds

- **[Runtime health and compost](https://github.com/fredporter/uDOS-dev/blob/main/docs/runtime-health-and-compost-policy.md)** — workspace `.compost` vs **`~/.udos/`** cleanup.
- **[Core feeds and spool](https://github.com/fredporter/uDOS-core/blob/main/docs/feeds-and-spool.md)** — contract for feeds/spool (binder-aligned, no silent bloat).

## Where prose lives (maintainers)

- **[Family documentation layout](https://github.com/fredporter/uDOS-dev/blob/main/docs/family-documentation-layout.md)** — `docs/` vs `@dev/` vs `wiki/` across repos.
- **Planning:** [`next-family-plan-gate`](https://github.com/fredporter/uDOS-dev/blob/main/docs/next-family-plan-gate.md), [`v2-family-roadmap`](https://github.com/fredporter/uDOS-dev/blob/main/@dev/notes/roadmap/v2-family-roadmap.md), [`v2-roadmap-status`](https://github.com/fredporter/uDOS-dev/blob/main/@dev/notes/roadmap/v2-roadmap-status.md).

## Related on this repo

- [`publishing-architecture.md`](publishing-architecture.md) — how the library site is built.
- [`local-vs-github-docs-boundary.md`](local-vs-github-docs-boundary.md) — local edit vs public Pages.
- [`course-hooks-and-onboarding.md`](course-hooks-and-onboarding.md) — wiki units and learning metadata.
