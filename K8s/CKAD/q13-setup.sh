#!/bin/bash
# Q13 – Create NodePort Service
# Setup: Deployment api-server with label app=api, container port 9090
set -euo pipefail

echo "=== Q13 Setup: Create NodePort Service ==="

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api
          image: nginx:latest
          ports:
            - containerPort: 9090
EOF

kubectl rollout status deploy/api-server -n default --timeout=120s
echo "✅ Q13 setup complete. Deployment api-server running with label app=api on port 9090."
