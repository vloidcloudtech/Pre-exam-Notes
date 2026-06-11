# Create pod with multiple containers
cat <<'EOF' > multi-container-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-sidecars
  namespace: multi-container-demo
spec:
  containers:
  # Main application container
  - name: app
    image: busybox:stable
    command: ["sh", "-c"]
    args:
    - |
      echo "Application container started"
      for i in 1 2 3 4 5; do
        echo "INFO: Request $i processed" >> /shared/logs/app.log
        echo "app_requests_total{job=\"app\"} $i" >> /shared/metrics/app.metrics
        sleep 2
      done
      sleep 3600
    ports:
    - containerPort: 8080
    volumeMounts:
    - name: shared-logs
      mountPath: /shared/logs
    - name: shared-metrics
      mountPath: /shared/metrics
  # Logging sidecar container
  - name: logger
    image: busybox:stable
    command: ["sh", "-c"]
    args:
    - |
      echo "Logger sidecar started"
      sleep 5
      tail -f /shared/logs/app.log 2>/dev/null || sleep 3600
    volumeMounts:
    - name: shared-logs
      mountPath: /shared/logs
  # Monitoring sidecar container
  - name: monitor
    image: busybox:stable
    command: ["sh", "-c"]
    args:
    - |
      echo "Monitor sidecar started"
      while true; do
        if [ -f /shared/metrics/app.metrics ]; then
          echo "Metrics available"
          sleep 10
        else
          sleep 5
        fi
      done
    volumeMounts:
    - name: shared-metrics
      mountPath: /shared/metrics
  volumes:
  - name: shared-logs
    emptyDir: {}
  - name: shared-metrics
    emptyDir: {}
EOF
kubectl apply -f multi-container-pod.yaml

# Verify pod
kubectl get pods -n multi-container-demo
kubectl describe pod app-with-sidecars -n multi-container-demo
