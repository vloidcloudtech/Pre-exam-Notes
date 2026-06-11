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
resource_exists() { kubectl get "$1" -n "$2" >/dev/null 2>&1 && echo true || echo false; }
kget() { kubectl get "$1" -n "$2" -o jsonpath="{$3}" 2>/dev/null; }

score=0
total=4
print_header "Question 2 | Multi-container Pod with Init Container"

# 1. Pod exists
check_criterion "Pod app-with-init exists in default namespace" \
  "$(resource_exists pod/app-with-init default)" && ((score++))

# 2. Pod has init container
init_containers=$(kget "pod/app-with-init" "default" "{.spec.initContainers[*].name}")
check_criterion "Pod has init container" \
  "$(echo $init_containers | grep -q 'init' && echo true || echo false)" && ((score++))

# 3. Pod has main container
containers=$(kget "pod/app-with-init" "default" "{.spec.containers[*].name}")
check_criterion "Pod has main application container" \
  "$(echo $containers | grep -q 'app' && echo true || echo false)" && ((score++))

# 4. Pod is Running (init completed)
pod_status=$(kget "pod/app-with-init" "default" "{.status.phase}")
check_criterion "Pod is Running (init container completed successfully)" \
  "$([ "$pod_status" = "Running" ] && echo true || echo false)" && ((score++))

print_score $score $total
