# kubectl Command Learning Guide & Cheat Sheet

## Learning Strategy for kubectl Commands

### 1. **Core Learning Principles**

#### Understanding the Pattern
Most kubectl commands follow this structure:
```
kubectl [verb] [resource] [name] [flags]
```

**Verbs (Actions):**
- `create` - Create a resource
- `get` - List resources
- `describe` - Show detailed information
- `delete` - Delete resources
- `edit` - Edit a resource
- `apply` - Apply a configuration
- `exec` - Execute command in container
- `logs` - Print container logs
- `run` - Run a pod
- `expose` - Create a service
- `scale` - Scale a deployment
- `set` - Set specific features
- `rollout` - Manage rollouts
- `label` - Update labels
- `annotate` - Update annotations
- `patch` - Partially update
- `replace` - Replace a resource
- `port-forward` - Forward ports
- `proxy` - Run kubectl proxy
- `cp` - Copy files
- `attach` - Attach to container
- `auth` - Inspect authorization
- `cluster-info` - Display cluster info
- `config` - Modify kubeconfig
- `cordon` - Mark node unschedulable
- `uncordon` - Mark node schedulable
- `drain` - Drain node
- `taint` - Update taints

**Resources (What):**
- `pod` (po)
- `service` (svc)
- `deployment` (deploy)
- `replicaset` (rs)
- `statefulset` (sts)
- `daemonset` (ds)
- `job`
- `cronjob` (cj)
- `configmap` (cm)
- `secret`
- `ingress` (ing)
- `node` (no)
- `namespace` (ns)
- `persistentvolume` (pv)
- `persistentvolumeclaim` (pvc)
- `serviceaccount` (sa)
- `role`
- `rolebinding`
- `clusterrole`
- `clusterrolebinding`
- `networkpolicy` (netpol)
- `horizontalpodautoscaler` (hpa)
- `priorityclass` (pc)
- `resourcequota` (quota)
- `limitrange` (limits)
- `storageclass` (sc)
- `volumeattachment`
- `componentstatus` (cs)
- `endpoint` (ep)
- `event` (ev)

---

## 2. **Most Important Flags to Master**

### Global Flags (Work with Most Commands)
| Flag | Short | Purpose | Example |
|------|-------|---------|---------|
| `--namespace` | `-n` | Specify namespace | `kubectl get pods -n kube-system` |
| `--all-namespaces` | `-A` | All namespaces | `kubectl get pods -A` |
| `--output` | `-o` | Output format | `kubectl get pods -o yaml` |
| `--selector` | `-l` | Label selector | `kubectl get pods -l app=nginx` |
| `--field-selector` | | Field selector | `kubectl get pods --field-selector status.phase=Running` |
| `--watch` | `-w` | Watch for changes | `kubectl get pods -w` |
| `--help` | `-h` | Get help | `kubectl create -h` |
| `--dry-run` | | Simulation mode | `kubectl create deployment nginx --image=nginx --dry-run=client` |
| `--kubeconfig` | | Specify config file | `kubectl --kubeconfig=/path/to/config get pods` |

### Output Format Options (`-o`)
| Format | Description | Example |
|--------|-------------|---------|
| `json` | JSON output | `kubectl get pod nginx -o json` |
| `yaml` | YAML output | `kubectl get pod nginx -o yaml` |
| `wide` | Extra columns | `kubectl get pods -o wide` |
| `name` | Resource names only | `kubectl get pods -o name` |
| `jsonpath` | Extract specific fields | `kubectl get pods -o jsonpath='{.items[*].metadata.name}'` |
| `custom-columns` | Custom table | `kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase` |
| `go-template` | Go template | `kubectl get pods -o go-template='{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'` |

---

## 3. **Command Categories & Essential Flags**

### Creating Resources

#### `kubectl create` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--image` | Specify container image | `kubectl create deployment nginx --image=nginx:1.20` |
| `--replicas` | Number of replicas | `kubectl create deployment nginx --image=nginx --replicas=3` |
| `--port` | Container port | `kubectl create deployment nginx --image=nginx --port=80` |
| `--dry-run=client` | Generate without creating | `kubectl create deployment nginx --image=nginx --dry-run=client -o yaml` |
| `--save-config` | Save config for future apply | `kubectl create -f pod.yaml --save-config` |
| `--from-literal` | Create from literal value | `kubectl create configmap my-config --from-literal=key=value` |
| `--from-file` | Create from file | `kubectl create configmap my-config --from-file=config.txt` |
| `--from-env-file` | Create from env file | `kubectl create configmap my-config --from-env-file=.env` |

