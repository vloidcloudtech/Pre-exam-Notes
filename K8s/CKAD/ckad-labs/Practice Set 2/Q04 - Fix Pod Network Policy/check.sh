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
print_header "Question 4 | Fix Pod Network Policy"

# 1. NetworkPolicy exists
check_criterion "NetworkPolicy app-policy exists" \
  "$(resource_exists networkpolicy/app-policy default)" && ((score++))

# 2. Frontend pod exists with correct label
check_criterion "Pod with label role=frontend exists" \
  "$(kubectl get pods -n default -l role=frontend 2>/dev/null | tail -1 | grep -q 'Running' && echo true || echo false)" && ((score++))

# 3. Backend pod exists with correct label
check_criterion "Pod with label role=backend exists" \
  "$(kubectl get pods -n default -l role=backend 2>/dev/null | tail -1 | grep -q 'Running' && echo true || echo false)" && ((score++))

# 4. NetworkPolicy allows correct traffic
ingress_rule=$(kget "networkpolicy/app-policy" "default" "{.spec.ingress[0].from[0].podSelector.matchLabels.role}")
check_criterion "NetworkPolicy allows ingress from frontend pods" \
  "$([ "$ingress_rule" = "frontend" ] && echo true || echo false)" && ((score++))

print_score $score $total
