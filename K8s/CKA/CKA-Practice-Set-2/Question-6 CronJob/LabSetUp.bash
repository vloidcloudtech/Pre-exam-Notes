#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns batch-jobs --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Lab setup complete!"
echo "   - Namespace: batch-jobs"
echo "   - Task: Create CronJob with proper schedule and history limits"
