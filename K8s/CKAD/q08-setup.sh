#!/bin/bash
# Q8 – Fix Broken Deployment YAML
# Setup: Create /root/broken-deploy.yaml with deprecated API, missing selector, mismatched labels
set -euo pipefail

echo "=== Q8 Setup: Fix Broken Deployment YAML ==="

cat > /root/broken-deploy.yaml <<'EOF'
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
EOF

echo "✅ Q8 setup complete. /root/broken-deploy.yaml created with intentional errors."
echo "   Issues: deprecated apiVersion, missing selector field."
