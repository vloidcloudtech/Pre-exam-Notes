#!/bin/bash
# Q12 – Fix Service Selector
# Setup: Deployment web-app (labels app=webapp, tier=frontend) and Service web-svc with wrong selector
set -euo pipefail

echo "=== Q12 Setup: Fix Service Selector ==="

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
      tier: frontend
  template:
    metadata:
      labels:
        app: webapp
        tier: frontend
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
  name: web-svc
  namespace: default
spec:
  selector:
    app: wrongapp
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
EOF

kubectl rollout status deploy/web-app -n default --timeout=120s
echo "✅ Q12 setup complete. Deployment web-app running. Service web-svc has WRONG selector (app=wrongapp)."
