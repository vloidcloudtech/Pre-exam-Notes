# Create SSD app with required node affinity
cat <<'EOF' > ssd-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ssd-app
  namespace: node-affinity-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ssd-app
  template:
    metadata:
      labels:
        app: ssd-app
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: disktype
                operator: In
                values:
                - ssd
      containers:
      - name: app
        image: busybox:stable
        command: ["sleep", "3600"]
EOF
kubectl apply -f ssd-app-deployment.yaml

# Create standard app with preferred node affinity
cat <<'EOF' > standard-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: standard-app
  namespace: node-affinity-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: standard-app
  template:
    metadata:
      labels:
        app: standard-app
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            preference:
              matchExpressions:
              - key: disktype
                operator: In
                values:
                - standard
      containers:
      - name: app
        image: busybox:stable
        command: ["sleep", "3600"]
EOF
kubectl apply -f standard-app-deployment.yaml

# Verify deployments and pod scheduling
kubectl get deployments -n node-affinity-demo
kubectl get pods -n node-affinity-demo -o wide
