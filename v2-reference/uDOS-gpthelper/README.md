> **Archive (uDos v2/v3)**  
> This is a conceptual uDos v2/v3 project which has been archived for posterity.
>
> **Scheduled extension track:** **4.1.5** (uDos **4.1.0** line; numbers may be reprioritized in [`uDosDev/TASKS.md`](../uDosDev/TASKS.md)).
>
> **When to reintegrate:** after `uDosGo` is locked for **v4.0**, when a Task Forge item for this module is scheduled in `uDosDev` (see [dev-process-v4.md](../uDosDev/docs/dev-process-v4.md)).
>
> **How:** rebuild against the current `uDosGo` contracts and tests; publish as a **submodule under `uDosConnect`** (not merged into `uDosGo`). Extension releases are numbered **4.1.1+** in order of landing.
>
> ---

# uDOS-gpthelper

GPT bridge and helper specs for uDOS-connected custom GPTs (**Agent Digital**, **uDOS Developer**, etc.), aligned with **Agent Digital v2.1** (see `docs/agent-digital-v2_1-spec.md`).

## Owns

- OpenAPI action schemas (`actions/`)
- GPT integration and export docs (`docs/`)
- Export payload examples (`examples/`)
- Prompt patches (`prompts/patches/`) — paste into GPT Builder

## v2.1 highlights

- **Export priority:** ZIP → Canvas → file-by-file → single doc (non-code only); **no** dedicated GitHub-export mode.
- **Optional local ZIP:** `uDOS-host` `services/gpt-export-helper` + `actions/export-openapi.json`.
- **Local alias helper:** `docs/local-helper.md` (no raw paths from the model; alias names only).
- **Dev routing:** heavy code/app work → uDOS Developer (`docs/udos-developer-export-integration.md`).

## Validation

```bash
bash scripts/run-gpthelper-checks.sh
```
