#!/bin/bash
# Check script for Q13 - Create NodePort Service
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=4
print_header "Question 13 | Create NodePort Service"

# 1. Service exists
check_criterion "Service api-nodeport exists in default" \
  "$(resource_exists svc/api-nodeport default)" && ((score++))

# 2. Type is NodePort
svc_type=$(kget svc/api-nodeport default '.spec.type')
check_criterion "Service type is NodePort" \
  "$([ "$svc_type" = "NodePort" ] && echo true || echo false)" && ((score++))

# 3. Selector is app=api
svc_sel=$(kget svc/api-nodeport default '.spec.selector.app')
check_criterion "Selector is app=api" \
  "$([ "$svc_sel" = "api" ] && echo true || echo false)" && ((score++))

# 4. Port 80 -> targetPort 9090
svc_port=$(kget svc/api-nodeport default '.spec.ports[0].port')
tgt_port=$(kget svc/api-nodeport default '.spec.ports[0].targetPort')
check_criterion "Port 80 maps to targetPort 9090" \
  "$([ "$svc_port" = "80" ] && [ "$tgt_port" = "9090" ] && echo true || echo false)" && ((score++))

print_score $score $total
