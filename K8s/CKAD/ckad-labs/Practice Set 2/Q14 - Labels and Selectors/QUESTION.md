# Question 14 – Labels and Selectors

Use labels and selectors to organize and manage pods effectively.

## Your Task

1. Create 3 pods with different labels:
   - Pod 1: `env=prod`, `app=frontend`
   - Pod 2: `env=prod`, `app=backend`
   - Pod 3: `env=dev`, `app=backend`
2. Use label selectors to:
   - Select all pods with `env=prod`
   - Select all pods with `app=backend`
   - Select pods with `env=prod AND app=backend`
3. Update pod labels and verify changes
4. Delete pods using label selectors

## Docs

- [Labels and Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
