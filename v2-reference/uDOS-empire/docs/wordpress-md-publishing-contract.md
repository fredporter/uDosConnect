# WordPress-md publishing contract

## Purpose

Define the internal markdown-to-WordPress publishing lane for `uDOS-empire` on a
single-host Ubuntu runtime.

## Contract

- **Input:** markdown document with frontmatter-like metadata fields used by
  Empire packs (`title`, `slug`, `audience`, `tags`).
- **Transform:** deterministic conversion to WordPress post payload with:
  - `post_title`
  - `post_name` (slug)
  - `post_content` (markdown-preserving content lane)
  - `meta_input` including Empire audit fields
- **Persistence:** publish payload and run metadata are written to local runtime
  state before any remote mutation path.
- **Audit:** every publish attempt records:
  - `publish_id`
  - source path / source hash
  - target surface (`wordpress`)
  - timestamp
  - result (`dry-run`, `queued`, `applied`, `failed`)

## Modes

- **Dry-run (default in checks):** build payload, persist audit, no remote
  mutation.
- **Apply (operator mode):** allowed only under approved runtime policy on
  Ubuntu host.

## Validation

Run:

```bash
python3 scripts/smoke/wordpress_md_publish_smoke.py --json
```

Expected: schema id, deterministic slug, and audit fields are present.
