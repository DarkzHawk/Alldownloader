#!/usr/bin/env sh
set -eu

mkdir -p /config /downloads /work

APP_EXE="$HITOMI_HOME/hitomi_downloader_GUI.exe"
if [ ! -f "$APP_EXE" ]; then
  APP_EXE="$(find "$HITOMI_HOME" -maxdepth 3 -type f -iname '*hitomi*downloader*.exe' | sort | head -n 1 || true)"
fi

if [ -z "${APP_EXE:-}" ] || [ ! -f "$APP_EXE" ]; then
  echo "Hitomi Downloader executable not found under $HITOMI_HOME" >&2
  exit 1
fi

if [ ! -d "$WINEPREFIX/drive_c" ]; then
  echo "Initializing Wine prefix at $WINEPREFIX..."
  mkdir -p "$WINEPREFIX"
  xvfb-run -a -s "-screen 0 1280x720x24" wineboot --init >/tmp/wineboot.log 2>&1 || {
    cat /tmp/wineboot.log >&2 || true
    exit 1
  }
  wineserver -w >/dev/null 2>&1 || true
fi

exec xvfb-run -a -s "-screen 0 1280x720x24" wine "$APP_EXE" "$@"
