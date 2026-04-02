
<div align="center">

```
╔══════════════════════════════════════════════════════════════════╗
║            M E G A O L L A M A                                  ║
║            Instalador de +3000 Modelos Ollama                   ║
║                                                                  ║
║   Copyright  ©  E.B.G  |  2026  |  All Rights Reserved         ║
╚══════════════════════════════════════════════════════════════════╝
```

[![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Ollama](https://img.shields.io/badge/Powered%20by-Ollama-black)](https://ollama.ai)
[![License](https://img.shields.io/badge/License-Proprietary-red)](LICENSE)
[![Author](https://img.shields.io/badge/Author-E.B.G-blueviolet)]()

</div>

---

## 📌 Descripción

**MegaOllama** es un conjunto de herramientas en Bash para instalar, gestionar y explorar más de **3000 modelos de IA** a través de [Ollama](https://ollama.ai). Incluye dos scripts:

| Script | Descripción |
|--------|-------------|
| `megaollama.sh` | Instalador clásico basado en terminal (menú de texto) |
| `remastergui.sh` | **Remaster GUI** – Interfaz gráfica con `whiptail`/`dialog` |

Ambos leen el catálogo de modelos desde `modelos.txt` y permiten:

- 📥 Instalación de modelos individuales o en lote
- 🔍 Búsqueda por nombre y por categoría
- 💾 Filtrado por RAM disponible del sistema
- 🔒 Catálogo especializado en **Ciberseguridad**
- 💻 Catálogo especializado en **Programación**
- 🗑️ Desinstalación de modelos
- 📊 Visualización de modelos instalados

---

## 🚀 Requisitos

- **Sistema operativo**: Linux (Debian/Ubuntu/Fedora/Arch)
- **Ollama**: instalado y disponible en `$PATH`
- **Bash** 4.0+
- **`whiptail`** o **`dialog`** *(solo para `remastergui.sh`)*
- Archivo **`modelos.txt`** en la misma carpeta que el script

### Instalar Ollama

```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

### Instalar dependencia GUI

```bash
# Debian / Ubuntu
sudo apt install whiptail

# Fedora / RHEL
sudo dnf install newt

# Arch Linux
sudo pacman -S libnewt
```

---

## 📂 Estructura del Proyecto

```
MegaOllama/
├── megaollama.sh      # Instalador clásico (terminal)
├── remastergui.sh     # Remaster GUI (interfaz gráfica)
├── modelos.txt        # Catálogo de modelos (formato JS)
├── LICENSE            # Licencia propietaria – E.B.G
└── README.md          # Este archivo
```

---

## ▶️ Uso

### Instalador clásico

```bash
chmod +x megaollama.sh
./megaollama.sh
```

### Remaster GUI

```bash
chmod +x remastergui.sh
./remastergui.sh
```

---

## 📋 Formato de `modelos.txt`

El archivo debe contener el catálogo en formato JavaScript:

```javascript
const OLLAMA_MODELS_CATALOGUE = [
    { name: "llama3:8b", size: 4760350489, category: "General", description: "Modelo base Meta 2024" },
    { name: "mistral:7b", size: 4109865856, category: "General", description: "Modelo Mistral AI 7B" },
    // ...
];
```

---

## 🔒 Modelos de Ciberseguridad

Sección especializada con modelos orientados a:

> Pentesting · Hacking · Malware Analysis · Forensics · Exploit Development  
> Web Security · Network Security · Cloud Security · Mobile Security · OSINT

---

## 💻 Modelos de Programación

Sección especializada con modelos orientados a:

> Python · JavaScript · Java · C++ · Go · Rust · TypeScript · SQL  
> CodeLlama · StarCoder · WizardCoder · DeepSeek Coder · Qwen Coder

---

## ⚖️ Licencia

Este proyecto es **software propietario**.  
Consulta el archivo [LICENSE](LICENSE) para más detalles.

```
Copyright © E.B.G  |  2026  |  All Rights Reserved
Uso personal/educativo permitido. Distribución y uso comercial prohibidos.
```

---

<div align="center">
  Hecho con ❤️ por <strong>E.B.G</strong> &nbsp;|&nbsp; 2026
</div>
