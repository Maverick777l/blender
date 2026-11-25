# 🖥️ Escritori Virtual al Núbol (KDE Plasma + Blender + Google Chrome)

Executa un sistema operatiu complet amb **Blender** i **Google Chrome** directament al teu navegador mitjançant **GitHub Codespaces**.

[![Crea un Codespace nou a GitHub](https://github.com/codespaces/badge.svg)](https://codespaces.new/arnlopgar-debug/blender?quickstart=1)

---

## 🚀 Com funciona (100% Automàtic)

1. **Prem el botó de dalt** i selecciona **Create codespace** per crear un escriptori nou. Cal iniciar sessió a GitHub i tenir quota de Codespaces disponible.
2. **Espera uns 4 minuts** mentre el servidor instal·la i configura automàticament tot l'entorn.
3. S'obrirà automàticament una pestanya nova amb l'escriptori virtual (si no s'obre sola, ves a la pestanya inferior **PORTS**, busca el port **6080** i prem la icona del globus terraquì 🌐).

---

## 🔑 Dades d'accés per defecte

| Camp | Valor |
| :--- | :--- |
| **Usuari** | `admin` |
| **Contrasenya** | Generada al configurar el contenedor; consulta `~/.vnc/password` |

Per veure la contrasenya del Codespace actual, executa `cat ~/.vnc/password` al terminal del Codespace. El `postCreateCommand` només s'executa en crear el contenidor, així que actualitzar aquest repositori no canvia la contrasenya d'un Codespace existent.

Si KasmVNC indica que la contrasenya és incorrecta, restableix-la des del terminal del Codespace:

```bash
NEW_PASSWORD="$(openssl rand -hex 16)"
printf '%s\n' "$NEW_PASSWORD" > ~/.vnc/password
chmod 600 ~/.vnc/password
printf '%s\n%s\n' "$NEW_PASSWORD" "$NEW_PASSWORD" | vncpasswd -u admin -w -r
vncserver -kill :1
vncserver :1 -select-de manual -interface 0.0.0.0 -websocketPort 6080
cat ~/.vnc/password
```

Després d'uns quants intents fallits, KasmVNC pot bloquejar temporalment la IP; espera uns segons després de restablir-la abans de tornar a iniciar sessió.

---

## ✨ Què inclou?

* **KDE Plasma:** Escriptori modern i lleuger.
* **KasmVNC:** Transmissió de vídeo comprimida i xifrada al navegador.
* **Blender:** Optimitzat per a múltiples nuclis de CPU (`llvmpipe`).
* **Google Chrome:** Navegació lliure sense filtres locals.
