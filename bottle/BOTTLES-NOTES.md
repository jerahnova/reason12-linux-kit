# Bottles Integration Notes

## Current Situation

Reason 12 is currently more reliable as a host-integrated Wine setup than as a Bottles-native package.

The working runtime still depends on:
- a custom source-built Wine 11.6 WoW64 runner
- launch wrappers outside Bottles
- a host-side `rslaunch` URL handler

Because of that, Bottles import alone is not enough to reproduce the full working setup yet.

## Reference Runtime

- Runner: `<INSTALL_ROOT>/opt/wine-11.6`
- Prefix: `<INSTALL_ROOT>/.wine-reason12-116`
- Main launcher: `<INSTALL_ROOT>/bin/reason12-menufix`
- Companion wrapper: `<INSTALL_ROOT>/bin/reason-companion-url-116`
- Host `rslaunch` handler: `<XDG_DATA_HOME>/applications/reason-companion-rslaunch.desktop`

## Intended Bottles Direction

A future Bottles-ready version should ideally provide:
- a runner layout Bottles can consume directly
- bottle-local startup behavior instead of host-only wrappers
- a documented first-launch flow for Reason Companion and account handoff

Until then, these files are best treated as migration aids rather than a final package format.
