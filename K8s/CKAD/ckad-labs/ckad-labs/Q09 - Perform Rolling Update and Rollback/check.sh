#!/bin/bash
# Check script for Q9 - Perform Rolling Update and Rollback
# NOTE: This checks the FINAL state after rollback (nginx:1.20)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=3
print_header "Question 9 | Rolling Update and Rollback"

# 1. Deployment exists
check_criterion "Deployment app-v1 exists in default" \
  "$(resource_exists deploy/app-v1 default)" && ((score++))

# 2. Image is back to nginx:1.20 (after rollback)
image=$(kget deploy/app-v1 default '.spec.template.spec.containers[0].image')
check_criterion "Image is nginx:1.20 (rollback successful)" \
  "$([ "$image" = "nginx:1.20" ] && echo true || echo false)" && ((score++))

# 3. Rollout history has more than 1 revision (proves update happened)
rev_count=$(kubectl rollout history deploy app-v1 -n default 2>/dev/null | grep -c "^[0-9]")
check_criterion "Rollout history shows multiple revisions" \
  "$([ "$rev_count" -gt 1 ] 2>/dev/null && echo true || echo false)" && ((score++))

print_score $score $total
