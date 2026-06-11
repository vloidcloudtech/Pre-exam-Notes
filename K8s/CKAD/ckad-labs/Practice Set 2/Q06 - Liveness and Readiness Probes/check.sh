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
print_header "Question 6 | Liveness and Readiness Probes"

# 1. Deployment exists
check_criterion "Deployment health-check-app exists" \
  "$(resource_exists deployment/health-check-app default)" && ((score++))

# 2. Liveness probe configured
liveness=$(kget "deployment/health-check-app" "default" "{.spec.template.spec.containers[0].livenessProbe}")
check_criterion "Liveness probe is configured" \
  "$([ -n "$liveness" ] && echo true || echo false)" && ((score++))

# 3. Readiness probe configured
readiness=$(kget "deployment/health-check-app" "default" "{.spec.template.spec.containers[0].readinessProbe}")
check_criterion "Readiness probe is configured" \
  "$([ -n "$readiness" ] && echo true || echo false)" && ((score++))

# 4. Pod is Running and Ready
pod_ready=$(kubectl get pods -n default -l app=health-check -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
check_criterion "Pod is Running and Ready" \
  "$([ "$pod_ready" = "True" ] && echo true || echo false)" && ((score++))

print_score $score $total
