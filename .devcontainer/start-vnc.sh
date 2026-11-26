#!/bin/bash
# Arrenca (o reinicia) l'escriptori KasmVNC al port 6080.
# - Sense VNC_PASSWORD: s'entra directament, sense contrasenya. El port del
#   Codespace és privat, així que només hi pots accedir tu amb el teu GitHub.
# - Amb el secret VNC_PASSWORD: KasmVNC demana usuari 'admin' + aquesta contrasenya.
set -u

if ! command -v vncserver >/dev/null 2>&1; then
  echo "KasmVNC no està instal·lat. Executa: bash .devcontainer/setup.sh" >&2
  exit 1
fi

AUTH_ARGS="-disableBasicAuth"
if [ -n "${VNC_PASSWORD:-}" ]; then
  printf '%s\n%s\n' "$VNC_PASSWORD" "$VNC_PASSWORD" | vncpasswd -u admin -w -r >/dev/null
  AUTH_ARGS=""
fi

vncserver -kill :1 >/dev/null 2>&1 || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

# 'sg ssl-cert' perquè el grup nou sigui efectiu sense tornar a iniciar sessió.
setsid nohup sg ssl-cert -c "vncserver :1 -select-de manual -geometry 1600x900 -depth 24 $AUTH_ARGS" \
  >/tmp/vnc.log 2>&1 < /dev/null &

for _ in $(seq 1 60); do
  if curl -fsS --max-time 2 -o /dev/null http://127.0.0.1:6080/ 2>/dev/null \
    || curl -kfsS --max-time 2 -o /dev/null https://127.0.0.1:6080/ 2>/dev/null; then
    bash "$(dirname "$0")/info.sh"
    exit 0
  fi
  sleep 1
done

cat /tmp/vnc.log 2>/dev/null || true
ls ~/.vnc/*.log >/dev/null 2>&1 && tail -n 50 ~/.vnc/*.log
echo "KasmVNC no ha arrencat al port 6080." >&2
exit 1
