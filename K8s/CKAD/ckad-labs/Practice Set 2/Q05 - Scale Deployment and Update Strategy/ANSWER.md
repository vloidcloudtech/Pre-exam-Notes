# Answer 5 – Scale Deployment and Update Strategy

## Step 1 – Create initial Deployment

```bash
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-server
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: busybox:latest
        command: ["sleep", "3600"]
EOF
```

## Step 2 – Scale deployment to 5 replicas

```bash
kubectl scale deployment web-server --replicas=5 -n default
```

## Step 3 – Monitor rollout status

```bash
kubectl rollout status deployment/web-server -n default
```

## Step 4 – Update image

```bash
kubectl set image deployment/web-server web=busybox:stable -n default
```

## Step 5 – Monitor the rolling update

```bash
kubectl rollout status deployment/web-server -n default
kubectl get pods -n default -l app=web --watch
```

## Step 6 – Verify deployment configuration

```bash
kubectl get deployment web-server -n default
kubectl describe deployment web-server -n default
```
