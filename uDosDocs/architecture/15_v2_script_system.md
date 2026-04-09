# v2 Script System Specification

Version: 2.0
Status: canonical — promoted from `@dev/inbox/decisions/SCRIPT_SYSTEM_SPEC.md`

---

## Overview

uDOS scripts are executable markdown documents.

These documents can run in:

- TUI runtime (Go)
- Web/UI runtime (TypeScript)
- automated workflows

Script files use the `-script.md` suffix.

Examples:
- `startup-script.md`
- `reboot-script.md`

---

## uSCRIPT

uSCRIPT refers to executable uCode scripts written in the `-script.md` format.

### Document structure

```
script.md
│
├ frontmatter
├ markdown documentation
├ executable blocks (uCode)
└ presentation blocks (story)
```

---

## Script Frontmatter

```yaml
---
id: startup
type: script
version: 2
entry: boot
permissions:
  - read
  - draw
runtime:
  - tui
  - web
---
```

| Field | Description |
|---|---|
| `id` | Unique script identifier |
| `type` | Always `script` for executable documents |
| `version` | Script contract version |
| `entry` | Entry point label or block id |
| `permissions` | Declared capabilities required at runtime |
| `runtime` | Target runtime surfaces — `tui`, `web`, or both |

---

## Markdown Body

Human-readable explanation of the script purpose and behavior.

```markdown
# Startup

Initializes system state and renders boot banner.
```

---

## uCode Blocks

Executable commands using the uCode verb pattern.

~~~markdown
```ucode
SET system.status startup
SET system.last_startup $now

DRAW BLOCK assets/ucodesmile-ascii.md
DRAW PAT TEXT "Startup ready"
```
~~~

Commands follow the verb pattern:

```
SET variable value
STATUS
WORKFLOW RUN onboarding
DRAW BLOCK assets/example.md
```

Avoid language-style variable assignment — uCode is a deterministic command DSL, not a scripting language.

---

## Story Blocks

Story blocks define UI workflows and interactive experiences.

~~~markdown
```story
id: setup_udos_root
type: input
input: text
required: true
validation: path
label: Configure repository root
```
~~~

The Go runtime loads the document. The TypeScript UI renders the interactive experience and binds outputs.

---

## Asset Files

Assets are reusable renderable components.

```markdown
---
type: asset
format: ascii
name: ucodesmile
---

████████████████████
██                ██
██   uDOS Smile   ██
██                ██
████████████████████
```

Referenced via:

```
DRAW BLOCK assets/ucodesmile-ascii.md
```

---

## Script Execution

### TUI (Go runtime)

```
RUN startup-script.md
```

or

```
SCRIPT RUN startup
```

**Execution flow:**

1. Go parses frontmatter and declares permissions
2. Markdown body scanned for executable blocks
3. uCode blocks executed via the dispatcher
4. Results rendered in TUI

### Web / UI (TypeScript runtime)

TypeScript runtime:

- loads markdown
- renders story blocks
- binds outputs to UI components
- animates scenes and transitions

---

## Repository Layout

Recommended structure within any repo:

```
memory/
  scripts/
    system/
      reboot-script.md
      startup-script.md
  workflows/
    onboarding-script.md

assets/
  ascii/
    ucodesmile-ascii.md

stories/
  setup/
    wizard-setup-story.md
```

---

## Ownership and Boundary Rules

| Concern | Owner |
|---|---|
| Script parsing and frontmatter validation | `uDOS-core` |
| uCode block dispatch and execution | `uDOS-core` (Go runtime) |
| Story block rendering | `uDOS-wizard` (UI layer), `uDOS-themes` (presentation) |
| Script authoring conventions | any repo — follow shared format |
| Web runtime script loading | TypeScript/Wizard surface |

---

## Related Documents

- [04_command_language.md](04_command_language.md) — uCode verb reference and command language model
- [14_v2_language_runtime_spec.md](14_v2_language_runtime_spec.md) — language and runtime layer definitions
- [13_v2_workflow_automation_runtime_split.md](13_v2_workflow_automation_runtime_split.md) — runtime authority split across repos
