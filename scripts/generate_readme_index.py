#!/usr/bin/env python3

import re, sys, os, pathlib, datetime, html

ROOT = pathlib.Path(".")
PROB_DIR = ROOT / "problems"
NOTE_DIR = ROOT / "notes"
README = ROOT / "README.md"

def parse_frontmatter_and_title(path: pathlib.Path):
    text = path.read_text(encoding="utf-8", errors="ignore")
    date = ""
    # frontmatter
    if text.startswith("---"):
        parts = text.split("---", 2)
        if len(parts) >= 3:
            fm = parts[1]
            for line in fm.splitlines():
                if line.lower().startswith("date:"):
                    date = line.split(":",1)[1].strip()
            body = parts[2]
        else:
            body = text
    else:
        body = text
    # title
    m = re.search(r'^\s*#\s+(.+)$', body, flags=re.M)
    title = m.group(1).strip() if m else path.stem
    return date, title

def collect_entries(folder: pathlib.Path, prefix: str):
    out = []
    if not folder.exists():
        return out
    for p in sorted(folder.glob("*.md")):
        date, title = parse_frontmatter_and_title(p)
        out.append({
            "date": date,
            "title": title,
            "href": f"{prefix}/{p.stem}.md"  # link to the markdown in repo view
        })
    # sort newest first
    def key(e):
        try:
            return (datetime.datetime.strptime(e["date"], "%Y-%m-%d"), e["title"])
        except Exception:
            return (datetime.datetime.min, e["title"])
    out.sort(key=key, reverse=True)
    return out

def build_section(title, entries, limit=10):
    lines = [f"### {title}", ""]
    if not entries:
        lines.append("_No entries yet._")
        return "\n".join(lines)
    for e in entries[:limit]:
        d = e["date"] or "—"
        lines.append(f"- **{d}** — [{e['title']}]({e['href']})")
    lines.append("")
    return "\n".join(lines)

START = "<!-- AUTOGEN:START -->"
END   = "<!-- AUTOGEN:END -->"

problems = collect_entries(PROB_DIR, "problems")
notes    = collect_entries(NOTE_DIR, "notes")

auto = []
auto.append("## Research Index")
auto.append("")
auto.append(build_section("Latest Problems", problems))
auto.append(build_section("Latest Notes", notes))
auto_text = "\n".join(auto)

if README.exists():
    content = README.read_text(encoding="utf-8")
else:
    content = "# Research Notes\n\nThis repository contains my math research notes and problem logs.\n\n"

if START in content and END in content:
    new_content = re.sub(f"{START}.*?{END}", f"{START}\n{auto_text}\n{END}", content, flags=re.S)
else:
    new_content = content.rstrip() + "\n\n" + START + "\n" + auto_text + "\n" + END + "\n"

README.write_text(new_content, encoding="utf-8")
print("Updated README.md with latest index.")
