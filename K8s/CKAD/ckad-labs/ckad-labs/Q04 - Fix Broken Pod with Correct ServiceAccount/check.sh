#!/bin/bash
# Check script for Q4 - Fix Broken Pod with Correct ServiceAccount
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=3
print_header "Question 4 | Fix Broken Pod with Correct ServiceAccount"

# 1. Pod exists
check_criterion "Pod metrics-pod exists in monitoring" \
  "$(resource_exists pod/metrics-pod monitoring)" && ((score++))

# 2. Pod uses monitor-sa (the correct SA)
pod_sa=$(kget pod/metrics-pod monitoring '.spec.serviceAccountName')
check_criterion "Pod uses ServiceAccount monitor-sa" \
  "$([ "$pod_sa" = "monitor-sa" ] && echo true || echo false)" && ((score++))

# 3. Pod is running
phase=$(kget pod/metrics-pod monitoring '.status.phase')
check_criterion "Pod is in Running state" \
  "$([ "$phase" = "Running" ] && echo true || echo false)" && ((score++))

print_score $score $total
