#!/bin/bash
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
resource_exists() { kubectl get "$1" -n "$2" 2>/dev/null >/dev/null && echo true || echo false; }
kget() { kubectl get "$1" -n "$2" -o jsonpath="{$3}" 2>/dev/null; }

score=0
total=4
print_header "Question 5 | Scale Deployment and Update Strategy"

# 1. Deployment exists
check_criterion "Deployment web-server exists" \
  "$(resource_exists deployment/web-server default)" && ((score++))

# 2. Deployment has 5 replicas
replicas=$(kget "deployment/web-server" "default" "{.spec.replicas}")
check_criterion "Deployment scaled to 5 replicas" \
  "$([ "$replicas" = "5" ] && echo true || echo false)" && ((score++))

# 3. Rolling update strategy configured
max_surge=$(kget "deployment/web-server" "default" "{.spec.strategy.rollingUpdate.maxSurge}")
max_unavail=$(kget "deployment/web-server" "default" "{.spec.strategy.rollingUpdate.maxUnavailable}")
check_criterion "RollingUpdate strategy with maxSurge=2 and maxUnavailable=1" \
  "$([ "$max_surge" = "2" ] && [ "$max_unavail" = "1" ] && echo true || echo false)" && ((score++))

# 4. Ready replicas match desired replicas
ready=$(kget "deployment/web-server" "default" "{.status.readyReplicas}")
check_criterion "All 5 replicas are ready" \
  "$([ "$ready" = "5" ] && echo true || echo false)" && ((score++))

print_score $score $total
