# Dev brief template (inbox intake)

Use this template for all new inbox briefs.

---

## Brief metadata

- title:
- date:
- author:
- scope: (family / repo-specific)
- target repo(s):
- related lane: (post-08 / optional `v2.x` gate item / repo patch)

## Problem statement

What is broken, missing, or ambiguous?

## In-family expected outcome

Describe the preferred solution using current uDOS contracts and runtime
boundaries. Do not default to out-of-family alternatives.

## Constraints and boundaries

- ownership boundaries:
- runtime/storage constraints (`~/.udos/`, no repo-state drift):
- security/policy constraints:
- backward compatibility constraints:

## Canonical references (required)

- owning contract/doc:
- family control-plane doc:
- roadmap/backlog ledger:

## Proposed change set

- docs changes:
- script/tooling changes:
- contract/schema changes:
- runtime/service changes:

## Validation plan

- commands to run:
- expected outputs:
- browser/UI checks (if applicable):

## Promotion target

Where this brief should be promoted after review:

- [ ] `docs/` (stable public)
- [ ] `@dev/notes/roadmap/` or report
- [ ] `@dev/requests/active-index.md`
- [ ] `@dev/pathways/`
- [ ] repo-local `@dev/` in owning repo

## Acceptance checklist

- [ ] terminology matches family guardrails
- [ ] references are current and real
- [ ] no contradictory ownership claims
- [ ] no out-of-family default solution drift
- [ ] validation steps are executable

---

If a brief fails this template, keep it in inbox and do not promote.
