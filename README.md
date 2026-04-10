# Reason 12 Linux/Wine Kit

A reusable Linux kit for running Reason 12 under a source-built Wine 11.6 WoW64 runtime.

This repository contains the share-safe parts of the setup:
- a rebuilt Wine 11.6 WoW64 runner
- launch scripts and desktop integration
- install and bootstrap helpers
- Bottles-related notes for future packaging work

It does not include licenses, account state, private prefixes, or any Reason-owned installers.

## Project Status

Current status: usable, but not yet polished enough to claim full end-user parity with native Windows.

Validated:
- the source-built Wine 11.6 WoW64 runner works
- a fresh blank prefix can install the official Reason 12 installer successfully
- a fresh blank prefix can install the official Reason Companion installer successfully
- the official Reason installer lays down the shared resources and stock soundbanks required for startup
- Reason can reach a usable UI on Linux under the known-good setup

Known limitations:
- Reason may still show a misleading Companion error even when startup succeeds
- Companion itself is not fully healthy under Wine
- first-launch auth and account-handshake behavior still need more validation from a fully fresh end-user path
- this repository is not yet a finished Bottles-native export

## Repository Layout

Top-level files:
- `README.md`: project overview and usage notes
- `STATE.txt`: concise technical state summary
- `install-kit.sh`: installs the reusable kit into a target root
- `bootstrap-prefix.sh`: creates and initializes a fresh Wine prefix
- `archive-commands.sh`: example commands for rebuilding release artifacts
- `RELEASE-ASSETS.md`: what should ship as release assets instead of git-tracked files
- `SHA256SUMS`: checksums for published binary artifacts

Directories:
- `export/`: launcher scripts and desktop-entry templates
- `bottle/`: notes and helper scripts for Bottles-related workflows

Release asset kept out of git:
- `wine-11.6.tar.zst`

## Canonical Runtime

The reference layout expected by this kit is:
- Wine runner: `<INSTALL_ROOT>/opt/wine-11.6`
- Prefix: `<INSTALL_ROOT>/.wine-reason12-116`
- Main launcher: `<INSTALL_ROOT>/bin/reason12-menufix`
- Companion wrapper: `<INSTALL_ROOT>/bin/reason-companion-url-116`
- Host `rslaunch` handler: `<XDG_DATA_HOME>/applications/reason-companion-rslaunch.desktop`

## Installation Flow

Typical use on another Linux machine:
1. Download or clone this repository.
2. Download the published release asset `wine-11.6.tar.zst` and place it in the repository root.
3. Obtain the official Reason 12 installer and the official Reason Companion installer.
4. Run `./install-kit.sh [target-root]`.
5. Run `./bootstrap-prefix.sh [target-root]`.
6. Install Reason and Reason Companion into the created prefix using the official installers.
7. Launch Reason from the generated desktop entry or the installed launcher script.

## What This Repository Does Not Ship

This repository intentionally does not redistribute:
- Reason installers
- licenses or entitlements

## Why This Is Not Yet A Final Bottle

A fully portable Bottles export still needs more work.

The current working setup depends on Linux-host integration outside a bottle:
- a custom source-built Wine runner
- launcher scripts on the host filesystem
- a host `rslaunch` URL handler
- Companion behavior that remains somewhat fragile under Wine

That means this project is better described today as a reproducible Linux install kit than as a finished, one-click Bottles package.

## Recommended Next Work

The remaining high-value improvements are:
- remove the lingering false Companion error path
- validate first-launch auth from a completely fresh end-user setup
- reduce host-side integration requirements where possible
- decide whether Companion must be fully interactive, or only reliable enough to support Reason startup
