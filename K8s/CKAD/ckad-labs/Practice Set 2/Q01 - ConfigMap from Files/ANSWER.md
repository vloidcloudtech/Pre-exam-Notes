# Answer 1 – ConfigMap from Files

## Step 1 – Create configuration files

```bash
cat > app.conf <<'EOF'
server.port=8080
server.timeout=30
logging.level=INFO
EOF

cat > database.conf <<'EOF'
db.host=localhost
db.port=5432
db.name=appdb
EOF
```

## Step 2 – Create ConfigMap from files

```bash
kubectl create configmap app-config \
  --from-file=app.conf \
  --from-file=database.conf \
  -n default
```

## Step 3 – Create Deployment with ConfigMap volume mount

```bash
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web
        image: busybox:latest
        command: ["sh", "-c", "cat /etc/config/app.conf && sleep 3600"]
        volumeMounts:
        - name: config
          mountPath: /etc/config
      volumes:
      - name: config
        configMap:
          name: app-config
EOF
```

## Step 4 – Verify

```bash
kubectl get configmap app-config -n default
kubectl get deployment web-app -n default
kubectl describe pod -l app=web-app -n default
```
