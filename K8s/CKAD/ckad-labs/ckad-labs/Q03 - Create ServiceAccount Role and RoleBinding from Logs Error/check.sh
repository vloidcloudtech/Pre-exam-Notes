#!/bin/bash
# Check script for Q3 - Create ServiceAccount, Role, and RoleBinding
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=5
print_header "Question 3 | ServiceAccount, Role, and RoleBinding"

# 1. ServiceAccount log-sa exists
check_criterion "ServiceAccount log-sa exists in audit" \
  "$(resource_exists sa/log-sa audit)" && ((score++))

# 2. Role log-role exists
check_criterion "Role log-role exists in audit" \
  "$(resource_exists role/log-role audit)" && ((score++))

# 3. Role has correct verbs on pods
verbs=$(kubectl get role log-role -n audit -o jsonpath='{.rules[0].verbs[*]}' 2>/dev/null)
has_verbs=false
echo "$verbs" | grep -q "get" && echo "$verbs" | grep -q "list" && echo "$verbs" | grep -q "watch" && has_verbs=true
check_criterion "Role log-role grants get, list, watch on pods" "$has_verbs" && ((score++))

# 4. RoleBinding log-rb exists
check_criterion "RoleBinding log-rb exists in audit" \
  "$(resource_exists rolebinding/log-rb audit)" && ((score++))

# 5. Pod log-collector uses log-sa
pod_sa=$(kget pod/log-collector audit '.spec.serviceAccountName')
check_criterion "Pod log-collector uses ServiceAccount log-sa" \
  "$([ "$pod_sa" = "log-sa" ] && echo true || echo false)" && ((score++))

print_score $score $total
