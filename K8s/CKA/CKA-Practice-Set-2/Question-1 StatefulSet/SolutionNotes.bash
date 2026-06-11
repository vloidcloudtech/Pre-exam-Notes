# Create headless Service first (required by StatefulSet)
cat <<'EOF' > mysql-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: databases
spec:
  clusterIP: None  # Headless service
  selector:
    app: mysql-db
  ports:
  - port: 3306
    targetPort: 3306
EOF
kubectl apply -f mysql-service.yaml

# Create StatefulSet with persistent storage
cat <<'EOF' > mysql-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql-db
  namespace: databases
spec:
  serviceName: mysql-service
  replicas: 3
  selector:
    matchLabels:
      app: mysql-db
  template:
    metadata:
      labels:
        app: mysql-db
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "secure123"
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: fast-ssd
      resources:
        requests:
          storage: 1Gi
EOF
kubectl apply -f mysql-statefulset.yaml

# Verify StatefulSet is running
kubectl get statefulset -n databases
kubectl get pods -n databases -L metadata.name
kubectl get pvc -n databases
