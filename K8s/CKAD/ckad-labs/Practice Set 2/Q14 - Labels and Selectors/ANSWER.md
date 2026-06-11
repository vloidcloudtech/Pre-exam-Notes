# Answer 14 – Labels and Selectors

## Step 1 – Create labeled pods

```bash
kubectl run pod1 --image=busybox:latest --labels=env=prod,app=frontend -- sleep 3600
kubectl run pod2 --image=busybox:latest --labels=env=prod,app=backend -- sleep 3600
kubectl run pod3 --image=busybox:latest --labels=env=dev,app=backend -- sleep 3600
```

## Step 2 – Use label selectors to query

```bash
# Select all production pods
kubectl get pods -n default -l env=prod

# Select all backend pods
kubectl get pods -n default -l app=backend

# Select production backend pods
kubectl get pods -n default -l env=prod,app=backend

# Equality-based selector
kubectl get pods -n default -l 'app in (frontend,backend)'
```

## Step 3 – Update labels

```bash
kubectl label pods pod1 -n default version=v1.0 --overwrite
kubectl get pods --show-labels -n default
```

## Step 4 – Delete pods using selectors

```bash
# Delete all dev pods
kubectl delete pods -n default -l env=dev

# Verify deletion
kubectl get pods -n default
```
