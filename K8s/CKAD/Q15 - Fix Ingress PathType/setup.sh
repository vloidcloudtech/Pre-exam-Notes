#!/bin/bash
set -euo pipefail
echo "=== Q15 Setup: Fix Ingress PathType ==="

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deploy
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-backend
  template:
    metadata:
      labels:
        app: api-backend
    spec:
      containers:
        - name: api
          image: nginx:latest
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: default
spec:
  selector:
    app: api-backend
  ports:
    - port: 8080
      targetPort: 8080
      protocol: TCP
EOF

cat > /root/fix-ingress.yaml << 'YAMLEOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: default
spec:
  rules:
    - http:
        paths:
          - path: /api
            pathType: InvalidType
            backend:
              service:
                name: api-svc
                port:
                  number: 8080
YAMLEOF

kubectl rollout status deploy/api-deploy -n default --timeout=120s
echo "✅ Q15 setup complete. /root/fix-ingress.yaml created with invalid pathType."
