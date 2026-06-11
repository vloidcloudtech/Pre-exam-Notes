# Label all nodes as monitoring-enabled
kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | xargs -I {} kubectl label node {} monitoring-enabled=true --overwrite

# Create DaemonSet with tolerations for master and nodeSelector
cat <<'EOF' > node-monitor-ds.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-monitor
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: node-monitor
  template:
    metadata:
      labels:
        app: node-monitor
    spec:
      nodeSelector:
        monitoring-enabled: "true"
      tolerations:
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      containers:
      - name: monitor
        image: busybox:stable
        command: ["sh", "-c", "echo 'Monitoring node: '$(hostname); sleep 3600"]
        resources:
          requests:
            cpu: 50m
            memory: 32Mi
          limits:
            cpu: 100m
            memory: 64Mi
EOF
kubectl apply -f node-monitor-ds.yaml

# Verify DaemonSet
kubectl get daemonset -n monitoring
kubectl get pods -n monitoring -o wide
