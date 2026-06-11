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
print_header "Question 7 | Container Security Context"

# 1. Pod exists
check_criterion "Pod secure-pod exists" \
  "$(resource_exists pod/secure-pod default)" && ((score++))

# 2. Pod security context has fsGroup
fsgroup=$(kget "pod/secure-pod" "default" "{.spec.securityContext.fsGroup}")
check_criterion "Pod security context sets fsGroup=2000" \
  "$([ "$fsgroup" = "2000" ] && echo true || echo false)" && ((score++))

# 3. Container runs as non-root user
runuser=$(kget "pod/secure-pod" "default" "{.spec.securityContext.runAsUser}")
check_criterion "Pod security context runs as user 1001" \
  "$([ "$runuser" = "1001" ] && echo true || echo false)" && ((score++))

# 4. Pod is Running
pod_status=$(kget "pod/secure-pod" "default" "{.status.phase}")
check_criterion "Pod is Running" \
  "$([ "$pod_status" = "Running" ] && echo true || echo false)" && ((score++))

print_score $score $total
