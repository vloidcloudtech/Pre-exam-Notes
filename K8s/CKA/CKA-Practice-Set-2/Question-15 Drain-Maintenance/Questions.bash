# Question:
# Node drain safely evicts pods from a node for maintenance. Kubernetes respects
# PodDisruptionBudgets and graceful termination periods during drain.

# Task:
# 1. Create a namespace called 'drain-demo'
# 2. Create a Deployment with 3 replicas labeled for drain testing
# 3. Create a PodDisruptionBudget allowing max 1 disruption at a time
# 4. Taint a node to simulate maintenance mode
# 5. Use kubectl drain to safely evict pods from the node
# 6. Verify pods are rescheduled and PDB is respected
# 7. Remove taint to make node available again

# Video Link - TBD
