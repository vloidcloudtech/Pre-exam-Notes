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
# Question 1 | MariaDB Persistent Volume (4 points)
# ============================================================================
score=0
total=4
print_header "Question 1 | MariaDB Persistent Volume"

# 1. PersistentVolumeClaim exists in mariadb namespace
check_criterion "PVC mariadb exists in mariadb namespace" \
  "$(resource_exists persistentvolumeclaim/mariadb mariadb)" && ((score++))

# 2. PVC explicitly references the existing PV mariadb-pv (volumeName specified)
pvc_volume=$(kubectl get pvc mariadb -n mariadb -o jsonpath='{.spec.volumeName}' 2>/dev/null)
check_criterion "PVC mariadb references existing PV mariadb-pv" \
  "$([ "$pvc_volume" = "mariadb-pv" ] && echo true || echo false)" && ((score++))

# 3. PersistentVolume is bound to PVC
pv_status=$(kubectl get pv mariadb-pv -o jsonpath='{.status.phase}' 2>/dev/null)
check_criterion "PV mariadb-pv is Bound" \
  "$([ "$pv_status" = "Bound" ] && echo true || echo false)" && ((score++))

# 4. Deployment uses the PVC
dep_pvc=$(kubectl get deploy mariadb -n mariadb -o jsonpath='{.spec.template.spec.volumes[?(@.name=="data")].persistentVolumeClaim.claimName}' 2>/dev/null)
check_criterion "Deployment mariadb uses PVC mariadb" \
  "$([ "$dep_pvc" = "mariadb" ] && echo true || echo false)" && ((score++))

print_score $score $total
