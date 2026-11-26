#!/bin/bash
# Instal·la KDE Plasma, Blender, Google Chrome i KasmVNC (Ubuntu 24.04 "noble").
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo -E apt-get install -y \
  kde-plasma-desktop konsole dolphin dbus-x11 x11-xserver-utils \
  blender ssl-cert openssl curl ca-certificates fonts-dejavu

# KasmVNC: el paquet ha de coincidir amb la versió d'Ubuntu del contenidor (noble).
KASM_URL="$(curl -fsSL https://api.github.com/repos/kasmtech/KasmVNC/releases/latest \
  | grep -o 'https://[^"]*noble[^"]*_amd64\.deb' | head -n1)"
if [ -z "$KASM_URL" ]; then
  KASM_URL="https://github.com/kasmtech/KasmVNC/releases/download/v1.5.2/kasmvncserver_ubuntu_noble_1.5.2_amd64.deb"
fi
curl -fsSL "$KASM_URL" -o /tmp/kasm.deb
curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb
sudo -E apt-get install -y /tmp/kasm.deb /tmp/chrome.deb
rm -f /tmp/kasm.deb /tmp/chrome.deb
sudo apt-get clean
sudo usermod -aG ssl-cert "$USER"

# Chrome dins d'un contenidor: sense sandbox i amb renderitzat per programari.
sudo sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --no-sandbox --disable-dev-shm-usage --enable-webgl --ignore-gpu-blocklist --enable-unsafe-swiftshader|g' \
  /usr/share/applications/google-chrome.desktop

mkdir -p "$HOME/.vnc"
if [ ! -s "$HOME/.vnc/password" ]; then
  openssl rand -hex 16 > "$HOME/.vnc/password"
fi
chmod 600 "$HOME/.vnc/password"
VNC_PASSWORD="$(cat "$HOME/.vnc/password")"
printf '%s\n%s\n' "$VNC_PASSWORD" "$VNC_PASSWORD" | vncpasswd -u admin -w -r

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout "$HOME/.vnc/self.pem" -out "$HOME/.vnc/self.pem" -subj "/CN=localhost" 2>/dev/null

cat > "$HOME/.vnc/kasmvnc.yaml" <<YAML
network:
  protocol: http
  interface: 0.0.0.0
  websocket_port: 6080
  ssl:
    pem_certificate: $HOME/.vnc/self.pem
    pem_key: $HOME/.vnc/self.pem
    require_ssl: false
encoding:
  rect_encoding_mode:
    min_quality: 4
    max_quality: 7
YAML

# Marca que l'escriptori ja està triat perquè vncserver no pregunti res.
touch "$HOME/.vnc/.de-was-selected"

cat > "$HOME/.vnc/xstartup" <<'XS'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export LP_NUM_THREADS="$(nproc)"
export KWIN_COMPOSE=N
exec dbus-launch --exit-with-session startplasma-x11
XS
chmod +x "$HOME/.vnc/xstartup"

kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock false
kwriteconfig5 --file kscreenlockerrc --group Daemon --key LockOnResume false
kwriteconfig5 --file kwalletrc --group Wallet --key Enabled false
kwriteconfig5 --file kwinrc --group Compositing --key Enabled false

echo "Instal·lació completada."
