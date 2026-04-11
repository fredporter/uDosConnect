> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.17** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-workflow

`uDOS-workflow` is the workflow-execution repo for the uDOS family.

It is intended to hold workflow-facing contracts, execution surfaces, and
runtime adapters that should not live inside `uDOS-core`, `uDOS-wizard`, or a
single product repo.

Current initialization status:

- repo initialized
- remote GitHub repository created
- activation scaffold in place for follow-on workflow rounds

## Installation and activation (scaffold)

This repo is **not** a standalone runnable product yet. There is no primary TUI/GUI binary; treat it as **contracts + docs + future adapters**.

- **Python:** root **`requirements.txt`** is intentionally empty except for a comment — use sibling repos’ virtualenvs until workflow code ships (`uDOS-dev` **`docs/pr-checklist.md`**).
- **Completion context (archived workspace):** **`uDOS-dev/workspaces/archive/v2/completion-round-03-tui.code-workspace`** includes this repo alongside **`uDOS-shell`**, **`uDOS-grid`**, and **`uDOS-core`**.
