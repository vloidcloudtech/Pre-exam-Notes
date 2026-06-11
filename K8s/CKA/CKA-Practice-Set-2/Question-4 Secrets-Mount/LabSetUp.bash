#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns secrets-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: secrets-demo"
echo "   - Task: Create Secret and Deployment that uses it securely"
