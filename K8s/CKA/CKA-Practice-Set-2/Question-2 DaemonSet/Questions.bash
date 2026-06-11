# Question:
# You need to deploy a system monitoring agent across all nodes in the cluster,
# including master nodes. DaemonSet is the ideal resource for this task as it ensures
# one pod runs on every node.

# Task:
# 1. Create a namespace called 'monitoring'
# 2. Create a DaemonSet named 'node-monitor' with:
#    - Image: busybox:stable
#    - Container name: monitor
#    - Command: sleep 3600 (keeps running)
# 3. Ensure the DaemonSet tolerates master node taints (NoSchedule)
# 4. Verify a pod is running on every node in the cluster
# 5. Label each node with 'monitoring-enabled=true' 
# 6. Modify the DaemonSet to use nodeSelector to only deploy on labeled nodes

# Video Link - TBD
