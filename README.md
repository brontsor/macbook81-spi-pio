# macbook81-spi-pio

Built-in keyboard and trackpad for the MacBook (Retina, 12-inch, Early 2015),
model `MacBook8,1`, on Omarchy.

Both devices are the SPI topcase behind the Wildcat Point-LP GSPI controller
at PCI `00:15.4`. The companion DMA engine at `00:15.0` is built into
`linux-omarchy`. On this board it accepts transfers and never completes them.
`applespi` times out with `-110`. The keyboard node is registered and dead.
The trackpad never appears.

A modprobe blacklist cannot stop a built-in driver. The workaround is one
kernel parameter:

```
initcall_blacklist=dw_pci_driver_init
```

That token is the one already used on other Omarchy MacBook8,1 machines
([omacom-os/omarchy#9735](https://github.com/omacom-os/omarchy/pull/9735)).
This package is only the Limine drop-in and the scripts that install it.
It does not include the hibernate hooks or the suspend change from that
discussion. Those are a different package.

A proper applespi PIO quirk exists upstream and is not in kernel
`7.2.5-4-omarchy`. This drop-in is the workaround until that quirk is in
the kernel you boot.

## Install

This machine boots a Limine UKI. The command line is inside
`/boot/EFI/Linux/omarchy_linux-omarchy.efi`. Writing the drop-in is not
enough.

```bash
sudo bash apply.sh
sudo reboot
```

`apply.sh` installs `/etc/limine-entry-tool.d/macbook81-spi-pio.conf` and
rebuilds the UKI with `limine-mkinitcpio`. It stops if the token is not in
the rebuilt UKI. Do not run `limine-update`. That reinstalls the bootloader.

## After reboot

- `/proc/cmdline` contains `initcall_blacklist=dw_pci_driver_init`
- the kernel log says `no DMA channels available, using PIO` for `00:15.4`
- an Apple SPI keyboard and an Apple SPI trackpad both show up

Omarchy's installer already requests early load of `applespi`,
`spi_pxa2xx_platform`, and `spi_pxa2xx_pci`. This package does not add
that file.

## Revert

```bash
sudo bash revert.sh
sudo reboot
```

## License

MIT. See `LICENSE`. The kernel parameter itself is not original to this
repository.
