#!/bin/bash
# Check script for Q14 - Create Ingress Resource
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=4
print_header "Question 14 | Create Ingress Resource"

# 1. Ingress exists
check_criterion "Ingress web-ingress exists in default" \
  "$(resource_exists ingress/web-ingress default)" && ((score++))

# 2. Host is web.example.com
host=$(kget ingress/web-ingress default '.spec.rules[0].host')
check_criterion "Host is web.example.com" \
  "$([ "$host" = "web.example.com" ] && echo true || echo false)" && ((score++))

# 3. pathType is Prefix
pt=$(kget ingress/web-ingress default '.spec.rules[0].http.paths[0].pathType')
check_criterion "pathType is Prefix" \
  "$([ "$pt" = "Prefix" ] && echo true || echo false)" && ((score++))

# 4. Backend is web-svc on port 8080
backend_name=$(kget ingress/web-ingress default '.spec.rules[0].http.paths[0].backend.service.name')
backend_port=$(kget ingress/web-ingress default '.spec.rules[0].http.paths[0].backend.service.port.number')
check_criterion "Backend is web-svc:8080" \
  "$([ "$backend_name" = "web-svc" ] && [ "$backend_port" = "8080" ] && echo true || echo false)" && ((score++))

print_score $score $total
