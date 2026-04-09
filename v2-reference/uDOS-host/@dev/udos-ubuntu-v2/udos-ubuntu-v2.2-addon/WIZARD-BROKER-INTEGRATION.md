# Wizard Broker Integration

This add-on scaffold is a suitable destination for `Wizard` broker handoff.

## Intended Relationship

- `Wizard` receives the user request
- `Wizard` resolves Ubuntu OKD as the correct execution target
- `Wizard` packages a delegation envelope
- `services/okd/` executes the request
- result status is returned to the caller through the broker or directly

## Why This Fits

This scaffold already points toward:

- deterministic document formatting
- provider-backed fallback only when needed
- local beacon-aware Ubuntu hosting
- service-oriented OK execution

That makes it a good execution target while keeping the broker thin.

## Rule

Do not move broker logic into `services/okd/`.

Keep:

- brokering in Wizard
- execution in Ubuntu OKD
- runtime authority in Ubuntu

## Suggested Broker Capability Mapping

- `format_doc` -> `uDOS-host/services/okd`
- `ingest_link` -> `uDOS-host/services/okd`
- `research_topic` -> `uDOS-host/services/okd`
- `library_browse` -> `uDOS-host/library`
- `beacon_status` -> `uDOS-host/network/beacon`

## Suggested Envelope Target

```json
{
  "destination_service": "uDOS-host",
  "destination_surface": "services/okd",
  "capability": "ok.transformation",
  "dispatch_mode": "direct"
}
```
