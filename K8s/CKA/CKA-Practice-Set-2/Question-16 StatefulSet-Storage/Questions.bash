# Question:
# StatefulSets manage stateful applications with stable network identities
# and persistent storage, commonly used for databases and distributed systems.

# Task:
# 1. Create a namespace called 'statefulset-demo'
# 2. Create a StorageClass (if not present) for persistent volumes
# 3. Create a Headless Service for the StatefulSet
# 4. Create a StatefulSet named 'database' with:
#    - 3 replicas with stable pod names (database-0, database-1, database-2)
#    - Each pod gets persistent storage
#    - Ordered deployment and termination
# 5. Verify stable DNS names for StatefulSet pods
# 6. Verify PersistentVolumeClaims are created for each pod

# Video Link - TBD
