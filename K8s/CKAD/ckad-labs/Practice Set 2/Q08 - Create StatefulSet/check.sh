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
print_header "Question 8 | Create StatefulSet"

# 1. StatefulSet exists
check_criterion "StatefulSet db-server exists" \
  "$(resource_exists statefulset/db-server default)" && ((score++))

# 2. Headless Service exists
svc_cluster_ip=$(kget "service/db-service" "default" "{.spec.clusterIP}")
check_criterion "Headless Service db-service exists (clusterIP: None)" \
  "$([ "$svc_cluster_ip" = "None" ] && echo true || echo false)" && ((score++))

# 3. Pods have stable names
pod_0=$(resource_exists pod/db-server-0 default)
pod_1=$(resource_exists pod/db-server-1 default)
pod_2=$(resource_exists pod/db-server-2 default)
check_criterion "Pods named db-server-0, db-server-1, db-server-2 exist" \
  "$([ "$pod_0" = "true" ] && [ "$pod_1" = "true" ] && [ "$pod_2" = "true" ] && echo true || echo false)" && ((score++))

# 4. PVCs exist for each pod
pvc_count=$(kubectl get pvc -n default 2>/dev/null | wc -l)
check_criterion "PersistentVolumeClaims created for each pod (3 PVCs)" \
  "$([ "$pvc_count" -ge 4 ] && echo true || echo false)" && ((score++))

print_score $score $total
