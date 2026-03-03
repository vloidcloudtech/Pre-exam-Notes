#!/bin/bash
set -euo pipefail
echo "=== Q16 Setup: Add Resource Requests and Limits to Pod ==="

kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: prod
spec:
  hard:
    limits.cpu: "2"
    limits.memory: "4Gi"
    requests.cpu: "1"
    requests.memory: "2Gi"
    pods: "5"
EOF

echo "✅ Q16 setup complete. Namespace prod with ResourceQuota (limits.cpu: 2, limits.memory: 4Gi)."
