# General Knowledge Library

## Names

This collection is referred to as:

- **General Knowledge Library** (preferred public name)
- **General Knowledge Bank** (informal)
- **Central Knowledge Library** (v1 and informal usage)

Treat the names as synonyms in docs; prefer “General Knowledge Library” in new
public text.

## Purpose

A **survival-guide style** set of articles: cross-cutting, practical reference
that stays **grounded** (real projects, real standards), not abstract theory
alone.

It anchors questions such as:

- How deep should a topic go for a given task?
- What research rigor or evidence is expected?
- Which **comparable projects** are high-standard examples to emulate?

## Boundary Of uDOS Knowledge

The library is not only themed survival, how-to, and lifestyle material. It also
**defines what counts as in-family knowledge**: the outer edge of what uDOS
should recommend when answering “how do I…?” including with code.

**In scope:** guide the user along paths the family already supports — for
example a **uCode journey**, **compatible devices** and surfaces, binders,
shell, Wizard, and documented family contracts. Answers should stay inside what
can be achieved **without inventing a parallel product** or one-off stack
outside the family.

**Out of scope for default guidance:** suggesting unrelated frameworks, greenfield
repos, or “build something else” flows that imply **new development** outside
uDOS’s model. If something truly is missing, the honest response is a **family
gap** (issue, binder, roadmap), not a detour into an incompatible ecosystem.

This boundary keeps assistants, docs, and bundled sanity checks **aligned with
real uDOS**, not generic coding advice.

Articles in `docs/knowledge/` should make these expectations explicit where they
touch automation, code, or devices.

### Example: what to do with an old PC?

A **within-family** answer stays on the uDOS spine: use **Sonic** (or the
documented install lane), put **uDOS Ubuntu** on the machine as the command-centre
host, learn and write **uCode** for scripted behaviour, and use **Home
Assistant** (and the **uHOME** / Matter surfaces) where home automation fits the
documented stack — not a shopping list of unrelated distros, hypervisors, or DIY
platforms as the default “first try.”

**Out of family** for default guidance: recommending a random Linux image, a
generic homelab stack, or a greenfield project with no tie-in to Sonic, Ubuntu,
Shell, Wizard, or uHOME contracts. If a gap exists (e.g. hardware not yet
supported), say so and route to family tracking instead of inventing a parallel
path.

## Canonical Location

- **Source of truth:** `docs/knowledge/` in `uDOS-docs` (markdown articles,
  indexed from `docs/knowledge/README.md`). Drop new articles into this folder.
- **Public entry:** `docs/general-knowledge-library.md` (short overview and
  links).
- **GitHub Pages:** same content is published with the rest of `uDOS-docs` site
  generation; the library is part of the public family index, not a private lane.

## Read-only vs Living Document

| Layer | Role |
| --- | --- |
| **Published / bundled** | A **snapshot** of the library: read-only for operators and for sanity checks bundled with Core/docs tooling and offline seeds. Keeps expectations “real” against drift. |
| **Repository** | **Living:** improvements arrive via normal PRs (wiki-style: fix, extend, add articles). |

The bundled copy is **not** edited at runtime; updates ship with the next
release or doc refresh.

## Relationship To Other Lanes

- **`docs/`** — stable family reference; GKL articles may link here for
  architecture and policy.
- **`wiki/`** — short units and quick how-tos; GKL is **longer-form** and
  comparative (depth, research bar, exemplars).
- **`seed/`** — installers may copy a **subset** of `docs/knowledge/` into a
  local read-only bundle for offline fallback; see `seed/README.md`.

## What Belongs Here

- Boundary and scope articles: what uDOS may recommend vs what is a gap or
  out-of-family suggestion.
- Survival and orientation articles (scope, depth, “what good looks like”).
- Curated **reference projects** and emulation targets (with attribution).
- Research and citation standards for family work.
- Cross-topic material that does not fit a single component repo.

## What Does Not Belong Here

- Implementation-only detail that belongs in `uDOS-core` or another repo.
- Secrets, credentials, or machine-local state.
- Unbounded dumps; keep articles small and maintainable (same spirit as
  `architecture/08_seed_and_template_policy.md`).
