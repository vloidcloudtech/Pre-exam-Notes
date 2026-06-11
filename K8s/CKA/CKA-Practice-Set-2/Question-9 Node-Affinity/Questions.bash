# Question:
# Node affinity controls pod scheduling based on node labels and node properties,
# enabling placement on specific nodes with desired characteristics.

# Task:
# 1. Create a namespace called 'node-affinity-demo'
# 2. Label nodes with custom labels (e.g., 'disktype=ssd', 'region=us-west')
# 3. Create Deployment 'ssd-app' with:
#    - requiredNodeAffinity: only on nodes with disktype=ssd
# 4. Create Deployment 'standard-app' with:
#    - preferredNodeAffinity: prefer nodes with disktype=standard
# 5. Verify pods are scheduled according to node affinity rules

# Video Link - TBD
