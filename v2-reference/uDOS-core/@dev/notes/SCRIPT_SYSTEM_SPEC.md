
# uDOS v2 Script System Specification
Version: 2.0

## Overview

uDOS scripts are executable markdown documents.

These documents can run in:

- TUI runtime (Go)
- Web/UI runtime (TypeScript)
- automated workflows

Script files use the `-script.md` suffix.

Example:

startup-script.md
reboot-script.md

---

## uSCRIPT

uSCRIPT refers to executable uCode scripts written in the `-script.md` format.

Structure:

script.md
│
├ frontmatter
├ markdown documentation
├ executable blocks
└ presentation blocks

---

## Script Frontmatter

```
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

---

## Markdown Body

Human readable explanation of the script.

Example:

```
# Startup

Initializes system state and renders boot banner.
```

---

## uCode Blocks

Executable commands.

```
```ucode
SET system.status startup
SET system.last_startup $now

DRAW BLOCK assets/ucodesmile-ascii.md
DRAW PAT TEXT "Startup ready"
```
```

Commands should follow the verb pattern:

```
SET variable value
STATUS
WORKFLOW RUN onboarding
```

Avoid language-style variable assignment.

---

## Story Blocks

Story blocks define UI workflows.

Example:

```
```story
id: setup_udos_root
type: input
input: text
required: true
validation: path
label: Configure repository root
```
```

The Go runtime loads the document, while the TypeScript UI renders the interactive experience.

---

## Asset Files

Assets are reusable renderable components.

Example ASCII asset:

```
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

### TUI

```
RUN startup-script.md
```

or

```
SCRIPT RUN startup
```

Execution flow:

1. Go parses frontmatter
2. markdown scanned
3. uCode blocks executed
4. results rendered

---

### Web / UI

TypeScript runtime:

- loads markdown
- renders story blocks
- binds outputs to UI
- animates scenes

---

## Repository Layout

Recommended structure:

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

---

## Summary

Executable markdown enables:

- portable automation
- documentation + execution
- UI workflows
- teaching and onboarding

uDOS scripts become **living operational documents**.