#### `kubectl run` Flags (Pod Creation)
| Flag | Purpose | Example |
|------|---------|---------|
| `--image` | Container image | `kubectl run nginx --image=nginx` |
| `--port` | Expose port | `kubectl run nginx --image=nginx --port=80` |
| `--rm` | Delete after exit | `kubectl run test --image=busybox --rm -it -- sh` |
| `-it` | Interactive terminal | `kubectl run test --image=busybox -it -- sh` |
| `--restart` | Restart policy | `kubectl run job --image=busybox --restart=OnFailure` |
| `--limits` | Resource limits | `kubectl run nginx --image=nginx --limits='cpu=200m,memory=512Mi'` |
| `--requests` | Resource requests | `kubectl run nginx --image=nginx --requests='cpu=100m,memory=256Mi'` |
| `--env` | Environment variable | `kubectl run nginx --image=nginx --env='ENV=prod'` |
| `--labels` | Add labels | `kubectl run nginx --image=nginx --labels='app=web,env=prod'` |
| `--serviceaccount` | Service account | `kubectl run nginx --image=nginx --serviceaccount=my-sa` |
| `--` | Command separator | `kubectl run busybox --image=busybox -- sleep 3600` |

### Viewing Resources

#### `kubectl get` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--all-namespaces` / `-A` | All namespaces | `kubectl get pods -A` |
| `--watch` / `-w` | Watch changes | `kubectl get pods -w` |
| `--output` / `-o` | Output format | `kubectl get pods -o yaml` |
| `--selector` / `-l` | Label selector | `kubectl get pods -l app=nginx` |
| `--field-selector` | Field selector | `kubectl get pods --field-selector=status.phase=Running` |
| `--sort-by` | Sort results | `kubectl get pods --sort-by=.metadata.creationTimestamp` |
| `--show-labels` | Show all labels | `kubectl get pods --show-labels` |
| `--label-columns` / `-L` | Show specific label columns | `kubectl get pods -L app,version` |
| `--no-headers` | Omit headers | `kubectl get pods --no-headers` |
| `--export` | Export without metadata | `kubectl get deployment nginx --export -o yaml` |

#### `kubectl describe` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--show-events` | Show events (default true) | `kubectl describe pod nginx --show-events=false` |

### Modifying Resources

#### `kubectl edit` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--output` / `-o` | Output format after edit | `kubectl edit deployment nginx -o json` |
| `--save-config` | Save config | `kubectl edit deployment nginx --save-config` |
| `--validate` | Validate before save | `kubectl edit deployment nginx --validate=true` |

#### `kubectl set` Subcommands & Flags
| Subcommand | Purpose | Example |
|------------|---------|---------|
| `image` | Update image | `kubectl set image deployment/nginx nginx=nginx:1.20` |
| `resources` | Set resources | `kubectl set resources deployment nginx --limits=cpu=200m,memory=512Mi` |
| `selector` | Set selector | `kubectl set selector service my-service app=nginx` |
| `env` | Set environment | `kubectl set env deployment/nginx ENV=prod` |
| `serviceaccount` | Set service account | `kubectl set serviceaccount deployment nginx my-sa` |
| `subject` | Set RBAC subject | `kubectl set subject rolebinding admin --user=jane` |

#### `kubectl label` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--overwrite` | Overwrite existing | `kubectl label pod nginx env=prod --overwrite` |
| `--all` | All resources | `kubectl label pods --all env=prod` |
| `--selector` / `-l` | Label selector | `kubectl label pods -l app=nginx tier=frontend` |
| Key- | Remove label | `kubectl label pod nginx env-` |

#### `kubectl annotate` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--overwrite` | Overwrite existing | `kubectl annotate pod nginx description='web server' --overwrite` |
| `--all` | All resources | `kubectl annotate pods --all description='production'` |
| Key- | Remove annotation | `kubectl annotate pod nginx description-` |

#### `kubectl scale` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--replicas` | Number of replicas | `kubectl scale deployment nginx --replicas=5` |
| `--current-replicas` | Precondition check | `kubectl scale deployment nginx --current-replicas=3 --replicas=5` |
| `--timeout` | Operation timeout | `kubectl scale deployment nginx --replicas=5 --timeout=1m` |

