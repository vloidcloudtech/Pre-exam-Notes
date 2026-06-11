#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns rbac-test --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: rbac-test"
echo "   - Task: Create ServiceAccount, Role, and RoleBinding with proper permissions"
