# Create backend Deployment
cat <<'EOF' > backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: affinity-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: busybox:stable
        command: ["sleep", "3600"]
EOF
kubectl apply -f backend-deployment.yaml

# Create frontend Deployment with pod affinity
cat <<'EOF' > frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: affinity-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      affinity:
        podAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - backend
            topologyKey: kubernetes.io/hostname
      containers:
      - name: frontend
        image: busybox:stable
        command: ["sleep", "3600"]
EOF
kubectl apply -f frontend-deployment.yaml

# Create cache Deployment with pod anti-affinity
cat <<'EOF' > cache-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cache
  namespace: affinity-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cache
  template:
    metadata:
      labels:
        app: cache
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - cache
              topologyKey: kubernetes.io/hostname
      containers:
      - name: cache
        image: busybox:stable
        command: ["sleep", "3600"]
EOF
kubectl apply -f cache-deployment.yaml

# Verify deployments
kubectl get deployments -n affinity-demo
kubectl get pods -n affinity-demo -o wide
