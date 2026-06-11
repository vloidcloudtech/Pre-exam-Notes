# Question:
# A team needs to deploy a database application that requires stable network identities
# and persistent storage for each replica. Your task is to create a StatefulSet that
# maintains hostname stability and uses persistent storage.

# Task:
# 1. Create a namespace called 'databases'
# 2. Create a StatefulSet named 'mysql-db' with:
#    - 3 replicas
#    - Image: mysql:5.7
#    - Container name: mysql
#    - Environment variable MYSQL_ROOT_PASSWORD set to 'secure123'
#    - Mount a persistent volume at /var/lib/mysql with the claim name 'mysql-storage'
# 3. Create a headless Service named 'mysql-service' that targets the StatefulSet
# 4. Verify each pod has a stable DNS name (mysql-db-0.mysql-service.databases.svc.cluster.local)
# 5. Ensure PersistentVolumeClaims are created for each replica

# Video Link - TBD
