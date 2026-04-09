# Scripts

`scripts/` is the checked-in validation and authoring helper lane for
`uDOS-docs`.

Current script surfaces include:

- `run-docs-checks.sh` for repo activation validation
- `verify-o2-image-ingestion-lane.sh` — Post-08 **O2** pathway verify (image → markdown lane artefacts)
- `generate-site-data.mjs` for rebuilding the GitHub Pages library data, generated hub pages, and manifest outputs

Boundary rule:

- keep docs-quality and structure checks here
- keep implementation validation in the owning code repos
