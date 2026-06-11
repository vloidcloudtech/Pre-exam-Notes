#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns affinity-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: affinity-demo"
echo "   - Task: Create Deployments with pod affinity and anti-affinity rules"
