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

kget() { kubectl get "$1" -n "$2" -o jsonpath="{$3}" 2>/dev/null; }

# ============================================================================
# Question 3 | Sidecar Container (3 points)
# ============================================================================
score=0
total=3
print_header "Question 3 | Sidecar Container"

# 1. Deployment has shared emptyDir volume
volume_name=$(kget "deploy/wordpress" "default" "{.spec.template.spec.volumes[?(@.emptyDir)].name}")
check_criterion "Deployment has emptyDir volume" \
  "$([ -n "$volume_name" ] && echo true || echo false)" && ((score++))

# 2. Wordpress container mounts the volume
wp_mounts=$(kget "deploy/wordpress" "default" "{.spec.template.spec.containers[?(@.name=='wordpress')].volumeMounts[*].name}")
check_criterion "Wordpress container mounts shared volume" \
  "$(echo $wp_mounts | grep -q "$volume_name" && echo true || echo false)" && ((score++))

# 3. Sidecar container exists and mounts the same volume
sidecar_name=$(kget "deploy/wordpress" "default" "{.spec.template.spec.containers[?(@.name=='sidecar')].name}")
check_criterion "Sidecar container exists and mounts volume" \
  "$([ "$sidecar_name" = "sidecar" ] && echo true || echo false)" && ((score++))

print_score $score $total
