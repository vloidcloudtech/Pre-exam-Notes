# Answer 11 – Add Volume Mount to Pod

## Step 1 – Create ConfigMap

```bash
kubectl create configmap app-config \
  --from-literal=app.name=MyApp \
  --from-literal=app.version=1.0 \
  -n default
```

## Step 2 – Create Pod with volume mounts

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: data-consumer
  namespace: default
spec:
  containers:
  - name: app
    image: busybox:latest
    command: ["sh", "-c", "cat /etc/config/app.name && ls -la /tmp/cache && sleep 3600"]
    volumeMounts:
    - name: config
      mountPath: /etc/config
    - name: cache
      mountPath: /tmp/cache
  volumes:
  - name: config
    configMap:
      name: app-config
  - name: cache
    emptyDir: {}
EOF
```

## Step 3 – Verify volume mounts

```bash
kubectl get pod data-consumer -n default
kubectl exec data-consumer -n default -- ls /etc/config
kubectl exec data-consumer -n default -- touch /tmp/cache/test.txt
kubectl exec data-consumer -n default -- ls /tmp/cache
```
