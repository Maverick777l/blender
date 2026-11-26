# 🖥️ Escriptori Virtual al Núvol (KDE Plasma + Blender + Google Chrome)

Executa un sistema operatiu complet amb **Blender** i **Google Chrome** directament al teu navegador mitjançant **GitHub Codespaces**.

[![Crea un Codespace nou a GitHub](https://github.com/codespaces/badge.svg)](https://codespaces.new/arnlopgar-debug/blender?quickstart=1)

---

## 🚀 Com funciona (100% automàtic)

1. **Prem el botó de dalt** i selecciona **Create codespace**. Cal iniciar sessió a GitHub i tenir quota de Codespaces disponible.
2. **Espera uns 5-8 minuts** la primera vegada mentre s'instal·la tot. Les vegades següents arrenca en pocs segons.
3. S'obrirà una pestanya nova amb l'escriptori. **No cal cap contrasenya.**
   - Si no s'obre sola: al terminal apareix l'enllaç de l'escriptori, o ves a la pestanya **PORTS**, busca el port **6080** i prem el globus 🌐.

---

## 🔓 Sense contrasenya

L'escriptori s'obre directament, sense la finestra d'usuari i contrasenya de KasmVNC.
És segur perquè el port del Codespace és **privat**: només hi pots entrar tu, amb la sessió de GitHub iniciada.

> ⚠️ No posis el port 6080 com a **Public** a la pestanya PORTS si no tens contrasenya: qualsevol persona amb l'enllaç hi podria entrar.

**Vols contrasenya igualment?** Crea un secret de Codespaces anomenat `VNC_PASSWORD` a
[github.com/settings/codespaces](https://github.com/settings/codespaces) (o omple'l a la pàgina de creació del Codespace). Llavors KasmVNC demanarà l'usuari `admin` i aquesta contrasenya.

---

## 🛠️ Si l'escriptori no apareix

Obre el terminal del Codespace i escriu:

```bash
escriptori
```

Això reinicia l'escriptori i torna a mostrar l'enllaç. Si encara falla, mira el registre amb `cat /tmp/vnc.log` i `tail -n 50 ~/.vnc/*.log`.

Si el Codespace es va crear abans d'aquest arreglament, esborra'l a [github.com/codespaces](https://github.com/codespaces) i crea'n un de nou amb el botó (el botó reobre el Codespace antic si ja n'hi ha un).

---

## ✨ Què inclou?

* **KDE Plasma** en espanyol, amb teclat espanyol, sense animacions ni indexador de fitxers (va més ràpid).
* **Accessos directes a l'escriptori:** Blender, Google Chrome, Konsole, Dolphin i la carpeta **Projecte** (el repositori: el que hi guardis ho pots pujar a GitHub).
* **KasmVNC:** imatge comprimida al navegador, amb porta-retalls compartit i resolució que s'adapta a la finestra.
* **Blender:** renderitzat per CPU amb tots els nuclis (`llvmpipe`).
* **Google Chrome:** preparat per funcionar dins del contenidor.

## 💡 Consells

* Els fitxers fora de la carpeta **Projecte** es mantenen mentre no esborris el Codespace, però per no perdre res, desa la feina a **Projecte** i fes *commit*.
* El Codespace s'atura sol després d'un temps sense ús (per estalviar quota). En tornar-lo a obrir, l'escriptori arrenca automàticament.
* Per a Blender va millor una màquina de 4 nuclis (es tria a **Create codespace → Machine type**), però gasta la quota el doble de ràpid.
