# Create app deployment within quota
cat <<'EOF' > app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quota-app
  namespace: quota-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: quota-app
  template:
    metadata:
      labels:
        app: quota-app
    spec:
      containers:
      - name: app
        image: busybox:stable
        command: ["sleep", "3600"]
        resources:
          requests:
            cpu: 250m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
EOF
kubectl apply -f app-deployment.yaml

# Verify ResourceQuota usage
echo "ResourceQuota status:"
kubectl describe resourcequota compute-quota -n quota-test
