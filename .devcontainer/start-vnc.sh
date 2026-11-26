#!/bin/bash
# Arrenca (o reinicia) l'escriptori KasmVNC al port 6080.
set -u

if ! command -v vncserver >/dev/null 2>&1; then
  echo "KasmVNC no està instal·lat. Executa: bash .devcontainer/setup.sh" >&2
  exit 1
fi

vncserver -kill :1 >/dev/null 2>&1 || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

# 'sg ssl-cert' perquè el grup nou sigui efectiu sense tornar a iniciar sessió.
setsid nohup sg ssl-cert -c "vncserver :1 -select-de manual -geometry 1600x900 -depth 24" \
  >/tmp/vnc.log 2>&1 < /dev/null &

for _ in $(seq 1 60); do
  if curl -fsS --max-time 2 -o /dev/null http://127.0.0.1:6080/ 2>/dev/null \
    || curl -kfsS --max-time 2 -o /dev/null https://127.0.0.1:6080/ 2>/dev/null; then
    echo "Escriptori a punt al port 6080 (usuari: admin, contrasenya: cat ~/.vnc/password)."
    exit 0
  fi
  sleep 1
done

cat /tmp/vnc.log 2>/dev/null || true
ls ~/.vnc/*.log >/dev/null 2>&1 && tail -n 50 ~/.vnc/*.log
echo "KasmVNC no ha arrencat al port 6080." >&2
exit 1
