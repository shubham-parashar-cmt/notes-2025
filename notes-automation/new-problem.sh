#!/usr/bin/env bash
set -e
if [ -z "$1" ]; then
  echo "Usage: $0 \"Short title\" [-b 1|2|3] [-t tags]" >&2
  exit 1
fi
TITLE="$1"; shift
BLOCK=""; TAGS="sheaves,cohomology"
while getopts "b:t:h" opt; do
  case "$opt" in
    b) BLOCK="$OPTARG" ;;
    t) TAGS="$OPTARG" ;;
    h) echo "Usage: $0 \"Short title\" [-b 1|2|3] [-t tags]" ; exit 0 ;;
  esac
done
DATE=$(date +%F)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
DIR="problems"; mkdir -p "$DIR"
FILE="$DIR/${DATE}_${SLUG}.md"
if [ -f "$FILE" ]; then echo "Error: $FILE exists" >&2; exit 2; fi
TEMPLATE="problems/problem_log_template.md"
[ -f "$TEMPLATE" ] || TEMPLATE="templates/problem_log_template.md"
if [ -f "$TEMPLATE" ]; then
  awk -v d="$DATE" -v b="${BLOCK:-b1}" -v t="$TAGS" -v ttl="$TITLE" '
    BEGIN{ fc=0 }
    /^---$/ {fc++; print; next}
    { if (fc==1 && $0 ~ /^date:/) { print "date: " d; next }
      if (fc==1 && $0 ~ /^block:/) { print "block: " b; next }
      if (fc==1 && $0 ~ /^tags:/)  { print "tags: [" t "]"; next }
    }
    { gsub(/<short title>/, ttl); print }
  ' "$TEMPLATE" > "$FILE"
else
  cat > "$FILE" <<EOF
---
date: ${DATE}
block: ${BLOCK:-b1}
project: <topic/area>
status: exploring
tags: [${TAGS}]
---
# Problem Log — ${TITLE}
**Goal (1 sentence):**  <state the statement>
## Statement / Setup
-
## Attempts
-
## Obstacle
-
## Next step
-
## References
-
EOF
fi
echo "Created: $FILE"
