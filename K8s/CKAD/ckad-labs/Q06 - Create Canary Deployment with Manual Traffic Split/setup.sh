#!/bin/bash
set -euo pipefail
echo "=== Q6 Setup: Canary Deployment with Manual Traffic Split ==="

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: default
spec:
  replicas: 5
  selector:
    matchLabels:
      app: webapp
      version: v1
  template:
    metadata:
      labels:
        app: webapp
        version: v1
    spec:
      containers:
        - name: web
          image: nginx:latest
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: default
spec:
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
EOF

kubectl rollout status deploy/web-app -n default --timeout=120s
echo "✅ Q6 setup complete."
