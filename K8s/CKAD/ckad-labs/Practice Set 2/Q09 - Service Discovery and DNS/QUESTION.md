# Question 9 – Service Discovery and DNS

Services in Kubernetes use DNS for discovery. Configure a service and test DNS name resolution from within the cluster.

## Your Task

1. Create a Deployment named `api-server` with 2 replicas
2. Expose it with a Service named `api-service` (type: ClusterIP) on port 80
3. Create a client pod that performs DNS lookup for the service
4. Verify the service is discoverable using:
   - Short name: `api-service`
   - FQDN: `api-service.default.svc.cluster.local`
5. Test connectivity from client to service

## Docs

- [Service Discovery](https://kubernetes.io/docs/concepts/services-networking/service-discovery-dns/)
