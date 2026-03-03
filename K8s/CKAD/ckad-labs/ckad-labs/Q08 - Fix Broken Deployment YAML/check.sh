#!/bin/bash
# Check script for Q8 - Fix Broken Deployment YAML
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=4
print_header "Question 8 | Fix Broken Deployment YAML"

# 1. Deployment broken-app exists
check_criterion "Deployment broken-app exists in default" \
  "$(resource_exists deploy/broken-app default)" && ((score++))

# 2. Uses apps/v1 API (if it exists, it passed this)
api=$(kubectl get deploy broken-app -n default -o jsonpath='{.apiVersion}' 2>/dev/null)
check_criterion "apiVersion is apps/v1" \
  "$([ "$api" = "apps/v1" ] && echo true || echo false)" && ((score++))

# 3. selector matches template labels
selector=$(kget deploy/broken-app default '.spec.selector.matchLabels.app')
tmpl_label=$(kget deploy/broken-app default '.spec.template.metadata.labels.app')
check_criterion "Selector matchLabels matches template labels" \
  "$([ -n "$selector" ] && [ "$selector" = "$tmpl_label" ] && echo true || echo false)" && ((score++))

# 4. Deployment is available
avail=$(kubectl get deploy broken-app -n default -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
check_criterion "Deployment has available replicas" \
  "$([ -n "$avail" ] && [ "$avail" -gt 0 ] 2>/dev/null && echo true || echo false)" && ((score++))

print_score $score $total
