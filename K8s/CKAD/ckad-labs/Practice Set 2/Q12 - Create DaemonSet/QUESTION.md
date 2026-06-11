# Question 12 – Create DaemonSet

Create a DaemonSet that runs a pod on every node in the cluster. This is useful for monitoring, logging, or network agents.

## Your Task

1. Create a DaemonSet named `node-monitor` in namespace `default`
2. The DaemonSet should:
   - Run a pod on every node (including control plane with toleration)
   - Use image: `busybox:latest`
   - Have pod name pattern: `node-monitor-xxxxx`
3. Configure tolerations to run on control plane nodes
4. Verify a pod is running on each node
5. Check the pod count equals the number of nodes

## Docs

- [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
- [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
