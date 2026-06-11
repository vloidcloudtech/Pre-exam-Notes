# Question 5 – Scale Deployment and Update Strategy

An application deployment needs to be scaled and configured with a proper update strategy.

## Your Task

1. Create a Deployment named `web-server` with:
   - 2 initial replicas
   - Image: `busybox:latest`
   - Label: `app: web`
2. Scale the deployment to 5 replicas
3. Configure the deployment with:
   - Rolling update strategy
   - maxSurge: 2
   - maxUnavailable: 1
4. Update the image to a new version
5. Monitor the rolling update process

## Docs

- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Rolling Updates](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
