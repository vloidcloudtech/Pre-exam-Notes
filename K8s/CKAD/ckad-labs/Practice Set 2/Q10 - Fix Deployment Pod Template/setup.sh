#!/bin/bash
set -euo pipefail
echo "=== Q10 Setup: Fix Deployment Pod Template ==="

# Create broken deployment with invalid image
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: broken-app
  template:
    metadata:
      labels:
        app: broken-app
    spec:
      containers:
      - name: app
        image: invalid-image:nonexistent
        command: ["sleep", "3600"]
EOF

echo "Broken deployment created - candidate needs to fix image and pod template"
