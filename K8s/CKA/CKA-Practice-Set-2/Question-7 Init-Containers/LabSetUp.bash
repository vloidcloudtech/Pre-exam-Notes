#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns init-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: init-demo"
echo "   - Task: Create Pod with init container that prepares shared volume"
