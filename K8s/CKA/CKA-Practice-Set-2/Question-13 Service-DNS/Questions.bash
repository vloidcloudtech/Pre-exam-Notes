# Question:
# Services use DNS names to discover other services in the cluster.
# Kubernetes DNS automatically creates DNS records for services.

# Task:
# 1. Create a namespace called 'dns-demo'
# 2. Create a Service named 'api-backend' (type: ClusterIP)
# 3. Create a Deployment named 'api-pod' with 2 replicas
# 4. Create a client pod that queries the service using DNS names:
#    - Short name: api-backend
#    - FQDN: api-backend.dns-demo.svc.cluster.local
# 5. Verify DNS resolution works from within the cluster

# Video Link - TBD
