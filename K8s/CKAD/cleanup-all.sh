#!/bin/bash
# Cleanup script - tears down all lab resources
# Usage:
#   ./cleanup-all.sh          # Cleanup everything
#   ./cleanup-all.sh 1 3 8    # Cleanup specific questions
set -uo pipefail

echo "============================================="
echo "  CKAD Practice Questions - Lab Cleanup"
echo "============================================="
echo ""

cleanup_q1() {
  echo "Cleaning Q1..."
  kubectl delete deploy api-server -n default --ignore-not-found
  kubectl delete secret db-credentials -n default --ignore-not-found
}

cleanup_q2() {
  echo "Cleaning Q2..."
  kubectl delete cronjob backup-job -n default --ignore-not-found
  kubectl delete job -l job-name=backup-job-test -n default --ignore-not-found
}

cleanup_q3() {
  echo "Cleaning Q3..."
  kubectl delete namespace audit --ignore-not-found
}

cleanup_q4() {
  echo "Cleaning Q4..."
  kubectl delete namespace monitoring --ignore-not-found
}

cleanup_q5() {
  echo "Cleaning Q5..."
  rm -rf /root/app-source /root/my-app.tar
  podman rmi my-app:1.0 2>/dev/null || true
  docker rmi my-app:1.0 2>/dev/null || true
}

cleanup_q6() {
  echo "Cleaning Q6..."
  kubectl delete deploy web-app web-app-canary -n default --ignore-not-found
  kubectl delete svc web-service -n default --ignore-not-found
}

cleanup_q7() {
  echo "Cleaning Q7..."
  kubectl delete namespace network-demo --ignore-not-found
}

cleanup_q8() {
  echo "Cleaning Q8..."
  rm -f /root/broken-deploy.yaml
  kubectl delete deploy broken-app -n default --ignore-not-found
}

cleanup_q9() {
  echo "Cleaning Q9..."
  kubectl delete deploy app-v1 -n default --ignore-not-found
}

cleanup_q10() {
  echo "Cleaning Q10..."
  kubectl delete deploy api-deploy -n default --ignore-not-found
}

cleanup_q11() {
  echo "Cleaning Q11..."
  kubectl delete deploy secure-app -n default --ignore-not-found
}

cleanup_q12() {
  echo "Cleaning Q12..."
  kubectl delete deploy web-app -n default --ignore-not-found
  kubectl delete svc web-svc -n default --ignore-not-found
}

cleanup_q13() {
  echo "Cleaning Q13..."
  kubectl delete deploy api-server -n default --ignore-not-found
  kubectl delete svc api-nodeport -n default --ignore-not-found
}

cleanup_q14() {
  echo "Cleaning Q14..."
  kubectl delete deploy web-deploy -n default --ignore-not-found
  kubectl delete svc web-svc -n default --ignore-not-found
  kubectl delete ingress web-ingress -n default --ignore-not-found
}

cleanup_q15() {
  echo "Cleaning Q15..."
  rm -f /root/fix-ingress.yaml
  kubectl delete deploy api-deploy -n default --ignore-not-found
  kubectl delete svc api-svc -n default --ignore-not-found
  kubectl delete ingress api-ingress -n default --ignore-not-found
}

cleanup_q16() {
  echo "Cleaning Q16..."
  kubectl delete namespace prod --ignore-not-found
}

if [ $# -eq 0 ]; then
  QUESTIONS=$(seq 1 16)
else
  QUESTIONS="$@"
fi

for q in $QUESTIONS; do
  cleanup_q$q 2>/dev/null || echo "⚠️  Q$q cleanup had issues"
done

echo ""
echo "✅ Cleanup complete!"
