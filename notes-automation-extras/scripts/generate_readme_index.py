#!/usr/bin/env python3
import re, os, pathlib, datetime
ROOT = pathlib.Path("."); PROB = ROOT/"problems"; NOTE = ROOT/"notes"; README = ROOT/"README.md"
def parse(path):
    t = path.read_text(encoding="utf-8", errors="ignore"); date=""; body=t
    if t.startswith("---"):
        parts = t.split("---",2)
        if len(parts)>=3:
            for line in parts[1].splitlines():
                if line.lower().startswith("date:"): date=line.split(":",1)[1].strip()
            body = parts[2]
    m = re.search(r'^\s*#\s+(.+)$', body, flags=re.M)
    title = m.group(1).strip() if m else path.stem
    return date, title
def collect(folder, prefix):
    out=[]
    if folder.exists():
        for p in sorted(folder.glob("*.md")):
            d,t = parse(p); out.append({"date": d, "title": t, "href": f"{prefix}/{p.stem}.md"})
    def key(e):
        try: return (datetime.datetime.strptime(e["date"], "%Y-%m-%d"), e["title"])
        except: return (datetime.datetime.min, e["title"])
    out.sort(key=key, reverse=True); return out
def section(title, entries, limit=10):
    lines=[f"### {title}",""]
    if not entries:
        lines.append("_No entries yet._"); return "\n".join(lines)
    for e in entries[:limit]:
        d=e["date"] or "—"; lines.append(f"- **{d}** — [{e['title']}]({e['href']})")
    lines.append(""); return "\n".join(lines)
START="<!-- AUTOGEN:START -->"; END="<!-- AUTOGEN:END -->"
problems=collect(PROB,"problems"); notes=collect(NOTE,"notes")
auto="## Research Index\n\n"+section("Latest Problems",problems)+"\n"+section("Latest Notes",notes)
content = README.read_text(encoding="utf-8") if README.exists() else "# Research Notes\n\n"
if START in content and END in content:
    new=re.sub(f"{START}.*?{END}", f"{START}\n{auto}\n{END}", content, flags=re.S)
else:
    new=content.rstrip()+"\n\n"+START+"\n"+auto+"\n"+END+"\n"
README.write_text(new, encoding="utf-8"); print("Updated README.md")
