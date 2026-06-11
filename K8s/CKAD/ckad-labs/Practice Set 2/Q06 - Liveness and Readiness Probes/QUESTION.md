# Question 6 – Liveness and Readiness Probes

An application needs health checks configured to ensure it's properly monitored and restarted if unhealthy.

## Your Task

1. Create a Deployment named `health-check-app` with:
   - A liveness probe that checks the app every 10 seconds
   - A readiness probe that checks if app is ready to serve traffic
   - Both probes using HTTP GET on port 8080 path `/health`
2. The pod should have:
   - Initial delay of 5 seconds for readiness probe
   - Initial delay of 15 seconds for liveness probe
3. Failure threshold of 3 for both probes
4. Verify probes are configured correctly

## Docs

- [Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
