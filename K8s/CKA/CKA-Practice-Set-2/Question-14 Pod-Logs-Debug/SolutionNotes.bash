# Create pod with multiple containers
cat <<'EOF' > multi-container-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-app
  namespace: logging-demo
spec:
  containers:
  - name: app
    image: busybox:stable
    command: ["sh", "-c"]
    args:
    - |
      echo "Application starting..."
      for i in 1 2 3 4 5; do
        echo "Log line $i from app"
        sleep 1
      done
      sleep 3600
  - name: sidecar
    image: busybox:stable
    command: ["sh", "-c"]
    args:
    - |
      echo "Sidecar starting..."
      for i in 1 2 3; do
        echo "Sidecar log $i"
        sleep 2
      done
      sleep 3600
EOF
kubectl apply -f multi-container-pod.yaml

# Create failing pod to demonstrate error state
cat <<'EOF' > failing-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: failing-pod
  namespace: logging-demo
spec:
  containers:
  - name: bad-container
    image: busybox:stable
    command: ["sh", "-c", "exit 1"]
  restartPolicy: Never
EOF
kubectl apply -f failing-pod.yaml

# Verify pods
kubectl get pods -n logging-demo
