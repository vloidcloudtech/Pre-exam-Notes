# Answer 6 – Liveness and Readiness Probes

## Create Deployment with Health Checks

```bash
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: health-check-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: health-check
  template:
    metadata:
      labels:
        app: health-check
    spec:
      containers:
      - name: app
        image: busybox:latest
        command: ["sh", "-c", "while true; do echo 'ok' > /tmp/health; sleep 1; done"]
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
          failureThreshold: 3
EOF
```

## Verify Probes

```bash
kubectl get deployment health-check-app -n default
kubectl describe pod -l app=health-check -n default
kubectl get pods -n default -l app=health-check -w
```
