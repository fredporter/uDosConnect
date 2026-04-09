# uDOS Developer — export integration & dev handoff (v2.1)

## Role

**uDOS Developer** receives **implementation-heavy** work that Agent Digital **does not** complete as a full Binder (see **`docs/agent-digital-v2_1-spec.md`** dev routing).

## When Agent Digital stops and hands off

Trigger dev handoff when the user asks for things like:

- Building a full app (mobile/web/desktop)
- Backend / API / database / auth systems
- Deployment or hosting setup

## Handoff contents

1. Stop Binder “full compile” for that scope.
2. Output a **DEV BRIEF** with: project summary, core requirements, suggested stack, constraints, output expectation.
3. Provide a **paste-ready prompt** block for uDOS Developer.
4. Link the operator to the **uDOS Developer** custom GPT (URL from your GPT Builder / published link).

### Example handoff skeleton

```markdown
# ⚠️ This project is best handled by uDOS Developer

## DEV BRIEF

## Project Summary

## Core Requirements

## Suggested Stack

## Constraints

## Output Expectation

## COPY INTO uDOS Developer

<paste prompt>

## LINK

<your uDOS Developer GPT URL>
```

Example public GPT URL format (verify yours): `https://chatgpt.com/g/g-69cf507db23081919d19148b7df1ff49-udos-developer`

## Export Action (future)

When **EXPORT** is used and an export Action is available, package generated **code-binder** files into a ZIP and return the download link — same pattern as Agent Digital (`docs/agent-digital-export-integration.md`).
