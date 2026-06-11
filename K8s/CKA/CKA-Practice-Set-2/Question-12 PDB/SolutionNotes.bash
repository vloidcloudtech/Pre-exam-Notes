# Create Deployment with 3 replicas
cat <<'EOF' > web-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: pdb-demo
spec:
  replicas: 3
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
        image: busybox:stable
        command: ["sleep", "3600"]
        resources:
          requests:
            cpu: 50m
            memory: 32Mi
          limits:
            cpu: 100m
            memory: 64Mi
EOF
kubectl apply -f web-app-deployment.yaml

# Create PodDisruptionBudget
cat <<'EOF' > web-app-pdb.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: web-app-pdb
  namespace: pdb-demo
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: web-app
EOF
kubectl apply -f web-app-pdb.yaml

# Verify Deployment and PDB
kubectl get deployment -n pdb-demo
kubectl get pdb -n pdb-demo
kubectl get pods -n pdb-demo
