# Unit 01: Deer Flow Basics

## What This Module Is

`uDOS-plugin-deerflow` is the optional Deer Flow execution adapter for graph
and long-horizon workflow lanes.

## What You Should Learn

By the end of this unit you should be able to:

- explain what the plugin owns
- describe the adapter boundary
- run the repo checks
- explain why the graph is not the source of truth

## Practical How-To

1. Bootstrap the repo.
2. Validate translation.
3. Run the staged checks.

```bash
make bootstrap
make validate
bash scripts/run-deerflow-checks.sh
```

## Editable Demo

Run the example path:

```bash
make run-example
```

## Quick Check

You pass this unit if you can answer:

- What remains canonical in uDOS?
- What does Deer Flow do?
- Why is upstream clone preferred over a long-lived fork?
