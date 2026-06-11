# Question:
# Pod Disruption Budgets (PDB) define the minimum number of pods that must remain
# available during voluntary disruptions (maintenance, updates).

# Task:
# 1. Create a namespace called 'pdb-demo'
# 2. Create a Deployment named 'web-app' with 3 replicas
# 3. Create a PodDisruptionBudget named 'web-app-pdb' that:
#    - Maintains minimum 2 available pods
#    - Applies to pods with label app: web-app
# 4. Verify PDB is configured correctly
# 5. Test PDB by attempting to evict pods and verify minimum availability is maintained

# Video Link - TBD
