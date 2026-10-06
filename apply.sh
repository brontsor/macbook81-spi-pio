#!/bin/bash
# Install the PIO cmdline drop-in and rebuild the UKI so the next boot uses it.
# Must run as root. Does not reboot.
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "run as root: sudo bash $0" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")" && pwd)"
DROPIN="/etc/limine-entry-tool.d/macbook81-spi-pio.conf"
UKI="/boot/EFI/Linux/omarchy_linux-omarchy.efi"

install -m 644 "$ROOT/macbook81-spi-pio.conf" "$DROPIN"
echo "== installed $DROPIN =="
cat "$DROPIN"

echo "== rebuilding UKI and boot entries (limine-mkinitcpio) =="
limine-mkinitcpio

echo
echo "== initcall_blacklist in /boot/limine.conf =="
grep -n initcall_blacklist /boot/limine.conf || echo "NOT IN limine.conf"
echo
echo "== initcall_blacklist in UKI $UKI =="
if [[ -f "$UKI" ]] && strings "$UKI" | grep -F 'initcall_blacklist=dw_pci_driver_init'; then
  echo "READY FOR REBOOT. The token is in the UKI."
else
  echo "NOT READY. The token did not land. Do not reboot for this change."
  exit 1
fi
