#!/bin/bash
# Remove the PIO cmdline drop-in and rebuild the UKI without it.
# Must run as root. Does not reboot.
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "run as root: sudo bash $0" >&2
  exit 1
fi

DROPIN="/etc/limine-entry-tool.d/macbook81-spi-pio.conf"
UKI="/boot/EFI/Linux/omarchy_linux-omarchy.efi"

rm -f "$DROPIN"
echo "== removed $DROPIN =="

echo "== rebuilding UKI and boot entries (limine-mkinitcpio) =="
limine-mkinitcpio

echo
if [[ -f "$UKI" ]] && strings "$UKI" | grep -F 'initcall_blacklist=dw_pci_driver_init'; then
  echo "STILL IN UKI. Do not reboot until the token is gone."
  exit 1
fi
echo "Rebuilt. Reboot to return to the previous cmdline."
