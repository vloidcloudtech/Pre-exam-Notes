#!/bin/bash
set -e

echo "🔹 Creating namespace..."
kubectl create ns node-affinity-demo --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Labeling nodes..."
# Get first two nodes and label them
NODES=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')
COUNT=0
for NODE in $NODES; do
  [ $COUNT -eq 0 ] && kubectl label node $NODE disktype=ssd --overwrite || kubectl label node $NODE disktype=standard --overwrite
  COUNT=$((COUNT + 1))
  [ $COUNT -eq 2 ] && break
done

echo "✅ Lab setup complete!"
echo "   - Namespace: node-affinity-demo"
echo "   - Nodes labeled with disktype"
