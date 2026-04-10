#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="${1:-$HOME/reason12-linux}"
PREFIX="${TARGET_ROOT}/.wine-reason12-116"
WINE_BIN="${TARGET_ROOT}/opt/wine-11.6/bin/wine"

cat <<EOF
This helper prepares a fresh prefix for Reason 12.

Expected next step:
- run the official Reason installer and the official Reason Companion installer
  using this prefix and Wine runner

Commands:
  WINEPREFIX="${PREFIX}" "${WINE_BIN}" wineboot -u
  WINEPREFIX="${PREFIX}" "${WINE_BIN}" /path/to/Install\ Reason\ 12.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
  WINEPREFIX="${PREFIX}" "${WINE_BIN}" /path/to/ReasonCompanion.exe /S

If you want a fully scripted install, you still need to supply the official
installer files.
EOF

mkdir -p "${PREFIX}"
WINEPREFIX="${PREFIX}" "${WINE_BIN}" wineboot -u
