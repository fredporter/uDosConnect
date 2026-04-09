#!/usr/bin/env bash
# Shared udos-web listen defaults (command-centre demo, udos-web stub, checks).
# Keep in sync with config/env/udos-web.env.example and
# contracts/udos-web/command-centre-static-demo.v1.json defaults.

UDOS_WEB_DEFAULT_BIND=127.0.0.1
UDOS_WEB_DEFAULT_PORT=7107

# Apply defaults to UDOS_WEB_BIND / UDOS_WEB_PORT when unset (mutates caller shell).
udos_web_resolve_listen() {
  UDOS_WEB_BIND="${UDOS_WEB_BIND:-$UDOS_WEB_DEFAULT_BIND}"
  UDOS_WEB_PORT="${UDOS_WEB_PORT:-$UDOS_WEB_DEFAULT_PORT}"
}

# After udos_web_resolve_listen: base URL for operator hints (no trailing path).
udos_web_base_url() {
  udos_web_resolve_listen
  printf 'http://%s:%s/' "$UDOS_WEB_BIND" "$UDOS_WEB_PORT"
}
