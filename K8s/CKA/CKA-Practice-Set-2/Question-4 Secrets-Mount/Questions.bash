# Question:
# Your application requires sensitive data like API keys and database credentials
# that should not be stored in ConfigMaps. Create a Secret and mount it securely
# in a pod.

# Task:
# 1. Create a namespace called 'secrets-demo'
# 2. Create a Secret named 'app-secrets' with:
#    - username: admin
#    - password: SecurePass123!
#    - api-key: sk-abc123def456
# 3. Create a Deployment named 'api-client' that:
#    - Mounts the Secret as a volume at /etc/secrets
#    - Injects Secret values as environment variables
# 4. Verify the pod can read secrets from both volume and environment
# 5. Ensure secrets are base64-encoded in etcd

# Video Link - TBD
