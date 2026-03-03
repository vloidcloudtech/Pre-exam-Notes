#!/bin/bash
# Check script for Q6 - Canary Deployment with Manual Traffic Split
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=4
print_header "Question 6 | Canary Deployment with Manual Traffic Split"

# 1. web-app scaled to 8
replicas=$(kget deploy/web-app default '.spec.replicas')
check_criterion "Deployment web-app has 8 replicas" \
  "$([ "$replicas" = "8" ] && echo true || echo false)" && ((score++))

# 2. web-app-canary exists
check_criterion "Deployment web-app-canary exists" \
  "$(resource_exists deploy/web-app-canary default)" && ((score++))

# 3. web-app-canary has 2 replicas
canary_replicas=$(kget deploy/web-app-canary default '.spec.replicas')
check_criterion "Deployment web-app-canary has 2 replicas" \
  "$([ "$canary_replicas" = "2" ] && echo true || echo false)" && ((score++))

# 4. web-app-canary has label app=webapp (so Service selects it)
canary_label=$(kget deploy/web-app-canary default '.spec.template.metadata.labels.app')
check_criterion "Canary pods have label app=webapp" \
  "$([ "$canary_label" = "webapp" ] && echo true || echo false)" && ((score++))

print_score $score $total
