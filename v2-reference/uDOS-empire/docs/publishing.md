# uDOS-empire Publishing

## Role

Publishing is a first-class Empire lane, not a side effect of CRM sync.

Empire should support reusable publishing operations such as:

- website or page publish jobs
- static campaign pages
- landing page packs
- CMS or WordPress adapters
- form and widget wiring
- asset formatting
- launch-pack assembly

## Channel Direction

Empire should be channel-aware without turning into separate mini-products.

Initial channels:

- email
- WordPress web publishing
- static campaign pages
- forms and account widgets
- exports and reports

Later channels:

- optional remote CRM adapters
- social publishing helpers
- event communications
- SMS or WhatsApp style adapters
- headless content syndication

## Execution Expectations

Publishing flows should support:

- preview before change
- dry-run before write
- approval gates
- test publish or test send where relevant
- logs and outputs
- rollback notes where rollback is possible

## Repo Direction

The current refactor should make publishing visibly WordPress-centred first,
with starter packs, templates, and examples that assume local hosting on
`uDOS-host` before optional remote adapters are layered back in.
