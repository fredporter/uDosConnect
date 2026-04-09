# Family first-run operator flow (Wizard-led, GUI-first)

**Family coordination doc.** Maps the **intended beginner experience**: where to
start, how **Sonic**, **Wizard**, and **uDOS-host** fit together, and how the
**Sonic knowledge base** grows. Implementation will land incrementally; this is
the **target story** for product and docs.

## Principles

1. **Start with Wizard** — “If in doubt, open Wizard.” It captures **intent**
   (what the operator wants to do) and **delegates** to the right pathway — not
   every install is “full uDOS-host”. Over time it should also surface **family
   health and resources** (disk, library bloat, compost/spool hints) and **run**
   delegated checks — see `docs/udos-host-platform-posture.md` § **System health,
   disk budget, and retention**. It does not replace **uDOS-host** layout
   authority or **Core** contracts where those components are in scope.
2. **Plain language, not jargon** — many operators will **not** know “TUI” vs
   “GUI”. Wizard should ask in **outcomes**: e.g. “work in a **browser or app
   window** (point and click)” vs “work mostly in a **terminal** (keyboard,
   text panels)”. Docs may still say TUI/GUI for maintainers; the **product
   surface** should not require vocabulary lessons first.
3. **GUI by default** — for typical consumer paths, stay in **click-to-run**
   surfaces (Wizard, web operator UI, Sonic config GUIs). A **terminal-style**
   operator UI only when the user **explicitly** chooses that style, opens it
   from an **advanced** path, or picks an intent (see **examples** below) where
   the terminal **is** the right tool.
4. **On-demand / as-needed installs** — do **not** pull optional stacks (e.g.
   Shell’s **Bubble Tea** / Go TUI graph, heavy dev toolchains) until the user
   **needs** that path. If they never open the terminal operator, **never**
   install those deps. First-run installs the **smallest** slice that matches
   intent; **extend** and **repair** add layers later.
5. **Full local offline (opt-in)** — if the user **explicitly** asks at the
   start for a **full local offline** install (air-gapped or “everything on disk
   up front”), the family may ship a **fat profile** that pre-stages documented
   bundles for that profile. That is the **exception**; default remains **lean +
   on-demand** for features they will not use. **Related:** a **household
   library host** (often **uDOS-host** / **uDOS-server**) may run **continuous
   prefetch** into **`~/.udos/library/`** and serve the **LAN** so other devices
   stay installable when the **grid is down** — see `docs/udos-host-platform-posture.md`
   § **Offline-first survival posture** (prepare **while connected**; when the
   internet is gone it is **too late** to fetch essentials).
6. **No monorepo home** — the operator chooses **checkout root(s)** and paths;
   Wizard + host materialise **`~/.udos/`** (or tier-2 macOS equivalents) per
   published layout rules.
7. **Organic stack growth** — add family repos and services **as needed**, not
   “clone everything on day one.”
8. **Sonic as return point** — **extend**, **repair**, and **reinstall** flows
   bring the operator **back to Sonic** (and Wizard for “what’s next?”).
9. **Prepare while connected** — uDOS is **offline-first** by design. **uDOS-host**
   and **Sonic** (where implemented) should support **predownloading** updates
   and requirements into the **local library** (`~/.udos/library/` and related
   surfaces) and **serving** them on the **LAN** for later installs and repairs.
   That is how we avoid **long waits** when links are good and avoid **total loss
   of capability** when they are not.
10. **Library must not starve runtime** — large installers (e.g. multi-gig OS
    images), **duplicate** versions, and unbounded caches can fill the disk until
    **nothing runs**. **Retention caps**, **dedupe**, **Sonic partition**
    separation of library vs runtime, **compost** rotation, and **spool/feeds**
    hygiene are part of **system health**, not optional polish. **Wizard** is
    the intended **global family health and resource** view; **uDOS-host** and
    **Sonic** own the **enforcement** and **paths**.

## Cold start vs already-on-Linux

| Situation | What happens first |
| --- | --- |
| **Blank machine / need USB** | Another machine (or rescue flow) uses **Sonic** + **Ventoy** to prepare media and install **Linux** — see `sonic-screwdriver/docs/` and `docs/foundation-distribution.md`. After Linux boots, the **Wizard-led** flow below is the main story. |
| **Linux (or tier-2 macOS) already running** | **Wizard** is the **first family surface** the doc recommends: onboarding, roots, requirements, Sonic install, then deeper menus. |

## Target sequence (operator journey)

The steps are **logical**; some may merge in one UI screen as implementation matures.

1. **Open Wizard** — entry shell: **intent** (media home / full host / dev /
   documents-only / repair / USB help), then goals and **what’s next**. Branching
   here avoids installing daemons and repos the user will never use.
