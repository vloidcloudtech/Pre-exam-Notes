# Question 10 – Fix Deployment Pod Template

A Deployment exists but its Pod template is broken. Fix the template so pods can be successfully deployed.

## Your Task

1. A Deployment named `broken-app` exists with issues in the Pod template
2. Common issues to look for:
   - Missing required fields in containers
   - Invalid image reference
   - Incorrect port configuration
   - Resource specification issues
3. Identify and fix the broken template
4. Verify the deployment creates pods successfully
5. Check all pods are in Running state

## Docs

- [Pod Template](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)
