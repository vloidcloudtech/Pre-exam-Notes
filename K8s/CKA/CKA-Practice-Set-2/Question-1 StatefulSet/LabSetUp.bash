#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns databases --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating StorageClass for StatefulSet..."
kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF

echo "✅ Lab setup complete!"
echo "   - Namespace: databases"
echo "   - StorageClass: fast-ssd"
echo "   - Task: Create StatefulSet mysql-db with 3 replicas and headless service"
