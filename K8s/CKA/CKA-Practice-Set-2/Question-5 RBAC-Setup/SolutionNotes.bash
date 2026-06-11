# Create ServiceAccount
kubectl create serviceaccount app-reader -n rbac-test

# Create Role with specific permissions
cat <<'EOF' > pod-reader-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: rbac-test
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get"]
EOF
kubectl apply -f pod-reader-role.yaml

# Create RoleBinding
cat <<'EOF' > pod-reader-rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-reader-binding
  namespace: rbac-test
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-reader
subjects:
- kind: ServiceAccount
  name: app-reader
  namespace: rbac-test
EOF
kubectl apply -f pod-reader-rolebinding.yaml

# Create test pod using the ServiceAccount
cat <<'EOF' > test-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: rbac-test-pod
  namespace: rbac-test
spec:
  serviceAccountName: app-reader
  containers:
  - name: busybox
    image: busybox:stable
    command: ["sleep", "3600"]
EOF
kubectl apply -f test-pod.yaml

# Verify RBAC setup
kubectl get serviceaccount -n rbac-test
kubectl get role -n rbac-test
kubectl get rolebinding -n rbac-test
