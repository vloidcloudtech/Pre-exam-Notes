# Create Headless Service for StatefulSet
cat <<'EOF' > database-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: database
  namespace: statefulset-demo
spec:
  clusterIP: None
  selector:
    app: database
  ports:
  - port: 5432
    targetPort: 5432
EOF
kubectl apply -f database-service.yaml

# Create StorageClass if needed
cat <<'EOF' > storage-class.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF
kubectl apply -f storage-class.yaml || true

# Create StatefulSet
cat <<'EOF' > database-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: database
  namespace: statefulset-demo
spec:
  serviceName: database
  replicas: 3
  selector:
    matchLabels:
      app: database
  template:
    metadata:
      labels:
        app: database
    spec:
      containers:
      - name: postgres
        image: busybox:stable
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
      storageClassName: local-storage
      resources:
        requests:
          storage: 1Gi
EOF
kubectl apply -f database-statefulset.yaml

# Verify StatefulSet
kubectl get statefulset -n statefulset-demo
kubectl get pvc -n statefulset-demo
kubectl get pods -n statefulset-demo -o wide
