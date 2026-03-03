#!/bin/bash
# Check script for Q15 - Fix Ingress PathType
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=4
print_header "Question 15 | Fix Ingress PathType"

# 1. Ingress exists (was applied successfully)
check_criterion "Ingress api-ingress exists in default" \
  "$(resource_exists ingress/api-ingress default)" && ((score++))

# 2. pathType is valid (Prefix, Exact, or ImplementationSpecific)
pt=$(kget ingress/api-ingress default '.spec.rules[0].http.paths[0].pathType')
valid_pt=false
[ "$pt" = "Prefix" ] || [ "$pt" = "Exact" ] || [ "$pt" = "ImplementationSpecific" ] && valid_pt=true
check_criterion "pathType is a valid value ($pt)" "$valid_pt" && ((score++))

# 3. Path is /api
path=$(kget ingress/api-ingress default '.spec.rules[0].http.paths[0].path')
check_criterion "Path is /api" \
  "$([ "$path" = "/api" ] && echo true || echo false)" && ((score++))

# 4. Backend is api-svc:8080
backend_name=$(kget ingress/api-ingress default '.spec.rules[0].http.paths[0].backend.service.name')
backend_port=$(kget ingress/api-ingress default '.spec.rules[0].http.paths[0].backend.service.port.number')
check_criterion "Backend is api-svc:8080" \
  "$([ "$backend_name" = "api-svc" ] && [ "$backend_port" = "8080" ] && echo true || echo false)" && ((score++))

print_score $score $total
