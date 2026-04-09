#!/usr/bin/env bash
set -euo pipefail

HOSTAPD_CONF="${1:-./hostapd/hostapd.conf.example}"
DNSMASQ_CONF="${2:-./dnsmasq/dnsmasq.conf.example}"

echo "This scaffold script copies example configs into place."
echo "Review interface names, country code, and passphrase before use."

sudo cp "$HOSTAPD_CONF" /etc/hostapd/hostapd.conf
sudo cp "$DNSMASQ_CONF" /etc/dnsmasq.d/udos-beacon.conf

echo "Enable IP forwarding manually or through your preferred firewall tooling."
echo "Suggested next steps:"
echo "  sudo systemctl unmask hostapd"
echo "  sudo systemctl enable hostapd dnsmasq"
echo "  sudo systemctl restart hostapd dnsmasq"
