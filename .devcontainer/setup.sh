#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
sudo apt update && sudo apt install -y kde-plasma-desktop konsole dolphin blender ssl-cert
gh release download -R kasmtech/KasmVNC -p "*noble*amd64.deb" -O /tmp/kasm.deb && sudo apt install -y /tmp/kasm.deb
python3 -c 'import urllib.request, base64; urllib.request.urlretrieve(base64.b64decode("aHR0cHM6Ly9kbC5nb29nbGUuY29tL2xpbnV4L2RpcmVjdC9nb29nbGUtY2hyb21lLXN0YWJsZV9jdXJyZW50X2FtZDY0LmRlYg==").decode(), "/tmp/chrome.deb")'
sudo apt install -y /tmp/chrome.deb && rm -f /tmp/*.deb && sudo apt clean
sudo sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --no-sandbox|g' /usr/share/applications/google-chrome.desktop
mkdir -p ~/.vnc && printf "123456\n123456\n" | vncpasswd -u admin -w -r && echo "codespace:123456" | sudo chpasswd
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/.vnc/self.pem -out ~/.vnc/self.pem -subj "/CN=localhost"
printf "network:\n  ssl:\n    pem_certificate: /home/codespace/.vnc/self.pem\n    pem_key: /home/codespace/.vnc/self.pem\n    require_ssl: false\nencoding:\n  rect_encoding_mode:\n    min_quality: 4\n    max_quality: 7\n" > ~/.vnc/kasmvnc.yaml
printf '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexport LIBGL_ALWAYS_SOFTWARE=1\nexport GALLIUM_DRIVER=llvmpipe\nexport LP_NUM_THREADS=4\nexec startplasma-x11\n' > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup
kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock false
kwriteconfig5 --file kwalletrc --group Wallet --key Enabled false
