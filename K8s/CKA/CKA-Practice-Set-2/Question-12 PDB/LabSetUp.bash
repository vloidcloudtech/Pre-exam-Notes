#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns pdb-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: pdb-demo"
echo "   - Task: Create Deployment and PodDisruptionBudget"
