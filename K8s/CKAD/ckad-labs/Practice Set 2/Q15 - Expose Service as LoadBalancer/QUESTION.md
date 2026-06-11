# Question 15 – Expose Service as LoadBalancer

Expose an application externally using a LoadBalancer service type.

## Your Task

1. Create a Deployment named `web-app` with 2 replicas
2. Expose it using a Service of type LoadBalancer:
   - Service name: `web-service`
   - Port: 80
   - Target port: 8080
3. Configure the service to route traffic to pods with label `app: web-app`
4. Verify the external IP/port is accessible
5. Scale the deployment and verify traffic is balanced

## Docs

- [Service - LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
