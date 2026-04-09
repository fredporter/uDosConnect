# Security and Trust Boundaries

## Why this matters

Deer Flow is designed as a powerful agent runtime with sandboxed execution, filesystem access, memory, skills, tool integration, and sub-agent orchestration. That is useful, but it also means uDOS must integrate it as a controlled execution surface, not as a free-ranging authority.

## Security posture

### uDOS owns policy
- execution approval rules
- allowed workflow classes
- path restrictions
- artifact promotion rules
- trust-class boundaries
- MCP provider routing policy

### Deer Flow receives delegated execution
- only after translation
- only with an approved runtime profile
- only with bounded inputs
- only with auditable output capture

## Default deny rules

The adapter should default to deny for:

- unrestricted filesystem writes outside a staged workdir
- direct promotion into canonical vault paths
- hidden network egress where not explicitly allowed
- arbitrary model or tool selection outside configured policy
- persistent memory writes that bypass uDOS normalization
- execution against unapproved upstream versions

## Working directory model

Use a staged runtime directory:

```text
runtime/
  deerflow/
    sessions/
      <execution-id>/
        input/
        work/
        output/
        logs/
```

Deer Flow may operate inside `work/` and write provisional artifacts to `output/`.

Promotion into binder or vault paths happens only after normalization and policy checks.

## Memory model

Deer Flow memory is runtime-local and disposable by default.
uDOS memory and vault remain canonical.

If memory import/export is later allowed, it must be:

- explicit
- auditable
- scope-bound
- reversible where possible

## Network policy

Profiles:

- `offline`: no egress
- `limited`: approved endpoints only
- `online`: explicit admin or wizard approval required

## Skills policy

Skills discovered upstream are not automatically trusted in uDOS.

They must be:
- disabled by default unless mapped
- classified by trust level
- optionally wrapped by uDOS capability metadata

## Incident handling

Every failed or denied execution should emit:

- execution id
- upstream version pin
- policy profile
- denied operation summary
- normalized error shape
