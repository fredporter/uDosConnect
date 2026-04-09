# Publish Adapter

Maps themes into publishing output for docs, local web publishing, and
email-safe rendering.

Implemented surface:

- `index.mjs` renders Tailwind Prose HTML output plus an email-safe fallback.
- `tailwind-prose-preset.json` is the shared machine-readable class contract
  (`classes.article`) for workspace/static publish consumers.
