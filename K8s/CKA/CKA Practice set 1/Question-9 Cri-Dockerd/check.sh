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

# ============================================================================
# Question 9 | CRI-Dockerd Installation (2 points)
# ============================================================================
score=0
total=2
print_header "Question 9 | CRI-Dockerd Installation"

# 1. cri-docker service is running
service_status=$(systemctl is-active cri-docker 2>/dev/null || echo "inactive")
check_criterion "cri-docker service is active" \
  "$([ "$service_status" = "active" ] && echo true || echo false)" && ((score++))

# 2. Required sysctl settings applied
bridge_setting=$(sysctl -n net.bridge.bridge-nf-call-iptables 2>/dev/null || echo "0")
check_criterion "Sysctl net.bridge.bridge-nf-call-iptables = 1" \
  "$([ "$bridge_setting" = "1" ] && echo true || echo false)" && ((score++))

print_score $score $total
