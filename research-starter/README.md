# Research Starter

Zero-setup LaTeX + hygiene for math notes.

## Quick start
1. **Devcontainer (VS Code)**: Open repo in container. It installs LaTeX, `pre-commit`, `codespell`, etc.
2. Build PDF: `make pdf` → `main.pdf`
3. Hygiene: `pre-commit install` (already in postCreate) → commits are auto-checked.
4. CI: Every push runs **build-latex** and uploads `main.pdf` as an artifact.
5. (Optional) Deploy: Put rendered files in `./public` and enable **deploy-pages** workflow.

## Files
- `main.tex` — starter TeX (XeLaTeX)
- `Makefile` — `pdf`, `clean`, `check`
- `.pre-commit-config.yaml` — tidy, spellcheck, Ruff/Black for Python helpers
- `.devcontainer/` — containerized toolchain
- `.github/workflows/` — Actions for PDF and Pages
- `CITATION.cff` — easy citation metadata
