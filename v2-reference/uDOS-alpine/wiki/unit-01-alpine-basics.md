# Unit 01: Alpine Basics

## What This Module Is

`uDOS-alpine` is the lightweight Alpine runtime companion for the uDOS family.

## What You Should Learn

By the end of this unit you should be able to:

- explain what Alpine owns
- run the repo checks
- describe the difference between Alpine and Ubuntu in the family
- identify the ThinUI boundary

## Practical How-To

1. Read the runtime profile.
2. Run the repo checks.
3. Review the smallest build example.

```bash
cat docs/alpine-runtime-profile.md
bash scripts/run-alpine-checks.sh
cat examples/basic-alpine-build.md
```

## Editable Demo

Review the ThinUI handoff payload and launch path:

```bash
cat profiles/thinui-c64-launch.json
bash scripts/demo-thinui-launch.sh
```

## Quick Check

You pass this unit if you can answer:

- What does Alpine own?
- Which command validates the repo?
- When should work move to Ubuntu instead?
