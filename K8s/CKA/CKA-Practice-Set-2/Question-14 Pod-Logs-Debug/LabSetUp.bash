#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns logging-demo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: logging-demo"
echo "   - Task: Create pods for logging and debug practice"
