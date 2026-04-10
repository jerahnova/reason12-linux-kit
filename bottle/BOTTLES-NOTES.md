# Notes

## Current Local State

- Bottles version: `63.2`
- Bottles data path:
  `~/.var/app/com.usebottles.bottles/data/bottles`
- No managed runners are currently installed in Bottles on this machine.

## Current Working Reason Runtime

- Runner:
  `<INSTALL_ROOT>/opt/wine-11.6`
- Prefix:
  `<INSTALL_ROOT>/.wine-reason12-116`
- Main launcher:
  `<INSTALL_ROOT>/bin/reason12-menufix`
- Companion wrapper:
  `<INSTALL_ROOT>/bin/reason-companion-url-116`
- Host `rslaunch` desktop handler:
  `<XDG_DATA_HOME>/applications/reason-companion-rslaunch.desktop`

## Important Limitation

The working setup still depends on host integration outside Bottles:
- custom Wine tree
- launch wrappers in `~/bin`
- `rslaunch` URL handler on the Linux host

So Bottles import is only one part of the setup.
