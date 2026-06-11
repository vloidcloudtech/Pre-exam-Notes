# Answer 10 – Fix Deployment Pod Template

## Step 1 – View broken deployment

```bash
kubectl get deployment broken-app -n default
kubectl describe deployment broken-app -n default
kubectl get pods -n default
```

## Step 2 – Edit deployment

```bash
kubectl edit deployment broken-app -n default
```

## Step 3 – Fix common issues

Check and fix:
- Image: should be `busybox:latest`
- Ensure `imagePullPolicy` is set to `IfNotPresent` or `Always`
- Ensure ports are correctly specified if needed
- Ensure resource requests/limits are valid if specified
- Ensure label selector matches pod labels

## Step 4 – Example fixed template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: broken-app
  template:
    metadata:
      labels:
        app: broken-app
    spec:
      containers:
      - name: app
        image: busybox:latest
        command: ["sleep", "3600"]
        imagePullPolicy: IfNotPresent
EOF
```

## Step 5 – Verify

```bash
kubectl get deployment broken-app -n default
kubectl get pods -n default -l app=broken-app
```
