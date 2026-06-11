# Answer 15 – Expose Service as LoadBalancer

## Step 1 – Create Deployment

```bash
kubectl create deployment web-app --image=busybox:latest -n default
kubectl scale deployment web-app --replicas=2 -n default
```

## Step 2 – Expose as LoadBalancer service

```bash
kubectl expose deployment web-app \
  --name=web-service \
  --port=80 \
  --target-port=8080 \
  --type=LoadBalancer \
  -n default
```

## Step 3 – Verify Service

```bash
kubectl get service web-service -n default
kubectl describe service web-service -n default
kubectl get endpoints web-service -n default
```

## Step 4 – Test connectivity

```bash
# Get external IP/port
kubectl get service web-service -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}:{.spec.ports[0].port}'

# Port-forward for testing (if no external IP)
kubectl port-forward service/web-service 8080:80 -n default
```

## Step 5 – Scale and verify load balancing

```bash
kubectl scale deployment web-app --replicas=4 -n default
kubectl get pods -n default -l app=web-app
```
