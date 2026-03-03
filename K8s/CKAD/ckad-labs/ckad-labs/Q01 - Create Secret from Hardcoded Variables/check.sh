#!/bin/bash
# Check script for Q1 - Create Secret from Hardcoded Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/lib/common.sh"

score=0
total=4
print_header "Question 1 | Create Secret from Hardcoded Variables"

# 1. Secret db-credentials exists
check_criterion "Secret db-credentials exists in default" \
  "$(resource_exists secret/db-credentials default)" && ((score++))

# 2. Secret has correct DB_USER key
secret_user=$(kubectl get secret db-credentials -n default -o jsonpath='{.data.DB_USER}' 2>/dev/null | base64 -d 2>/dev/null)
check_criterion "Secret DB_USER = admin" \
  "$([ "$secret_user" = "admin" ] && echo true || echo false)" && ((score++))

# 3. Secret has correct DB_PASS key
secret_pass=$(kubectl get secret db-credentials -n default -o jsonpath='{.data.DB_PASS}' 2>/dev/null | base64 -d 2>/dev/null)
check_criterion "Secret DB_PASS = Secret123!" \
  "$([ "$secret_pass" = 'Secret123!' ] && echo true || echo false)" && ((score++))

# 4. Deployment uses secretKeyRef for DB_USER
env_ref=$(kubectl get deploy api-server -n default -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="DB_USER")].valueFrom.secretKeyRef.name}' 2>/dev/null)
check_criterion "Deployment api-server uses secretKeyRef for DB_USER" \
  "$([ "$env_ref" = "db-credentials" ] && echo true || echo false)" && ((score++))

print_score $score $total