#### `kubectl patch` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--type` | Patch type (json/merge/strategic) | `kubectl patch deployment nginx --type=json -p='[{"op":"replace","path":"/spec/replicas","value":3}]'` |
| `-p` | Patch data | `kubectl patch deployment nginx -p='{"spec":{"replicas":3}}'` |
| `--dry-run` | Test patch | `kubectl patch deployment nginx -p='{"spec":{"replicas":3}}' --dry-run=client` |

### Deleting Resources

#### `kubectl delete` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--all` | Delete all | `kubectl delete pods --all` |
| `--force` | Force delete | `kubectl delete pod nginx --force` |
| `--grace-period` | Grace period seconds | `kubectl delete pod nginx --grace-period=0` |
| `--cascade` | Cascade deletion | `kubectl delete deployment nginx --cascade=orphan` |
| `--now` | Delete immediately | `kubectl delete pod nginx --now` |
| `--wait` | Wait for deletion | `kubectl delete pod nginx --wait=false` |
| `--selector` / `-l` | Label selector | `kubectl delete pods -l app=nginx` |
| `--field-selector` | Field selector | `kubectl delete pods --field-selector=status.phase=Failed` |

### Debugging & Troubleshooting

#### `kubectl logs` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--follow` / `-f` | Stream logs | `kubectl logs nginx -f` |
| `--previous` / `-p` | Previous container logs | `kubectl logs nginx -p` |
| `--since` | Logs since duration | `kubectl logs nginx --since=1h` |
| `--since-time` | Logs since timestamp | `kubectl logs nginx --since-time=2023-01-01T00:00:00Z` |
| `--timestamps` | Include timestamps | `kubectl logs nginx --timestamps` |
| `--tail` | Number of lines | `kubectl logs nginx --tail=100` |
| `--container` / `-c` | Specific container | `kubectl logs nginx -c sidecar` |
| `--all-containers` | All containers | `kubectl logs nginx --all-containers` |
| `--selector` / `-l` | Label selector | `kubectl logs -l app=nginx` |
| `--max-log-requests` | Parallel log requests | `kubectl logs -l app=nginx --max-log-requests=10` |

#### `kubectl exec` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `-it` | Interactive terminal | `kubectl exec -it nginx -- bash` |
| `--container` / `-c` | Specific container | `kubectl exec nginx -c sidecar -- ls` |
| `--stdin` / `-i` | Pass stdin | `kubectl exec -i nginx -- cat > /tmp/file` |
| `--tty` / `-t` | Allocate TTY | `kubectl exec -t nginx -- bash` |
| `--` | Command separator | `kubectl exec nginx -- ls -la` |

#### `kubectl port-forward` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--address` | Listen address | `kubectl port-forward nginx 8080:80 --address=0.0.0.0` |

#### `kubectl cp` Usage
| Direction | Example |
|-----------|---------|
| Pod to Local | `kubectl cp nginx:/var/log/nginx.log ./nginx.log` |
| Local to Pod | `kubectl cp ./file.txt nginx:/tmp/file.txt` |
| With Container | `kubectl cp nginx:/tmp/file.txt ./file.txt -c sidecar` |

### Rollout Management

#### `kubectl rollout` Subcommands
| Subcommand | Purpose | Example |
|------------|---------|---------|
| `status` | Check status | `kubectl rollout status deployment/nginx` |
| `history` | View history | `kubectl rollout history deployment/nginx` |
| `undo` | Rollback | `kubectl rollout undo deployment/nginx` |
| `pause` | Pause rollout | `kubectl rollout pause deployment/nginx` |
| `resume` | Resume rollout | `kubectl rollout resume deployment/nginx` |
| `restart` | Restart pods | `kubectl rollout restart deployment/nginx` |

#### `kubectl rollout` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--to-revision` | Specific revision | `kubectl rollout undo deployment/nginx --to-revision=3` |
| `--watch` / `-w` | Watch status | `kubectl rollout status deployment/nginx -w` |
| `--revision` | Show specific revision | `kubectl rollout history deployment/nginx --revision=2` |

### Service & Networking

