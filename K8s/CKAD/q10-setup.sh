#!/bin/bash
# Q10 – Add Readiness Probe to Deployment
# Setup: Deployment api-deploy with container on port 8080, no readiness probe
set -euo pipefail

echo "=== Q10 Setup: Add Readiness Probe to Deployment ==="

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deploy
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api-deploy
  template:
    metadata:
      labels:
        app: api-deploy
    spec:
      containers:
        - name: api
          image: nginx:latest
          ports:
            - containerPort: 8080
EOF

kubectl rollout status deploy/api-deploy -n default --timeout=120s
echo "✅ Q10 setup complete. Deployment api-deploy running on port 8080, no readiness probe."
