# CKA (Certified Kubernetes Administrator) Exam Study Guide

## Exam Overview
- **Duration:** 2 hours
- **Format:** Performance-based, hands-on practical exam
- **Passing Score:** 66%
- **Validity:** 3 years
- **Environment:** Remote proctored with access to Kubernetes documentation

## Exam Weight Distribution
- **Cluster Architecture, Installation & Configuration:** 25%
- **Workloads & Scheduling:** 15%
- **Services & Networking:** 20%
- **Storage:** 10%
- **Troubleshooting:** 30%

---

## Domain 1: Cluster Architecture, Installation & Configuration (25%)

### 1.1 Manage Role-Based Access Control (RBAC)
**Key Concepts:**
- Roles and ClusterRoles
- RoleBindings and ClusterRoleBindings
- Service accounts
- User and group management

**Study Topics:**
- Create and configure Roles with specific permissions
- Bind roles to users, groups, and service accounts
- Understand the difference between Role and ClusterRole
- Configure service account permissions for pods
- Audit RBAC policies using `kubectl auth can-i`

**Practice Commands:**
```bash
kubectl create role pod-reader --verb=get,list,watch --resource=pods
kubectl create rolebinding pod-reader-binding --role=pod-reader --user=jane
kubectl auth can-i create pods --as=jane
```

### 1.2 Prepare Infrastructure for Kubernetes Installation
**Key Concepts:**
- System requirements
- Network prerequisites
- Container runtime installation
- Kernel modules and system configurations

**Study Topics:**
- Configure swap (disable for Kubernetes)
- Set up required kernel modules (br_netfilter, overlay)
- Configure sysctl parameters
- Install container runtime (containerd, CRI-O, Docker)
- Configure cgroup drivers

### 1.3 Create and Manage Clusters with kubeadm
**Key Concepts:**
- kubeadm init and join workflows
- Bootstrap tokens
- Cluster upgrade process
- Certificate management

**Study Topics:**
- Initialize a control plane node with `kubeadm init`
- Add worker nodes with `kubeadm join`
- Generate and manage bootstrap tokens
- Upgrade clusters using kubeadm
- Backup and restore etcd
- Configure kubeadm with configuration files

**Practice Commands:**
```bash
kubeadm init --pod-network-cidr=10.244.0.0/16
kubeadm token create --print-join-command
kubeadm upgrade plan
kubeadm upgrade apply v1.30.0
```

### 1.4 Implement High Availability Control Plane
**Key Concepts:**
- Stacked vs external etcd topology
- Load balancer configuration
- Multiple control plane nodes
- etcd cluster management

**Study Topics:**
- Configure HA control plane with kubeadm
- Set up external load balancer
- Understand etcd quorum requirements
- Add and remove control plane nodes
- Configure etcd snapshots and restoration

### 1.5 Use Helm and Kustomize
**Key Concepts:**
- Helm charts and repositories
- Helm releases and upgrades
- Kustomize overlays and patches
- Resource management with both tools

**Study Topics:**
- Install and manage Helm charts
- Create and modify Helm values files
- Use Kustomize to customize deployments
- Apply patches and overlays with Kustomize
- Combine base and overlay configurations

### 1.6 Understand Extension Interfaces
**Key Concepts:**
- Container Network Interface (CNI)
- Container Storage Interface (CSI)
- Container Runtime Interface (CRI)

**Study Topics:**
- Install and configure CNI plugins (Calico, Flannel, Weave)
- Understand CSI driver deployment
- Configure different container runtimes
- Troubleshoot interface-related issues

### 1.7 Configure Custom Resources and Operators
**Key Concepts:**
- Custom Resource Definitions (CRDs)
- Operators and operator patterns
- Controller management

**Study Topics:**
- Create and manage CRDs
- Install operators using Operator Lifecycle Manager (OLM)
- Understand operator patterns and use cases
- Deploy and configure common operators

---

## Domain 2: Workloads & Scheduling (15%)

### 2.1 Application Deployments
**Key Concepts:**
- Deployments, ReplicaSets, and Pods
- Rolling updates and rollbacks
- Deployment strategies
- Update history and revisions

