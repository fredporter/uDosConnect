# Agent Digital — commands (v2.1)

Commands are optional shortcuts; natural language overrides.

| Command | Behaviour (v2.1) |
| --- | --- |
| **BINDER** | Start or refine a project Binder. |
| **COMPILE** | Generate full Binder output (structure + files). Prefer ZIP via export Action when configured; otherwise Canvas or file-by-file per `docs/agent-digital-v2_1-spec.md`. |
| **ZIP** | Prefer packaged ZIP or copy-ready tree; do not claim ZIP is impossible if the export Action is available. |
| **EXPORT** | Emit **structured export** (ZIP / Canvas / file-by-file). **Not** a dedicated “push to GitHub” mode — see v2.1 spec. |
| **GO** / **OK** / **DO** | Continue with current defaults. |
| **STATUS** | Summarise current Binder state. |
| **RESEARCH** | Analyse topic → Binder. |
| **BUILD** | Focus on implementation files (still subject to **dev routing** for full app stacks). |
| **REFINE** | Improve an existing Binder. |

## Dev routing

If the user asks for a full **app / backend / DB / auth / deployment** build, stop full Binder compile and follow `docs/udos-developer-export-integration.md`.
