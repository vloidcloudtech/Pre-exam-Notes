#!/bin/bash
# Check script for Q16 - Add Resource Requests and Limits to Pod
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=5
print_header "Question 16 | Resource Requests and Limits"

# 1. Pod exists
check_criterion "Pod resource-pod exists in prod" \
  "$(resource_exists pod/resource-pod prod)" && ((score++))

# 2. Image is nginx:latest
image=$(kget pod/resource-pod prod '.spec.containers[0].image')
check_criterion "Image is nginx:latest" \
  "$(echo "$image" | grep -q "nginx" && echo true || echo false)" && ((score++))

# 3. CPU limit is 1 (half of quota 2)
cpu_limit=$(kget pod/resource-pod prod '.spec.containers[0].resources.limits.cpu')
check_criterion "CPU limit is 1 (half of quota)" \
  "$([ "$cpu_limit" = "1" ] || [ "$cpu_limit" = "1000m" ] && echo true || echo false)" && ((score++))

# 4. Memory limit is 2Gi (half of quota 4Gi)
mem_limit=$(kget pod/resource-pod prod '.spec.containers[0].resources.limits.memory')
check_criterion "Memory limit is 2Gi (half of quota)" \
  "$([ "$mem_limit" = "2Gi" ] && echo true || echo false)" && ((score++))

# 5. CPU request >= 100m
cpu_req=$(kget pod/resource-pod prod '.spec.containers[0].resources.requests.cpu')
check_criterion "CPU request is at least 100m" \
  "$([ -n "$cpu_req" ] && echo true || echo false)" && ((score++))

print_score $score $total
