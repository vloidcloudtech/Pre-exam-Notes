# Answer 9 – Service Discovery and DNS

## Step 1 – Create Deployment

```bash
kubectl create deployment api-server --image=busybox:latest -n default
kubectl scale deployment api-server --replicas=2 -n default
```

## Step 2 – Create Service

```bash
kubectl expose deployment api-server --name=api-service --port=80 --target-port=8080 -n default
```

## Step 3 – Create client pod

```bash
kubectl run client --image=busybox:latest --command -- sleep 3600 -n default
```

## Step 4 – Test DNS resolution

```bash
# Short name
kubectl exec client -n default -- nslookup api-service

# FQDN
kubectl exec client -n default -- nslookup api-service.default.svc.cluster.local

# Test connectivity
kubectl exec client -n default -- wget -O - http://api-service
```
