#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: monitoring"
echo "   - Task: Create DaemonSet that runs on all nodes with proper tolerations"
