#!/bin/bash
# Master Lab Setup Script for CKAD Practice Questions
# Usage:
#   ./setup-all.sh          # Setup all questions
#   ./setup-all.sh 1 3 8    # Setup specific questions only
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -eq 0 ]; then
  QUESTIONS=$(seq 1 16)
else
  QUESTIONS="$@"
fi

echo "============================================="
echo "  CKAD Practice Questions - Lab Setup"
echo "============================================="
echo ""

FAILED=()

for q in $QUESTIONS; do
  PADDED=$(printf "%02d" "$q")
  SCRIPT="$SCRIPT_DIR/q${PADDED}-setup.sh"

  if [ ! -f "$SCRIPT" ]; then
    echo "⚠️  Script not found: $SCRIPT"
    FAILED+=("Q$q")
    continue
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  bash "$SCRIPT"
  if [ $? -ne 0 ]; then
    FAILED+=("Q$q")
    echo "❌ Q$q setup failed!"
  fi
  echo ""
done

echo "============================================="
if [ ${#FAILED[@]} -eq 0 ]; then
  echo "✅ All lab setups completed successfully!"
else
  echo "⚠️  Failed setups: ${FAILED[*]}"
fi
echo "============================================="
