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

# ============================================================================
# Question 17 | TLS Configuration (2 points)
# ============================================================================
score=0
total=2
print_header "Question 17 | TLS Configuration"

# 1. ConfigMap updated (TLSv1.2 removed from SSL protocols)
cm_data=$(kubectl get cm nginx-config -n nginx-static -o jsonpath='{.data}' 2>/dev/null)
tlsv12_removed=$(echo "$cm_data" | grep -v "TLSv1\.2" >/dev/null && echo true || echo false)
check_criterion "ConfigMap nginx-config updated (TLSv1.2 removed)" "$tlsv12_removed" && ((score++))

# 2. Deployment has been restarted to pick up new config
dep_status=$(kubectl get deploy nginx-static -n nginx-static -o jsonpath='{.status.conditions[?(@.type=="Available")].status}' 2>/dev/null)
check_criterion "Deployment nginx-static restarted and available" \
  "$([ "$dep_status" = "True" ] && echo true || echo false)" && ((score++))

print_score $score $total
