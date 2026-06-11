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
# Question 6 | Custom Resource Definitions (2 points)
# ============================================================================
score=0
total=2
print_header "Question 6 | Custom Resource Definitions"

# 1. Certificate CRD exists (cert-manager)
cert_crd=$(kubectl get crd certificate.cert-manager.io >/dev/null 2>&1 && echo true || echo false)
check_criterion "Certificate CRD exists" "$cert_crd" && ((score++))

# 2. ClusterIssuer CRD exists (cert-manager)
issuer_crd=$(kubectl get crd clusterissuers.cert-manager.io >/dev/null 2>&1 && echo true || echo false)
check_criterion "ClusterIssuer CRD exists" "$issuer_crd" && ((score++))

print_score $score $total
