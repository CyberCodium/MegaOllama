<div align="center">

# 🦙 MegaOllama

**The ultimate interactive Bash installer and manager for 300+ Ollama AI models**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/Shell-Bash%205%2B-green.svg)](https://www.gnu.org/software/bash/)
[![Ollama](https://img.shields.io/badge/Requires-Ollama-blue.svg)](https://ollama.ai)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-lightgrey.svg)]()
[![Contributions welcome](https://img.shields.io/badge/Contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## 📖 Overview

**MegaOllama** is a powerful interactive terminal tool that turns the management of local AI models into a smooth and intuitive experience. Instead of memorising dozens of `ollama pull` commands, MegaOllama provides a rich, colour-coded menu to **browse**, **filter**, **install** and **remove** any of the 300+ models in its built-in catalogue — all without leaving your terminal.

Key highlights:
- 📦 **3,000+ curated models** with size, RAM requirements and descriptions
- 🎨 **Colour-coded TUI** — no external dependencies beyond Ollama itself
- 🔒 **Specialised sections** for Cybersecurity and Programming models
- 💾 **RAM-aware recommendations** — only shows models your machine can actually run
- 🔍 **Instant search** by name or category

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📥 Install recommended models | One-click install of the top 10 curated models |
| 🔍 Search by name | Fuzzy search through the full catalogue |
| 📂 Filter by category | Browse General, Programming, Instructive, and more |
| 📋 Full catalogue list | Paginated view of all 3,000+ models |
| 💾 RAM-based filter | Auto-detects available RAM and shows only compatible models |
| 🗑️ Uninstall models | Safely remove installed models with confirmation prompt |
| 📊 View installed models | Live list from `ollama list` |
| 🔒 Cybersecurity section | Filtered view of pentesting / security / forensics models |
| 💻 Programming section | Filtered view of code-generation models |

---

## 🖥️ Requirements

| Dependency | Version | Notes |
|-----------|---------|-------|
| [Ollama](https://ollama.ai) | ≥ 0.1.0 | Must be installed and in `PATH` |
| Bash | ≥ 5.0 | Default on most modern Linux/macOS |
| `bc` | Any | Used for size calculations |
| `sed` / `awk` | Any | POSIX standard utilities |

> **Minimum hardware:** 8 GB RAM recommended. The tool will auto-detect your available RAM and highlight compatible models.

---

## 🚀 Installation

### 1. Clone the repository

```bash
git clone https://github.com/CyberCodium/MegaOllama.git
cd MegaOllama
```

### 2. Make the script executable

```bash
chmod +x megaollama.sh
```

### 3. (Optional) Install Ollama if you haven't already

```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

### 4. Run MegaOllama

```bash
./megaollama.sh
```

---

## 🎮 Usage

Once launched, you will see the main menu:

```
╔═══════════════════════════════════════════════════════════════════╗
║    OLLAMA INSTALLER - 3000 MODELOS Y HERRAMIENTAS                 ║
║    E.B.G  | Copyright | 2026  |  All rights reserved.            ║
╚═══════════════════════════════════════════════════════════════════╝

📋 MENÚ PRINCIPAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 1) 📥 Instalar modelos principales (selección múltiple)
 2) 🔍 Buscar modelo por nombre
 3) 📂 Buscar por categoría
 4) 📋 Mostrar lista completa (300+)
 5) 💾 Instalar según RAM disponible
 6) 🗑️  Desinstalar modelo
 7) 📊 Ver modelos instalados
 8) 🔒 Modelos de Ciberseguridad
 9) 💻 Modelos de Programación
10) ❌ Salir
```

### Selecting multiple models

When prompted for a model selection, enter comma-separated numbers:

```
▶ Selecciona números (ej: 1,3,5) o 0 para TODOS: 1,3,5
```

Enter `0` to select **all** models in the current list.

### Model catalogue format

The catalogue is stored in `modelos.txt` using a simple JavaScript-style array format that the script parses at startup:

```js
{ name: "llama3.1:8b", size: 4760350489, category: "General", description: "Best balance 2024" },
```

You can extend the catalogue by adding new entries to `modelos.txt` following this exact format.

---

## 📁 Project Structure

```
MegaOllama/
├── megaollama.sh      # Main interactive script
├── modelos.txt        # Model catalogue (300+ entries in JS-array format)
├── README.md          # This file
├── LICENSE            # MIT License
├── CONTRIBUTING.md    # Contribution guidelines
└── CHANGELOG.md       # Version history
```

---

## 🔒 Security & Ethics

MegaOllama is a **download manager** — it only runs `ollama pull` and `ollama rm` commands on your behalf. No network connections are made by the script itself other than through the official Ollama CLI.

The cybersecurity model section is intended strictly for **educational, research and defensive security** purposes. Please comply with all applicable laws and regulations in your jurisdiction.

---

## 🤝 Contributing

Contributions are very welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to:

- Add new models to the catalogue
- Report bugs or request features
- Submit pull requests

---

## 📜 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a full list of changes across versions.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

Copyright © 2026 E.B.G / CyberCodium. All rights reserved.

---

## ⭐ Support

If you find MegaOllama useful, please consider giving it a ⭐ on GitHub — it helps others discover the project!

<div align="center">

Made with ❤️ by [CyberCodium](https://github.com/CyberCodium)

</div>
