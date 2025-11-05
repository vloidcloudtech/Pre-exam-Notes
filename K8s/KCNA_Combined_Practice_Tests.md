# KCNA Combined Practice Tests

## Complete Question Bank from Practice Tests 1 & 2

## Table of Contents

- Cloud Native Architecture


## Cloud Native Architecture

### Practice Test 1

#### Question 4

What is Site Reliability Engineering (SRE)?

- **A.** A practice of using software tools to automate IT infrastructure tasks such as system management and application monitoring. ✓
- **B.** The setup of frequent and automated code changes by integrating the changes from multiple developers.
- **C.** The process for automatically scaling the number of Pods in a deployment, replication controller, or replica set based on that resource's CPU utilization to match demand.
- **D.** A method of providing backend services on an as-used basis.

**Correct Answer: A**

> **Explanation:** Site reliability engineering (SRE) is the practice of using software tools to automate IT infrastructure tasks such as system management and application monitoring. Organizations use SRE to ensure their software applications remain reliable amidst frequent updates from development teams.

### Practice Test 2

#### Question 5

What are the 3 vendor-neutral container standards that the Open Container Initiative (OCI) provides?

- **A.** Pod Specification (pod-spec), Runtime Specification (runtime-spec), and Distribution Specification (distribution-spec).
- **B.** Runtime Specification (runtime-spec), Image Specification (image-spec), and Distribution Specification (distribution-spec). ✓
- **C.** CustomResourceDefinitions Specification (crd-spec), Runtime Specification (runtime-spec), and Distribution Specification (distribution-spec).
- **D.** Deployment Specification (deployment-spec), Image Specification (image-spec), and Runtime Specification (runtime-spec).

**Correct Answer: B**

> **Explanation:** The Open Container Initiative (OCI) currently contains three specifications: Runtime Specification (runtime-spec), Image Specification (image-spec), and Distribution Specification (distribution-spec).


## Cloud Native Application Delivery

### Practice Test 1

#### Question 3

What does Continuous Deployment mean in CI/CD?

- **A.** It is a system property that defines the degree to which the system can generate actionable insights.
- **B.** It is the process of automatically deploying the application code changes from the test environment to production. ✓
- **C.** It is a set of practices in which code changes are automatically deployed and tested into an acceptance environment.
- **D.** It is the practice of integrating code changes from numerous developers as regularly as possible.

**Correct Answer: B**

> **Explanation:** Continuous Deployment goes a step further than continuous delivery by deploying finished software directly to production. It is the final phase of the CI/CD pipeline where code changes are automatically deployed from test to production.


## Cloud Native Observability

### Practice Test 1

#### Question 3

Which of the following statements best describes what Prometheus is?

- **A.** A single-purpose and lightweight component that can be added to any Kubernetes cluster to drive the scaling of any container in Kubernetes based on the number of events needing to be processed.
- **B.** An Observability framework and toolkit designed to create and manage telemetry data such as traces, metrics, and logs.
- **C.** A tool for keeping Kubernetes clusters in sync with sources of configuration and automating updates to the configuration when there is new code to deploy.
- **D.** An open-source systems monitoring and alerting toolkit that provides a multi-dimensional data model with time series data identified by metric name and key/value pairs. ✓ ✓

**Correct Answer: D**

> **Explanation:** Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. It provides a multi-dimensional data model with time series data identified by metric name and key/value pairs.

#### Question 5

Which of the following is not a type of telemetry data that is used as a signal in OpenTelemetry?

- **A.** Traces
- **B.** Logs
- **C.** Metrics
- **D.** Ephemeral ✓ ✓

**Correct Answer: D**

> **Explanation:** In OpenTelemetry, the supported signals are Traces, Metrics, Logs, and Baggage. Ephemeral is not a telemetry signal in OpenTelemetry.

### Practice Test 2

#### Question 3

What are the different telemetry data that OpenTelemetry can create and manage?

- **A.** Traces, Metrics, and Logs ✓
- **B.** Startup, Readiness, and Liveness
- **C.** ClusterIP, NodePort, LoadBalancer, and ExternalName
- **D.** Cloud, Clusters, Containers, and Code

**Correct Answer: A**

> **Explanation:** OpenTelemetry is an Observability framework and toolkit designed to create and manage telemetry data such as traces, metrics, and logs.

#### Question 4

You are developing an eLearning application that will run on a Kubernetes cluster. Which of the following is the most operationally-efficient way to implement tracing?

