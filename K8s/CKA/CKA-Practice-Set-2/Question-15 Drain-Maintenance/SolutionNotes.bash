# Create Deployment for drain testing
cat <<'EOF' > drain-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: drain-app
  namespace: drain-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: drain-app
  template:
    metadata:
      labels:
        app: drain-app
    spec:
      terminationGracePeriodSeconds: 30
      containers:
      - name: app
        image: busybox:stable
        command: ["sleep", "3600"]
        resources:
          requests:
            cpu: 50m
            memory: 32Mi
EOF
kubectl apply -f drain-app-deployment.yaml

# Create PodDisruptionBudget
cat <<'EOF' > drain-pdb.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: drain-pdb
  namespace: drain-demo
spec:
  maxUnavailable: 1
  selector:
    matchLabels:
      app: drain-app
EOF
kubectl apply -f drain-pdb.yaml

# Verify Deployment and PDB
kubectl get deployment -n drain-demo
kubectl get pdb -n drain-demo
kubectl get pods -n drain-demo -o wide

echo "
To test drain:
1. Get a node name: kubectl get nodes
2. Add taint: kubectl taint nodes <node> maintenance=true:NoSchedule
3. Drain node: kubectl drain <node> --ignore-daemonsets --delete-emptydir-data
4. Remove taint: kubectl taint nodes <node> maintenance-
"
