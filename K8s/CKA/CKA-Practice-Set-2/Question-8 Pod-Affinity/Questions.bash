# Question:
# Pod affinity controls where pods can be scheduled relative to other pods,
# while pod anti-affinity spreads pods across nodes for redundancy.

# Task:
# 1. Create a namespace called 'affinity-demo'
# 2. Create Deployment 'backend' with 2 replicas (baseline)
# 3. Create Deployment 'frontend' with:
#    - podAffinity: requiredDuringSchedulingIgnoredDuringExecution
#    - Co-locate with backend pods (app: backend label)
# 4. Create Deployment 'cache' with:
#    - podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution
#    - Spread cache pods across different nodes
# 5. Verify deployments are scheduled according to affinity rules

# Video Link - TBD
