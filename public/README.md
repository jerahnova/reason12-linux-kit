# Reason 12 Linux/Wine State

This directory documents the current working Reason 12 setup on this machine.

This `public/` tree is the distributable side only.

Private machine/user data has been moved out to a separate non-public archive root.

## Current Status

Working:
- Reason 12 launches under source-built `wine-11.6`
- Main Reason UI is usable
- `.rns` files are associated with the same launcher
- Companion can be started in the same prefix
- A fresh blank prefix can install both official installers successfully under the rebuilt WoW64 runner
- The official Reason installer lays down shared resources plus the stock soundbanks needed to start Reason

Known issues:
- Reason may still show a misleading Companion error even when it continues launching
- Companion UI is not fully healthy under Wine
- This is not yet a clean portable Bottles export
- I would not claim "all Reason offers work" yet, especially first-launch/account/device-management paths

## Canonical Runtime

- Wine runner: `<INSTALL_ROOT>/opt/wine-11.6`
- Prefix: `<INSTALL_ROOT>/.wine-reason12-116`
- Main launcher: `<INSTALL_ROOT>/bin/reason12-menufix`
- Companion wrapper: `<INSTALL_ROOT>/bin/reason-companion-url-116`
- Host rslaunch handler desktop file:
  `<XDG_DATA_HOME>/applications/reason-companion-rslaunch.desktop`

## Why This Is Not A Real Bottle Yet

The setup still depends on host-side integration outside a bottle:
- custom source-built Wine
- custom launch scripts in `~/bin`
- host `x-scheme-handler/rslaunch`
- Companion startup behavior under Wine

A Bottles export would need either:
1. a Bottles runner compatible with this exact behavior, plus bottle-local startup hooks, or
2. a setup script that recreates the host integration after import

## First-Launch Concern

The original install blocker is no longer the installer path.

A clean blank prefix now installs correctly from the official:
- `Reason_1274_d3-Stable-820-Win.zip`
- `ReasonCompanion-3.0.18-win.exe`

The remaining redistribution risk is first launch after install.

Reason/Companion still appear to rely on:
- browser/account callback flow
- `rslaunch:` handoff
- Companion startup behavior under Wine

So while the current setup can work locally, I would not package it yet as:
"import this bottle and everything including Companion/account/device workflows works"

That would be overstating the current state.

## Public vs Private

Public here:
- source-built `wine-11.6` WoW64 archive
- launcher scripts and desktop integration
- installer/bootstrap scripts and notes

Private elsewhere:
- archived live prefix with entitlement/account state
- debug logs
- downloaded installers

## What We Do Have Enough For

We do have enough for a reproducible local project package:
- document the exact runner and prefix
- archive the built Wine tree
- keep the wrapper scripts and desktop integration

That is enough to reproduce the non-private side of the setup on a similar machine.

## Drop-In Use

This public package is now usable as a drop-in kit.

Main entry points:
- `install-kit.sh`
- `bootstrap-prefix.sh`

Typical flow on another machine:
1. unpack `public/`
2. run `./install-kit.sh [target-root]`
3. run `./bootstrap-prefix.sh [target-root]`
4. install the official Reason 12 and Reason Companion installers into the
   created prefix
5. launch from the installed desktop entry

This is still not a one-click final bottle, but it is now a real reusable kit.

## Important Paths Inside The Prefix

- Reason install:
  `<PREFIX>/drive_c/Program Files/Propellerhead/Reason 12`
- Companion install:
  `<PREFIX>/drive_c/users/<WINDOWS_USER>/AppData/Local/Programs/reason-companion-app`
- Shared resources:
  `<PREFIX>/drive_c/ProgramData/Propellerhead Software/SharedResources/Reason`
- Factory soundbanks:
  `<PREFIX>/drive_c/ProgramData/Propellerhead Software/Soundbanks`

## Recommendation

Package this next as a restoreable setup with a verified installer path, not as a polished Bottle.

If we want a real deliverable for others, the remaining work should focus on:
- removing the lingering Companion error dialog
- validating first-launch auth flow from a fresh prefix
- deciding whether Companion must be fully interactive or only good enough for Reason startup
