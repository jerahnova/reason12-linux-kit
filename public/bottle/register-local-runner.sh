#!/usr/bin/env bash
set -euo pipefail

RUNNER_SRC="${HOME}/opt/wine-11.6"
RUNNERS_DIR="${HOME}/.var/app/com.usebottles.bottles/data/bottles/runners"
RUNNER_NAME="sys-wine-11.6-reason"
RUNNER_DST="${RUNNERS_DIR}/${RUNNER_NAME}"

if [ ! -x "${RUNNER_SRC}/bin/wine" ]; then
  echo "Missing runner at ${RUNNER_SRC}" >&2
  exit 1
fi

mkdir -p "${RUNNERS_DIR}"
rm -f "${RUNNER_DST}"
ln -s "${RUNNER_SRC}" "${RUNNER_DST}"

cat <<EOF
Registered local runner symlink:
  ${RUNNER_DST} -> ${RUNNER_SRC}

This only stages the runner path for local Bottles experiments.
It does not create a Bottle by itself.
EOF
