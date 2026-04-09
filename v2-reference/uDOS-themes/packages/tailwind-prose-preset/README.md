# udos-tailwind-prose-preset

Machine-readable Tailwind prose class contract for publish surfaces.

## Canonical source

The authoritative JSON lives at **`../../src/adapters/publish/tailwind-prose-preset.json`** in this repo. This package copy is refreshed with:

```bash
bash scripts/sync-publish-prose-preset-to-package.sh
```

Run from the `uDOS-themes` repo root (or via a family checkout with `uDOS-themes` as the current directory).

## Consume from another repo

With sibling checkouts under a family root:

```bash
npm install file:../uDOS-themes/packages/tailwind-prose-preset
```

Then import the JSON from `udos-tailwind-prose-preset` (Node `"exports"` resolves to `tailwind-prose-preset.json`).

## Related

- `uDOS-themes/docs/integration-thinui-workflow-prose-gtx.md`
- `uDOS-workspace/apps/web/src/lib/theme/README.md` (browser mirror via `sync-publish-prose-preset-to-workspace.sh`)
