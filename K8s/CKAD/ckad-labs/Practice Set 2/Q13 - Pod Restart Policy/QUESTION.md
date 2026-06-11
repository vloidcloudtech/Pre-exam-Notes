# Question 13 – Pod Restart Policy

Configure the correct restart policy for a Pod based on its purpose.

## Your Task

1. Create a Pod named `one-time-job` that:
   - Runs a simple command that completes successfully
   - Has restartPolicy: Never (the pod should not restart on exit)
2. Create a Pod named `retry-pod` that:
   - Runs a command that fails initially
   - Has restartPolicy: OnFailure (pod restarts if it fails)
3. Monitor both pods and verify restart behavior
4. Verify pod logs show the execution

## Docs

- [Pod Restart Policy](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy)
