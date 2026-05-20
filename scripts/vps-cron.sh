#!/usr/bin/env bash
set -euo pipefail
cd ~
if ! pgrep -u "$USER" supervisord > /dev/null 2>&1; then
  ~/.supervisor/bin/supervisord -c ~/.config/supervisord/supervisord.conf
fi
