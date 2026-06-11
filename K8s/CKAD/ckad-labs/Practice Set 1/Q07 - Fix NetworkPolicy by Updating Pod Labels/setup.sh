#!/bin/bash
set -euo pipefail
echo "=== Q7 Setup: Fix NetworkPolicy by Updating Pod Labels ==="

kubectl create namespace network-demo --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: network-demo
  labels:
    role: wrong-frontend
spec:
  containers:
    - name: frontend
      image: nginx:latest
      ports:
        - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: backend
  namespace: network-demo
  labels:
    role: wrong-backend
spec:
  containers:
    - name: backend
      image: nginx:latest
      ports:
        - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: database
  namespace: network-demo
  labels:
    role: wrong-db
spec:
  containers:
    - name: database
      image: nginx:latest
      ports:
        - containerPort: 80
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: network-demo
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: network-demo
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
              role: frontend
      ports:
        - protocol: TCP
          port: 80
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
  namespace: network-demo
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: backend
      ports:
        - protocol: TCP
          port: 80
EOF

kubectl wait --for=condition=Ready pod/frontend pod/backend pod/database -n network-demo --timeout=60s 2>/dev/null || true
echo "✅ Q7 setup complete."
