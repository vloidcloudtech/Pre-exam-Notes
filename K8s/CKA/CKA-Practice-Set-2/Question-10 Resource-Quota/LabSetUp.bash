#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns quota-test --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating ResourceQuota..."
cat <<'EOF' > quota.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: quota-test
spec:
  hard:
    requests.cpu: 500m
    requests.memory: 512Mi
    pods: 5
  scopeSelector:
    matchExpressions:
    - operator: In
      scopeName: PriorityClass
      values: ["default"]
EOF
kubectl apply -f quota.yaml || true

echo "✅ Lab setup complete!"
echo "   - Namespace: quota-test"
echo "   - ResourceQuota: compute-quota (500m CPU, 512Mi Memory, 5 pods)"
