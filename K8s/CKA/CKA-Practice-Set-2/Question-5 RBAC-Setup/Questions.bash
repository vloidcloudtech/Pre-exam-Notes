# Question:
# Access control is critical in Kubernetes. Set up RBAC (Role-Based Access Control)
# to create a service account with specific permissions.

# Task:
# 1. Create a namespace called 'rbac-test'
# 2. Create a ServiceAccount named 'app-reader'
# 3. Create a Role named 'pod-reader' that allows:
#    - get, list, watch on pods
#    - get on pods/log
# 4. Create a RoleBinding that binds 'pod-reader' Role to 'app-reader' ServiceAccount
# 5. Create a test pod that uses 'app-reader' ServiceAccount
# 6. Verify the ServiceAccount has correct permissions using kubectl auth can-i

# Video Link - TBD
