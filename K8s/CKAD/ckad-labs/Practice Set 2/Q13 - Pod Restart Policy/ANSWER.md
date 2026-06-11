# Answer 13 – Pod Restart Policy

## Step 1 – Create Pod with Never restart policy

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: one-time-job
  namespace: default
spec:
  restartPolicy: Never
  containers:
  - name: job
    image: busybox:latest
    command: ["sh", "-c", "echo 'Job completed'; exit 0"]
EOF
```

## Step 2 – Create Pod with OnFailure restart policy

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: retry-pod
  namespace: default
spec:
  restartPolicy: OnFailure
  containers:
  - name: retry
    image: busybox:latest
    command: ["sh", "-c", "echo 'Attempting...'; sleep 2; exit 1"]
EOF
```

## Step 3 – Monitor and verify

```bash
kubectl get pods -n default -w
kubectl logs one-time-job -n default
kubectl logs retry-pod -n default
kubectl describe pod one-time-job -n default
kubectl describe pod retry-pod -n default
```

## Expected behavior:
- `one-time-job`: Pod exits, stays in Completed state, does NOT restart
- `retry-pod`: Pod exits with failure, restarts automatically
