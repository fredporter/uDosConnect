# uDOS v2 Autonomy Classes

Status: v2.0.4 contract baseline
Contract owner: uDOS-core

## Purpose

Define the canonical autonomy classes used by OK Agent capability contracts and
managed routing policy.

## Class Definitions

### class0_manual_only

- assist output only
- no autonomous execution
- operator triggers all actions

### class1_bounded_local

- bounded local deterministic loops
- no unmanaged network escalation
- Core-safe local execution class

### class2_deferred_managed

- Wizard-managed deferred execution
- budget and schedule checks required
- may require approval by policy

### class3_contributor

- contributor-only automation in Dev lanes
- not release runtime default behavior
- must stay auditable and isolated

### class4_restricted_high_trust

- explicitly approved, tightly scoped automation
- strongest audit and revocation expectations
- never default

## Ownership Guidance

- Core classifies and validates autonomy class metadata
- Wizard enforces managed class behavior for networked execution
- Dev validates fixture and promotion behavior before release promotion

## Rule

Autonomy class metadata constrains behavior. It never transfers runtime
authority away from Core validation.
