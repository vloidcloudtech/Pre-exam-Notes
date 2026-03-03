#!/bin/bash
# Master setup - runs all or specific question setups
# Usage: ./setup-all.sh        (all questions)
#        ./setup-all.sh 1 3 8  (specific questions)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================="
echo "  CKAD Practice Questions - Lab Setup"
echo "============================================="

if [ $# -eq 0 ]; then
  for d in "$SCRIPT_DIR"/Q*/; do
    [ -f "$d/setup.sh" ] && echo "" && bash "$d/setup.sh"
  done
else
  for q in "$@"; do
    PADDED=$(printf "Q%02d" "$q")
    MATCH=$(find "$SCRIPT_DIR" -maxdepth 1 -type d -name "${PADDED} -*" | head -1)
    if [ -n "$MATCH" ] && [ -f "$MATCH/setup.sh" ]; then
      echo "" && bash "$MATCH/setup.sh"
    else
      echo "WARNING: No setup found for question $q"
    fi
  done
fi

echo ""
echo "============================================="
echo "Setup complete!"
echo "============================================="
