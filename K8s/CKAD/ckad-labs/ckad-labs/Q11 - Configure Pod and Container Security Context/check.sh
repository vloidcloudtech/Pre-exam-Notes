#!/bin/bash
# Check script for Q11 - Configure Pod and Container Security Context
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=3
print_header "Question 11 | Pod and Container Security Context"

# 1. Deployment exists
check_criterion "Deployment secure-app exists in default" \
  "$(resource_exists deploy/secure-app default)" && ((score++))

# 2. Pod-level runAsUser is 1000
run_as=$(kget deploy/secure-app default '.spec.template.spec.securityContext.runAsUser')
check_criterion "Pod-level runAsUser is 1000" \
  "$([ "$run_as" = "1000" ] && echo true || echo false)" && ((score++))

# 3. Container has NET_ADMIN capability
caps=$(kget deploy/secure-app default '.spec.template.spec.containers[?(@.name=="app")].securityContext.capabilities.add[*]')
check_criterion "Container app has NET_ADMIN capability" \
  "$(echo "$caps" | grep -q "NET_ADMIN" && echo true || echo false)" && ((score++))

print_score $score $total
