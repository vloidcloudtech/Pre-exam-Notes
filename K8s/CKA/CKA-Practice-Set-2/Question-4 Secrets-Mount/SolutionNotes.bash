# Create Secret with sensitive data
kubectl create secret generic app-secrets -n secrets-demo \
  --from-literal=username='admin' \
  --from-literal=password='SecurePass123!' \
  --from-literal=api-key='sk-abc123def456' \
  --dry-run=client -o yaml | kubectl apply -f -

# Create Deployment that uses Secret securely
cat <<'EOF' > api-client-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-client
  namespace: secrets-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-client
  template:
    metadata:
      labels:
        app: api-client
    spec:
      containers:
      - name: client
        image: busybox:stable
        command: ["sh", "-c", "echo 'Secrets mounted at /etc/secrets'; ls -la /etc/secrets; echo $APP_USERNAME; sleep 3600"]
        env:
        - name: APP_USERNAME
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: username
        - name: APP_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: password
        - name: APP_API_KEY
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: api-key
        volumeMounts:
        - name: secrets
          mountPath: /etc/secrets
          readOnly: true
      volumes:
      - name: secrets
        secret:
          secretName: app-secrets
          defaultMode: 0400
EOF
kubectl apply -f api-client-deployment.yaml

# Verify Secret and Deployment
kubectl get secret -n secrets-demo
kubectl get deployment -n secrets-demo
kubectl get pods -n secrets-demo
