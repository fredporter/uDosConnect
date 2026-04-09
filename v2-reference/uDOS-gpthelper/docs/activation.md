# Activation

## Spec baseline

Custom GPT behaviour for Agent Digital should follow **`docs/agent-digital-v2_1-spec.md`** and the patches in **`prompts/patches/`**.

## Validation

```bash
bash scripts/run-gpthelper-checks.sh
```

## GitHub Actions

On **push** / **pull_request** to **`main`**, CI runs **`validate.yml`** (script checks) and the reusable **`uDOS-dev`** **`family-policy-check.yml`**. Canonical contract: **`uDOS-dev/docs/github-actions-family-contract.md`**.
