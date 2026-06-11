# Question 11 – Add Volume Mount to Pod

A Pod needs access to configuration and data from external storage. Add and configure volume mounts.

## Your Task

1. Create a ConfigMap named `app-config` with sample configuration data
2. Create a Pod named `data-consumer` that:
   - Mounts the ConfigMap as a volume at `/etc/config`
   - Mounts an emptyDir volume at `/tmp/cache`
3. The pod should have a command that reads from both mounted paths
4. Verify both volume mounts are accessible from within the pod

## Docs

- [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
- [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
