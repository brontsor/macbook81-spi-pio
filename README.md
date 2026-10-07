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

That token is the public Omarchy workaround for this model. The
write-up that names it, and also sets `mem_sleep_default=s2idle` on
the same line, is Matthias Granberry's
[gist](https://gist.github.com/matthiasjg/78aaf7802146f0b89be3da9e4feb111f).
The open pull request that copies the keyboard half is
[omacom/omarchy#9735](https://github.com/omacom/omarchy/pull/9735).
The `omacom-os` URL does not resolve.

This package is only the Limine drop-in and the scripts that install
the keyboard token. It does not include that gist's hibernate hooks,
its suspend detach hook, or the sleep token. Those are a different
discussion. The real fix, a PIO quirk in the SPI driver, is Shih-Yuan
Lee's series on the linux-spi list
([v16 5/7](https://lore.kernel.org/linux-spi/20260720162117.32304-6-fourdollars@debian.org/)).
It is not in kernel `7.2.5-4-omarchy`. This drop-in is the workaround
until that quirk is in the kernel you boot.

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

## For agents

Read `AGENTS.md` before changing this tree.

## License

MIT. See `LICENSE`. The kernel parameter itself is not original to this
repository.
