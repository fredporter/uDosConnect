# WordPress Plugin Source Lane

`src/wordpress-plugin/` is the first-pass source and contract lane for the
Empire WordPress-plugin refactor.

This lane should hold plugin-owned assets such as:

- plugin manifest and module boundaries
- WordPress user-meta contact record rules
- import profile contracts
- admin workflow contracts
- local email or activity logging shapes

Current starter files:

- `plugin-manifest.json`
- `contact-record-profile.json`

Boundary rule:

- keep WordPress-plugin-owned CRM, email, notes, and admin contracts here
- keep host-owned runtime, scheduling, repo-store, and Git or GitHub actions in
  `uDOS-host`
- treat older Google, HubSpot, and webhook assets elsewhere in `src/` as
  transition material only
