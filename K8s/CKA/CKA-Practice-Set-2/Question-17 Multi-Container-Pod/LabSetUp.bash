#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns multi-container-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: multi-container-demo"
echo "   - Task: Create pod with multiple coordinated containers"
