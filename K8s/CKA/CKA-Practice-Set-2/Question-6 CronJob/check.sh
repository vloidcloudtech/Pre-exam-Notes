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
# Question 6 | CronJob (4 points)
# ============================================================================
score=0
total=4
print_header "Question 6 | CronJob"

# 1. CronJob exists
check_criterion "CronJob backup-job exists in batch-jobs namespace" \
  "$(resource_exists cronjob/backup-job batch-jobs)" && ((score++))

# 2. CronJob schedule is 0 2 * * * (2 AM daily)
schedule=$(kget "cronjob/backup-job" "batch-jobs" "{.spec.schedule}")
check_criterion "CronJob schedule set to 0 2 * * * (2 AM daily)" \
  "$([ "$schedule" = "0 2 * * *" ] && echo true || echo false)" && ((score++))

# 3. History limits configured
success_limit=$(kget "cronjob/backup-job" "batch-jobs" "{.spec.successfulJobsHistoryLimit}")
failure_limit=$(kget "cronjob/backup-job" "batch-jobs" "{.spec.failedJobsHistoryLimit}")
check_criterion "SuccessfulJobsHistoryLimit=3 and FailedJobsHistoryLimit=1" \
  "$([ "$success_limit" = "3" ] && [ "$failure_limit" = "1" ] && echo true || echo false)" && ((score++))

# 4. ConcurrencyPolicy is set
concurrency=$(kget "cronjob/backup-job" "batch-jobs" "{.spec.concurrencyPolicy}")
check_criterion "ConcurrencyPolicy is set to Allow" \
  "$([ "$concurrency" = "Allow" ] && echo true || echo false)" && ((score++))

print_score $score $total
