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
# Question 1 | ConfigMap from Files (4 points)
# ============================================================================
score=0
total=4
print_header "Question 1 | ConfigMap from Files"

# 1. ConfigMap exists
check_criterion "ConfigMap app-config exists in default namespace" \
  "$(resource_exists configmap/app-config default)" && ((score++))

# 2. ConfigMap has app.conf key
cm_keys=$(kubectl get configmap app-config -n default -o jsonpath='{.data}' 2>/dev/null)
check_criterion "ConfigMap contains app.conf key" \
  "$(echo $cm_keys | grep -q 'app.conf' && echo true || echo false)" && ((score++))

# 3. ConfigMap has database.conf key
check_criterion "ConfigMap contains database.conf key" \
  "$(echo $cm_keys | grep -q 'database.conf' && echo true || echo false)" && ((score++))

# 4. Deployment web-app exists with ConfigMap mounted
dep_volumes=$(kget "deployment/web-app" "default" "{.spec.template.spec.volumes[*].configMap.name}")
check_criterion "Deployment mounts ConfigMap at /etc/config" \
  "$(echo $dep_volumes | grep -q 'app-config' && echo true || echo false)" && ((score++))

print_score $score $total
