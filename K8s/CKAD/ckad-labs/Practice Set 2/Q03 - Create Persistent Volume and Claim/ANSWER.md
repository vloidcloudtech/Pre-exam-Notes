# Answer 3 – Create Persistent Volume and Claim

## Step 1 – Create PersistentVolume

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data
EOF
```

## Step 2 – Create PersistentVolumeClaim

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pvc
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
EOF
```

## Step 3 – Create Pod using PVC

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pv-consumer
  namespace: default
spec:
  containers:
  - name: app
    image: busybox:latest
    command: ["sh", "-c", "echo 'Persistent data' > /data/file.txt && cat /data/file.txt && sleep 3600"]
    volumeMounts:
    - name: task-storage
      mountPath: /data
  volumes:
  - name: task-storage
    persistentVolumeClaim:
      claimName: task-pvc
EOF
```

## Step 4 – Verify

```bash
kubectl get pv
kubectl get pvc
kubectl get pod pv-consumer -n default
```
