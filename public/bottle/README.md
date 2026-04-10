# Reason 12 Bottles Handoff

This directory contains the current Bottles-oriented handoff for the working
Reason 12 + source-built Wine 11.6 setup.

It is not a final portable Bottle export yet.

What it gives you:
- a way to register the local `wine-11.6` tree for Bottles use
- a way to restore the private working prefix to an importable location
- the launch wrappers and desktop files already proven on this machine
- a drop-in public install/bootstrap kit for non-private deployment

What it does not guarantee yet:
- a pristine first-launch Companion flow on a new machine
- a share-safe full archive, because the live prefix contains private data
- a Bottles-native `bottle.yml` generated directly from a real bottle instance

## Files

- `register-local-runner.sh`
- `restore-private-prefix.sh`
- `BOTTLES-NOTES.md`

## Intended Flow

1. Register the local Wine runner for Bottles bookkeeping.
2. Restore the private prefix archive to an importable location.
3. Open Bottles and use Import/Export -> Importer -> Refresh.
4. Import the restored prefix.
5. Re-apply the known-good launch wrappers and `rslaunch` integration if needed.

## Why This Approach

Official Bottles docs say:
- config backups are based on the `bottle.yml` in a bottle root
- full backups include all personal files
- Bottles can also import wineprefixes from other managers

Sources:
- https://docs.usebottles.com/bottles/backups
- https://docs.usebottles.com/bottles/import-from-other-managers
- https://docs.usebottles.com/advanced/cli
