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
print_header "Question 3 | Create Persistent Volume and Claim"

# 1. PV exists
check_criterion "PersistentVolume task-pv exists" \
  "$(resource_exists pv/task-pv default)" && ((score++))

# 2. PVC exists
check_criterion "PersistentVolumeClaim task-pvc exists" \
  "$(resource_exists pvc/task-pvc default)" && ((score++))

# 3. Pod exists with PVC mounted
check_criterion "Pod pv-consumer exists and uses PVC" \
  "$(resource_exists pod/pv-consumer default)" && ((score++))

# 4. PV and PVC are bound
pv_status=$(kget "pv/task-pv" "default" "{.status.phase}")
pvc_status=$(kget "pvc/task-pvc" "default" "{.status.phase}")
check_criterion "PV and PVC are bound" \
  "$([ "$pv_status" = "Bound" ] && [ "$pvc_status" = "Bound" ] && echo true || echo false)" && ((score++))

print_score $score $total