#### `kubectl expose` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--port` | Service port | `kubectl expose deployment nginx --port=80` |
| `--target-port` | Container port | `kubectl expose deployment nginx --port=80 --target-port=8080` |
| `--type` | Service type | `kubectl expose deployment nginx --port=80 --type=NodePort` |
| `--node-port` | Specific NodePort | `kubectl expose deployment nginx --port=80 --type=NodePort --node-port=30080` |
| `--external-ip` | External IP | `kubectl expose deployment nginx --port=80 --external-ip=1.2.3.4` |
| `--load-balancer-ip` | LB IP | `kubectl expose deployment nginx --port=80 --type=LoadBalancer --load-balancer-ip=1.2.3.4` |
| `--selector` | Pod selector | `kubectl expose deployment nginx --port=80 --selector='app=nginx'` |
| `--session-affinity` | Session affinity | `kubectl expose deployment nginx --port=80 --session-affinity=ClientIP` |
| `--cluster-ip` | Cluster IP | `kubectl expose deployment nginx --port=80 --cluster-ip=10.0.0.100` |
| `--name` | Service name | `kubectl expose deployment nginx --port=80 --name=nginx-service` |
| `--protocol` | Protocol | `kubectl expose deployment nginx --port=80 --protocol=TCP` |

### RBAC Commands

#### `kubectl auth` Subcommands
| Subcommand | Purpose | Example |
|------------|---------|---------|
| `can-i` | Check permissions | `kubectl auth can-i create pods` |
| `reconcile` | Reconcile RBAC | `kubectl auth reconcile -f rbac.yaml` |

#### `kubectl auth can-i` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--as` | Impersonate user | `kubectl auth can-i create pods --as=jane` |
| `--as-group` | Impersonate group | `kubectl auth can-i create pods --as=jane --as-group=developers` |
| `--all-namespaces` | Check all namespaces | `kubectl auth can-i create pods --all-namespaces` |
| `--list` | List all permissions | `kubectl auth can-i --list` |
| `--subresource` | Check subresource | `kubectl auth can-i get pods --subresource=log` |

### Node Management

#### `kubectl cordon/uncordon`
| Command | Purpose | Example |
|---------|---------|---------|
| `cordon` | Mark unschedulable | `kubectl cordon node1` |
| `uncordon` | Mark schedulable | `kubectl uncordon node1` |

#### `kubectl drain` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--force` | Force deletion | `kubectl drain node1 --force` |
| `--ignore-daemonsets` | Ignore DaemonSets | `kubectl drain node1 --ignore-daemonsets` |
| `--delete-emptydir-data` | Delete emptyDir data | `kubectl drain node1 --delete-emptydir-data` |
| `--grace-period` | Grace period | `kubectl drain node1 --grace-period=30` |
| `--timeout` | Operation timeout | `kubectl drain node1 --timeout=5m` |
| `--pod-selector` | Drain specific pods | `kubectl drain node1 --pod-selector='app=nginx'` |
| `--disable-eviction` | Use delete instead | `kubectl drain node1 --disable-eviction` |
| `--skip-wait-for-delete-timeout` | Skip wait timeout | `kubectl drain node1 --skip-wait-for-delete-timeout=10` |

#### `kubectl taint` Usage
| Action | Example |
|--------|---------|
| Add taint | `kubectl taint nodes node1 key=value:NoSchedule` |
| Remove taint | `kubectl taint nodes node1 key:NoSchedule-` |
| Overwrite taint | `kubectl taint nodes node1 key=value:NoSchedule --overwrite` |

### Configuration Management

#### `kubectl config` Subcommands
| Subcommand | Purpose | Example |
|------------|---------|---------|
| `current-context` | Show current context | `kubectl config current-context` |
| `get-contexts` | List contexts | `kubectl config get-contexts` |
| `use-context` | Switch context | `kubectl config use-context prod` |
| `set-context` | Modify context | `kubectl config set-context --current --namespace=dev` |
| `get-clusters` | List clusters | `kubectl config get-clusters` |
| `set-cluster` | Configure cluster | `kubectl config set-cluster prod --server=https://1.2.3.4` |
| `set-credentials` | Set user credentials | `kubectl config set-credentials user --token=abc123` |
| `view` | View config | `kubectl config view` |
| `delete-context` | Delete context | `kubectl config delete-context old-context` |
| `rename-context` | Rename context | `kubectl config rename-context old new` |

