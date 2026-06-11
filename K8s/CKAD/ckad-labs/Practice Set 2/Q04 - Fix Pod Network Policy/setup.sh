#!/bin/bash
set -euo pipefail
echo "=== Q4 Setup: Fix Pod Network Policy ==="

# Create a broken NetworkPolicy
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: app-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: middleware
    ports:
    - protocol: TCP
      port: 9000
EOF

echo "Broken NetworkPolicy created - candidate needs to fix it"