- **A.** Implement tracing in the Kubernetes cluster using Flux.
- **B.** Integrate Prometheus to trace the requests in the Kubernetes cluster using container probes.
- **C.** Implement tracing in the Kubernetes cluster using Jaeger. ✓
- **D.** Integrate Grafana Loki to trace the requests in the Kubernetes cluster via sidecar containers.

**Correct Answer: C**

> **Explanation:** Jaeger is a distributed tracing system released as open source by Uber Technologies. It is used for monitoring and troubleshooting microservices-based distributed systems.

#### Question 9

Which of the following metric types in Prometheus represents a single numerical value that can arbitrarily increase and decrease over time?

- **A.** Gauge ✓
- **B.** Counter
- **C.** Histogram
- **D.** Summary

**Correct Answer: A**

> **Explanation:** A Gauge is a metric that represents a single numerical value that can arbitrarily go up and down. Gauges are typically used for measured values like temperatures or current memory usage.


## Container Orchestration

### Practice Test 1

#### Question 1

Which of the following should you use to request storage in a Kubernetes cluster?

- **A.** PersistentVolume (PV)
- **B.** Container Storage Interface (CSI)
- **C.** PersistentVolumeClaim (PVC) ✓
- **D.** Container Storage Interface (CSI) Volume Cloning

**Correct Answer: C**

> **Explanation:** A PersistentVolumeClaim (PVC) is a request for storage by a user. It is similar to a Pod - Pods consume node resources and PVCs consume PV resources.

#### Question 4

How can you configure a Service to be reachable only from within the Kubernetes cluster?

- **A.** Set up a NodePort Service type which configures every node in the cluster to listen on an assigned port.
- **B.** Create a LoadBalancer Service type to automatically provision a load balancer from your cloud provider that's only accessible within the cluster.
- **C.** Use the default ClusterIP Service type that assigns an IP address from a pool of IP addresses that your cluster has reserved. ✓
- **D.** Create a Headless Service by explicitly specifying None for the cluster IP address.

**Correct Answer: C**

> **Explanation:** A ClusterIP is a type of Service in Kubernetes that exposes the Service on a cluster-internal IP. This is the default Service type.

#### Question 7

Which of the following is a type of a namespaced object?

- **A.** StorageClass
- **B.** Node
- **C.** PersistentVolume
- **D.** Deployment ✓ ✓

**Correct Answer: D**

> **Explanation:** Deployments are namespaced objects. StorageClass, Nodes, and PersistentVolumes are cluster-wide objects.

#### Question 9

Which of the following provides an internal alias for an external DNS name?

- **A.** ClusterIP
- **B.** LoadBalancer
- **C.** InternalTrafficPolicy
- **D.** ExternalName ✓ ✓

**Correct Answer: D**

> **Explanation:** Services of type ExternalName map a Service to a DNS name. This provides an internal alias for an external DNS name.

### Practice Test 2

#### Question 3

Which of the following is true regarding the LoadBalancer Service type?

- **A.** It exposes the Service on a cluster-internal IP address.
- **B.** It allows you to integrate your Kubernetes cluster with an external load balancer from a cloud provider of your choice, like AWS or GCP. ✓
- **C.** It exposes the Service on each Node's IP at a static port.
- **D.** It configures your cluster's DNS server to return a CNAME record with an external hostname that you specify.

**Correct Answer: B**

> **Explanation:** The LoadBalancer type exposes the Service externally using an external load balancer from a cloud provider.

#### Question 5

Which of the following acts as an entry point for your Kubernetes cluster and lets you consolidate your routing rules into a single resource?

- **A.** Ingress ✓
- **B.** EndpointSlice
- **C.** Container Networking Interface (CNI)
- **D.** LoadBalancer

**Correct Answer: A**

> **Explanation:** An Ingress is an API object that manages external access to the services in a cluster, typically HTTP.

#### Question 7

Which of the following is not included in the set of initial namespaces that Kubernetes starts by default?

- **A.** kube-node-lease
- **B.** kube-public
- **C.** kube-system
- **D.** kube-scheduler ✓ ✓

**Correct Answer: D**

> **Explanation:** Kubernetes starts with four initial namespaces: default, kube-node-lease, kube-public, and kube-system. kube-scheduler is a control plane component, not a namespace.

#### Question 12

What is the common built-in autoscaling on Kubernetes that can be easily created using the kubectl autoscale command?

- **A.** Vertical Pod Autoscaler
- **B.** Horizontal Pod Autoscaler ✓
- **C.** Cluster Autoscaler
- **D.** Karpenter