**Study Topics:**
- Create and manage Deployments
- Perform rolling updates with zero downtime
- Rollback to previous versions
- Configure update strategies (RollingUpdate, Recreate)
- Manage deployment history and revision limits

**Practice Commands:**
```bash
kubectl create deployment nginx --image=nginx:1.19
kubectl set image deployment/nginx nginx=nginx:1.20
kubectl rollout status deployment/nginx
kubectl rollout undo deployment/nginx
kubectl rollout history deployment/nginx
```

### 2.2 ConfigMaps and Secrets
**Key Concepts:**
- ConfigMap creation and usage
- Secret types and encoding
- Volume mounts vs environment variables
- Immutable ConfigMaps and Secrets

**Study Topics:**
- Create ConfigMaps from files, literals, and directories
- Create different types of Secrets (generic, docker-registry, TLS)
- Mount ConfigMaps and Secrets as volumes
- Use ConfigMaps and Secrets as environment variables
- Update pod configurations with ConfigMap changes

**Practice Commands:**
```bash
kubectl create configmap app-config --from-file=config.properties
kubectl create secret generic db-secret --from-literal=password=mysecret
kubectl create secret docker-registry regcred --docker-server=... --docker-username=...
```

### 2.3 Workload Autoscaling
**Key Concepts:**
- Horizontal Pod Autoscaler (HPA)
- Vertical Pod Autoscaler (VPA)
- Metrics server
- Custom metrics

**Study Topics:**
- Install and configure metrics-server
- Create HPA based on CPU and memory
- Configure custom metrics for HPA
- Understand VPA recommendations and updates
- Set appropriate resource requests and limits

### 2.4 Self-Healing Applications
**Key Concepts:**
- Liveness and readiness probes
- Startup probes
- RestartPolicy
- Pod disruption budgets

**Study Topics:**
- Configure health checks (HTTP, TCP, exec)
- Set appropriate probe parameters (initialDelaySeconds, periodSeconds)
- Implement Pod Disruption Budgets (PDB)
- Configure restart policies for different workload types
- Design resilient application architectures

### 2.5 Pod Scheduling and Admission
**Key Concepts:**
- Node selectors and affinity
- Taints and tolerations
- Pod priority and preemption
- Resource quotas and limit ranges

**Study Topics:**
- Configure node selectors for pod placement
- Use node affinity and anti-affinity rules
- Apply taints to nodes and tolerations to pods
- Set pod priorities and priority classes
- Configure resource quotas at namespace level
- Implement limit ranges for resource constraints

**Practice Commands:**
```bash
kubectl taint nodes node1 key=value:NoSchedule
kubectl label nodes node2 disktype=ssd
kubectl create priorityclass high-priority --value=1000
```

---

## Domain 3: Services & Networking (20%)

### 3.1 Pod Connectivity
**Key Concepts:**
- Cluster networking model
- Pod-to-pod communication
- DNS resolution
- Network namespaces

**Study Topics:**
- Understand Kubernetes networking requirements
- Configure pod networking with CNI plugins
- Troubleshoot pod connectivity issues
- Use network debugging tools (ping, nslookup, curl)
- Understand cluster CIDR and service CIDR

### 3.2 Network Policies
**Key Concepts:**
- Ingress and egress rules
- Label selectors
- Namespace isolation
- Default policies

**Study Topics:**
- Create Network Policies for pod isolation
- Configure ingress and egress rules
- Use label selectors and namespace selectors
- Implement default deny policies
- Test and validate network policies

**Practice YAML:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: web-netpol
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - port: 80
```

### 3.3 Service Types
**Key Concepts:**
- ClusterIP services
- NodePort services
- LoadBalancer services
- ExternalName services
- Headless services

**Study Topics:**
- Create and configure different service types
- Understand service discovery mechanisms
- Configure service endpoints manually
- Use services for internal and external traffic
- Implement session affinity

**Practice Commands:**
```bash
kubectl expose deployment nginx --port=80 --type=ClusterIP
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080
kubectl create service loadbalancer nginx --tcp=80:80
```

### 3.4 Gateway API and Ingress
**Key Concepts:**
- Ingress controllers
- Ingress resources
- Gateway API resources
- TLS termination
- Path-based and host-based routing

**Study Topics:**
- Deploy and configure Ingress controllers (nginx, traefik)
- Create Ingress rules for routing
- Configure TLS/SSL certificates
- Implement Gateway API resources (Gateway, HTTPRoute)
- Configure path and host-based routing rules

**Practice YAML:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  tls:
  - hosts:
    - app.example.com
    secretName: tls-secret
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
```

