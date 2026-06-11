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
# Question 5 | HorizontalPodAutoscaler (4 points)
# ============================================================================
score=0
total=4
print_header "Question 5 | HorizontalPodAutoscaler"

# 1. HPA exists for apache-deployment
check_criterion "HPA apache-server exists in autoscale namespace" \
  "$(resource_exists horizontalpodautoscaler/apache-server autoscale)" && ((score++))

# 2. HPA targets correct deployment
target=$(kget "hpa/apache-server" "autoscale" "{.spec.scaleTargetRef.name}")
check_criterion "HPA targets apache-deployment" \
  "$([ "$target" = "apache-deployment" ] && echo true || echo false)" && ((score++))

# 3. Min and max replicas configured
min_replicas=$(kget "hpa/apache-server" "autoscale" "{.spec.minReplicas}")
max_replicas=$(kget "hpa/apache-server" "autoscale" "{.spec.maxReplicas}")
check_criterion "HPA minReplicas=1 and maxReplicas=4" \
  "$([ "$min_replicas" = "1" ] && [ "$max_replicas" = "4" ] && echo true || echo false)" && ((score++))

# 4. CPU metric configured
cpu_metric=$(kget "hpa/apache-server" "autoscale" "{.spec.metrics[?(@.type=='Resource')].resource.name}")
check_criterion "HPA uses CPU metric" \
  "$(echo $cpu_metric | grep -q "cpu" && echo true || echo false)" && ((score++))

print_score $score $total
