#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns config-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: config-demo"
echo "   - Task: Create ConfigMap and Deployment that uses it"
