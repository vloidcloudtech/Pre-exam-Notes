# Question:
# Multi-container pods enable sidecar patterns, init patterns, and shared
# networking/storage between tightly-coupled containers.

# Task:
# 1. Create a namespace called 'multi-container-demo'
# 2. Create a pod with 3 containers:
#    - Main container: application serving on port 8080
#    - Logging sidecar: collecting logs and shipping to stdout
#    - Monitoring sidecar: health checking and metrics
# 3. Configure shared volumes:
#    - emptyDir for shared log files
#    - emptyDir for shared metrics
# 4. Verify all containers are running and share localhost networking
# 5. Verify containers can access shared volumes

# Video Link - TBD
