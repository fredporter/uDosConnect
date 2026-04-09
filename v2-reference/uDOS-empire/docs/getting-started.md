# uDOS-empire Getting Started

Use this order:

1. Read `docs/README.md`.
2. Read `README.md` for the short repo definition.
3. Read `docs/boundary.md` before changing ownership or adding adapters.
4. Read `docs/architecture.md` for the current layer split.
5. Read `docs/wordpress-plugin-architecture.md` for the plugin direction.
6. Read `docs/wordpress-plugin-data-model.md` for the local CRM model.
7. Follow `docs/quickstart.md` for the shortest practical path.
8. Run `bash scripts/run-empire-checks.sh`.

Then move into the lane that matches the work:

- WordPress plugin architecture: `docs/wordpress-plugin-architecture.md`
- contacts and CRM: `docs/wordpress-plugin-data-model.md` and
  `docs/contact-and-crm-model.md`
- WordPress-centred email or publish flows: `docs/publishing.md`
- legacy migration context: `docs/architecture.md` and `src/README.md`

Put runnable demonstrations in `examples/` and add regression coverage for any
workflow contract you change.
