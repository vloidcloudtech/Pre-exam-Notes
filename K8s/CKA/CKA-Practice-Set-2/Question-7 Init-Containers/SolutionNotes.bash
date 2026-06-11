# Create Pod with init container
cat <<'EOF' > app-with-init.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-init
  namespace: init-demo
spec:
  initContainers:
  - name: init-downloader
    image: busybox:stable
    command: ["sh", "-c"]
    args:
    - |
      echo 'Downloading config file...'
      cat > /shared/config.txt << 'CONFIG'
      app_name=MyApp
      version=1.0
      environment=production
      CONFIG
      echo 'Config downloaded successfully'
    volumeMounts:
    - name: shared-volume
      mountPath: /shared
  containers:
  - name: app
    image: busybox:stable
    command: ["sh", "-c"]
    args:
    - |
      echo 'App starting, checking config...'
      cat /shared/config.txt
      sleep 3600
    volumeMounts:
    - name: shared-volume
      mountPath: /shared
  volumes:
  - name: shared-volume
    emptyDir: {}
EOF
kubectl apply -f app-with-init.yaml

# Verify Pod
kubectl get pods -n init-demo
kubectl describe pod app-with-init -n init-demo
