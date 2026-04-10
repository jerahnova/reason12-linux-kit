#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="${1:-$HOME/reason12-linux}"
XDG_APPS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
DESKTOP_DIR="${XDG_DESKTOP_DIR:-$HOME/Desktop}"

mkdir -p "${TARGET_ROOT}" "${TARGET_ROOT}/bin" "${XDG_APPS_DIR}" "${DESKTOP_DIR}"

echo "Extracting wine-11.6 into ${TARGET_ROOT} ..."
tar -C "${TARGET_ROOT}" -xaf "${PROJECT_ROOT}/wine-11.6.tar.zst"

echo "Installing launcher scripts ..."
cp -f "${PROJECT_ROOT}/export/reason12-menufix" "${TARGET_ROOT}/bin/"
cp -f "${PROJECT_ROOT}/export/reason-companion-url-116" "${TARGET_ROOT}/bin/"
chmod +x "${TARGET_ROOT}/bin/reason12-menufix" "${TARGET_ROOT}/bin/reason-companion-url-116"

render_template() {
  local src="$1"
  local dst="$2"
  sed "s|@INSTALL_ROOT@|${TARGET_ROOT}|g" "${src}" > "${dst}"
}

echo "Installing desktop entries ..."
render_template "${PROJECT_ROOT}/export/Reason 12.desktop.in" "${DESKTOP_DIR}/Reason 12.desktop"
render_template "${PROJECT_ROOT}/export/Reason 12 Wine 11.desktop.in" "${DESKTOP_DIR}/Reason 12 Wine 11.desktop"
render_template "${PROJECT_ROOT}/export/reason-companion-rslaunch.desktop.in" "${XDG_APPS_DIR}/reason-companion-rslaunch.desktop"
chmod +x "${DESKTOP_DIR}/Reason 12.desktop" "${DESKTOP_DIR}/Reason 12 Wine 11.desktop"

update-desktop-database "${XDG_APPS_DIR}" >/dev/null 2>&1 || true
xdg-mime default reason-companion-rslaunch.desktop x-scheme-handler/rslaunch || true

cat <<EOF
Installed public kit to:
  ${TARGET_ROOT}

Created:
  ${TARGET_ROOT}/opt/wine-11.6
  ${TARGET_ROOT}/bin/reason12-menufix
  ${TARGET_ROOT}/bin/reason-companion-url-116
  ${DESKTOP_DIR}/Reason 12.desktop
  ${DESKTOP_DIR}/Reason 12 Wine 11.desktop
  ${XDG_APPS_DIR}/reason-companion-rslaunch.desktop

Next:
1. Obtain the official Reason 12 and Reason Companion installers.
2. Create a prefix at:
   ${TARGET_ROOT}/.wine-reason12-116
3. Install Reason and Companion into that prefix.
4. Launch Reason from the installed desktop icon.
EOF
