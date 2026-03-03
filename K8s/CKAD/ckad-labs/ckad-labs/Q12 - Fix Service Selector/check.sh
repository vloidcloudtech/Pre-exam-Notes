#!/bin/bash
# Check script for Q12 - Fix Service Selector
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=3
print_header "Question 12 | Fix Service Selector"

# 1. Service exists
check_criterion "Service web-svc exists in default" \
  "$(resource_exists svc/web-svc default)" && ((score++))

# 2. Selector is app=webapp
svc_sel=$(kget svc/web-svc default '.spec.selector.app')
check_criterion "Service selector is app=webapp" \
  "$([ "$svc_sel" = "webapp" ] && echo true || echo false)" && ((score++))

# 3. Endpoints are populated
ep_count=$(kubectl get endpoints web-svc -n default -o jsonpath='{.subsets[0].addresses}' 2>/dev/null | grep -c "ip")
check_criterion "Service has active endpoints" \
  "$([ "$ep_count" -gt 0 ] 2>/dev/null && echo true || echo false)" && ((score++))

print_score $score $total
