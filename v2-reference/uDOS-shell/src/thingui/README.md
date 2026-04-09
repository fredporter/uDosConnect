# ThinGUI

Browser-rendered lightweight GUI launch surfaces.

This module exists to hand off shell intent into browser-hosted Wizard or
server GUI targets without rebuilding a second page framework inside
`uDOS-shell`.

Its role is to:

- build launch URLs for Wizard- or server-owned browser GUI targets
- keep shell-side handoff explicit and small
- avoid duplicating page-system logic that belongs in browser apps

This module is a launcher surface, not a second app framework.
