# Question:
# LimitRange enforces minimum and maximum resource requests/limits, preventing
# pod resource outliers and ensuring consistent resource allocation.

# Task:
# 1. Create a namespace called 'limit-demo'
# 2. Create a LimitRange named 'resource-limits' that enforces:
#    - CPU min: 50m, max: 1000m
#    - Memory min: 32Mi, max: 1Gi
#    - Default CPU request: 100m, limit: 500m
#    - Default Memory request: 64Mi, limit: 512Mi
# 3. Create a pod that respects the LimitRange (no explicit requests/limits)
# 4. Verify the pod gets default limits injected
# 5. Try to create a pod that violates LimitRange and verify it fails

# Video Link - TBD
