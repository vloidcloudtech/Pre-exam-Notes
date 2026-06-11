# Answer 2 – Multi-container Pod with Init Container

## Step 1 – Create Pod with Init Container

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: app-with-init
  namespace: default
spec:
  initContainers:
  - name: init-config
    image: busybox:latest
    command: ["sh", "-c"]
    args:
    - |
      echo "Initializing configuration..."
      cat > /shared/config.txt <<'CONFIG'
      app_name=MyApp
      version=1.0
      environment=production
      CONFIG
      echo "Config file created successfully"
  containers:
  - name: app
    image: busybox:latest
    command: ["sh", "-c"]
    args:
    - |
      echo "Application starting..."
      cat /shared/config.txt
      sleep 3600
    volumeMounts:
    - name: shared-volume
      mountPath: /shared
  volumes:
  - name: shared-volume
    emptyDir: {}
EOF
```

## Step 2 – Verify init container executed

```bash
kubectl get pod app-with-init -n default
kubectl describe pod app-with-init -n default
kubectl logs app-with-init -n default -c init-config
```

## Step 3 – Verify main container can read config

```bash
kubectl logs app-with-init -n default -c app
```
