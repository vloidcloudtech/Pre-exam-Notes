#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0c'

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
print_header "Question 10 | Fix Deployment Pod Template"

# 1. Deployment exists
check_criterion "Deployment broken-app exists" \
  "$(resource_exists deployment/broken-app default)" && ((score++))

# 2. Deployment has valid image
image=$(kget "deployment/broken-app" "default" "{.spec.template.spec.containers[0].image}")
check_criterion "Deployment uses valid image (busybox:latest)" \
  "$([ "$image" = "busybox:latest" ] && echo true || echo false)" && ((score++))

# 3. Pod is created
pod_count=$(kubectl get pods -n default -l app=broken-app --no-headers 2>/dev/null | wc -l)
check_criterion "Pod is created from fixed deployment" \
  "$([ "$pod_count" -ge 1 ] && echo true || echo false)" && ((score++))

# 4. Pod is Running
pod_status=$(kubectl get pods -n default -l app=broken-app -o jsonpath='{.items[0].status.phase}' 2>/dev/null)
check_criterion "Pod is Running" \
  "$([ "$pod_status" = "Running" ] && echo true || echo false)" && ((score++))

print_score $score $total
