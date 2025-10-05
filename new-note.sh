#!/usr/bin/env bash
# new-note.sh "Short title here" [-t tag1,tag2]
# Creates notes/YYYY-MM-DD_slug.md with frontmatter + H1.
set -e
if [ -z "$1" ]; then
  echo "Usage: $0 \"Short title\" [-t tags]" >&2
  exit 1
fi
TITLE="$1"; shift
TAGS="reading"
while getopts "t:h" opt; do
  case "$opt" in
    t) TAGS="$OPTARG" ;;
    h) echo "Usage: $0 \"Short title\" [-t tags]"; exit 0 ;;
  esac
done
DATE=$(date +%F)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
DIR="notes"; mkdir -p "$DIR"
FILE="$DIR/${DATE}_${SLUG}.md"
if [ -f "$FILE" ]; then echo "Error: $FILE exists" >&2; exit 2; fi
cat > "$FILE" <<EOF
---
date: ${DATE}
tags: [${TAGS}]
status: note
---

# Note — ${TITLE}

**Summary (2–3 lines):**

-

**References / Links:**

-
EOF
echo "Created: $FILE"
