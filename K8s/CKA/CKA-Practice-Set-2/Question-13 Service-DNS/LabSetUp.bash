#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns dns-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: dns-demo"
echo "   - Task: Create Service and test DNS resolution"
