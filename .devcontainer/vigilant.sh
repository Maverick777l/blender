#!/bin/bash
# Comprova cada 30 s que l'escriptori respon; si falla 3 cops seguits, el reinicia.
DIR="$(cd "$(dirname "$0")" && pwd)"
FALLADES=0
while sleep 30; do
  if curl -fsS --max-time 5 -o /dev/null http://127.0.0.1:6080/ 2>/dev/null     || curl -kfsS --max-time 5 -o /dev/null https://127.0.0.1:6080/ 2>/dev/null; then
    FALLADES=0
  else
    FALLADES=$((FALLADES + 1))
  fi
  if [ "$FALLADES" -ge 3 ]; then
    echo "$(date '+%F %T') L'escriptori no respon: reiniciant..."
    rm -f /tmp/escriptori-vigilant.pid
    exec bash "$DIR/start-vnc.sh"
  fi
done
