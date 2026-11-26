#!/bin/bash
# Instal·la KDE Plasma, Blender, Google Chrome i KasmVNC (Ubuntu 24.04 "noble").
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL=6

# Mostra el pas actual en gran i el desa perquè 'info.sh' el pugui ensenyar.
pas() {
  echo "$1/$TOTAL $2" > /tmp/escriptori-estat
  echo
  echo "=============================================================="
  echo "  ⏳ [$1/$TOTAL] $2"
  echo "=============================================================="
}

# Qualsevol terminal nou mostra l'estat i l'enllaç de l'escriptori.
if ! grep -q "escriptori-info" "$HOME/.bashrc" 2>/dev/null; then
  echo "bash \"$DIR/info.sh\"  # escriptori-info" >> "$HOME/.bashrc"
fi

pas 1 "Preparant la instal·lació (uns 5-8 minuts en total)"

sudo apt-get update -q
pas 2 "Instal·lant l'escriptori KDE i Blender (el pas més llarg)"
sudo -E apt-get install -y \
  kde-plasma-desktop konsole dolphin dbus-x11 x11-xserver-utils \
  blender ssl-cert openssl curl ca-certificates fonts-dejavu

pas 3 "Instal·lant l'idioma espanyol"
# Idioma espanyol per a KDE (opcional: si falla, l'escriptori surt en anglès).
sudo -E apt-get install -y language-pack-es language-pack-kde-es || true

pas 4 "Descarregant i instal·lant KasmVNC i Google Chrome"
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

pas 5 "Configurant l'escriptori"
# Chrome dins d'un contenidor: sense sandbox i amb renderitzat per programari.
sudo sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --no-sandbox --disable-dev-shm-usage --enable-webgl --ignore-gpu-blocklist --enable-unsafe-swiftshader|g' \
  /usr/share/applications/google-chrome.desktop

mkdir -p "$HOME/.vnc"
# Usuari intern de KasmVNC (vncserver el necessita encara que no es demani contrasenya).
INTERNAL_PASSWORD="$(openssl rand -hex 16)"
printf '%s\n%s\n' "$INTERNAL_PASSWORD" "$INTERNAL_PASSWORD" | vncpasswd -u admin -w -r

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
if locale -a 2>/dev/null | grep -qi '^es_ES.utf8$'; then
  export LANG=es_ES.UTF-8 LANGUAGE=es:en LC_ALL=es_ES.UTF-8
fi
setxkbmap es 2>/dev/null || true
# La pantalla no s'apaga mai ni surt l'estalvi de pantalla.
xset s off s noblank -dpms 2>/dev/null || true
exec dbus-launch --exit-with-session startplasma-x11
XS
chmod +x "$HOME/.vnc/xstartup"

kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock false
kwriteconfig5 --file kscreenlockerrc --group Daemon --key LockOnResume false
kwriteconfig5 --file kwalletrc --group Wallet --key Enabled false
kwriteconfig5 --file kwinrc --group Compositing --key Enabled false

# Rendiment: sense animacions, sense indexador de fitxers ni pantalla de càrrega.
kwriteconfig5 --file kdeglobals --group KDE --key AnimationDurationFactor 0
kwriteconfig5 --file baloofilerc --group "Basic Settings" --key "Indexing-Enabled" false
kwriteconfig5 --file ksplashrc --group KSplash --key Engine none
kwriteconfig5 --file ksplashrc --group KSplash --key Theme None
kwriteconfig5 --file ksmserverrc --group General --key loginMode emptySession

# Teclat espanyol (amb anglès com a segona opció).
kwriteconfig5 --file kxkbrc --group Layout --key Use true
kwriteconfig5 --file kxkbrc --group Layout --key LayoutList es,us

# Ordre 'escriptori' per reiniciar l'escriptori des de qualsevol terminal.
sudo tee /usr/local/bin/escriptori >/dev/null <<CMD
#!/bin/bash
exec bash "$PWD/.devcontainer/start-vnc.sh" "\$@"
CMD
sudo chmod +x /usr/local/bin/escriptori

# Accessos directes a l'escriptori de KDE.
DESKTOP_DIR="$HOME/Desktop"
mkdir -p "$DESKTOP_DIR"
for app in blender google-chrome org.kde.konsole org.kde.dolphin; do
  if [ -f "/usr/share/applications/$app.desktop" ]; then
    cp "/usr/share/applications/$app.desktop" "$DESKTOP_DIR/"
    chmod +x "$DESKTOP_DIR/$app.desktop"
  fi
done
# Carpeta del repositori: el que hi guardis es pot pujar a GitHub.
ln -sfn "$PWD" "$DESKTOP_DIR/Projecte"

# Google Chrome com a navegador per defecte.
mkdir -p "$HOME/.config"
cat > "$HOME/.config/mimeapps.list" <<'MIME'
[Default Applications]
x-scheme-handler/http=google-chrome.desktop
x-scheme-handler/https=google-chrome.desktop
text/html=google-chrome.desktop
MIME

# Sense gestió d'energia: l'escriptori no se suspèn ni apaga la pantalla.
kwriteconfig5 --file powermanagementprofilesrc --group AC --group DPMSControl --key idleTime 0
kwriteconfig5 --file powermanagementprofilesrc --group AC --group DimDisplay --key idleTime 0

pas 6 "Arrencant l'escriptori"
rm -f /tmp/escriptori-estat
echo "✅ Instal·lació completada."
