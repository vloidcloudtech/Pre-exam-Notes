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
# Question 12 | Ingress (3 points)
# ============================================================================
score=0
total=3
print_header "Question 12 | Ingress"

# 1. NodePort service exists
check_criterion "Service echo-service exists in echo-sound namespace" \
  "$(resource_exists service/echo-service echo-sound)" && ((score++))

# 2. Service is NodePort type
svc_type=$(kget "service/echo-service" "echo-sound" "{.spec.type}")
check_criterion "Service echo-service is NodePort type" \
  "$([ "$svc_type" = "NodePort" ] && echo true || echo false)" && ((score++))

# 3. Ingress resource exists
check_criterion "Ingress echo exists in echo-sound namespace" \
  "$(resource_exists ingress/echo echo-sound)" && ((score++))

print_score $score $total
