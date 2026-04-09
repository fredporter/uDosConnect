# uDOS GPT Export Helper — Repo Ready Pack

This pack scaffolds the first deterministic export bridge for GPT-powered uDOS tools.

It includes:
- `uDOS-gpthelper/` — GPT bridge specs, action schemas, prompt patches, examples
- `uDOS-host/` — lightweight Node export service intended to run on the local host layer
- updated dev brief
- ngrok notes
- systemd service example

## Purpose

Allow GPTs such as:
- Agent Digital
- future uDOS Developer

to export real downloadable ZIP files by calling a small helper service.

## Repo Intent

This is a narrow helper feature:
- deterministic file export
- small webhook/action bridge
- hosted locally on `uDOS-host`
- future-friendly toward MCP-linked local tooling

It is not:
- a full auth platform
- a SaaS dashboard
- a cloud editor
- a full runtime replacement
