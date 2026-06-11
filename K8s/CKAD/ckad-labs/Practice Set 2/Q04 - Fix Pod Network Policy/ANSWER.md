# Answer 4 – Fix Pod Network Policy

## Step 1 – Create NetworkPolicy that allows frontend to backend communication

```bash
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: app-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - namespaceSelector: {}
EOF
```

## Step 2 – Create frontend pod with label

```bash
kubectl run frontend --image=busybox:latest --labels=role=frontend -- sleep 3600
```

## Step 3 – Create backend pod with label

```bash
kubectl run backend --image=busybox:latest --labels=role=backend -- \
  sh -c "nc -l -p 8080 -e echo 'Backend responding'"
```

## Step 4 – Test communication

```bash
kubectl exec frontend -- wget -O - http://backend:8080
```
