# 🖥️ Escriptori Virtual al Núvol (KDE Plasma + Blender + Google Chrome)

Executa un sistema operatiu Linux complet amb **Blender** i **Google Chrome** directament al teu navegador mitjançant **GitHub Codespaces**. Funciona des de qualsevol ordinador (també Chromebooks i ordinadors amb restriccions): només cal un navegador.

[![Crea un Codespace nou a GitHub](https://github.com/codespaces/badge.svg)](https://codespaces.new/arnlopgar-debug/blender?quickstart=1)

---

## 🚀 Com funciona (100% automàtic)

1. **Prem el botó de dalt** i selecciona **Create codespace**. Cal iniciar sessió a GitHub i tenir quota de Codespaces disponible.
2. **Espera uns 5-8 minuts** la primera vegada mentre s'instal·la tot. Les vegades següents arrenca en pocs segons.
3. S'obrirà una pestanya nova amb l'escriptori. **No cal cap contrasenya.**

Si la pestanya no s'obre sola, tens dues opcions:

* Al **terminal** del Codespace apareix un requadre amb l'enllaç directe a l'escriptori: fes-hi clic.
* O ves a la pestanya **PORTS**, busca el port **6080** (*Escriptori Virtual*) i prem la icona del globus 🌐.

> ℹ️ El botó porta `?quickstart=1`: si ja tens un Codespace d'aquest repositori, el **reobre** en lloc de crear-ne un de nou.

---

## 🔓 Sense contrasenya (i per què és segur)

L'escriptori s'obre directament, **sense la finestra d'usuari i contrasenya de KasmVNC**.

És segur perquè el port 6080 del Codespace és **privat**: GitHub només deixa entrar-hi el propietari del Codespace, amb la sessió de GitHub iniciada. Ningú més hi pot accedir encara que tingui l'enllaç.

> ⚠️ **No canviïs el port 6080 a _Public_** a la pestanya PORTS si no tens contrasenya: qualsevol persona amb l'enllaç podria entrar al teu escriptori.

### Vols posar contrasenya igualment?

1. Ves a [github.com/settings/codespaces](https://github.com/settings/codespaces) → **Codespaces secrets** → **New secret**.
2. Nom: `VNC_PASSWORD`. Valor: la contrasenya que vulguis. A **Repository access** tria aquest repositori.
3. Crea un Codespace nou (o reinicia l'actual).

Des de llavors KasmVNC demanarà l'usuari **`admin`** i aquesta contrasenya. La pàgina de creació del Codespace també et deixa omplir aquest secret, però és opcional: si el deixes buit, no hi ha contrasenya.

---

## ✨ Què inclou?

| | |
| :--- | :--- |
| 🖥️ **KDE Plasma** | Escriptori en **espanyol** amb **teclat espanyol** (i anglès com a segona opció). Sense animacions, sense indexador de fitxers i sense pantalla de càrrega, perquè vagi més ràpid. La pantalla no s'apaga ni es bloqueja mai. |
| 🎨 **Blender** | Renderitzat per CPU amb tots els nuclis disponibles (`llvmpipe`). |
| 🌐 **Google Chrome** | Preparat per funcionar dins del contenidor i configurat com a navegador per defecte. |
| 📡 **KasmVNC** | Imatge comprimida al navegador, porta-retalls compartit (copiar i enganxar entre el teu ordinador i l'escriptori) i resolució que s'adapta a la mida de la finestra. |
| 📁 **Accessos directes** | A l'escriptori hi trobaràs Blender, Google Chrome, Konsole (terminal), Dolphin (fitxers) i la carpeta **Projecte**. |
| 🔄 **Vigilant automàtic** | Comprova cada 30 segons que l'escriptori respon. Si cau, el torna a arrencar sol. |
| 🔗 **Enllaç al terminal** | Cada vegada que obres el terminal del Codespace es mostra l'enllaç directe a l'escriptori. |

---

## 🛠️ Si l'escriptori no apareix o es penja

Obre el terminal del Codespace (a VS Code: menú ☰ → **Terminal** → **New Terminal**) i escriu:

```bash
escriptori
```

Això reinicia l'escriptori i torna a mostrar l'enllaç. Normalment no caldrà, perquè el vigilant automàtic ja el reinicia sol.

Si encara falla, aquests registres diuen què passa:

```bash
cat /tmp/vnc.log          # arrencada de KasmVNC
tail -n 50 ~/.vnc/*.log   # registre de l'escriptori
cat /tmp/vigilant.log     # reinicis automàtics
```

### El meu Codespace és d'abans d'aquests canvis

Els canvis d'aquest repositori només s'apliquen als Codespaces **nous**. Si el teu es va crear abans:

1. Ves a [github.com/codespaces](https://github.com/codespaces).
2. Al teu Codespace, prem **⋯** → **Delete** (abans, desa el que vulguis conservar).
3. Torna aquí i prem el botó per crear-ne un de nou.

---

## 💡 Consells

* **Desa la feina a la carpeta _Projecte_** de l'escriptori: és aquest repositori, i el que hi guardis ho pots pujar a GitHub fent *commit*. La resta de fitxers es mantenen mentre no esborris el Codespace.
* El Codespace **s'atura sol** després d'un temps sense ús, per estalviar quota. En tornar-lo a obrir, l'escriptori arrenca automàticament.
* Per a Blender va millor una màquina de **4 nuclis** (es tria a **Create codespace → Machine type**), però gasta la quota gratuïta el doble de ràpid.
* Si el teclat escriu caràcters estranys, canvia la disposició amb la icona del teclat de la barra de tasques (ES ↔ US).

---

## ⚙️ Com està fet (per a curiosos)

| Fitxer | Què fa |
| :--- | :--- |
| `.devcontainer/devcontainer.json` | Defineix el Codespace: Ubuntu 24.04, 2 GB de memòria compartida (perquè Chrome no es pengi), el port 6080 i el secret opcional `VNC_PASSWORD`. |
| `.devcontainer/setup.sh` | S'executa **un cop**, en crear el Codespace: instal·la KDE, Blender, Chrome i KasmVNC i ho configura tot. |
| `.devcontainer/start-vnc.sh` | S'executa **cada cop** que s'engega el Codespace (i amb l'ordre `escriptori`): arrenca l'escriptori i el vigilant. |
| `.devcontainer/vigilant.sh` | Reinicia l'escriptori si deixa de respondre. |
| `.devcontainer/info.sh` | Mostra l'enllaç de l'escriptori al terminal. |
