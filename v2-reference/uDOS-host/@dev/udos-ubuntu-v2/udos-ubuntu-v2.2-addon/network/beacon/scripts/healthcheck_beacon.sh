#!/usr/bin/env bash
set -euo pipefail

echo "== hostapd =="
systemctl is-active hostapd || true
echo "== dnsmasq =="
systemctl is-active dnsmasq || true
echo "== addresses =="
ip addr show wlan0 || true
echo "== routes =="
ip route || true
