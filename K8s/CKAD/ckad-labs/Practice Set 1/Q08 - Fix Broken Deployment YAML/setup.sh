#!/bin/bash
set -euo pipefail
echo "=== Q8 Setup: Fix Broken Deployment YAML ==="

cat > /root/broken-deploy.yaml << 'YAMLEOF'
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: broken-app
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: web
          image: nginx
YAMLEOF

echo "✅ Q8 setup complete. /root/broken-deploy.yaml created with intentional errors."
