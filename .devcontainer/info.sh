#!/bin/bash
# Mostra on és l'escriptori i com entrar-hi.
URL="http://localhost:6080/"
if [ -n "${CODESPACE_NAME:-}" ] && [ -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]; then
  URL="https://${CODESPACE_NAME}-6080.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}/"
fi
echo
echo "=============================================================="
echo "  🖥️  Escriptori virtual: $URL"
if [ -n "${VNC_PASSWORD:-}" ]; then
  echo "  🔑 Usuari: admin   Contrasenya: la del secret VNC_PASSWORD"
else
  echo "  🔓 Sense contrasenya (accés només amb el teu compte de GitHub)"
fi
echo "  🔄 Si no respon, escriu:  escriptori"
echo "=============================================================="
echo
