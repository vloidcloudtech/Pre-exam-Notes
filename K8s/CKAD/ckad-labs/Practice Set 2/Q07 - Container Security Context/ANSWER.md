# Answer 7 – Container Security Context

## Create Pod with Security Context

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: default
spec:
  securityContext:
    fsGroup: 2000
    runAsUser: 1001
    runAsNonRoot: true
  containers:
  - name: app
    image: busybox:latest
    command: ["sh", "-c", "id && echo 'Running as non-root' && sleep 3600"]
    securityContext:
      privileged: false
      readOnlyRootFilesystem: true
    volumeMounts:
    - name: tmp
      mountPath: /tmp
  volumes:
  - name: tmp
    emptyDir: {}
EOF
```

## Verify Security Context

```bash
kubectl get pod secure-pod -n default
kubectl describe pod secure-pod -n default
kubectl logs secure-pod -n default
```

## Verify Pod can write to /tmp

```bash
kubectl exec secure-pod -n default -- sh -c "echo 'test' > /tmp/test.txt && cat /tmp/test.txt"
```
