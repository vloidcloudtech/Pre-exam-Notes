# Question:
# ResourceQuotas limit total resource consumption in a namespace, ensuring fair
# resource allocation across teams and preventing resource exhaustion.

# Task:
# 1. Create a namespace called 'quota-test'
# 2. Create a ResourceQuota named 'compute-quota' that limits:
#    - CPU: 500m
#    - Memory: 512Mi
#    - Number of pods: 5
# 3. Create a Deployment that uses 250m CPU and 256Mi Memory (1 replica)
# 4. Verify the ResourceQuota reflects the resource usage
# 5. Try to create a second deployment that exceeds the quota and verify it fails

# Video Link - TBD
