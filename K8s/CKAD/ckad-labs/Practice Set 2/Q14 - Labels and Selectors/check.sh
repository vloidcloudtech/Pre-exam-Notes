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
print_header "Question 14 | Labels and Selectors"

# 1. pod1 exists with correct labels
pod1_labels=$(kubectl get pod pod1 -n default -o jsonpath='{.metadata.labels}' 2>/dev/null)
check_criterion "pod1 exists with env=prod,app=frontend labels" \
  "$(echo $pod1_labels | grep -q 'prod' && echo $pod1_labels | grep -q 'frontend' && echo true || echo false)" && ((score++))

# 2. pod2 exists with correct labels
pod2_labels=$(kubectl get pod pod2 -n default -o jsonpath='{.metadata.labels}' 2>/dev/null)
check_criterion "pod2 exists with env=prod,app=backend labels" \
  "$(echo $pod2_labels | grep -q 'prod' && echo $pod2_labels | grep -q 'backend' && echo true || echo false)" && ((score++))

# 3. pod3 exists with correct labels
pod3_labels=$(kubectl get pod pod3 -n default -o jsonpath='{.metadata.labels}' 2>/dev/null)
check_criterion "pod3 exists with env=dev,app=backend labels" \
  "$(echo $pod3_labels | grep -q 'dev' && echo $pod3_labels | grep -q 'backend' && echo true || echo false)" && ((score++))

# 4. Can select pods with labels
prod_pods=$(kubectl get pods -n default -l env=prod --no-headers 2>/dev/null | wc -l)
check_criterion "Can query pods by labels (env=prod returns results)" \
  "$([ "$prod_pods" -ge 2 ] && echo true || echo false)" && ((score++))

print_score $score $total
