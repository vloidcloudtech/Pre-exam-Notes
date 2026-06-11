# Answer 16 – Mount Secret as Volume

## Step 1 – Create Secret

```bash
kubectl create secret generic app-secret \
  --from-literal=username=admin \
  --from-literal=password=SecurePass123! \
  -n default
```

## Step 2 – Create Pod with Secret volume mount

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: secret-consumer
  namespace: default
spec:
  containers:
  - name: app
    image: busybox:latest
    command: ["sh", "-c"]
    args:
    - |
      echo "Secret files in /etc/secrets:"
      ls -la /etc/secrets
      echo ""
      echo "Username:"
      cat /etc/secrets/username
      echo ""
      echo "Password:"
      cat /etc/secrets/password
      sleep 3600
    volumeMounts:
    - name: secrets
      mountPath: /etc/secrets
      readOnly: true
  volumes:
  - name: secrets
    secret:
      secretName: app-secret
      defaultMode: 0400
EOF
```

## Step 3 – Verify secret access

```bash
kubectl get pod secret-consumer -n default
kubectl exec secret-consumer -n default -- ls -la /etc/secrets
kubectl exec secret-consumer -n default -- cat /etc/secrets/username
```

## Step 4 – Verify file permissions

```bash
kubectl exec secret-consumer -n default -- stat /etc/secrets/username
```

The file should have mode 0400 (read-only for owner).
