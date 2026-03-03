#!/bin/bash
# Q3 – Create ServiceAccount, Role, and RoleBinding from Logs Error
# Setup: Namespace audit with Pod log-collector using default SA, failing with auth errors
set -euo pipefail

echo "=== Q3 Setup: ServiceAccount, Role, and RoleBinding from Logs Error ==="

kubectl create namespace audit --dry-run=client -o yaml | kubectl apply -f -

# Pod that tries to list pods using the K8s API and logs the auth error
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: log-collector
  namespace: audit
spec:
  serviceAccountName: default
  containers:
    - name: log-collector
      image: curlimages/curl:latest
      command:
        - sh
        - -c
        - |
          while true; do
            echo "Attempting to list pods..."
            RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
              -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
              --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
              "https://kubernetes.default.svc/api/v1/namespaces/audit/pods" 2>&1)
            if [ "$RESPONSE" != "200" ]; then
              echo "ERROR: User \"system:serviceaccount:audit:default\" cannot list pods in the namespace \"audit\""
            else
              echo "Successfully listed pods"
            fi
            sleep 10
          done
EOF

kubectl wait --for=condition=Ready pod/log-collector -n audit --timeout=60s 2>/dev/null || true
echo "✅ Q3 setup complete. Pod log-collector in namespace audit is running with default SA."
