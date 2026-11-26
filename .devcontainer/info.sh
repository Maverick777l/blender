#!/bin/bash
# Mostra l'estat i l'enllaç de l'escriptori (s'executa en obrir cada terminal).
URL="http://localhost:6080/"
if [ -n "${CODESPACE_NAME:-}" ] && [ -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]; then
  URL="https://${CODESPACE_NAME}-6080.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}/"
fi

if curl -fsS --max-time 1 -o /dev/null http://127.0.0.1:6080/ 2>/dev/null \
  || curl -kfsS --max-time 1 -o /dev/null https://127.0.0.1:6080/ 2>/dev/null; then
  ESTAT="✅ Escriptori a punt"
elif [ -f /tmp/escriptori-estat ]; then
  ESTAT="⏳ Instal·lant: pas $(cat /tmp/escriptori-estat) (mira el terminal 'postCreateCommand')"
else
  ESTAT="⏳ Arrencant... (si triga més d'1 minut, escriu: escriptori)"
fi

echo
echo "=============================================================="
echo "  🖥️  Escriptori virtual: $URL"
echo "  $ESTAT"
if [ -n "${VNC_PASSWORD:-}" ]; then
  echo "  🔑 Usuari: admin   Contrasenya: la del secret VNC_PASSWORD"
else
  echo "  🔓 Sense contrasenya (accés només amb el teu compte de GitHub)"
fi
echo "  🔄 Si no respon, escriu:  escriptori"
echo "=============================================================="
echo
