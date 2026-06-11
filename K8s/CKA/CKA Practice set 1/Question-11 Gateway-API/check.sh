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
# Question 11 | Gateway API (3 points)
# ============================================================================
score=0
total=3
print_header "Question 11 | Gateway API"

# 1. Gateway resource exists
check_criterion "Gateway web-gateway exists in default namespace" \
  "$(resource_exists gateway.networking.k8s.io/web-gateway default)" && ((score++))

# 2. HTTPRoute resource exists
check_criterion "HTTPRoute web-route exists in default namespace" \
  "$(resource_exists httproute.networking.k8s.io/web-route default)" && ((score++))

# 3. Gateway references correct TLS secret
gateway_secret=$(kget "gateway.networking.k8s.io/web-gateway" "default" "{.spec.listeners[0].tls.certificateRefs[0].name}")
check_criterion "Gateway uses web-tls secret" \
  "$([ "$gateway_secret" = "web-tls" ] && echo true || echo false)" && ((score++))

print_score $score $total
