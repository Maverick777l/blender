#!/bin/bash
set -eu

# Ensure we always start a clean desktop session and avoid leaving stale X/VNC
# state behind when the Codespace restarts.
kwriteconfig5 --file kwinrc --group Compositing --key Enabled false
rm -rf /tmp/.X* 2>/dev/null || true
vncserver -kill :1 >/dev/null 2>&1 || true

nohup vncserver :1 -select-de manual -interface 0.0.0.0 -websocketPort 6080 >/tmp/vnc.log 2>&1 &

for _ in $(seq 1 30); do
  if curl -fsS --max-time 2 http://127.0.0.1:6080/ >/dev/null 2>&1 \
    || curl -kfsS --max-time 2 https://127.0.0.1:6080/ >/dev/null 2>&1; then
    exit 0
  fi
  sleep 1
done

cat /tmp/vnc.log 2>/dev/null || true
printf 'KasmVNC did not become ready on port 6080.\n' >&2
exit 1
