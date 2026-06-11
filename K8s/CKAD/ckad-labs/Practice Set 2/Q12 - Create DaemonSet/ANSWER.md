# Answer 12 – Create DaemonSet

## Create DaemonSet with tolerations

```bash
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-monitor
  namespace: default
spec:
  selector:
    matchLabels:
      app: node-monitor
  template:
    metadata:
      labels:
        app: node-monitor
    spec:
      tolerations:
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      containers:
      - name: monitor
        image: busybox:latest
        command: ["sh", "-c", "echo 'Node monitor running on $(hostname)' && sleep 3600"]
EOF
```

## Verify DaemonSet

```bash
kubectl get daemonset node-monitor -n default
kubectl get pods -n default -l app=node-monitor -o wide
kubectl get nodes --no-headers | wc -l
kubectl get pods -n default -l app=node-monitor --no-headers | wc -l
```

The pod count should match the node count (or be close if some nodes are tainte).