**Correct Answer: B**

> **Explanation:** HorizontalPodAutoscaler automatically updates a workload resource to match demand by deploying more Pods. It can be created using kubectl autoscale.

#### Question 14

Which of the following statements best describes RuntimeClass?

- **A.** A feature for selecting the container runtime configuration that will be used to run your Pod's containers. ✓
- **B.** A feature for selecting the container runtime configuration of your cluster.
- **C.** A feature for selecting the container runtime configuration that will be used to run the pods of your Nodes.
- **D.** A feature for selecting the container runtime configuration that will be used to run your Nodes.

**Correct Answer: A**

> **Explanation:** RuntimeClass is a feature for selecting the container runtime configuration used to run a Pod's containers.

#### Question 17

Which of the following statements is true regarding Service Accounts?

- **A.** A service account is a type of human account in Kubernetes that uses Role Based Access Control (RBAC)
- **B.** Service Accounts provide a distinct identity in a cluster allowing authentication to the Kubernetes API server or implementing identity-based security policies. ✓
- **C.** Service accounts exist as ServiceAccount objects in every Pod of the Kubernetes cluster.
- **D.** Service accounts are similar to user accounts as both can authenticate human users in the Kubernetes cluster.

**Correct Answer: B**

> **Explanation:** Service accounts provide a distinct identity in a Kubernetes cluster for non-human authentication and authorization.

#### Question 20

What can you use to provide an identity for the processes that run in your Pods?

- **A.** Security Context
- **B.** QoS Class (Quality of Service Class)
- **C.** Service Account ✓
- **D.** Service Internal Traffic Policy

**Correct Answer: C**

> **Explanation:** Service accounts are used to provide identities for Pods that need to communicate with the Kubernetes API server.

#### Question 21

Which of the following statements is NOT a valid description of Service Accounts?

- **A.** Service Accounts are lightweight, where each one exists in the cluster and is defined in the Kubernetes API.
- **B.** Service Accounts are namespaced, where each one is bound to a Kubernetes namespace.
- **C.** Service Accounts are portable, wherein a configuration bundle might include service account definitions.
- **D.** Service Accounts are intended to be global and not namespaced, where names must be unique across all namespaces. ✓ ✓

**Correct Answer: D**

> **Explanation:** This statement is NOT true. Service accounts are namespaced resources, not global.

#### Question 22

What should you do to grant cross-namespace access to Pods?

- **A.** Configure a Network Policy between the namespaces
- **B.** Set up Security Context between the two namespaces
- **C.** Implement a Service Internal Traffic Policy
- **D.** Use Service Accounts to grant cross-namespace access ✓ ✓

**Correct Answer: D**

> **Explanation:** Service accounts can be used to provide identities and grant cross-namespace access.


## Kubernetes Fundamentals

### Practice Test 1

#### Question 7

Which of the following is NOT a valid phase of a Pod in Kubernetes?

- **A.** Pending
- **B.** Running
- **C.** Terminating ✓
- **D.** Failed

**Correct Answer: C**

> **Explanation:** The valid phases of a Pod are: Pending, Running, Succeeded, Failed, and Unknown. 'Terminating' is shown by kubectl but is not an official Pod phase.

#### Question 8

Which of the following is not a service type in Kubernetes?

- **A.** ClusterIP
- **B.** NodePort
- **C.** Ingress ✓
- **D.** ExternalName

**Correct Answer: C**

> **Explanation:** The Kubernetes Service types are: ClusterIP, NodePort, LoadBalancer, and ExternalName. Ingress is not a Service type.

#### Question 13

Which Kubernetes command can be used to login to a pod via SSH?

- **A.** kubectl port-forward
- **B.** kubectl exec ✓
- **C.** kubectl run
- **D.** kubectl expose

**Correct Answer: B**

> **Explanation:** The kubectl exec command enables users to execute a specific command in a container, including getting shell access.

#### Question 17

Which control plane component links your Kubernetes cluster into your cloud provider's API?

- **A.** kube-apiserver
- **B.** kube-scheduler
- **C.** kube-controller-manager
- **D.** cloud-controller-manager ✓ ✓

**Correct Answer: D**

> **Explanation:** The cloud-controller-manager embeds cloud-specific control logic and links your cluster to your cloud provider's API.

#### Question 20

What can you use to provide an identity for processes that run in your Pods?