### 3.5 CoreDNS
**Key Concepts:**
- DNS resolution in Kubernetes
- CoreDNS configuration
- Service discovery
- DNS policies

**Study Topics:**
- Configure and troubleshoot CoreDNS
- Understand DNS naming conventions
- Modify CoreDNS ConfigMap
- Configure DNS policies in pods
- Debug DNS resolution issues

---

## Domain 4: Storage (10%)

### 4.1 Storage Classes and Dynamic Provisioning
**Key Concepts:**
- Storage Classes
- Dynamic volume provisioning
- Storage provisioners
- Default storage class

**Study Topics:**
- Create and configure Storage Classes
- Set up dynamic provisioning
- Configure reclaim policies
- Set default storage class
- Understand different provisioners (AWS EBS, GCE PD, NFS)

**Practice YAML:**
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
reclaimPolicy: Retain
allowVolumeExpansion: true
```

### 4.2 Volume Types and Access Modes
**Key Concepts:**
- Volume types (emptyDir, hostPath, persistentVolumeClaim)
- Access modes (ReadWriteOnce, ReadOnlyMany, ReadWriteMany)
- Volume modes (Filesystem, Block)

**Study Topics:**
- Configure different volume types
- Understand access mode compatibility
- Use appropriate volumes for different scenarios
- Configure volume mounts in pods
- Share volumes between containers

### 4.3 Persistent Volumes and Claims
**Key Concepts:**
- Persistent Volumes (PV)
- Persistent Volume Claims (PVC)
- Binding process
- Storage capacity and selection

**Study Topics:**
- Create and manage PVs
- Create PVCs with specific requirements
- Understand PV-PVC binding process
- Configure storage size and access modes
- Troubleshoot binding issues

**Practice Commands:**
```bash
kubectl create -f pv.yaml
kubectl create -f pvc.yaml
kubectl get pv,pvc
kubectl describe pvc my-claim
```

---

## Domain 5: Troubleshooting (30%)

### 5.1 Cluster and Node Troubleshooting
**Key Concepts:**
- Control plane components
- Node status and conditions
- System logs
- Component health checks

**Study Topics:**
- Check control plane component status
- Troubleshoot node NotReady conditions
- Analyze system and kubelet logs
- Fix certificate issues
- Resolve etcd problems
- Debug API server issues

**Practice Commands:**
```bash
kubectl get nodes
kubectl describe node node1
kubectl get componentstatuses
kubectl logs -n kube-system kube-apiserver-master
journalctl -u kubelet
```

### 5.2 Cluster Component Troubleshooting
**Key Concepts:**
- kube-apiserver issues
- etcd troubleshooting
- kube-scheduler problems
- kube-controller-manager issues
- kubelet and kube-proxy debugging

**Study Topics:**
- Identify and fix component configuration issues
- Analyze component logs
- Verify component certificates
- Check component arguments and flags
- Restore failed components

### 5.3 Resource Monitoring
**Key Concepts:**
- Metrics server
- Resource usage monitoring
- kubectl top command
- Container resource metrics

**Study Topics:**
- Install and configure metrics-server
- Monitor node and pod resource usage
- Identify resource bottlenecks
- Set up basic monitoring
- Analyze resource consumption patterns

**Practice Commands:**
```bash
kubectl top nodes
kubectl top pods --all-namespaces
kubectl top pod nginx --containers
```

### 5.4 Container Output Management
**Key Concepts:**
- Container logs
- Log aggregation
- Debugging containers
- Exec into containers

**Study Topics:**
- View and follow container logs
- Access logs from previous container instances
- Debug running containers with exec
- Configure log rotation
- Implement centralized logging

**Practice Commands:**
```bash
kubectl logs pod-name
kubectl logs pod-name -c container-name
kubectl logs pod-name --previous
kubectl exec -it pod-name -- /bin/bash
kubectl debug node/node1
```

### 5.5 Service and Networking Troubleshooting
**Key Concepts:**
- Service discovery issues
- DNS resolution problems
- Network policy debugging
- Connectivity testing

**Study Topics:**
- Test service connectivity
- Debug DNS resolution
- Verify network policies
- Test pod-to-pod communication
- Troubleshoot ingress issues
- Use network debugging tools

**Practice Commands:**
```bash
kubectl run test --image=busybox -it --rm -- sh
nslookup kubernetes.default
curl service-name.namespace.svc.cluster.local
kubectl get endpoints
kubectl port-forward pod-name 8080:80
```

---

## Exam Preparation Tips

### Essential kubectl Commands
```bash
# Imperative commands for quick resource creation
kubectl run nginx --image=nginx
kubectl create deployment web --image=nginx --replicas=3
kubectl expose deployment web --port=80 --type=NodePort
kubectl scale deployment web --replicas=5
kubectl set image deployment/web nginx=nginx:1.20

