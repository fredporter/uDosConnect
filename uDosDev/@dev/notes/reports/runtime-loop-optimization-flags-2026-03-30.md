# Runtime loop / control-flow audit — optimisation flags

- **Roadmap:** recorded under `@dev/notes/roadmap/v2-family-roadmap.md` § Engineering backlog (continuous).
- Scope: **`uDOS-ubuntu/scripts`** (host runtime glue), **`uDOS-core/scripts`** (contract enforcement), light touch on **`udos-commandd`** Python snippets.
- Purpose: call out patterns that are **correct but heavier than needed**, or **repeat work** in tight paths, for a future cleanup round.

## High value (worth scheduling)

| Location | What | Why flag | Suggested direction |
| --- | --- | --- | --- |
| `uDOS-ubuntu/scripts/udos-commandd.sh` | Many separate `python3 … <<'PY'` blocks | Each subcommand **cold-starts Python** and re-reads JSON from disk | One **`python3 -m udos_commandd`** (or `scripts/commandd.py`) with subcommands (`list-operations`, `surface-summary`, `policy-summary`, `ensure-op`) so imports and file reads happen once per invocation |
| `uDOS-ubuntu/scripts/udos-commandd.sh` | `policy_field` + `repo.push` | **Up to three** Python processes to read the same policy JSON for one operation | Single Python helper returning `{mode, reason, approval_env}` or parse once in the future unified commandd CLI |
| `uDOS-core/scripts/run-contract-enforcement.sh` | `implementation_targets` vs `dependency_targets` | **Duplicated `for candidate in …` loops** (two nearly identical directory lists + two manifest lists) | ~~One `_collect_repo_targets` helper~~ **Done (2026-03-30)** |

## Medium value (micro-optimisations / clarity)

| Location | What | Why flag | Suggested direction |
| --- | --- | --- | --- |
| `uDOS-ubuntu/scripts/lib/runtime-layout.sh` | `while read; mkdir -p` over lines | Works; **N forked mkdirs** vs one batch | ~~`ud_os_runtime_roots \| xargs mkdir -p`~~ **Done (2026-03-30)** |
| `uDOS-ubuntu/scripts/run-ubuntu-checks.sh` | Large inline Python block | Not a loop issue, but **long single heredoc** is hard to diff and extend | Move to `scripts/check_ubuntu_contracts.py` + `pytest` or `python3 -m` for the JSON assertions only |
| `uDOS-ubuntu/scripts/udos-gitd.sh` | `while read` over TSV in `cmd_repo_list` | Linear in repo count — **fine** for expected scale | If registry grows large: consider `column -t` / `awk` one-shot for machine output, or keep as-is until profiling says otherwise |
| `uDOS-ubuntu/scripts/udos-gitd.sh` | `registry_has_repo` / `registry_get_path` via **awk per call** | OK for small TSV | If hot: migrate to JSON registry (already planned in handover notes) or single awk pass |

## Low value / acceptable as-is

| Location | What | Note |
| --- | --- | --- |
| `uDOS-ubuntu/scripts/serve-command-centre-demo.sh` | No loops | **v2 contract** single bind/port — good |
| `uDOS-ubuntu/scripts/lane1-runtime-proof-tui.sh` | Sequential `bash` to three repos | Intentional **orchestration**, not a hot loop |
| `uDOS-ubuntu/scripts/udos-commandd.sh` | `for item in ops` inside Python heredocs | Normal iteration over registry rows — **O(n)** once per call |

## Already removed (historical)

- **`serve-command-centre-demo.sh`** previously had **multi-port scan + self-test retries** — replaced by **v2 `UDOS_WEB_*` single port** + `contracts/udos-web/command-centre-static-demo.v1.json`.

## v1 / compost snapshot allowlist (2026-03-30)

Executed removals (local organic heaps and **tracked** doc snapshots only; **no** `uDOS-docs` knowledge bank or external `*-v1-archived` repos):

- **`uDOS-family/.compost/`** — deleted (parent workspace snapshot tree; not versioned).
- **`uDOS-ubuntu/docs/.compost/`** — removed from git + disk; **`docs/.compost/`** added to `.gitignore`.
- **`uDOS-dev/docs/.compost/`** — removed from git + disk; **`docs/.compost/`** added to `.gitignore`.
- **`uHOME-server/docs/.compost/`** — deleted on disk; **`docs/.compost/`** added to `.gitignore` (was untracked).

Inbound links that pointed at compost copies were retargeted to **`uDOS-ubuntu/docs/architecture.md`**, **`config-layout.md`**, and **`systemd-unit-plan.md`**.

## Suggested order of work

1. ~~**Batch mkdir** in `runtime-layout.sh` (tiny, safe).~~ **Done** (`xargs mkdir -p`).
2. **Unify commandd Python** into one entrypoint (largest win for repeated CLI use).
3. ~~**Deduplicate** `run-contract-enforcement.sh` target lists.~~ **Done** (`_collect_repo_targets`).
4. **Extract** `run-ubuntu-checks` Python when that file next grows.
