# Question 7 – Container Security Context

A container needs to run with restricted security settings to follow the principle of least privilege.

## Your Task

1. Create a Pod named `secure-pod` with:
   - A security context that:
     - Runs as user ID 1001 (non-root)
     - Sets fsGroup to 2000
     - Disables privileged mode
     - Makes filesystem read-only
2. Verify the security context is applied correctly
3. Ensure the pod can still write to `/tmp` (mounted as emptyDir)

## Docs

- [Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
