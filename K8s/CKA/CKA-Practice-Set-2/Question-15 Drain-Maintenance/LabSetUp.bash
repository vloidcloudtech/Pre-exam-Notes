#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns drain-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: drain-demo"
echo "   - Task: Create Deployment and PDB for drain testing"