2. **Choose root(s)** — where checkouts and family folders live (e.g. convention
   under `~/Code/`); persist choice for later steps (no hidden global “family
   repo”).
3. **Install requirements** — OS packages, runtimes, and **preflight** checks
   for the **chosen slice only** — delegated to **uDOS-host** scripts and Sonic
   hooks; Wizard shows progress and logs. Skip Bubble Tea / Shell TUI build deps
   until the user picks a terminal path or launches Shell (**unless** full
   offline profile below).
4. **Install Sonic** — `sonic-screwdriver` available on PATH or via documented
   installer; Wizard runs or links **first-run / preflight** per Sonic docs.
5. **Universal menu selector (Ventoy-style)** — a **Sonic master config** pattern:
   pick images, profiles, and install **variants** in a **GUI** (not a raw TUI
   menu unless advanced).
6. **Customise install** — profiles: host-only, dev, uHOME gaming dual-boot,
   minimal stack, **full local offline** (pre-stage bundles), etc.; output drives
   what gets cloned, enabled, cached, or flashed next.
7. **Remain in click-first surfaces** — ThinUI / Wizard / web for status and
   next actions **when that matches intent**; terminal operator UI only if the
   user chose it or opens it later (on-demand install of TUI deps then).
8. **Back to Sonic** — for **extend** (new device, new profile), **repair**
   (re-run layout, fix hooks), **reinstall** (clean slice while keeping user
   registry where safe).
9. **Grow the local uDOS stack** — add Core, host, Wizard, workspace, etc.
   **incrementally**; Wizard suggests **next repo** or **next service** from
   capability and intent, not a single megaclone.

## Intent-based profiles (examples)

Wizard (and Sonic **install profiles**) should treat these as **first-class
outcomes**, not failed shortcuts to “full server”.

### Example A — Media library and player only (uHOME pathway)

- **Signals:** User does **not** want command-centre daemons, always-on server
  features, or a full **uDOS-host** spine for their goal.
- **Path:** Wizard routes to the **uHOME** lane: household media, library, and
  player surfaces (see `uHOME-server` and related ThinUI / local-console docs).
- **Stack:** **Skip** or **defer** full host install; pull **only** what uHOME
  needs for media + playback + local network context. They can **add** host
  pieces later via Sonic/Wizard if intent changes.

### Example B — Markdown batch work only (Core + terminal operator)

- **Signals:** User wants to **process or format a bunch of Markdown** (batch
  pipeline, local scripts, contract-aware tooling) — **no** browser command
  centre, **no** media stack.
- **Path:** Wizard asks in **plain language** (“terminal-style dashboard” vs
  “browser”) and offers a **minimal profile**: **`uDOS-core`** + **`uDOS-shell`**
  when they confirm the terminal path. **Bubble Tea** and other TUI-only deps
  install **here** (or on **first launch** of Shell), not during a click-first
  media or uHOME install.
- **Stack:** **No** requirement to install Wizard HTTP surfaces, **uDOS-host**
  services, or uHOME for this intent. Click-first default does not apply because
  the user **chose** the terminal workflow in words they understand; they can add
  a GUI path later and pull deps **then**.

**Rule of thumb:** **Full uDOS-host** is one profile among several. Sonic’s
**global library** + **user device** records should eventually tag which
**profile** each machine runs so extend/repair/reinstall stays consistent with
intent.

## Sonic data model (target)

Sonic maintains a **living database** (format TBD: SQLite, JSON tree, etc.) fed by two streams:

| Stream | Role |
| --- | --- |
| **Global device library** | **Curated, read-only** (or vendor-updated) catalogue: hardware classes, known-good images, Ventoy-friendly layouts, flash procedures, capability tags. |
| **User devices** | Everything the **operator registers** (“this laptop”, “this NAS”, “this stick”): purpose, OS, dual-boot flags, installed profiles. |

**Behaviour:** Sonic **merges** global + user records to infer **what this machine can do**, what **images apply**, and whether **reflash** or **repurpose** options exist. The DB **grows over time** as the library updates and the user adds gear — it is not a one-shot config file.

## Related docs

- `docs/family-operator-organisation-map.md` — index of journey, host, health, surfaces, process
- `docs/udos-host-platform-posture.md` — uDOS-host naming, Linux/macOS, Windows scope, LAN library / offline-first survival
- `docs/foundation-distribution.md` — paths, `~/.udos/`, Sonic/Ventoy vs host boundary
- `docs/gui-system-family-contract.md` — Wizard vs host vs browser
- `uDOS-wizard/docs/` — broker and operator entry (implementation)
- `sonic-screwdriver/docs/` — USB, Ventoy, machine profiles, handoff to Ubuntu
- `uDOS-host/docs/linux-first-run-quickstart.md` — Linux host bootstrap details
