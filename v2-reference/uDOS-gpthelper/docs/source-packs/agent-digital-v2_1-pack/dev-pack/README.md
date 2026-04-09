# Agent Digital v2.1 — Dev Pack
This pack defines the updated architecture for Agent Digital.
## Core Decisions
- Universal export mode only (ZIP, Canvas, file-by-file)
- Optional local helper mode via uDOS-gpthelper
- No GitHub export mode
- Dev tasks are routed to uDOS Developer GPT
## Key Features
- File-by-file export fallback (one file per reply)
- Suggest + override intake flow
- Dev routing system
- Binder-first output structure
## Outcome
Agent Digital is now:
- predictable
- structured
- focused on outputs (not code execution)
