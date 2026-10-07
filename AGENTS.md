# macbook81-spi-pio

Built-in keyboard and trackpad for the MacBook (Retina, 12-inch, Early 2015), model `MacBook8,1`, on Omarchy. This package is only the Limine drop-in for one kernel parameter.

- The parameter is `initcall_blacklist=dw_pci_driver_init`. Do not put `mem_sleep_default` on that line.
- Do not install the gist hibernate hooks or the suspend detach hook.
- Rebuild with `limine-mkinitcpio`. Do not run `limine-update`.
- Do not remove `macbook12-spi-driver`.
- The token is the public workaround. The driver fix is Shih-Yuan Lee's series. Do not describe this drop-in as that fix.
- Do not push, add a remote, or change visibility unless asked.
- Do not write a session recap into this repository.
- Do not record a serial, a manufacture week, or a battery date.
