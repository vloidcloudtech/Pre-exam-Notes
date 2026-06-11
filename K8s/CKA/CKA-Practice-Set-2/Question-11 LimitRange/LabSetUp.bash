#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns limit-demo --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating LimitRange..."
cat <<'EOF' > limitrange.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: resource-limits
  namespace: limit-demo
spec:
  limits:
  - default:
      cpu: 500m
      memory: 512Mi
    defaultRequest:
      cpu: 100m
      memory: 64Mi
    max:
      cpu: 1000m
      memory: 1Gi
    min:
      cpu: 50m
      memory: 32Mi
    type: Container
EOF
kubectl apply -f limitrange.yaml

echo "✅ Lab setup complete!"
echo "   - Namespace: limit-demo"
echo "   - LimitRange enforcing CPU (50m-1000m) and Memory (32Mi-1Gi)"
