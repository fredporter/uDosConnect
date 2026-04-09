# @dev Tag Recipe

## Purpose

Use small `@dev` tags to peg runtime behavior that should remain deliberately
version-locked until a later update round.

## When To Add A Tag

Add an `@dev` tag when:

- a local clone should stay pinned to checked-in knowledge
- a fallback path needs a future update hook
- a behavior should be easy to find in logs, envelopes, and docs

## Preferred Shape

- `@dev/local-gpt4all-update`
- `@dev/ucode-cli-fallback`
- `@dev/family-env-contract`
- `@dev/wizard-secret-store`

## Recipe

1. Add the tag to the runtime envelope.
2. Add the tag to session or routing history when practical.
3. Add a short doc note if the tag marks a user-visible behavior.
4. Keep the tag stable until the next intentional update pass.

## Dev Mode Status

When useful, pair each `@dev` tag with a small Dev Mode status.

Preferred statuses:

- `active`
- `stable`
- `version-locked`
- `queued`
- `blocked`
- `superseded`

Recommended form:

- `@dev/local-gpt4all-update`
  status: `version-locked`
- `@dev/ucode-cli-fallback`
  status: `active`

Use Dev Mode status when:

- a roadmap micro-round is underway
- a runtime lane is intentionally pinned
- a future update peg should be visible without opening a full request
- a tagged behavior is blocked or superseded

## Family Alignment

Pair `@dev` tags with the active family plan and the owning repo's local
semantic version.

Example:

- active family plan: `v2.3`
- local repo version: `2.3.1`
- tags: `@dev/ucode-cli-fallback`, `@dev/local-gpt4all-update`

Family integration tags do not always need a repo-local version change if they
describe a shared cross-repo lane instead of a single implementation round.

Examples:

- `@dev/family-env-contract`
- `@dev/family-user-vars`
- `@dev/family-seed-store`
- `@dev/wizard-secret-store`
- `@dev/family-wizard-networking`

## Rule

`@dev` tags are future pegs, not automatic update signals.
Dev Mode statuses describe current operating posture, not release readiness.
