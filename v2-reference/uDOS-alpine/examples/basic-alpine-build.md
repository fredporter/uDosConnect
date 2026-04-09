# Basic Alpine Build

This is the smallest v2-local walkthrough for validating `uDOS-alpine` as an
Alpine packaging and profile surface.

## Validate The Repo

```bash
scripts/run-alpine-checks.sh
```

## Run The Current Build Helper

```bash
scripts/build-apk.sh
```

Expected outcome:

- the Alpine profile surface remains lightweight and explicit
- a staged package-root tarball is written under `distribution/packages/`
- packaging ownership stays in `uDOS-alpine`
- broader deployment bootstrap remains in `sonic-screwdriver`