#### `kubectl config` Common Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--kubeconfig` | Config file | `kubectl config view --kubeconfig=/path/to/config` |
| `--minify` | Minimal output | `kubectl config view --minify` |
| `--raw` | Raw config | `kubectl config view --raw` |
| `--flatten` | Flatten config | `kubectl config view --flatten` |
| `--merge` | Merge configs | `kubectl config view --merge` |

### Advanced Operations

#### `kubectl apply` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `-f` / `--filename` | Specify file | `kubectl apply -f deployment.yaml` |
| `-R` / `--recursive` | Recursive directory | `kubectl apply -f ./configs/ -R` |
| `--prune` | Delete removed resources | `kubectl apply -f manifest.yaml --prune` |
| `--cascade` | Cascade strategy | `kubectl apply -f manifest.yaml --cascade=orphan` |
| `--force` | Force apply | `kubectl apply -f manifest.yaml --force` |
| `--grace-period` | Termination grace period | `kubectl apply -f manifest.yaml --grace-period=30` |
| `--dry-run` | Test apply | `kubectl apply -f manifest.yaml --dry-run=server` |
| `--server-side` | Server-side apply | `kubectl apply -f manifest.yaml --server-side` |
| `--field-manager` | Field manager name | `kubectl apply -f manifest.yaml --field-manager=kubectl` |
| `--force-conflicts` | Force conflicts | `kubectl apply -f manifest.yaml --force-conflicts` |

#### `kubectl replace` Flags
| Flag | Purpose | Example |
|------|---------|---------|
| `--force` | Delete and recreate | `kubectl replace --force -f pod.yaml` |
| `--cascade` | Cascade strategy | `kubectl replace -f deployment.yaml --cascade=orphan` |
| `--grace-period` | Grace period | `kubectl replace -f pod.yaml --grace-period=0` |
| `--save-config` | Save config | `kubectl replace -f deployment.yaml --save-config` |
| `--validate` | Validate manifest | `kubectl replace -f deployment.yaml --validate=true` |

#### `kubectl diff` Usage
| Purpose | Example |
|---------|---------|
| Compare with cluster | `kubectl diff -f deployment.yaml` |
| Recursive diff | `kubectl diff -R -f ./configs/` |

---

## 4. **Daily Practice Routine**

### Week 1: Basic Operations
**Day 1-2: Pod Management**
- Practice: `kubectl run`, `kubectl get pods`, `kubectl describe pod`
- Master flags: `--image`, `-o wide`, `-o yaml`, `--all-namespaces`

**Day 3-4: Deployments**
- Practice: `kubectl create deployment`, `kubectl scale`, `kubectl set image`
- Master flags: `--replicas`, `--dry-run=client`, `--record`

**Day 5-7: Services & Networking**
- Practice: `kubectl expose`, `kubectl get svc`, `kubectl get endpoints`
- Master flags: `--type`, `--port`, `--target-port`, `--selector`

### Week 2: Intermediate Operations
**Day 8-9: ConfigMaps & Secrets**
- Practice: Creating from literals, files, and env files
- Master flags: `--from-literal`, `--from-file`, `--from-env-file`

**Day 10-11: Labels & Selectors**
- Practice: `kubectl label`, using `-l` selector
- Master complex selectors: `app=nginx,env!=prod`, `version in (v1,v2)`

**Day 12-14: Troubleshooting**
- Practice: `kubectl logs`, `kubectl exec`, `kubectl describe`
- Master flags: `-f`, `--previous`, `-it`, `--since`

### Week 3: Advanced Operations
**Day 15-16: RBAC**
- Practice: Creating roles, rolebindings, testing with `auth can-i`
- Master flags: `--verb`, `--resource`, `--as`

**Day 17-18: Node Management**
- Practice: `kubectl taint`, `kubectl cordon`, `kubectl drain`
- Master taint effects: NoSchedule, PreferNoSchedule, NoExecute

**Day 19-21: Advanced Outputs**
- Practice: JSONPath, custom-columns, Go templates
- Master complex queries and field extraction

### Week 4: Exam Preparation
**Day 22-24: Speed Drills**
- Time yourself creating resources imperatively
- Practice generating YAML with `--dry-run=client -o yaml`
- Master quick edits with `kubectl edit` and `kubectl patch`

**Day 25-27: Scenario Practice**
- Complete end-to-end scenarios
- Practice rollbacks and updates
- Debug failing deployments

