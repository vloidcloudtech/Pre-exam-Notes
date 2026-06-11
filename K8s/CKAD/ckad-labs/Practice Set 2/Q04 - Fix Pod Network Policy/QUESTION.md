# Question 4 – Fix Pod Network Policy

A NetworkPolicy has been deployed but pods cannot communicate as expected. You need to fix the policy to allow the correct traffic.

## Your Task

1. A NetworkPolicy named `app-policy` exists but is misconfigured
2. Fix the policy to:
   - Allow ingress traffic on port 8080
   - Allow traffic from pods with label `role: frontend`
   - Allow egress traffic to all destinations
3. Create a frontend pod with the correct label
4. Create a backend pod (API server)
5. Verify the frontend pod can reach the backend pod

## Docs

- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
