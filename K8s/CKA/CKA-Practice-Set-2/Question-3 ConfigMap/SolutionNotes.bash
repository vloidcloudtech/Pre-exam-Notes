# Create ConfigMap with multiple data sources
kubectl create configmap app-config -n config-demo \
  --from-literal=database.url='postgres://db.internal:5432/app' \
  --from-literal=log.level='INFO' \
  --dry-run=client -o yaml | kubectl apply -f -

# Add nginx.conf via patch or create with embedded content
cat <<'EOF' > nginx.conf
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://backend;
    }
}
EOF
kubectl create configmap app-config -n config-demo \
  --from-file=nginx.conf \
  --dry-run=client -o yaml | kubectl apply -f -

# Create Deployment that uses ConfigMap
cat <<'EOF' > app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-server
  namespace: config-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-server
  template:
    metadata:
      labels:
        app: app-server
    spec:
      containers:
      - name: app
        image: busybox:stable
        command: ["sh", "-c", "cat /etc/config/database.url; echo $LOG_LEVEL; sleep 3600"]
        env:
        - name: DATABASE_URL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: database.url
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: log.level
        volumeMounts:
        - name: config
          mountPath: /etc/config
      volumes:
      - name: config
        configMap:
          name: app-config
EOF
kubectl apply -f app-deployment.yaml

# Verify ConfigMap and Deployment
kubectl get configmap -n config-demo
kubectl get deployment -n config-demo
kubectl get pods -n config-demo
