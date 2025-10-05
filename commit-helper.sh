#!/usr/bin/env bash
set -e
TYPE="feat"; BLOCK=""; MSG=""
while getopts "t:b:m:h" opt; do
  case "$opt" in
    t) TYPE="$OPTARG" ;;
    b) BLOCK="$OPTARG" ;;
    m) MSG="$OPTARG" ;;
    h) echo "Usage: $0 [-t type] [-b 1|2|3] -m \"message\""; exit 0 ;;
  esac
done
[ -z "$MSG" ] && { echo "Error: please provide a commit message with -m" >&2; exit 1; }
if [ -z "$BLOCK" ]; then
  H=$(date +%H); M=$(date +%M); MIN=$((10#$H*60 + 10#$M))
  if [ $MIN -ge 450 ] && [ $MIN -lt 810 ]; then BLOCK=1
  elif [ $MIN -ge 840 ] && [ $MIN -lt 1200 ]; then BLOCK=2
  elif [ $MIN -ge 1230 ] || [ $MIN -lt 150 ]; then BLOCK=3
  else BLOCK=3
  fi
fi
DATE=$(date +%F)
git add -A
git commit -m "$TYPE($DATE-b$BLOCK): $MSG"
