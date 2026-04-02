# Contributing to MegaOllama

Thank you for taking the time to contribute! 🎉  
All contributions — bug reports, feature suggestions, documentation improvements and new model entries — are welcome.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Features](#suggesting-features)
  - [Adding Models to the Catalogue](#adding-models-to-the-catalogue)
  - [Submitting a Pull Request](#submitting-a-pull-request)
- [Development Guidelines](#development-guidelines)
- [Commit Message Style](#commit-message-style)

---

## Code of Conduct

By participating in this project you agree to treat all contributors with respect. Harassment, discrimination or hostile behaviour of any kind will not be tolerated.

---

## How to Contribute

### Reporting Bugs

1. Search [existing issues](https://github.com/CyberCodium/MegaOllama/issues) to avoid duplicates.
2. Open a new issue and include:
   - A clear and descriptive title.
   - Steps to reproduce the problem.
   - Expected vs. actual behaviour.
   - Your OS, Bash version (`bash --version`) and Ollama version (`ollama --version`).

### Suggesting Features

Open an issue with the `enhancement` label and describe:
- The problem you are trying to solve.
- Your proposed solution or idea.
- Any alternatives you considered.

### Adding Models to the Catalogue

The model catalogue lives in `modelos.txt`. Each entry follows this exact format on **a single line**:

```js
{ name: "model-name:tag", size: <bytes_as_integer>, category: "Category", description: "Short description" },
```

**Rules:**
- `name` must match the exact Ollama model name (verified on [ollama.com/library](https://ollama.com/library)).
- `size` is the download size in bytes. Use `0` if unknown.
- `category` should reuse an existing category where possible (e.g. `"Programación"`, `"General"`, `"Instructivo"`).
- `description` must be short (≤ 60 characters), in the same language as surrounding entries.
- Group new entries under the appropriate `// ========== SECTION ==========` comment.

After adding entries, test locally:

```bash
chmod +x megaollama.sh
./megaollama.sh  # choose option 4 to verify your entries appear
```

### Submitting a Pull Request

1. Fork the repository and create a branch from `main`:
   ```bash
   git checkout -b feat/my-new-feature
   ```
2. Make your changes following the [development guidelines](#development-guidelines) below.
3. Commit using the [commit message style](#commit-message-style).
4. Push your branch and open a Pull Request against `main`.
5. Fill in the Pull Request template, explaining *what* and *why*.

---

## Development Guidelines

- **Shell style**: Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html).
- **Compatibility**: Script must run on **Bash ≥ 5.0** on both Linux and macOS.
- **No external dependencies**: Do not introduce dependencies beyond `bash`, `bc`, `sed`, `awk` and `ollama`.
- **Colour output**: Use the existing colour variables (`$RED`, `$GREEN`, etc.). Do not hard-code ANSI escape codes inline.
- **Error handling**: Always validate user input and provide clear error messages.
- **Modular functions**: Keep each feature in its own clearly labelled function (see numbered sections in `megaollama.sh`).

---

## Commit Message Style

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>
```

| Type | When to use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code change without feature/fix |
| `chore` | Build process or tooling changes |
| `models` | Adding/updating model catalogue entries |

**Examples:**
```
feat(menu): add pagination for long model lists
fix(ram): correct byte-to-GB conversion for macOS sysctl
models(security): add 5 new OSCP-focused models
docs(readme): update installation section
```

---

Thank you for helping make MegaOllama better! 🚀
