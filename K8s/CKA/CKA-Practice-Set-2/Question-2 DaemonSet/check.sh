#!/bin/bash
# ============================================================================
# SCORING FUNCTIONS
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_success() { echo -e "  ${GREEN}PASS${NC} - $1"; }
print_fail() { echo -e "  ${RED}FAIL${NC} - $1"; }

print_header() {
  echo ""
  echo -e "${CYAN}========================================================${NC}"
  echo -e "${BOLD}$1${NC}"
  echo -e "${CYAN}========================================================${NC}"
}

print_score() {
  local score=$1 total=$2 pct=0
  [ "$total" -gt 0 ] && pct=$(( score * 100 / total ))
  if [ "$score" -eq "$total" ]; then
    echo -e "\n  ${GREEN}${BOLD}Score: $score/$total ($pct%)${NC}\n"
  elif [ "$score" -gt 0 ]; then
    echo -e "\n  ${YELLOW}${BOLD}Score: $score/$total ($pct%)${NC}\n"
  else
    echo -e "\n  ${RED}${BOLD}Score: $score/$total ($pct%)${NC}\n"
  fi
}

check_criterion() {
  local description="$1" condition="$2"
  if [ "$condition" = "true" ]; then
    print_success "$description"; return 0
  else
    print_fail "$description"; return 1
  fi
}

resource_exists() { kubectl get "$1" -n "$2" >/dev/null 2>&1 && echo true || echo false; }
kget() { kubectl get "$1" -n "$2" -o jsonpath="{$3}" 2>/dev/null; }

# ============================================================================
# Question 2 | DaemonSet Node Monitor (4 points)
# ============================================================================
score=0
total=4
print_header "Question 2 | DaemonSet Node Monitor"

# 1. DaemonSet exists
check_criterion "DaemonSet node-monitor exists in monitoring namespace" \
  "$(resource_exists daemonset/node-monitor monitoring)" && ((score++))

# 2. DaemonSet has tolerations
tolerations=$(kget "daemonset/node-monitor" "monitoring" "{.spec.template.spec.tolerations[*].key}")
check_criterion "DaemonSet has tolerations for control-plane nodes" \
  "$(echo $tolerations | grep -q "node-role.kubernetes.io" && echo true || echo false)" && ((score++))

# 3. DaemonSet has nodeSelector
selector=$(kget "daemonset/node-monitor" "monitoring" "{.spec.template.spec.nodeSelector}")
check_criterion "DaemonSet uses nodeSelector for monitoring-enabled" \
  "$([ -n "$selector" ] && echo true || echo false)" && ((score++))

# 4. Pods are running on all nodes
ds_pods=$(kget "daemonset/node-monitor" "monitoring" "{.status.desiredNumberScheduled}")
ready_pods=$(kget "daemonset/node-monitor" "monitoring" "{.status.numberReady}")
check_criterion "All desired DaemonSet pods are running" \
  "$([ "$ds_pods" = "$ready_pods" ] && [ "$ds_pods" -gt "0" ] && echo true || echo false)" && ((score++))

print_score $score $total
