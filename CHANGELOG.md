# Changelog

All notable changes to **MegaOllama** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Pagination for the full catalogue list (option 4)
- Export installed model list to JSON/CSV
- Automatic Ollama update checker
- Multi-language support (EN/ES)

---

## [1.1.0] — 2026-04-02

### Added
- `README.md` — comprehensive documentation with badges, usage guide and project structure
- `LICENSE` — MIT License
- `CONTRIBUTING.md` — contributor guidelines including model catalogue format
- `CHANGELOG.md` — this file
- `.gitignore` — standard Bash/shell project ignores

### Changed
- Script renamed from `script-ollama.sh` to `megaollama.sh` for clarity

---

## [1.0.0] — 2026-01-01

### Added
- Interactive TUI main menu with 10 options
- Colour-coded output using ANSI escape codes
- Model catalogue loaded from external `modelos.txt` file (300+ models)
- Option 1 — Install recommended models with multi-selection support
- Option 2 — Search model by name
- Option 3 — Filter models by category
- Option 4 — Full catalogue list with install prompt
- Option 5 — RAM-aware model recommendations (auto-detects system RAM)
- Option 6 — Uninstall model with confirmation prompt
- Option 7 — View currently installed models via `ollama list`
- Option 8 — Cybersecurity specialised section (filtered by security keywords)
- Option 9 — Programming specialised section (filtered by coding keywords)
- `calc_ram()` helper — converts model byte size to human-readable RAM requirement
- `format_size()` helper — converts byte sizes to MB/GB display strings
- Ollama installation check at startup with helpful install instructions
- `modelos.txt` catalogue with 300+ models across categories including:
  - General purpose (LLaMA, Mistral, Gemma, Phi, Qwen, …)
  - Code generation (CodeLlama, DeepSeek Coder, StarCoder, WizardCoder, …)
  - Cybersecurity (pentesting, forensics, OSCP, malware analysis, …)
  - Lightweight models (sub-2 GB for low-resource machines)
  - Gigantic models (70B+ for multi-GPU setups)

---

[Unreleased]: https://github.com/CyberCodium/MegaOllama/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/CyberCodium/MegaOllama/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/CyberCodium/MegaOllama/releases/tag/v1.0.0
