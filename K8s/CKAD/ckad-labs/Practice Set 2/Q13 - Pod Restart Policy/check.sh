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
print_header "Question 13 | Pod Restart Policy"

# 1. one-time-job pod exists
check_criterion "Pod one-time-job exists" \
  "$(resource_exists pod/one-time-job default)" && ((score++))

# 2. retry-pod exists
check_criterion "Pod retry-pod exists" \
  "$(resource_exists pod/retry-pod default)" && ((score++))

# 3. one-time-job has Never restart policy
restart_policy=$(kget "pod/one-time-job" "default" "{.spec.restartPolicy}")
check_criterion "one-time-job has restartPolicy: Never" \
  "$([ "$restart_policy" = "Never" ] && echo true || echo false)" && ((score++))

# 4. retry-pod has OnFailure restart policy
retry_policy=$(kget "pod/retry-pod" "default" "{.spec.restartPolicy}")
check_criterion "retry-pod has restartPolicy: OnFailure" \
  "$([ "$retry_policy" = "OnFailure" ] && echo true || echo false)" && ((score++))

print_score $score $total
