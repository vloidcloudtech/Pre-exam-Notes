# Answer 8 – Create StatefulSet

## Step 1 – Create Headless Service

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: db-service
  namespace: default
spec:
  clusterIP: None
  selector:
    app: db
  ports:
  - port: 5432
    targetPort: 5432
EOF
```

## Step 2 – Create StatefulSet

```bash
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db-server
  namespace: default
spec:
  serviceName: db-service
  replicas: 3
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - name: db
        image: busybox:latest
        command: ["sleep", "3600"]
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
EOF
```

## Verify

```bash
kubectl get statefulset db-server -n default
kubectl get pods -n default -l app=db
kubectl get pvc -n default -l app=db
```
