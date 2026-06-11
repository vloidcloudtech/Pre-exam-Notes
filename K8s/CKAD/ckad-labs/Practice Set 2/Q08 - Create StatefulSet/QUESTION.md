# Question 8 – Create StatefulSet

An application requires stable pod names and persistent storage. Create a StatefulSet to handle this.

## Your Task

1. Create a StatefulSet named `db-server` with:
   - 3 replicas
   - Pod names should follow pattern: `db-server-0`, `db-server-1`, `db-server-2`
   - Create a headless Service named `db-service` for the StatefulSet
2. Each pod should have persistent storage using volumeClaimTemplates
3. Verify pods are created with stable names in order
4. Verify PersistentVolumeClaims are created for each pod

## Docs

- [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [Headless Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)
