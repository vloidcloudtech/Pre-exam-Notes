# CKAD Practice Questions - Lab Setup Scripts

Lab setup scripts for [aravind4799/CKAD-Practice-Questions](https://github.com/aravind4799/CKAD-Practice-Questions).

Each script provisions the prerequisite Kubernetes resources that a question assumes already exist, so you can jump straight into solving the problem.

## Prerequisites

- A running Kubernetes cluster (minikube, kind, k3s, etc.)
- `kubectl` configured and pointing to your cluster
- `podman` or `docker` installed (for Q5 only)

## Usage

```bash
# Make all scripts executable
chmod +x *.sh

# Setup a single question
./q01-setup.sh

# Setup all questions at once
./setup-all.sh

# Setup specific questions
./setup-all.sh 1 3 8 12

# Cleanup everything when done
./cleanup-all.sh

# Cleanup specific questions
./cleanup-all.sh 1 3 8
```

## What Each Script Creates

| Script | Question | Resources Created |
|--------|----------|-------------------|
| `q01-setup.sh` | Create Secret from Hardcoded Variables | Deployment `api-server` with hardcoded env vars |
| `q02-setup.sh` | Create CronJob | _(none - create from scratch)_ |
| `q03-setup.sh` | ServiceAccount, Role, RoleBinding | Namespace `audit`, Pod `log-collector` with default SA |
| `q04-setup.sh` | Fix Broken Pod with Correct SA | Namespace `monitoring`, 3 SAs, 3 Roles, 2 RoleBindings, Pod `metrics-pod` |
| `q05-setup.sh` | Build Container Image | `/root/app-source/` directory with Dockerfile |
| `q06-setup.sh` | Canary Deployment | Deployment `web-app` (5 replicas), Service `web-service` |
| `q07-setup.sh` | Fix NetworkPolicy Labels | Namespace `network-demo`, 3 Pods (wrong labels), 3 NetworkPolicies |
| `q08-setup.sh` | Fix Broken Deployment YAML | `/root/broken-deploy.yaml` with intentional errors |
| `q09-setup.sh` | Rolling Update and Rollback | Deployment `app-v1` with `nginx:1.20` |
| `q10-setup.sh` | Add Readiness Probe | Deployment `api-deploy` on port 8080 |
| `q11-setup.sh` | Security Context | Deployment `secure-app` with no security context |
| `q12-setup.sh` | Fix Service Selector | Deployment `web-app`, Service `web-svc` (wrong selector) |
| `q13-setup.sh` | Create NodePort Service | Deployment `api-server` with label `app=api`, port 9090 |
| `q14-setup.sh` | Create Ingress | Deployment `web-deploy`, Service `web-svc` on port 8080 |
| `q15-setup.sh` | Fix Ingress PathType | `/root/fix-ingress.yaml` (invalid pathType), Service `api-svc` |
| `q16-setup.sh` | Resource Requests and Limits | Namespace `prod` with ResourceQuota |

## Notes

- **Resource conflicts**: Some questions use the same resource names in `default` namespace (e.g., Q1 and Q13 both create `api-server`). Run them independently or clean up between questions.
- **Q5** requires `podman` or `docker` on the node and writes to `/root/`.
- **Q8 and Q15** write files to `/root/` to simulate exam file-based questions.
- Scripts are idempotent — safe to re-run.