- **A.** Security Context
- **B.** QoS Class
- **C.** Service Account ✓
- **D.** Service Internal Traffic Policy

**Correct Answer: C**

> **Explanation:** Service accounts provide a distinct identity in a Kubernetes cluster for Pods to authenticate to the API server.

#### Question 23

Which command describes the supported API resource and all its associated fields?

- **A.** kubectl get namespaces
- **B.** kubectl options
- **C.** kubectl explain ✓
- **D.** kubectl describe

**Correct Answer: C**

> **Explanation:** kubectl explain lists the fields for supported API resources and describes their associated fields.

### Practice Test 2

#### Question 3

Which of the following provides containers with automatic bin packing?

- **A.** Argo
- **B.** Grafana
- **C.** Prometheus
- **D.** Kubernetes ✓ ✓

**Correct Answer: D**

> **Explanation:** Kubernetes provides automatic bin packing to fit containers onto nodes to make the best use of resources.

#### Question 5

Which of the following is a type of Kubernetes Service?

- **A.** LoadBalancer ✓
- **B.** ReplicaSet
- **C.** NetworkPolicy
- **D.** Ingress

**Correct Answer: A**

> **Explanation:** LoadBalancer is one of the four valid Kubernetes Service types along with ClusterIP, NodePort, and ExternalName.

#### Question 7

Which command should you use to deploy a new Deployment object?

- **A.** kubectl rollout -f tutorialsdojo-deployment.yaml
- **B.** kubectl run -f tutorialsdojo-deployment.yaml
- **C.** kubectl exec -f tutorialsdojo-deployment.yaml
- **D.** kubectl apply -f tutorialsdojo-deployment.yaml ✓ ✓

**Correct Answer: D**

> **Explanation:** kubectl apply is the recommended way to create and update resources in a cluster.

#### Question 11

Which statement is true regarding the etcd key-value store?

- **A.** It is one of the control plane's components in Kubernetes. ✓
- **B.** It provides an eventually consistent, distributed key-value store.
- **C.** It is one of the Node components in Kubernetes.
- **D.** It provides a way for administrators to describe the 'classes' of storage they offer.

**Correct Answer: A**

> **Explanation:** etcd is a consistent and highly-available key value store used as Kubernetes' backing store for all cluster data.

#### Question 13

Which is not a valid type of probe in Kubernetes?

- **A.** Liveness Probe
- **B.** Readiness Probe
- **C.** Container Probe ✓
- **D.** Startup Probe

**Correct Answer: C**

> **Explanation:** The valid probe types are: Liveness Probe, Readiness Probe, and Startup Probe. 'Container Probe' is not valid.

#### Question 14

Which lists are valid Cloud Controller Manager functions?

- **A.** Node controller, Route controller, and Service controller ✓
- **B.** Node controller, Job controller, EndpointSlice controller, and ServiceAccount controller
- **C.** kubelet, kube-proxy, and the container runtime
- **D.** kube-apiserver, kube-scheduler, kube-controller-manager, cloud-controller-manager, and etcd

**Correct Answer: A**

> **Explanation:** The cloud-controller-manager runs Node controller, Route controller, and Service controller for cloud provider dependencies.

#### Question 15

What does kubectl exec tutorials -c dojo -- date do?

- **A.** Execute 'date' in the pod called dojo that's running in the tutorials node.
- **B.** Get output from 'date' in the tutorials container from the dojo pod.
- **C.** Execute 'date' in the pod called tutorials that's running in the dojo node.
- **D.** Get output from 'date' in the dojo container from the tutorials pod. ✓ ✓

**Correct Answer: D**

> **Explanation:** This command executes 'date' in the dojo container (specified with -c) from the tutorials pod.

#### Question 17

Which acts as the front end for the Kubernetes control plane?

- **A.** kube-apiserver ✓
- **B.** kube-scheduler
- **C.** kube-controller-manager
- **D.** kube-proxy

**Correct Answer: A**

> **Explanation:** The API server exposes the Kubernetes API and is the front end for the Kubernetes control plane.

#### Question 18

What is true regarding kubectl describe vs kubectl explain commands?

- **A.** kubectl describe shows the API documentation of specified resources.
- **B.** kubectl describe provides a detailed description of selected resources including related resources. ✓
- **C.** kubectl explain shows the node's resource consumption.
- **D.** kubectl explain provides more detailed description than kubectl describe.

**Correct Answer: B**

> **Explanation:** kubectl describe shows details of actual resources in your cluster, while kubectl explain shows API documentation.