# Useful flags
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
kubectl create deployment web --image=nginx --dry-run=client -o yaml > deployment.yaml

# Quick edits
kubectl edit deployment nginx
kubectl patch deployment nginx -p '{"spec":{"replicas":3}}'

# Resource management
kubectl apply -f manifest.yaml
kubectl replace --force -f manifest.yaml
kubectl delete -f manifest.yaml
```

### Time Management Strategies
1. **Read all questions first** - Identify easy wins
2. **Use imperative commands** - Faster than writing YAML
3. **Use --dry-run=client -o yaml** - Generate YAML templates quickly
4. **Bookmark documentation** - Know where to find information
5. **Practice with kubectl explain** - Quick field reference
6. **Use aliases** - Set up k=kubectl, kgp="kubectl get pods"

### Key Documentation Pages
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [API Reference](https://kubernetes.io/docs/reference/kubernetes-api/)
- [kubectl Command Reference](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
- [Workload Resources](https://kubernetes.io/docs/concepts/workloads/)
- [Service and Networking](https://kubernetes.io/docs/concepts/services-networking/)

### Practice Resources
1. **Killer.sh** - CKA exam simulator (included with exam registration)
2. **Kubernetes the Hard Way** - Deep understanding of components
3. **Kind/Minikube/kubeadm** - Local cluster practice
4. **CKA Exercises GitHub Repos** - Hands-on practice scenarios

### Common Pitfalls to Avoid
- Not checking the namespace context
- Forgetting to verify resource creation
- Missing resource labels for selectors
- Incorrect YAML indentation
- Not reading error messages carefully
- Skipping question requirements

### Day of Exam Checklist
- [ ] Test your environment setup
- [ ] Have documentation bookmarked
- [ ] Clear workspace/desktop
- [ ] Have water available
- [ ] Read each question completely
- [ ] Verify namespace context
- [ ] Check your work with get/describe
- [ ] Move on if stuck (mark for review)

---

## Study Schedule Recommendation

### Week 1-2: Cluster Architecture & Installation
- Focus on kubeadm, RBAC, and cluster setup
- Practice cluster installation and upgrades
- Master RBAC concepts and commands

### Week 3-4: Workloads & Scheduling
- Deep dive into deployments and pods
- Practice with ConfigMaps and Secrets
- Master scheduling and node affinity

### Week 5: Services & Networking
- Understand all service types
- Practice with Ingress and Network Policies
- Debug networking issues

### Week 6: Storage
- Work with PV/PVC
- Practice dynamic provisioning
- Understand storage classes

### Week 7-8: Troubleshooting
- Practice debugging scenarios
- Master log analysis
- Focus on common issues

### Week 9-10: Practice Exams
- Take mock exams
- Time yourself
- Review weak areas
- Practice with killer.sh simulator

---

## Quick Reference Sheet

### Resource Short Names
```
po = pods
svc = services
deploy = deployments
rs = replicasets
ds = daemonsets
sts = statefulsets
cm = configmaps
ns = namespaces
pv = persistentvolumes
pvc = persistentvolumeclaims
sa = serviceaccounts
```

### Useful Aliases for Exam
```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias kdes='kubectl describe'
alias klog='kubectl logs'
alias kex='kubectl exec -it'
```

Good luck with your CKA exam preparation!
