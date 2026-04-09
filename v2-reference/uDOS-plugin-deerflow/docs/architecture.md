# Architecture

## Position

Deer Flow is not the source of truth in uDOS.

uDOS owns the authoring and truth layers:

- binder identity
- workflow definitions
- compile semantics
- human-readable vault artifacts
- release and publish routing
- policy and conformance rules

Deer Flow owns only the delegated execution lane when selected.

## Adapter model

```text
uDOS-core
  workflow/
    engine/
      native/
      deerflow-adapter/
```

This repo implements the `deerflow-adapter/` lane.

## Execution flow

1. User or automation advances a `#binder`.
2. uDOS compiles binder material into canonical workflow form.
3. Adapter translates canonical workflow JSON into a Deer Flow runnable graph spec.
4. Adapter invokes Deer Flow against a pinned upstream clone.
5. Deer Flow returns runtime state, events, artifacts, and errors.
6. Adapter normalizes the result into uDOS execution-result format.
7. uDOS decides what is persisted, promoted, published, or discarded.

## Important boundary

The graph is **not** the source of truth.

The binder and compiled workflow remain canonical.
Any Deer Flow graph is a generated execution artifact.

## Main components

### 1. Translator
Converts uDOS workflow shape into a Deer Flow execution graph.

Responsibilities:
- step to node mapping
- dependency edge mapping
- tool capability mapping
- execution metadata injection
- trust class gating
- filesystem and artifact lane restrictions

### 2. Executor
Invokes Deer Flow in a controlled way.

Responsibilities:
- select pinned upstream clone
- stage working directory
- pass runtime config
- capture logs and outputs
- enforce timeout and policy boundaries
- return normalized result

### 3. Result normalizer
Converts Deer Flow runtime outputs into stable uDOS artifacts.

Responsibilities:
- summarize node outcomes
- map artifacts to uDOS paths
- mark transient vs promoted outputs
- expose audit metadata
- surface errors and policy denials

### 4. Validator
Checks translation and execution results against uDOS schemas.

Responsibilities:
- schema validation
- policy field presence
- deterministic key checks
- commit/tag pin verification
- compatibility matrix checks

## Runtime lanes

### Lane A: native uDOS engine

Default, stable, simpler workflows.

### Lane B: Deer Flow adapter

Optional, heavier, graph-oriented, long-horizon workflows.

## Trust classes

### Certified
Allowed for supported bounded workflows after conformance.

### Community
Allowed only in sandboxed and explicitly enabled environments.

### Local wrapped
Educational or experimental use only. No automatic promotion to certified.

## Storage rules

Persist only normalized output back into the vault:

- summaries
- chosen artifacts
- execution metadata
- references to upstream version pin

Avoid persisting raw internal runtime noise unless explicitly requested for debugging.

## Future direction

A later visual builder may generate uDOS workflow JSON and preview Deer Flow
graphs, but that should still compile back into canonical uDOS workflow
artifacts first.
