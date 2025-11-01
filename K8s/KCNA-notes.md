# KCNA Exam Study Guide

## Table of Contents
1. [StatefulSets](#statefulsets)
2. [DaemonSets](#daemonsets)
3. [Default Namespaces](#default-namespaces)
4. [CronJobs](#cronjobs)
5. [SQL Query Syntax](#sql-query-syntax)
6. [kubectl Deployment Commands](#kubectl-deployment-commands)
7. [etcd, OCI, and CRI](#etcd-oci-and-cri)
8. [Control Plane vs Data Plane](#control-plane-vs-data-plane)
9. [Network Load Balancer (NLB)](#network-load-balancer-nlb)
10. [Volumes and Storage](#volumes-and-storage)
11. [Additional KCNA Exam Tips](#additional-kcna-exam-tips)

---

## StatefulSets

**What:** Workload objects for stateful applications

**Key Features:**
- Stable, unique network identifiers (pod names: `app-0`, `app-1`, `app-2`)
- Stable, persistent storage (PVCs persist across pod rescheduling)
- Ordered, graceful deployment and scaling
- Ordered, automated rolling updates

**When to Use:**
- Databases (MySQL, PostgreSQL, MongoDB, Cassandra)
- Distributed systems requiring stable identities (Kafka, Zookeeper, etcd, Elasticsearch)
- Applications needing persistent storage tied to specific pods

**Key Differences from Deployments:**
| Feature | StatefulSet | Deployment |
|---------|-------------|------------|
| Pod naming | Predictable (app-0, app-1) | Random hash |
| Storage | Persistent per pod | Shared or ephemeral |
| Scaling | Ordered (0→1→2) | Parallel |
| Use case | Stateful apps | Stateless apps |

---

## DaemonSets

**What:** Ensures a copy of a pod runs on all (or selected) nodes

**Behavior:**
- When nodes are added → pods automatically added
- When nodes are removed → pods are garbage collected
- One pod per node (typically)

**Common Use Cases:**
- **Log collection:** Fluentd, Logstash, Filebeat
- **Monitoring:** Prometheus node exporter, Datadog agent
- **Network plugins:** Calico, Weave, Cilium
- **Storage daemons:** Ceph, GlusterFS
- **Security agents:** Falco, Sysdig

**Node Selection:**
Can use nodeSelector or affinity rules to run on specific nodes only

---

## Default Namespaces

Kubernetes creates **4 default namespaces:**

1. **`default`**
   - For resources with no namespace specified
   - Where resources go if you don't specify a namespace

2. **`kube-system`**
   - For Kubernetes system components
   - Contains: API server, scheduler, controller manager, DNS, etc.

3. **`kube-public`**
   - Readable by all users (even unauthenticated)
   - Mostly for cluster information
   - Reserved for cluster usage

4. **`kube-node-lease`**
   - For node heartbeat/lease objects
   - Improves node heartbeat performance
   - One lease object per node

**Exam Tip:** Answer is **4 default namespaces**

---

## CronJobs

**What:** Creates Jobs on a time-based schedule (like cron in Linux)

**Best For:** Recurring/scheduled tasks in Kubernetes

**Cron Schedule Format:**
```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sun-Sat)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

**Common Examples:**
- `0 2 * * *` - Daily at 2 AM
- `*/5 * * * *` - Every 5 minutes
- `0 0 * * 0` - Weekly on Sunday at midnight
- `0 0 1 * *` - Monthly on the 1st at midnight

**Use Cases:**
- Database backups
- Report generation
- Data cleanup/archival
- Certificate renewal
- Health checks

---

## SQL Query Syntax

**Valid SQL Keywords/Components:**

✅ **Correct:**
- `SELECT` - specifies columns to retrieve
- `*` (asterisk) - wildcard for "all columns"
- `FROM` - specifies the table/source
- `WHERE` - filters rows based on conditions
- `ORDER BY` - sorts results
- `LIMIT` - restricts number of results
- `JOIN` - combines tables
- `GROUP BY` - groups rows
- `HAVING` - filters groups

❌ **Common Wrong Answers:**
- `WERE` (not a SQL keyword)
- Misspellings like `SELCT`, `FORM`
- Invalid operators

**In Kubernetes Context:**
- kubectl field selectors: `kubectl get pods --field-selector status.phase=Running`
- JSONPath queries: `kubectl get pods -o jsonpath='{.items[*].metadata.name}'`
- Log filtering with Loki, Elasticsearch, or Prometheus using SQL-like syntax

---

## kubectl Deployment Commands

### Correct Commands

**1. Imperative - Create from command line:**
```bash
kubectl create deployment <name> --image=<image-name>
```
Example:
```bash
kubectl create deployment nginx-deployment --image=nginx:1.14.2
kubectl create deployment my-app --image=nginx --replicas=3
```

**2. Declarative - Apply from YAML:**
```bash
kubectl apply -f deployment.yaml
```

**3. kubectl run (creates pod, not deployment in newer versions):**
```bash
kubectl run nginx --image=nginx
```

### Common Wrong Answers (DON'T USE)

❌ `kubectl run deployment <name> --image=<image>`  
❌ `kubectl start deployment <name>`  
❌ `kubectl deploy <name> --image=<image>`  
❌ `kubectl create deploy <name> --image=<image>` (missing 'ment')

### Useful Flags

```bash
--replicas=3           # Number of replicas
--port=80              # Container port
--dry-run=client -o yaml  # Generate YAML without creating
--record               # Record command in annotations
```

**Exam Tip:** `kubectl create deployment` is the standard imperative command

---

## etcd, OCI, and CRI

### etcd

**What:** Distributed key-value store - Kubernetes' backing store for all cluster data

**What It Stores:**
- All cluster state and configuration
- All Kubernetes objects (pods, services, deployments, secrets, configmaps)
- Node information
- Resource quotas and policies
- RBAC rules

**Key Points:**
- ⚠️ **ONLY the API Server** directly communicates with etcd
- Critical for cluster operation
- Should be backed up regularly
- Typically runs on control plane nodes
- Uses Raft consensus algorithm for distributed consensus

**If etcd Fails:**
- Cluster loses its state database
- Cannot create/update/delete resources
- Existing workloads continue running (kubelet has local state)
- Cluster becomes read-only essentially

### OCI (Open Container Initiative)

**What:** Industry standards for container formats and runtimes

**Two Main Specifications:**

1. **OCI Image Spec**
   - Defines container image format
   - How images are structured and distributed
   - Ensures portability across platforms

2. **OCI Runtime Spec**
   - Defines how to run containers
   - Configuration, execution environment
   - Lifecycle operations (create, start, stop, delete)

**OCI-Compliant Runtimes:**
- **runc** - reference implementation by Docker
- **crun** - faster, written in C
- **kata-runtime** - runs containers as VMs
- **gVisor** - sandboxed runtime

### CRI (Container Runtime Interface)

**What:** Plugin interface that allows Kubernetes to use different container runtimes

**Purpose:**
- Standardizes communication between kubelet and container runtimes
- Allows swapping runtimes without recompiling Kubernetes
- Provides API for image management and container lifecycle

**Two CRI Services:**
1. **ImageService** - pulling and managing images
2. **RuntimeService** - managing pods and containers

**CRI-Compatible Runtimes:**
- **containerd** (most common, default in many distros)
- **CRI-O** (lightweight, designed specifically for Kubernetes)
- **Docker Engine** (deprecated via dockershim in K8s 1.24+, but works via containerd)

### How They Work Together

**Complete Flow:**
```
User
 ↓
kubectl
 ↓
API Server ←→ etcd (stores desired state)
 ↓
Scheduler (assigns pod to node)
 ↓
Kubelet (on worker node)
 ↓
CRI (Container Runtime Interface)
 ↓
Container Runtime (containerd, CRI-O)
 ↓
OCI Runtime (runc)
 ↓
Container (running application)
```

**Example: Creating an nginx deployment**

1. `kubectl create deployment nginx --image=nginx`
2. **API Server** validates and writes to **etcd**
3. **Controller Manager** watches etcd, creates ReplicaSet
4. **ReplicaSet Controller** creates Pod objects in etcd
5. **Scheduler** watches for unscheduled pods, assigns to node
6. **Kubelet** on assigned node sees new pod
7. **Kubelet** calls **CRI** API: "create this container"
8. **Container Runtime** (containerd) pulls image via CRI ImageService
9. **containerd** calls **OCI runtime** (runc) with container spec
10. **runc** creates container using Linux namespaces/cgroups (OCI Runtime Spec)
11. Container runs, **kubelet** reports status → **API Server** → **etcd**

### Key Relationships

| Component | Talks To | Purpose |
|-----------|----------|---------|
| **etcd** | API Server only | Stores all cluster state |
| **API Server** | etcd, all components | Central communication hub |
| **CRI** | Kubelet ↔ Runtime | Standardized interface |
| **OCI** | Container Runtime | Standards for execution |

**Exam Tips:**
- etcd = cluster's database/brain
- OCI = container standards (format + runtime)
- CRI = interface between Kubernetes and container runtimes
- Only API Server talks directly to etcd
- CRI allows pluggable runtimes
- OCI ensures container portability

---

## Control Plane vs Data Plane

### Control Plane (Master/Management Layer)

**Purpose:** Makes ALL decisions about the cluster

**Components:**

1. **kube-apiserver**
   - REST API front-end for the control plane
   - Authentication, authorization, admission control
   - Only component that talks to etcd
   - All kubectl commands go here

2. **etcd**
   - Cluster state database
   - Stores desired state vs actual state
   - Distributed key-value store

3. **kube-scheduler**
   - Assigns pods to nodes
   - Considers: resource requirements, constraints, affinity/anti-affinity
   - Watches for unscheduled pods

4. **kube-controller-manager**
   - Runs controller processes:
     - Node Controller (monitors node health)
     - Replication Controller (maintains correct number of pods)
     - Endpoints Controller (populates endpoint objects)
     - Service Account & Token Controllers

5. **cloud-controller-manager** (optional)
   - Integrates with cloud provider APIs
   - Manages: nodes, routes, load balancers, volumes

**Responsibilities:**
- ✅ Scheduling decisions
- ✅ Detecting and responding to cluster events
- ✅ Storing cluster state
- ✅ Providing API endpoints
- ❌ Does NOT run application workloads

### Data Plane (Worker/Workload Layer)

**Purpose:** Executes decisions and runs application workloads

**Components (on each worker node):**

1. **kubelet**
   - Node agent that runs on each worker node
   - Ensures containers are running in pods
   - Reports node and pod status to API Server
   - Talks to CRI for container operations

2. **kube-proxy**
   - Network proxy on each node
   - Maintains network rules for Services
   - Implements Service abstraction (load balancing)
   - Modes: iptables, IPVS, userspace

3. **Container Runtime**
   - Pulls container images
   - Runs containers
   - Examples: containerd, CRI-O, Docker (via containerd)

**Responsibilities:**
- ✅ Running application pods
- ✅ Pulling container images
- ✅ Network routing between pods
- ✅ Monitoring container health
- ✅ Reporting status to control plane
- ❌ Does NOT make scheduling decisions

### Key Differences

| Aspect | Control Plane | Data Plane |
|--------|---------------|------------|
| **Function** | Decides WHAT & WHERE | Executes HOW |
| **Location** | Master/control nodes | Worker nodes |
| **Failure Impact** | Can't create/update resources | Apps keep running but can't change |
| **Scaling** | Usually 3 nodes (HA) | Scales with workload |
| **Access** | kubectl talks here | End users access apps here |
| **Components** | API, etcd, scheduler, controllers | kubelet, kube-proxy, runtime |

### Deployment Flow Through Both Planes

**Control Plane Actions:**
```
1. kubectl → API Server
2. API Server → etcd (stores deployment object)
3. Deployment Controller → creates ReplicaSet
4. ReplicaSet Controller → creates Pod objects
5. Scheduler → assigns pods to nodes
6. API Server → updates pod assignments in etcd
```

**Data Plane Actions:**
```
7. Kubelet watches API Server → sees assigned pod
8. Kubelet → CRI → Container Runtime
9. Container Runtime → pulls image, starts container
10. Kubelet → reports status to API Server
11. API Server → updates etcd with pod status
```

### What Happens If Components Fail?

**Control Plane Failure:**
- Existing apps keep running (kubelet has local cache)
- Cannot create/update/delete resources
- Cannot schedule new pods
- Cannot respond to failures
- Cluster becomes "frozen" in current state

**Data Plane Failure (single node):**
- Pods on that node stop
- Control plane detects node failure
- Scheduler reassigns pods to healthy nodes
- Applications continue on other nodes (if replicated)

**etcd Failure:**
- Most critical failure
- Cluster loses all state
- Must restore from backup
- This is why etcd backups are crucial!

**Exam Tips:**
- Control plane = "brain" (decides)
- Data plane = "muscles" (executes)
- API Server is the only component that talks to etcd
- Kubelet is the bridge between planes
- Control plane can fail temporarily without stopping running apps

---

## Network Load Balancer (NLB)

### What is NLB?

**NLB (Network Load Balancer)** is a **Layer 4 (TCP/UDP)** load balancer used in cloud environments

### NLB vs ALB

| Feature | NLB (Network Load Balancer) | ALB (Application Load Balancer) |
|---------|----------------------------|----------------------------------|
| **OSI Layer** | Layer 4 (Transport) | Layer 7 (Application) |
| **Protocols** | TCP, UDP, TLS | HTTP, HTTPS, HTTP/2, gRPC |
| **Performance** | Ultra-low latency | Lower throughput |
| **Throughput** | Millions of req/sec | Thousands of req/sec |
| **Routing** | IP address + Port only | Path, host, headers, query strings |
| **Health Checks** | TCP/port-based | HTTP/HTTPS with status codes |
| **Static IP** | ✅ Yes | ❌ No (DNS only) |
| **Cost** | Usually cheaper | More expensive |
| **Use Cases** | Gaming, IoT, databases | Web apps, microservices, APIs |
| **SSL Termination** | Limited | Full support |
| **WebSocket** | ✅ Native | ✅ Native |

### When to Use NLB

✅ **Use NLB when:**
- Need extreme performance (ultra-low latency)
- Non-HTTP protocols (TCP, UDP, custom protocols)
- Need static IP addresses for whitelisting
- Gaming servers
- IoT device connections
- Database access
- VoIP/SIP applications
- MQTT, AMQP messaging
- Streaming protocols

✅ **Use ALB when:**
- HTTP/HTTPS web applications
- Need path-based routing (`/api/*` → serviceA, `/web/*` → serviceB)
- Need host-based routing (api.example.com → serviceA, web.example.com → serviceB)
- Microservices architecture
- Need WAF (Web Application Firewall)
- SSL/TLS termination with certificate management

### NLB in Kubernetes

**Creating an NLB:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

**How It Works:**
```
Internet Traffic
      ↓
   [NLB] ← Cloud provider creates this
      ↓
   NodePort (on worker nodes) ← kube-proxy maintains iptables rules
      ↓
   Application Pods ← traffic distributed across healthy pods
```

**Flow:**
1. User creates Service with `type: LoadBalancer`
2. Cloud Controller Manager detects the service
3. Calls cloud provider API to create NLB
4. NLB gets external IP address
5. NLB forwards traffic to NodePort on worker nodes
6. kube-proxy routes to healthy pods based on selector

### Cloud-Specific Annotations

**AWS:**
```yaml
annotations:
  # Use NLB instead of CLB (Classic Load Balancer)
  service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
  
  # Internal NLB (private subnet)
  service.beta.kubernetes.io/aws-load-balancer-internal: "true"
  
  # Cross-zone load balancing
  service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
  
  # Connection draining timeout
  service.beta.kubernetes.io/aws-load-balancer-connection-draining-timeout: "60"
```

**GCP:**
```yaml
annotations:
  # Internal TCP/UDP load balancer
  cloud.google.com/load-balancer-type: "Internal"
  
  # Network tier
  cloud.google.com/network-tier: "Premium"
```

**Azure:**
```yaml
annotations:
  # Internal load balancer
  service.beta.kubernetes.io/azure-load-balancer-internal: "true"
  
  # Subnet
  service.beta.kubernetes.io/azure-load-balancer-internal-subnet: "subnet-name"
```

### Service Types Comparison

| Service Type | Accessibility | Load Balancing | Use Case | External IP |
|--------------|---------------|----------------|----------|-------------|
| **ClusterIP** | Internal only | kube-proxy | Service-to-service | ❌ No |
| **NodePort** | External via Node IP:Port | kube-proxy | Dev/testing | ❌ No (use node IPs) |
| **LoadBalancer** (NLB) | External via LB | Cloud LB + kube-proxy | Production (non-HTTP) | ✅ Yes |
| **Ingress** (ALB) | External via HTTP | ALB + Ingress Controller | Production (HTTP/HTTPS) | ✅ Yes |

### NLB Health Checks

NLB performs health checks on target nodes:
- TCP connection attempts
- Port-based checks
- If a node fails → traffic rerouted to healthy nodes
- Configurable interval and threshold

**Example health check config:**
```yaml
spec:
  healthCheckNodePort: 32000  # Custom health check port
  externalTrafficPolicy: Local  # Only route to local pods
```

**Exam Tips:**
- NLB = Layer 4 (TCP/UDP) load balancer
- Created by Service `type: LoadBalancer` with cloud provider
- Use for non-HTTP or high-performance needs
- ALB = Layer 7 (HTTP/HTTPS), use Ingress controller
- NLB provides static IP, ALB does not
- NLB is faster and cheaper than ALB

---

## Volumes and Storage

### Volume Types Overview

Kubernetes supports many volume types for different use cases:

### 1. Ephemeral Volumes (Temporary)

**emptyDir**
- Created when pod is assigned to node
- Initially empty
- Deleted when pod is removed from node
- Shared between containers in same pod

**Use Cases:**
- Scratch space
- Checkpointing
- Cache
- Temporary data between container restarts

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: cache
      mountPath: /cache
  volumes:
  - name: cache
    emptyDir: {}
```

### 2. Persistent Volumes (Long-term)

**hostPath**
- Mounts file/directory from host node filesystem
- ⚠️ Risky for multi-node clusters (data not portable)
- Useful for single-node testing

**Use Cases:**
- Single-node development
- System-level applications needing host access

### 3. Cloud Storage Volumes

**AWS EBS (Elastic Block Store)**
```yaml
volumes:
- name: aws-ebs
  awsElasticBlockStore:
    volumeID: vol-0123456789abcdef
    fsType: ext4
```

**GCE Persistent Disk**
```yaml
volumes:
- name: gce-pd
  gcePersistentDisk:
    pdName: my-disk
    fsType: ext4
```

**Azure Disk**
```yaml
volumes:
- name: azure-disk
  azureDisk:
    diskName: my-disk
    diskURI: /subscriptions/.../my-disk
```

### 4. Network Storage

**NFS (Network File System)**
```yaml
volumes:
- name: nfs-volume
  nfs:
    server: nfs-server.example.com
    path: /exported/path
```

**Ceph RBD, GlusterFS, iSCSI** - Other network storage options

### Persistent Volume (PV) and Persistent Volume Claim (PVC)

**Architecture:**
```
Developer → PVC (request) → PV (actual storage) → Cloud Disk/NFS/etc
```

**PersistentVolume (PV):**
- Cluster-level resource
- Provisioned by admin or dynamically
- Independent lifecycle from pods

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-example
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: standard
  hostPath:
    path: /mnt/data
```

**PersistentVolumeClaim (PVC):**
- Namespace-scoped resource
- Request for storage by user
- Binds to matching PV

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-example
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: standard
```

**Using PVC in Pod:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-pvc
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: storage
      mountPath: /data
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: pvc-example
```

### Access Modes

| Mode | Description | Use Case | Abbreviation |
|------|-------------|----------|--------------|
| **ReadWriteOnce (RWO)** | Read-write by single node | Databases | RWO |
| **ReadOnlyMany (ROX)** | Read-only by many nodes | Shared config | ROX |
| **ReadWriteMany (RWX)** | Read-write by many nodes | Shared data | RWX |
| **ReadWriteOncePod (RWOP)** | Read-write by single pod | Pod-specific | RWOP |

### Reclaim Policies

What happens to PV when PVC is deleted?

| Policy | Behavior |
|--------|----------|
| **Retain** | PV kept, data preserved, manual cleanup required |
| **Delete** | PV and underlying storage deleted automatically |
| **Recycle** | Basic scrub (`rm -rf`), deprecated |

### Storage Classes

**StorageClass** enables dynamic provisioning of PVs

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
  iopsPerGB: "50"
  fsType: ext4
volumeBindingMode: WaitForFirstConsumer
```

**Common Provisioners:**
- `kubernetes.io/aws-ebs` - AWS EBS
- `kubernetes.io/gce-pd` - GCE Persistent Disk
- `kubernetes.io/azure-disk` - Azure Disk
- `kubernetes.io/cinder` - OpenStack Cinder
- External provisioners: Ceph, NFS, etc.

### What Happens If Storage Fails?

**Scenario 1: Cloud Disk Failure (EBS, GCE PD)**
1. Pod cannot write/read data
2. Pod may become unhealthy (readiness/liveness probes fail)
3. Kubelet detects pod failure
4. Pod is rescheduled to another node
5. ⚠️ PV cannot attach to new node (still attached to old node)
6. Manual intervention or cloud provider detachment needed
7. Once detached, PV reattaches to new node
8. Data preserved (if disk not corrupted)

**Scenario 2: Node Failure with hostPath**
- Data is lost (stored on failed node)
- Pod rescheduled to different node
- New pod starts with empty data
- ⚠️ This is why hostPath is not recommended for production

**Scenario 3: Network Storage Failure (NFS)**
- All pods using that NFS mount affected
- Pods may hang or crash
- Data unavailable until NFS restored
- No automatic recovery

**Scenario 4: PV Deleted While Pod Running**
- If policy is `Delete`: underlying storage deleted
- Pod continues running with existing mounted volume
- On pod restart: volume unavailable, pod fails to start
- Data is lost

### Best Practices

✅ **Do:**
- Use PVCs for production workloads
- Set appropriate reclaim policies (Retain for important data)
- Use StorageClasses for dynamic provisioning
- Back up critical data regularly
- Use ReadWriteMany for shared data across pods
- Monitor storage capacity and IOPS

❌ **Don't:**
- Use hostPath in production multi-node clusters
- Use emptyDir for persistent data
- Ignore storage capacity planning
- Forget to set resource limits
- Use Delete policy without backups

### Volume Snapshots

**VolumeSnapshot** allows taking snapshots of PVCs:

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: snapshot-example
spec:
  volumeSnapshotClassName: csi-snapclass
  source:
    persistentVolumeClaimName: pvc-example
```

**Use Cases:**
- Backups
- Clone data for testing
- Point-in-time recovery

### CSI (Container Storage Interface)

Modern way to integrate storage with Kubernetes:
- Plugin architecture
- Cloud provider implementations
- Consistent API across storage vendors

**Popular CSI Drivers:**
- AWS EBS CSI
- GCE PD CSI
- Azure Disk CSI
- Ceph CSI
- NFS CSI

**Exam Tips:**
- emptyDir = temporary, deleted with pod
- PV = actual storage resource
- PVC = request/claim for storage
- StorageClass = enables dynamic provisioning
- RWO = single node read-write (most common)
- RWX = multiple nodes read-write (requires special storage like NFS)
- Retain policy = keeps data after PVC deletion
- hostPath = local node storage (not portable)
- Cloud volumes require cloud-specific configuration

---

## Additional KCNA Exam Tips

### Exam Format

- **Duration:** 90 minutes
- **Questions:** 60 multiple choice
- **Passing Score:** 75% (45 out of 60 correct)
- **Format:** Online, proctored
- **Open Book:** No (closed book exam)
- **Retake Policy:** Once every 12 months included with registration

### Topics Covered (Official Domains)

1. **Kubernetes Fundamentals (46%)**
   - Kubernetes resources (Pods, Deployments, Services)
   - Kubernetes architecture (control plane, data plane)
   - Kubernetes API
   - Containers
   - Scheduling

2. **Container Orchestration (22%)**
   - Container orchestration fundamentals
   - Runtime
   - Security
   - Networking
   - Service mesh
   - Storage

3. **Cloud Native Architecture (16%)**
   - Autoscaling
   - Serverless
   - Community and governance
   - Personas and roles
   - Open standards

4. **Cloud Native Observability (8%)**
   - Telemetry & observability
   - Prometheus
   - Cost management

5. **Cloud Native Application Delivery (8%)**
   - Application delivery fundamentals
   - GitOps
   - CI/CD

### Key Kubernetes Objects to Know

**Workload Resources:**
- **Pod** - smallest deployable unit
- **Deployment** - manages ReplicaSets, rolling updates
- **ReplicaSet** - maintains desired number of pod replicas
- **StatefulSet** - for stateful applications
- **DaemonSet** - runs on all/selected nodes
- **Job** - runs to completion
- **CronJob** - scheduled jobs

**Service & Networking:**
- **Service** - exposes pods (ClusterIP, NodePort, LoadBalancer)
- **Ingress** - HTTP/HTTPS routing
- **NetworkPolicy** - pod traffic rules
- **EndpointSlices** - network endpoints for services

**Configuration:**
- **ConfigMap** - non-confidential configuration data
- **Secret** - confidential data (passwords, tokens)

**Storage:**
- **PersistentVolume (PV)** - cluster storage resource
- **PersistentVolumeClaim (PVC)** - storage request
- **StorageClass** - dynamic provisioning

**Other:**
- **Namespace** - virtual cluster isolation
- **ServiceAccount** - pod identity
- **Role/RoleBinding** - RBAC within namespace
- **ClusterRole/ClusterRoleBinding** - RBAC cluster-wide

### kubectl Commands to Know

**Basic Commands:**
```bash
# Get resources
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get nodes

# Describe (detailed info)
kubectl describe pod <pod-name>
kubectl describe node <node-name>

# Create resources
kubectl create deployment nginx --image=nginx
kubectl create namespace dev

# Apply configuration
kubectl apply -f deployment.yaml

# Delete resources
kubectl delete pod <pod-name>
kubectl delete deployment <deployment-name>

# Logs
kubectl logs <pod-name>
kubectl logs -f <pod-name>  # follow/stream

# Execute commands in pod
kubectl exec -it <pod-name> -- /bin/bash

# Port forwarding
kubectl port-forward <pod-name> 8080:80

# Scale
kubectl scale deployment <name> --replicas=5

# Rollout
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
```

**Namespace Operations:**
```bash
kubectl get pods -n kube-system
kubectl get pods --all-namespaces
kubectl config set-context --current --namespace=dev
```

**Resource Management:**
```bash
kubectl top nodes
kubectl top pods
kubectl get events
kubectl get all
```

### Architecture Concepts

**Remember the Flow:**
```
kubectl → API Server → etcd
              ↓
        Scheduler & Controllers
              ↓
           Kubelet (on nodes)
              ↓
        Container Runtime
```

**Component Locations:**
- **Control Plane:** API Server, etcd, Scheduler, Controller Manager
- **Worker Nodes:** kubelet, kube-proxy, Container Runtime
- **Add-ons:** DNS, Dashboard, Monitoring

### Common Misconceptions

❌ **Wrong:** kubelet runs on control plane nodes  
✅ **Correct:** kubelet runs on ALL nodes (including control plane in some setups, but primarily worker nodes)

❌ **Wrong:** Pods directly communicate with etcd  
✅ **Correct:** Only API Server talks to etcd

❌ **Wrong:** Docker is required for Kubernetes  
✅ **Correct:** Any OCI-compliant runtime works (containerd, CRI-O)

❌ **Wrong:** Services create pods  
✅ **Correct:** Services select and expose existing pods

❌ **Wrong:** StatefulSets and Deployments are the same  
✅ **Correct:** StatefulSets provide stable identities and ordered deployment

### CNCF Landscape

Know major CNCF projects:

**Core:**
- Kubernetes - container orchestration
- containerd - container runtime
- Prometheus - monitoring
- Envoy - service proxy
- etcd - distributed key-value store

**Popular Projects:**
- Helm - package manager
- Flux/Argo CD - GitOps
- Istio/Linkerd - service mesh
- Harbor - container registry
- Falco - runtime security
- Jaeger - distributed tracing

### Cloud Native Principles

**12-Factor App:**
1. Codebase in version control
2. Explicit dependencies
3. Config in environment
4. Backing services as attached resources
5. Build, release, run stages
6. Stateless processes
7. Port binding
8. Concurrency via processes
9. Disposability (fast startup/shutdown)
10. Dev/prod parity
11. Logs as event streams
12. Admin processes

**Microservices Characteristics:**
- Single responsibility
- Independent deployment
- Decentralized data management
- API-based communication
- Fault isolation

### Observability (Prometheus Focus)

**Four Golden Signals:**
1. **Latency** - time to service requests
2. **Traffic** - demand on system
3. **Errors** - rate of failed requests
4. **Saturation** - resource utilization

**Prometheus Concepts:**
- **Metrics** - time series data
- **Labels** - key-value pairs for dimensions
- **PromQL** - query language
- **Exporters** - expose metrics from systems
- **Alertmanager** - handles alerts

### Security Basics

**Pod Security:**
- Run as non-root user
- Read-only root filesystem
- Drop capabilities
- Use security contexts

**RBAC (Role-Based Access Control):**
- **Role** - permissions within namespace
- **ClusterRole** - permissions cluster-wide
- **RoleBinding** - grants Role to user/group in namespace
- **ClusterRoleBinding** - grants ClusterRole cluster-wide

**Network Security:**
- NetworkPolicy - pod-to-pod traffic rules
- Service mesh for mTLS
- Ingress TLS termination

### Study Strategy

**1. Hands-On Practice:**
- Set up local cluster (minikube, kind, k3s)
- Practice kubectl commands
- Deploy sample applications
- Break things and fix them

**2. Official Documentation:**
- kubernetes.io/docs
- Read "Concepts" section thoroughly
- Understand architecture diagrams

**3. CNCF Resources:**
- Free "Introduction to Kubernetes" course (edX)
- CNCF landscape overview
- YouTube videos from KubeCon

**4. Focus Areas:**
- Kubernetes architecture (control plane vs data plane)
- Core objects (Pod, Deployment, Service, etc.)
- kubectl commands
- Container runtimes (CRI, OCI)
- Storage (PV, PVC, StorageClass)
- Networking (Services, Ingress)
- Basic observability concepts

**5. Practice Questions:**
- Take practice exams
- Review wrong answers
- Understand WHY answers are correct/incorrect

### Time Management

- 90 minutes for 60 questions = 1.5 minutes per question
- Don't spend too long on any question
- Flag uncertain questions and return later
- First pass: answer what you know
- Second pass: tackle flagged questions

### Common Pitfalls to Avoid

1. **Confusing similar concepts:**
   - StatefulSet vs Deployment
   - Service types (ClusterIP vs NodePort vs LoadBalancer)
   - PV vs PVC
   - Role vs ClusterRole

2. **Not knowing component locations:**
   - What runs on control plane?
   - What runs on worker nodes?
   - What talks to etcd?

3. **Mixing up kubectl syntax:**
   - `create` vs `apply`
   - `get` vs `describe`
   - Correct flag formats

4. **Forgetting the basics:**
   - 4 default namespaces
   - What is a Pod?
   - Service types

### Quick Reference Tables

**Service Types:**
| Type | Use Case | Accessibility |
|------|----------|---------------|
| ClusterIP | Internal | Cluster only |
| NodePort | Development | Node IP:Port |
| LoadBalancer | Production | External LB |
| ExternalName | External service | DNS CNAME |

**Workload Resources:**
| Type | Use Case | Features |
|------|----------|----------|
| Deployment | Stateless apps | Rolling updates, scaling |
| StatefulSet | Stateful apps | Stable identity, ordered |
| DaemonSet | Node agents | One per node |
| Job | Batch work | Run to completion |
| CronJob | Scheduled | Time-based |

**Access Modes:**
| Mode | Description | Example |
|------|-------------|---------|
| RWO | Single node R/W | Database |
| ROX | Many nodes R/O | Config |
| RWX | Many nodes R/W | Shared storage |

### Final Tips

✅ **Do:**
- Read questions carefully
- Eliminate obviously wrong answers
- Trust your preparation
- Stay calm and focused
- Use process of elimination

❌ **Don't:**
- Second-guess too much
- Leave questions blank (no penalty for wrong answers)
- Panic if you don't know something
- Rush through questions

### Resources

**Official:**
- https://kubernetes.io/docs/
- https://www.cncf.io/certification/kcna/
- https://training.linuxfoundation.org/

**Practice:**
- kubernetes.io/docs/tutorials/
- killer.sh (practice exams)
- KodeKloud KCNA course

**Community:**
- Kubernetes Slack
- Reddit r/kubernetes
- Stack Overflow

---

## Summary Checklist

Before the exam, make sure you understand:

- ✅ Kubernetes architecture (control plane vs data plane)
- ✅ Core components (API Server, etcd, scheduler, kubelet, etc.)
- ✅ Pod lifecycle and container runtime interaction
- ✅ Workload resources (Deployment, StatefulSet, DaemonSet, Job, CronJob)
- ✅ Services and networking (ClusterIP, NodePort, LoadBalancer, Ingress)
- ✅ Storage (emptyDir, PV, PVC, StorageClass)
- ✅ 4 default namespaces
- ✅ kubectl basic commands
- ✅ etcd, CRI, OCI roles and relationships
- ✅ NLB vs ALB differences
- ✅ Access modes for volumes
- ✅ What happens when components fail
- ✅ CNCF landscape basics
- ✅ Observability fundamentals (Prometheus)
- ✅ Cloud native principles

---

## Good Luck! 🚀

Remember: KCNA is a foundational exam. Focus on understanding concepts rather than memorizing commands. If you understand the "why" behind Kubernetes design decisions, the "what" and "how" become much easier.

**You've got this!** The fact that you're reviewing your mistakes and studying thoroughly shows you're on the right track. Take the exam again with confidence!
