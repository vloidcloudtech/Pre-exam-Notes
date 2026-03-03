#!/bin/bash
# Check script for Q2 - Create CronJob with Schedule and History Limits
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=6
print_header "Question 2 | Create CronJob with Schedule and History Limits"

# 1. CronJob exists
check_criterion "CronJob backup-job exists in default" \
  "$(resource_exists cronjob/backup-job default)" && ((score++))

# 2. Schedule
schedule=$(kget cronjob/backup-job default '.spec.schedule')
check_criterion "Schedule is */30 * * * *" \
  "$([ "$schedule" = "*/30 * * * *" ] && echo true || echo false)" && ((score++))

# 3. successfulJobsHistoryLimit
shl=$(kget cronjob/backup-job default '.spec.successfulJobsHistoryLimit')
check_criterion "successfulJobsHistoryLimit is 3" \
  "$([ "$shl" = "3" ] && echo true || echo false)" && ((score++))

# 4. failedJobsHistoryLimit
fhl=$(kget cronjob/backup-job default '.spec.failedJobsHistoryLimit')
check_criterion "failedJobsHistoryLimit is 2" \
  "$([ "$fhl" = "2" ] && echo true || echo false)" && ((score++))

# 5. activeDeadlineSeconds
ads=$(kget cronjob/backup-job default '.spec.jobTemplate.spec.activeDeadlineSeconds')
check_criterion "activeDeadlineSeconds is 300" \
  "$([ "$ads" = "300" ] && echo true || echo false)" && ((score++))

# 6. restartPolicy
rp=$(kget cronjob/backup-job default '.spec.jobTemplate.spec.template.spec.restartPolicy')
check_criterion "restartPolicy is Never" \
  "$([ "$rp" = "Never" ] && echo true || echo false)" && ((score++))

print_score $score $total
