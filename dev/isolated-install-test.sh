#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CURRENT_USER="$(id -un)"
TEST_USER="${TEST_USER:-$CURRENT_USER}"
BASE_DIR="${1:-$HOME/tmp/reason12-isolated}"
REASON_INSTALLER="${2:-}"
COMPANION_INSTALLER="${3:-}"
DISPLAY_VALUE="${DISPLAY:-:0}"
XAUTHORITY_VALUE="${XAUTHORITY:-${HOME}/.Xauthority}"
XDG_ROOT="${BASE_DIR}/xdg"
DESKTOP_DIR="${BASE_DIR}/desktop"
TARGET_ROOT="${BASE_DIR}/root"
STAGE_DIR="${BASE_DIR}/stage"
LOG_DIR="${BASE_DIR}/logs"
PREFIX="${TARGET_ROOT}/.wine-reason12-116"
WINE_BIN="${TARGET_ROOT}/opt/wine-11.6/bin/wine"
CROSS_USER=0
if [[ "${TEST_USER}" != "${CURRENT_USER}" ]]; then
  CROSS_USER=1
fi

usage() {
  cat <<USAGE
Usage:
  $(basename "$0") <base-dir> <path-to-Install Reason 12.exe> <path-to-ReasonCompanion.exe>

Environment:
  TEST_USER   local user to own the isolated test root (default: current user)
  DISPLAY     X display to expose to the isolated install (default: current DISPLAY or :0)
  XAUTHORITY  Xauthority file for DISPLAY (default: current user's .Xauthority)
USAGE
}

if [[ -z "${REASON_INSTALLER}" || -z "${COMPANION_INSTALLER}" ]]; then
  usage
  exit 2
fi

if [[ ! -f "${REASON_INSTALLER}" ]]; then
  echo "Missing Reason installer: ${REASON_INSTALLER}" >&2
  exit 1
fi

if [[ ! -f "${COMPANION_INSTALLER}" ]]; then
  echo "Missing Companion installer: ${COMPANION_INSTALLER}" >&2
  exit 1
fi

REASON_INSTALL_DIR="$(cd -- "$(dirname -- "${REASON_INSTALLER}")" && pwd)"

run_as_test_user() {
  if (( CROSS_USER )); then
    sudo -u "${TEST_USER}" "$@"
  else
    "$@"
  fi
}

if (( CROSS_USER )); then
  command -v xhost >/dev/null || { echo "xhost is required for cross-user tests" >&2; exit 1; }
  command -v sudo >/dev/null || { echo "sudo is required for cross-user tests" >&2; exit 1; }
  xhost +SI:localuser:"${TEST_USER}" >/dev/null
  sudo rm -rf "${BASE_DIR}"
else
  rm -rf "${BASE_DIR}"
fi

run_as_test_user mkdir -p "${DESKTOP_DIR}" "${XDG_ROOT}" "${TARGET_ROOT}" "${STAGE_DIR}" "${LOG_DIR}"

run_as_test_user bash -lc '
  set -euo pipefail
  cd "$1"
  XDG_DATA_HOME="$2" XDG_DESKTOP_DIR="$3" ./install-kit.sh "$4" > "$5/install-kit.log" 2>&1
  env DISPLAY="$6" XAUTHORITY="$7" XDG_DATA_HOME="$2" XDG_DESKTOP_DIR="$3" ./bootstrap-prefix.sh "$4" > "$5/bootstrap.log" 2>&1
' bash "${PROJECT_ROOT}" "${XDG_ROOT}" "${DESKTOP_DIR}" "${TARGET_ROOT}" "${LOG_DIR}" "${DISPLAY_VALUE}" "${XAUTHORITY_VALUE}"

if (( CROSS_USER )); then
  sudo mkdir -p "${STAGE_DIR}/reason-installer"
  sudo cp -a "${REASON_INSTALL_DIR}/." "${STAGE_DIR}/reason-installer/"
  sudo cp -f "${COMPANION_INSTALLER}" "${STAGE_DIR}/Reason Companion.exe"
  sudo chown -R "${TEST_USER}:${TEST_USER}" "${STAGE_DIR}/reason-installer" "${STAGE_DIR}/Reason Companion.exe"
else
  mkdir -p "${STAGE_DIR}/reason-installer"
  cp -a "${REASON_INSTALL_DIR}/." "${STAGE_DIR}/reason-installer/"
  cp -f "${COMPANION_INSTALLER}" "${STAGE_DIR}/Reason Companion.exe"
fi

run_as_test_user bash -lc '
  set +e
  env DISPLAY="$1" XAUTHORITY="$2" WINEPREFIX="$3" "$4" "$5" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART > "$6/reason-install.log" 2>&1
  rc=$?
  printf "REASON_RC=%s\n" "$rc" | tee "$6/reason-install.rc"
  exit 0
' bash "${DISPLAY_VALUE}" "${XAUTHORITY_VALUE}" "${PREFIX}" "${WINE_BIN}" "${STAGE_DIR}/reason-installer/Install Reason 12.exe" "${LOG_DIR}"

run_as_test_user bash -lc '
  set +e
  env DISPLAY="$1" XAUTHORITY="$2" WINEPREFIX="$3" "$4" "$5" /S > "$6/companion-install.log" 2>&1
  rc=$?
  printf "COMPANION_RC=%s\n" "$rc" | tee "$6/companion-install.rc"
  exit 0
' bash "${DISPLAY_VALUE}" "${XAUTHORITY_VALUE}" "${PREFIX}" "${WINE_BIN}" "${STAGE_DIR}/Reason Companion.exe" "${LOG_DIR}"

run_as_test_user bash -lc '
  set +e
  test -f "$1/drive_c/Program Files/Propellerhead/Reason 12/Reason.exe" && echo reason_exe=ok || echo reason_exe=missing
  test -f "$1/drive_c/users/${USER}/AppData/Local/Programs/reason-companion-app/Reason Companion.exe" && echo companion_exe=ok || echo companion_exe=missing
  test -f "$1/drive_c/ProgramData/Propellerhead Software/SharedResources/Reason/Reason.rpcp" && echo reason_rpcp=ok || echo reason_rpcp=missing
  find "$1/drive_c/ProgramData/Propellerhead Software/Soundbanks" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sed "s#^#soundbank=#"
' bash "${PREFIX}" > "${LOG_DIR}/verification.txt"

cat <<SUMMARY
Isolated test root ready:
  ${BASE_DIR}

Logs:
  ${LOG_DIR}/install-kit.log
  ${LOG_DIR}/bootstrap.log
  ${LOG_DIR}/reason-install.log
  ${LOG_DIR}/companion-install.log
  ${LOG_DIR}/verification.txt
SUMMARY
