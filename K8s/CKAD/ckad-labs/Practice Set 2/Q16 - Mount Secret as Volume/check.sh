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
print_header "Question 16 | Mount Secret as Volume"

# 1. Secret exists
check_criterion "Secret app-secret exists" \
  "$(resource_exists secret/app-secret default)" && ((score++))

# 2. Pod exists
check_criterion "Pod secret-consumer exists" \
  "$(resource_exists pod/secret-consumer default)" && ((score++))

# 3. Secret is mounted as volume
secret_volume=$(kget "pod/secret-consumer" "default" "{.spec.volumes[0].secret.secretName}")
check_criterion "Pod has Secret mounted as volume" \
  "$([ "$secret_volume" = "app-secret" ] && echo true || echo false)" && ((score++))

# 4. Volume is mounted read-only at /etc/secrets
mount_path=$(kget "pod/secret-consumer" "default" "{.spec.containers[0].volumeMounts[0].mountPath}")
read_only=$(kget "pod/secret-consumer" "default" "{.spec.containers[0].volumeMounts[0].readOnly}")
check_criterion "Secret mounted at /etc/secrets with readOnly=true" \
  "$([ "$mount_path" = "/etc/secrets" ] && [ "$read_only" = "true" ] && echo true || echo false)" && ((score++))

print_score $score $total
