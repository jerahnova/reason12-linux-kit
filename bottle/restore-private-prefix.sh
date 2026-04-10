#!/usr/bin/env bash
set -euo pipefail

ARCHIVE="${ARCHIVE:-<PRIVATE_PREFIX_ARCHIVE>}"
DEST_ROOT="${1:-${HOME}/BottlesImports}"
DEST_DIR="${DEST_ROOT}/Reason12-116"

if [ "${ARCHIVE}" = "<PRIVATE_PREFIX_ARCHIVE>" ] || [ ! -f "${ARCHIVE}" ]; then
  echo "Missing private prefix archive: ${ARCHIVE}" >&2
  exit 1
fi

mkdir -p "${DEST_ROOT}"
rm -rf "${DEST_DIR}"
mkdir -p "${DEST_DIR}"

tar -C "${DEST_DIR}" -xaf "${ARCHIVE}"

cat <<EOF
Restored private prefix to:
  ${DEST_DIR}/.wine-reason12-116

Next:
1. Open Bottles
2. Main menu -> Import/Export
3. Open Importer
4. Press Refresh
5. Import the restored prefix if Bottles detects it

If Bottles does not detect it automatically, point Bottles to a custom bottles
path or move/copy the restored prefix into a path Bottles scans.
EOF
