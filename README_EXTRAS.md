# Notes Automation — Extras

This adds:
- `new-note.sh` — create dated Markdown notes in `notes/`.
- `scripts/generate_readme_index.py` — updates `README.md` with the latest 10 problems and notes between markers.

## Quick start
1. Copy these files into your repo root (alongside `new-problem.sh` etc.).
2. Make the scripts executable:
   ```bash
   chmod +x new-note.sh scripts/generate_readme_index.py
   ```
3. Create a note:
   ```bash
   ./new-note.sh "Reading: FOAG 12.3 — Ampleness" -t reading,foag
   ```
4. Update README index (run locally before commit):
   ```bash
   python3 scripts/generate_readme_index.py
   ```
5. Commit and push.
