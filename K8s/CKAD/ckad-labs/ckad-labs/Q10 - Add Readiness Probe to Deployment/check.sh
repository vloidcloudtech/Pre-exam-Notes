#!/bin/bash
# Check script for Q10 - Add Readiness Probe to Deployment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=4
print_header "Question 10 | Add Readiness Probe to Deployment"

# 1. Deployment exists
check_criterion "Deployment api-deploy exists in default" \
  "$(resource_exists deploy/api-deploy default)" && ((score++))

# 2. Readiness probe path
probe_path=$(kget deploy/api-deploy default '.spec.template.spec.containers[0].readinessProbe.httpGet.path')
check_criterion "Readiness probe path is /ready" \
  "$([ "$probe_path" = "/ready" ] && echo true || echo false)" && ((score++))

# 3. Readiness probe port
probe_port=$(kget deploy/api-deploy default '.spec.template.spec.containers[0].readinessProbe.httpGet.port')
check_criterion "Readiness probe port is 8080" \
  "$([ "$probe_port" = "8080" ] && echo true || echo false)" && ((score++))

# 4. initialDelaySeconds
ids=$(kget deploy/api-deploy default '.spec.template.spec.containers[0].readinessProbe.initialDelaySeconds')
check_criterion "initialDelaySeconds is 5" \
  "$([ "$ids" = "5" ] && echo true || echo false)" && ((score++))

print_score $score $total