**Day 28-30: Review & Mock Exams**
- Review all command categories
- Take practice exams
- Focus on weak areas

---

## 5. **Memory Techniques**

### Mnemonics for Common Flags
- **CWONS**: Create, Watch, Output, Namespace, Selector (most common flags)
- **GRID**: Get, Run, (apply) Image, Delete (basic verbs)
- **SEAL**: Scale, Expose, Annotate, Label (modification verbs)

### Command Patterns to Remember
1. **Resource Creation Pattern:**
   ```
   kubectl create [resource] [name] --image=[image] --replicas=[n] --port=[port]
   ```

2. **Debugging Pattern:**
   ```
   kubectl logs [pod] -f --tail=100 --previous --timestamps
   kubectl exec -it [pod] -c [container] -- [command]
   ```

3. **Quick YAML Generation:**
   ```
   kubectl [verb] [resource] [name] [options] --dry-run=client -o yaml > file.yaml
   ```

4. **Label Selection Pattern:**
   ```
   kubectl get [resource] -l key=value,key2!=value2 --show-labels
   ```

5. **Output Extraction Pattern:**
   ```
   kubectl get [resource] -o jsonpath='{.items[*].metadata.name}'
   ```

---

## 6. **Quick Reference Card**

### Must-Know Shortcuts
```bash
# Quick pod
kubectl run nginx --image=nginx

# Quick deployment with replicas
kubectl create deploy nginx --image=nginx --replicas=3

# Quick service
kubectl expose deploy nginx --port=80

# Quick ConfigMap
kubectl create cm config --from-literal=key=value

# Quick Secret
kubectl create secret generic mysecret --from-literal=password=123

# Generate YAML
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml

# Quick edit
kubectl edit deploy nginx

# Quick scale
kubectl scale deploy nginx --replicas=5

# Quick update image
kubectl set image deploy/nginx nginx=nginx:1.20

# Quick rollback
kubectl rollout undo deploy/nginx

# Quick logs
kubectl logs -f nginx --tail=100

# Quick exec
kubectl exec -it nginx -- bash

# Quick describe
kubectl describe pod nginx

# Quick delete all pods
kubectl delete pods --all
```

### Essential Aliases for .bashrc
```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgd='kubectl get deployment'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kdd='kubectl describe deployment'
alias kds='kubectl describe svc'
alias kdn='kubectl describe node'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kef='kubectl edit'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kcu='kubectl config use-context'
alias kcc='kubectl config current-context'
alias kgc='kubectl config get-contexts'
alias kns='kubectl config set-context --current --namespace'

# CKA specific
alias kdr='kubectl --dry-run=client -o yaml'
alias krun='kubectl run --dry-run=client -o yaml'
alias kcreate='kubectl create --dry-run=client -o yaml'
```

---

## 7. **Testing Your Knowledge**

### Daily Challenge Questions
1. How do you create a pod with resource limits?
2. How do you get pods sorted by restart count?
3. How do you copy a file from a pod to local?
4. How do you check what permissions a user has?
5. How do you get the IP addresses of all pods?
6. How do you update all pods' labels at once?
7. How do you get logs from all containers in a pod?
8. How do you force delete a pod immediately?
9. How do you create a service without a selector?
10. How do you patch a deployment's replica count?

### Practice Scenarios
1. **Emergency Rollback**: A deployment is failing. Rollback to previous version.
2. **Debug Crash Loop**: A pod is in CrashLoopBackOff. Get logs and debug.
3. **Resource Constraints**: Add resource limits to a running deployment.
4. **Network Isolation**: Create a NetworkPolicy to isolate pods.
5. **Data Persistence**: Mount a ConfigMap as a volume in a pod.
6. **Service Discovery**: Expose a deployment and test connectivity.
7. **Node Maintenance**: Drain a node safely for maintenance.
8. **RBAC Setup**: Create a role that can only view pods in a namespace.
9. **Scaling Challenge**: Auto-scale a deployment based on CPU.
10. **Secret Management**: Create and mount a secret in a pod.

---

## Remember:
- **Practice daily**: 15-30 minutes of hands-on practice
- **Use help**: `kubectl [command] --help` is your friend
- **Learn patterns**: Commands follow consistent patterns
- **Speed matters**: Practice imperative commands for the exam
- **Verify everything**: Always check your work with `get` and `describe`
