#!/bin/bash
# Q11 – Configure Pod and Container Security Context
# Setup: Deployment secure-app with no security context
set -euo pipefail

echo "=== Q11 Setup: Configure Pod and Container Security Context ==="

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      containers:
        - name: app
          image: nginx:latest
          ports:
            - containerPort: 80
EOF

kubectl rollout status deploy/secure-app -n default --timeout=120s
echo "✅ Q11 setup complete. Deployment secure-app running with no security context."
