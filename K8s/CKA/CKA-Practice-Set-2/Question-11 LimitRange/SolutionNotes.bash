# Create pod without explicit resource requests/limits
# LimitRange will inject defaults
cat <<'EOF' > test-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: default-pod
  namespace: limit-demo
spec:
  containers:
  - name: busybox
    image: busybox:stable
    command: ["sleep", "3600"]
EOF
kubectl apply -f test-pod.yaml

# Verify LimitRange
kubectl get limitrange -n limit-demo
kubectl describe limitrange resource-limits -n limit-demo

# Verify pod has default limits injected
echo "Pod with injected defaults:"
kubectl get pod default-pod -n limit-demo -o jsonpath='{.spec.containers[0].resources}'
