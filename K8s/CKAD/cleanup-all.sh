#!/bin/bash
# Cleanup all lab resources
set -uo pipefail
echo "=== CKAD Practice Questions - Lab Cleanup ==="

echo "Cleaning Q1..."
kubectl delete deploy api-server -n default --ignore-not-found 2>/dev/null
kubectl delete secret db-credentials -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q2..."
kubectl delete cronjob backup-job -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q3..."
kubectl delete namespace audit --ignore-not-found 2>/dev/null

echo "Cleaning Q4..."
kubectl delete namespace monitoring --ignore-not-found 2>/dev/null

echo "Cleaning Q5..."
rm -rf /root/app-source /root/my-app.tar 2>/dev/null

echo "Cleaning Q6..."
kubectl delete deploy web-app web-app-canary -n default --ignore-not-found 2>/dev/null
kubectl delete svc web-service -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q7..."
kubectl delete namespace network-demo --ignore-not-found 2>/dev/null

echo "Cleaning Q8..."
rm -f /root/broken-deploy.yaml 2>/dev/null
kubectl delete deploy broken-app -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q9..."
kubectl delete deploy app-v1 -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q10..."
kubectl delete deploy api-deploy -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q11..."
kubectl delete deploy secure-app -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q12..."
kubectl delete deploy web-app -n default --ignore-not-found 2>/dev/null
kubectl delete svc web-svc -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q13..."
kubectl delete deploy api-server -n default --ignore-not-found 2>/dev/null
kubectl delete svc api-nodeport -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q14..."
kubectl delete deploy web-deploy -n default --ignore-not-found 2>/dev/null
kubectl delete svc web-svc -n default --ignore-not-found 2>/dev/null
kubectl delete ingress web-ingress -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q15..."
rm -f /root/fix-ingress.yaml 2>/dev/null
kubectl delete deploy api-deploy -n default --ignore-not-found 2>/dev/null
kubectl delete svc api-svc -n default --ignore-not-found 2>/dev/null
kubectl delete ingress api-ingress -n default --ignore-not-found 2>/dev/null

echo "Cleaning Q16..."
kubectl delete namespace prod --ignore-not-found 2>/dev/null

echo ""
echo "Cleanup complete!"
