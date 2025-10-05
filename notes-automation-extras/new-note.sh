#!/usr/bin/env bash
set -e
[ -z "$1" ] && { echo "Usage: $0 \"Short title\" [-t tag1,tag2]"; exit 1; }
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
[ -f "$FILE" ] && { echo "Error: $FILE exists" >&2; exit 2; }
cat > "$FILE" <<EOT
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
EOT
echo "Created: $FILE"
