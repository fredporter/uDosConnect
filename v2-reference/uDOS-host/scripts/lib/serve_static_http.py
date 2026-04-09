#!/usr/bin/env python3
"""Static file HTTP server aligned with udos-web listen contract.

Default bind 127.0.0.1 uses IPv6 dual-stack (::, IPV6_V6ONLY=0) when supported so
browsers that resolve ``localhost`` to ::1 still connect. Other binds use plain
ThreadingHTTPServer.
"""

from __future__ import annotations

import argparse
import http.server
import os
import socket
import sys
from http.server import ThreadingHTTPServer

# Defaults match scripts/lib/udos-web-listen.sh (invoke with explicit --bind/--port from callers).
_DEFAULT_BIND = "127.0.0.1"
_DEFAULT_PORT = 7107


class _DualStackLoopbackServer(ThreadingHTTPServer):
    address_family = socket.AF_INET6

    def server_bind(self) -> None:
        self.socket.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 0)
        super().server_bind()


def _serve(bind: str, port: int, directory: str) -> None:
    os.chdir(directory)
    handler = http.server.SimpleHTTPRequestHandler
    if bind == "127.0.0.1":
        try:
            httpd = _DualStackLoopbackServer(("::", port), handler)
        except OSError:
            httpd = ThreadingHTTPServer((bind, port), handler)
    else:
        httpd = ThreadingHTTPServer((bind, port), handler)
    httpd.serve_forever()


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--bind", "-b", default=_DEFAULT_BIND, help="Listen address")
    p.add_argument("--port", "-p", type=int, default=_DEFAULT_PORT)
    p.add_argument("--directory", "-d", required=True, help="Document root")
    args = p.parse_args()
    try:
        _serve(args.bind, args.port, args.directory)
    except OSError as e:
        print(f"serve_static_http: bind {args.bind!r} port {args.port}: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
