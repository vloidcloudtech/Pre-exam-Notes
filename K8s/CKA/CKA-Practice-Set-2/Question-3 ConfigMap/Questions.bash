# Question:
# An application needs configuration data that can be updated without rebuilding
# container images. ConfigMaps are the ideal resource to manage this type of data.

# Task:
# 1. Create a namespace called 'config-demo'
# 2. Create a ConfigMap named 'app-config' with:
#    - Key 'database.url' = 'postgres://db.internal:5432/app'
#    - Key 'log.level' = 'INFO'
#    - A file-based key 'nginx.conf' containing nginx configuration
# 3. Create a Deployment named 'app-server' that uses this ConfigMap:
#    - Mount ConfigMap as volume at /etc/config
#    - Inject ConfigMap keys as environment variables
# 4. Verify the pod can read the configuration from both volume and environment
# 5. Update ConfigMap and verify the pod reflects changes (volume-mounted configs auto-update)

# Video Link - TBD
