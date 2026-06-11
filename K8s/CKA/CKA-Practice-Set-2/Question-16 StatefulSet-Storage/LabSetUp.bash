#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns statefulset-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: statefulset-demo"
echo "   - Task: Create StatefulSet with persistent storage"
