#!/bin/bash
# Check script for Q7 - Fix NetworkPolicy by Updating Pod Labels
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=3
print_header "Question 7 | Fix NetworkPolicy by Updating Pod Labels"

# 1. frontend has role=frontend
fe_role=$(kget pod/frontend network-demo '.metadata.labels.role')
check_criterion "Pod frontend has label role=frontend" \
  "$([ "$fe_role" = "frontend" ] && echo true || echo false)" && ((score++))

# 2. backend has role=backend
be_role=$(kget pod/backend network-demo '.metadata.labels.role')
check_criterion "Pod backend has label role=backend" \
  "$([ "$be_role" = "backend" ] && echo true || echo false)" && ((score++))

# 3. database has role=db
db_role=$(kget pod/database network-demo '.metadata.labels.role')
check_criterion "Pod database has label role=db" \
  "$([ "$db_role" = "db" ] && echo true || echo false)" && ((score++))

print_score $score $total
