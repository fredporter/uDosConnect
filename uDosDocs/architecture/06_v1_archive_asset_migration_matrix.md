# v1 Archive Asset Migration Matrix

Purpose:

- assess reusable non-concept assets from `uDOS-v1-8-archived`
- break the archive into focus targets for multiple migration passes
- map reusable material into the current v2 family without recreating the v1 monorepo

## Assessment Method

Use four buckets:

- `reuse directly`
- `rewrite for v2`
- `extract as seed/template`
- `archive only`

Prefer extracting patterns, templates, lessons, and runbooks before extracting
runtime code.

## Focus Targets

### Target 1. Archived course ladder

Primary roots:

- `uDOS-v1-8-archived/courses/`
- `uDOS-v1-8-archived/wiki/Education-Pathways.md`

Current value:

- strongest reusable education structure in the archive
- already organized into lessons, exercises, checkpoints, projects, and resources
- aligns with the current family idea of use, learn, and build

Assessment:

- `rewrite for v2` as the default
- `extract as seed/template` for course structure files

Promote toward:

- `uDOS-docs` for family-level pathway language
- `uHOME-server/courses/` for local-network and Beacon Activate teaching
- `uDOS-empire` docs and course references for webhook/API automation teaching

Notes:

- the course structure itself is more valuable than the old repo path references
- Course 03 and Course 05 are especially relevant to webhook automation and the family model

Sample sources:

- `courses/03-api-and-automation/lessons/02-scheduler-jobs-and-webhooks.md`
- `courses/05-personal-infrastructure/lessons/01-pathway-family-and-self-hosting.md`

### Target 2. Archived wiki orientation pages

Primary roots:

- `uDOS-v1-8-archived/wiki/`

Current value:

- strong orientation writing
- useful public-facing explanations of binders, publishing, pathways, seed data, and onboarding

Assessment:

- `rewrite for v2` for most pages
- `extract as seed/template` for page structure and section ordering

Promote toward:

- `uDOS-docs` for family-level explanatory material
- repo-local `docs/` only when ownership is specific

Notes:

- the best wiki pages explain concepts clearly without overspecifying implementation
- binder/publishing, education pathways, and seed/template pages are especially reusable

Sample sources:

- `wiki/Binders-and-Publishing.md`
- `wiki/Education-Pathways.md`
- `wiki/Seed-Data-and-Templates.md`

### Target 3. Empire templates and operator scaffolds

Primary roots:

- `uDOS-v1-8-archived/modules/empire/templates/`
- `uDOS-v1-8-archived/modules/empire/docs/`
- `uDOS-v1-8-archived/modules/empire/scripts/`

Current value:

- useful webhook templates
- strong operator/runbook checklist material
- practical preflight and smoke-test shapes

Assessment:

- `extract as seed/template` for templates
- `rewrite for v2` for operator docs and smoke/preflight scripts
- `archive only` for v1-private secrets, local databases, and path-coupled setup scripts

Promote toward:

- `uDOS-empire/src/webhooks/` for provider and webhook templates
- `uDOS-empire/docs/` for operator runbooks
- `uDOS-empire/scripts/` later, once real runtime contracts exist

Notes:

- template and runbook patterns are better candidates than the old internal module layout
- preflight checks are worth reusing conceptually once v2 config loading exists

Sample sources:

- `modules/empire/templates/webhooks/hubspot-contact-master.md`
- `modules/empire/scripts/smoke/integration_preflight.py`
- `modules/empire/docs/empire-operator-guide.md`

### Target 4. Wizard networking, Beacon, and publish scaffolds

Primary roots:

- `uDOS-v1-8-archived/wizard/docs/`
- `uDOS-v1-8-archived/wizard/mcp/`
- `uDOS-v1-8-archived/wizard/tools/`
- selected `uDOS-v1-8-archived/wizard/tests/`

Current value:

- useful Beacon/networking explanations
- examples of route and test organization
- potential tooling patterns for MCP, secret handling, and route-level smoke checks

Assessment:

- `rewrite for v2` for Beacon/networking docs
- `extract as seed/template` for test shapes and route/tool organization
- `archive only` for large v1-specific route surfaces and built frontend artifacts

Promote toward:

- `uDOS-docs/wizard/` for family wording
- `uDOS-wizard` for active networking and provider docs
- `uHOME-server` docs where local client-facing behavior is the subject

Notes:

- treat built assets and sprawling route inventories as archive-only unless a live v2 owner asks for them
- preserve the shared-module idea where one renderer or IO surface may serve multiple contracts

Sample sources:

- `wizard/docs/BEACON-IMPLEMENTATION.md`
- `wizard/tests/publish_flow_test.py`
- `wizard/mcp/README.md`

### Target 5. Seed data, templates, and tracked examples

Primary roots:

- wiki and docs pages describing seed/template usage
- template and example folders across the archive

Current value:

- high leverage for v2 scaffolding
- useful for education, examples, and inspectable defaults

Assessment:

- `extract as seed/template`

Promote toward:

- `uDOS-docs/examples/`
- repo-local `examples/` and `config/`
- future shared seed/template lane if the family standardizes one

Notes:

- templates often survive architecture shifts better than scripts
- tracked examples should stay small, inspectable, and clearly owned

Sample source:

- `wiki/Seed-Data-and-Templates.md`

## Low-Priority Or Archive-Only Areas

Keep these low priority unless a specific v2 owner asks for them:

- built frontend bundles under `wizard/dist/` or `wizard/dashboard/dist/`
- local databases and backups under `modules/empire/data/`
- secrets, tokens, and local credential examples tied to private old flows
- broad v1 route/test inventories without a current v2 feature owner
- v1-specific TUI or Vibe internals unrelated to active family direction

## Recommended Pass Order

1. course and wiki content
2. Empire templates and operator docs
3. Beacon/networking docs and route/test shapes
4. seed/example extraction
5. only then evaluate code scripts for direct reuse

The code-level follow-on audit now lives in
`architecture/09_v1_code_helper_reuse_audit.md`.

## Practical Rule For Fresh v2 Work

Do not ask:

- "How do we move this old folder?"

Ask:

- "Which current v2 repo owns this function now?"
- "Is the reusable value in the code, the template, the runbook, or the explanation?"
- "Can we preserve the good idea with a smaller and cleaner v2 artifact?"

## Immediate Next Passes

### Pass A

Promote archived course/wiki wording into active `uDOS-docs` family pathway docs.

### Pass B

Promote archived Empire webhook templates and operator runbook ideas into
`uDOS-empire`.

### Pass C

Promote Beacon/networking and offline library wording into `uDOS-docs`,
`uDOS-wizard`, and `uHOME-server` using the new `Beacon Activate` language.

### Pass D

Rewrite archived smoke and preflight script shapes into v2-safe scaffolds under
the repos that now own those contracts.
