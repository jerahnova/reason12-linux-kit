#!/usr/bin/env bash
set -euo pipefail

# Share-safe example commands. Replace placeholders for the target machine.

INSTALL_ROOT="${INSTALL_ROOT:-<INSTALL_ROOT>}"
PROJECT_ROOT="${PROJECT_ROOT:-<PROJECT_ROOT>}"

echo "tar -C \"${INSTALL_ROOT}\" -caf \"${PROJECT_ROOT}/wine-11.6.tar.zst\" \"opt/wine-11.6\""
echo "tar -C \"${INSTALL_ROOT}\" -caf \"${PROJECT_ROOT}/reason12-prefix-116.tar.zst\" \".wine-reason12-116\""
echo "cp -a \"${INSTALL_ROOT}/bin/reason12-menufix\" \"${INSTALL_ROOT}/bin/reason-companion-url-116\" \"${PROJECT_ROOT}/export/\""
echo "cp -a \"<XDG_DATA_HOME>/applications/reason-companion-rslaunch.desktop\" \"${PROJECT_ROOT}/export/\""
