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
print_header "Question 15 | Expose Service as LoadBalancer"

# 1. Deployment exists
check_criterion "Deployment web-app exists" \
  "$(resource_exists deployment/web-app default)" && ((score++))

# 2. Service exists
check_criterion "Service web-service exists" \
  "$(resource_exists service/web-service default)" && ((score++))

# 3. Service is type LoadBalancer
svc_type=$(kget "service/web-service" "default" "{.spec.type}")
check_criterion "Service is type LoadBalancer" \
  "$([ "$svc_type" = "LoadBalancer" ] && echo true || echo false)" && ((score++))

# 4. Service has correct port configuration
svc_port=$(kget "service/web-service" "default" "{.spec.ports[0].port}")
target_port=$(kget "service/web-service" "default" "{.spec.ports[0].targetPort}")
check_criterion "Service has correct port (80) and targetPort (8080)" \
  "$([ "$svc_port" = "80" ] && [ "$target_port" = "8080" ] && echo true || echo false)" && ((score++))

print_score $score $total
