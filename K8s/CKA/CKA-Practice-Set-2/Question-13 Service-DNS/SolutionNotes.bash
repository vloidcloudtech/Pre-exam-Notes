# Create Deployment
cat <<'EOF' > api-pod-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-pod
  namespace: dns-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: busybox:stable
        command: ["sh", "-c", "echo 'API Server' | nc -l -p 8080"]
        ports:
        - containerPort: 8080
EOF
kubectl apply -f api-pod-deployment.yaml

# Create Service
cat <<'EOF' > api-backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: api-backend
  namespace: dns-demo
spec:
  selector:
    app: api
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
  type: ClusterIP
EOF
kubectl apply -f api-backend-service.yaml

# Create client pod to test DNS
cat <<'EOF' > client-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: client
  namespace: dns-demo
spec:
  containers:
  - name: client
    image: busybox:stable
    command: ["sleep", "3600"]
  restartPolicy: Never
EOF
kubectl apply -f client-pod.yaml

# Verify service
kubectl get service -n dns-demo
kubectl get deployment -n dns-demo
kubectl get pods -n dns-demo
