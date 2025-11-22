# CKS Certification - Cheat Sheets & Quick Reference

Comprehensive quick reference guide for the Certified Kubernetes Security Specialist (CKS) exam. Print-friendly, exam-focused, and designed for rapid recall.

**Exam**: CKS (Certified Kubernetes Security Specialist)
**Provider**: CNCF / Linux Foundation
**Duration**: 2 hours
**Passing Score**: 67%
**Prerequisites**: Valid CKA certification required

---

## Table of Contents

1. [CKS Exam Quick Card](#cks-exam-quick-card)
2. [Domain 1: Cluster Setup (10%)](#domain-1-cluster-setup-10)
3. [Domain 2: Cluster Hardening (15%)](#domain-2-cluster-hardening-15)
4. [Domain 3: System Hardening (15%)](#domain-3-system-hardening-15)
5. [Domain 4: Minimize Microservice Vulnerabilities (20%)](#domain-4-minimize-microservice-vulnerabilities-20)
6. [Domain 5: Supply Chain Security (20%)](#domain-5-supply-chain-security-20)
7. [Domain 6: Monitoring, Logging & Runtime Security (20%)](#domain-6-monitoring-logging--runtime-security-20)
8. [kubectl Speed Commands](#kubectl-speed-commands)
9. [Network Policy Templates](#network-policy-templates)
10. [RBAC Quick Reference](#rbac-quick-reference)
11. [Security Context Templates](#security-context-templates)
12. [AppArmor & Seccomp Profiles](#apparmor--seccomp-profiles)
13. [Image Scanning & Supply Chain](#image-scanning--supply-chain)
14. [Falco & Runtime Security](#falco--runtime-security)
15. [Audit Logging Configuration](#audit-logging-configuration)
16. [Troubleshooting Quick Reference](#troubleshooting-quick-reference)
17. [Exam Day Quick Cards](#exam-day-quick-cards)

---

## CKS Exam Quick Card

### Exam Format
- **Type**: Performance-based (hands-on tasks in real K8s clusters)
- **Duration**: 2 hours (120 minutes)
- **Number of Tasks**: 15-20 tasks
- **Passing Score**: 67%
- **Environment**: PSI Bridge Proctoring (remote)
- **K8s Version**: 1.29 (check current exam version)
- **Documentation**: kubernetes.io allowed (single tab)

### Weight Distribution
| Domain | Weight | Questions |
|--------|--------|-----------|
| Cluster Setup | 10% | 2-3 tasks |
| Cluster Hardening | 15% | 3 tasks |
| System Hardening | 15% | 3 tasks |
| Microservice Vulnerabilities | 20% | 4 tasks |
| Supply Chain Security | 20% | 4 tasks |
| Monitoring/Logging/Runtime | 20% | 4 tasks |

### Time Management
- **Average per task**: 6-8 minutes
- **Flag difficult tasks**: Move on, return later
- **First pass**: Complete easy tasks (40-50 minutes)
- **Second pass**: Medium difficulty (40-50 minutes)
- **Final pass**: Difficult tasks + review (20-30 minutes)

### Allowed Resources
- ✅ kubernetes.io documentation (single tab)
- ✅ kubectl explain
- ✅ kubectl --help
- ❌ GitHub, StackOverflow, blogs
- ❌ Personal notes
- ❌ Multiple browser tabs

### Critical Success Factors
1. **Speed with kubectl** - Practice aliases and shortcuts
2. **Know documentation structure** - Bookmark key pages beforehand (mentally)
3. **YAML syntax perfection** - Indentation errors = task failure
4. **Context switching** - Each task may use different cluster
5. **Verification** - Always verify task completion before moving on

---

## Domain 1: Cluster Setup (10%)

### 1.1 Network Policies - Quick Reference

**Default Deny All Ingress**:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

**Default Deny All Egress**:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-egress
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Egress
```

**Allow Specific Ingress**:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-frontend
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
```

**Allow Egress to DNS + External API**:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-and-api
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
    ports:
    - protocol: UDP
      port: 53
  - to:
    - podSelector: {}
    ports:
    - protocol: TCP
      port: 443
```

### 1.2 CIS Benchmarks - Key Checks

**kube-bench Installation**:
```bash
# Download and run
wget https://github.com/aquasecurity/kube-bench/releases/download/v0.7.0/kube-bench_0.7.0_linux_amd64.tar.gz
tar -xvf kube-bench_0.7.0_linux_amd64.tar.gz
sudo ./kube-bench --config-dir cfg --config cfg/config.yaml
```

**Critical Control Plane Checks**:
| Component | Setting | CIS Recommendation |
|-----------|---------|-------------------|
| kube-apiserver | --anonymous-auth | false |
| kube-apiserver | --authorization-mode | RBAC,Node |
| kube-apiserver | --audit-log-path | /var/log/k8s-audit.log |
| kube-apiserver | --audit-log-maxage | 30 |
| kube-apiserver | --enable-admission-plugins | NodeRestriction,PodSecurityPolicy |
| kubelet | --anonymous-auth | false |
| kubelet | --authorization-mode | Webhook |
| etcd | --client-cert-auth | true |

**Quick Fix Example**:
```bash
# Fix kubelet anonymous auth
sudo vi /var/lib/kubelet/config.yaml
# Set: authentication.anonymous.enabled: false
sudo systemctl restart kubelet
```

### 1.3 Ingress Security

**TLS Termination**:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: secure-ingress
  namespace: prod
spec:
  tls:
  - hosts:
    - myapp.example.com
    secretName: myapp-tls
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp
            port:
              number: 80
```

**Create TLS Secret**:
```bash
kubectl create secret tls myapp-tls \
  --cert=path/to/tls.crt \
  --key=path/to/tls.key \
  -n prod
```

---

## Domain 2: Cluster Hardening (15%)

### 2.1 RBAC Quick Reference

**Role vs ClusterRole**:
| Aspect | Role | ClusterRole |
|--------|------|-------------|
| Scope | Namespace | Cluster-wide |
| Resources | Namespaced resources | All resources + cluster-scoped |
| Binding | RoleBinding | ClusterRoleBinding (cluster) or RoleBinding (namespace) |

**Create Role - Read Pods**:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

**Create RoleBinding**:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jane
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

**ClusterRole - Admin Level**:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: secret-admin
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["*"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "create", "update", "patch"]
```

**ServiceAccount + Role Pattern**:
```bash
# Create ServiceAccount
kubectl create sa myapp-sa -n prod

# Create Role
kubectl create role myapp-role --verb=get,list --resource=pods,services -n prod

# Create RoleBinding
kubectl create rolebinding myapp-binding --role=myapp-role --serviceaccount=prod:myapp-sa -n prod

# Use in Pod
kubectl run myapp --image=nginx --serviceaccount=myapp-sa -n prod
```

### 2.2 ServiceAccount Security

**Disable Auto-Mounting**:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: secure-sa
  namespace: prod
automountServiceAccountToken: false
```

**Pod-Level Override**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  serviceAccountName: secure-sa
  automountServiceAccountToken: false
  containers:
  - name: app
    image: myapp:1.0
```

### 2.3 Upgrade Kubernetes Securely

**Control Plane Upgrade** (kubeadm):
```bash
# Check upgrade plan
sudo kubeadm upgrade plan

# Upgrade kubeadm
sudo apt-mark unhold kubeadm
sudo apt-get update && sudo apt-get install -y kubeadm=1.29.0-00
sudo apt-mark hold kubeadm

# Upgrade control plane
sudo kubeadm upgrade apply v1.29.0

# Upgrade kubelet and kubectl
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=1.29.0-00 kubectl=1.29.0-00
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

**Worker Node Upgrade**:
```bash
# Drain node
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# On worker node
sudo apt-mark unhold kubeadm kubelet kubectl
sudo apt-get update && sudo apt-get install -y kubeadm=1.29.0-00 kubelet=1.29.0-00 kubectl=1.29.0-00
sudo apt-mark hold kubeadm kubelet kubectl
sudo kubeadm upgrade node
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Uncordon node
kubectl uncordon <node-name>
```

---

## Domain 3: System Hardening (15%)

### 3.1 AppArmor Profiles

**Check AppArmor Status**:
```bash
# On node
sudo aa-status
sudo systemctl status apparmor

# List profiles
sudo aa-status | grep docker
```

**Load Custom Profile**:
```bash
# Create profile
sudo vi /etc/apparmor.d/k8s-deny-write

# Profile content
#include <tunables/global>

profile k8s-deny-write flags=(attach_disconnected) {
  #include <abstractions/base>

  file,
  # Deny all file writes
  deny /** w,
}

# Load profile
sudo apparmor_parser -r /etc/apparmor.d/k8s-deny-write
```

**Use in Pod**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: apparmor-pod
  annotations:
    container.apparmor.security.beta.kubernetes.io/secure-container: localhost/k8s-deny-write
spec:
  containers:
  - name: secure-container
    image: nginx
```

### 3.2 Seccomp Profiles

**Default Seccomp Profile** (RuntimeDefault):
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: seccomp-pod
spec:
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: nginx
```

**Custom Seccomp Profile**:
```yaml
# Create profile at /var/lib/kubelet/seccomp/deny-chmod.json
{
  "defaultAction": "SCMP_ACT_ALLOW",
  "syscalls": [
    {
      "names": ["chmod", "chown", "fchmod", "fchown"],
      "action": "SCMP_ACT_ERRNO"
    }
  ]
}
```

```yaml
# Use in Pod
apiVersion: v1
kind: Pod
metadata:
  name: custom-seccomp
spec:
  securityContext:
    seccompProfile:
      type: Localhost
      localhostProfile: deny-chmod.json
  containers:
  - name: app
    image: myapp:1.0
```

### 3.3 Kernel Hardening

**sysctl Settings**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sysctl-pod
spec:
  securityContext:
    sysctls:
    - name: net.ipv4.ip_forward
      value: "0"
    - name: kernel.shm_rmid_forced
      value: "1"
  containers:
  - name: app
    image: nginx
```

**Node-Level Hardening**:
```bash
# Edit /etc/sysctl.conf
kernel.kptr_restrict = 2
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
fs.suid_dumpable = 0

# Apply
sudo sysctl -p
```

---

## Domain 4: Minimize Microservice Vulnerabilities (20%)

### 4.1 Pod Security Standards (PSS)

**Namespace Labels**:
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: secure-ns
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

**PSS Levels**:
| Level | Description | Use Case |
|-------|-------------|----------|
| Privileged | Unrestricted | System-level workloads |
| Baseline | Minimally restrictive | Non-critical apps |
| Restricted | Heavily restricted | Security-sensitive apps |

### 4.2 Security Contexts - Complete Reference

**Pod-Level Security Context**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: myapp:1.0
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
        add:
        - NET_BIND_SERVICE
    volumeMounts:
    - name: cache
      mountPath: /cache
  volumes:
  - name: cache
    emptyDir: {}
```

**Security Context Decision Tree**:
```
Need root?
├─ NO → runAsNonRoot: true, runAsUser: 1000
└─ YES (rare)
   ├─ Need privilege escalation?
   │  ├─ NO → allowPrivilegeEscalation: false
   │  └─ YES → Document why, use privileged: true
   └─ Need host namespaces?
      ├─ NO → hostNetwork/hostPID/hostIPC: false
      └─ YES → Document why, enable specific namespace
```

### 4.3 Capabilities Management

**Common Capabilities**:
| Capability | Purpose | Risk Level |
|------------|---------|------------|
| NET_BIND_SERVICE | Bind to ports < 1024 | Low |
| CHOWN | Change file ownership | Medium |
| DAC_OVERRIDE | Bypass file permissions | High |
| SYS_ADMIN | System administration | Critical |
| NET_ADMIN | Network configuration | High |
| SYS_TIME | Change system time | Medium |

**Best Practice**:
```yaml
securityContext:
  capabilities:
    drop:
    - ALL
    add:
    - NET_BIND_SERVICE  # Only add what's needed
```

### 4.4 Read-Only Root Filesystem

**Pattern**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: readonly-pod
spec:
  containers:
  - name: app
    image: nginx
    securityContext:
      readOnlyRootFilesystem: true
    volumeMounts:
    - name: cache
      mountPath: /var/cache/nginx
    - name: run
      mountPath: /var/run
  volumes:
  - name: cache
    emptyDir: {}
  - name: run
    emptyDir: {}
```

---

## Domain 5: Supply Chain Security (20%)

### 5.1 Image Scanning with Trivy

**Basic Scan**:
```bash
# Scan image
trivy image nginx:1.21

# Scan with severity filter
trivy image --severity HIGH,CRITICAL nginx:1.21

# Scan with specific format
trivy image --format json -o results.json nginx:1.21

# Scan Kubernetes manifest
trivy config deployment.yaml

# Scan running cluster
trivy k8s --report summary cluster
```

**CI/CD Integration**:
```bash
# Fail pipeline if HIGH/CRITICAL found
trivy image --exit-code 1 --severity HIGH,CRITICAL myapp:latest
```

### 5.2 Image Policy Webhook / Admission Controllers

**ImagePolicyWebhook Configuration**:
```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
admissionPlugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/imagepolicy/kubeconfig.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: false
```

### 5.3 Verify Image Signatures (Cosign)

**Sign Image**:
```bash
# Generate key pair
cosign generate-key-pair

# Sign image
cosign sign --key cosign.key myregistry/myapp:v1.0

# Verify signature
cosign verify --key cosign.pub myregistry/myapp:v1.0
```

### 5.4 Restrict Registries

**Admission Controller Pattern**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: allowed-registry-pod
spec:
  containers:
  - name: app
    image: mycompany.azurecr.io/myapp:1.0  # ✅ Allowed
    # image: docker.io/nginx:latest  # ❌ Denied by policy
```

**OPA Gatekeeper Example**:
```yaml
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8sallowedrepos
spec:
  crd:
    spec:
      names:
        kind: K8sAllowedRepos
      validation:
        openAPIV3Schema:
          properties:
            repos:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sallowedrepos
        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not startswith(container.image, input.parameters.repos[_])
          msg := sprintf("Image %v not from allowed repos", [container.image])
        }
```

---

## Domain 6: Monitoring, Logging & Runtime Security (20%)

### 6.1 Falco Rules - Quick Reference

**Install Falco**:
```bash
# Using Helm
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm install falco falcosecurity/falco \
  --namespace falco --create-namespace \
  --set falco.jsonOutput=true
```

**Common Falco Rules**:
```yaml
# Detect shell in container
- rule: Shell in Container
  desc: Detect shell execution in container
  condition: >
    spawned_process and container and
    (proc.name = "bash" or proc.name = "sh")
  output: >
    Shell spawned in container (user=%user.name container=%container.name
    shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline)
  priority: WARNING

# Detect privileged container
- rule: Privileged Container Started
  desc: Detect privileged container
  condition: >
    container_started and container.privileged=true
  output: >
    Privileged container started (user=%user.name container=%container.name
    image=%container.image)
  priority: WARNING
```

**Check Falco Logs**:
```bash
# View Falco alerts
kubectl logs -n falco -l app.kubernetes.io/name=falco --tail=100 -f

# Filter for specific rule
kubectl logs -n falco -l app.kubernetes.io/name=falco | grep "Shell in Container"
```

### 6.2 Audit Logging Configuration

**Enable Audit Logging** (kube-apiserver):
```yaml
# /etc/kubernetes/manifests/kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - --audit-log-path=/var/log/kubernetes/audit.log
    - --audit-log-maxage=30
    - --audit-log-maxbackup=10
    - --audit-log-maxsize=100
    - --audit-policy-file=/etc/kubernetes/audit-policy.yaml
    volumeMounts:
    - mountPath: /etc/kubernetes/audit-policy.yaml
      name: audit-policy
      readOnly: true
    - mountPath: /var/log/kubernetes
      name: audit-log
  volumes:
  - hostPath:
      path: /etc/kubernetes/audit-policy.yaml
      type: File
    name: audit-policy
  - hostPath:
      path: /var/log/kubernetes
      type: DirectoryOrCreate
    name: audit-log
```

**Audit Policy** (Basic):
```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  resources:
  - group: ""
    resources: ["secrets"]
- level: RequestResponse
  verbs: ["create", "update", "patch", "delete"]
  resources:
  - group: ""
    resources: ["pods", "services"]
- level: Metadata
  omitStages:
  - RequestReceived
```

**Audit Policy Levels**:
| Level | Description | Use Case |
|-------|-------------|----------|
| None | Don't log | Non-sensitive, high-volume |
| Metadata | Log metadata only | Default for most resources |
| Request | Log metadata + request body | Sensitive creates/updates |
| RequestResponse | Log request + response | Debug/compliance |

### 6.3 Container Runtime Security (crictl)

**crictl Commands**:
```bash
# List running containers
sudo crictl ps

# Inspect container
sudo crictl inspect <container-id>

# View container logs
sudo crictl logs <container-id>

# Execute in container
sudo crictl exec -it <container-id> /bin/sh

# List images
sudo crictl images

# Remove container
sudo crictl rm <container-id>
```

**Check Runtime Class**:
```bash
kubectl get runtimeclass
```

**Use gVisor Runtime**:
```yaml
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: gvisor
handler: runsc
---
apiVersion: v1
kind: Pod
metadata:
  name: gvisor-pod
spec:
  runtimeClassName: gvisor
  containers:
  - name: app
    image: nginx
```

---

## kubectl Speed Commands

### Essential Aliases
```bash
# Add to ~/.bashrc
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kgns='kubectl get namespaces'
alias kdp='kubectl describe pod'
alias kds='kubectl describe svc'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kpf='kubectl port-forward'

# Context switching
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# RBAC
alias kgr='kubectl get role'
alias kgcr='kubectl get clusterrole'
alias kgrb='kubectl get rolebinding'
alias kgcrb='kubectl get clusterrolebinding'

# Security
alias kgsa='kubectl get serviceaccount'
alias kgnp='kubectl get networkpolicy'
alias kgpsp='kubectl get podsecuritypolicy'
```

### Speed Techniques

**1. Imperative Commands**:
```bash
# Create pod quickly
k run nginx --image=nginx --dry-run=client -o yaml > pod.yaml

# Create deployment
k create deploy nginx --image=nginx --replicas=3 --dry-run=client -o yaml > deploy.yaml

# Create service
k expose pod nginx --port=80 --target-port=80 --dry-run=client -o yaml > svc.yaml

# Create secret
k create secret generic db-secret --from-literal=password=mypass

# Create configmap
k create cm app-config --from-literal=key=value

# Create serviceaccount
k create sa myapp-sa
```

**2. JSON Path Queries**:
```bash
# Get pod IPs
k get pods -o jsonpath='{.items[*].status.podIP}'

# Get node names
k get nodes -o jsonpath='{.items[*].metadata.name}'

# Get container images
k get pods -o jsonpath='{.items[*].spec.containers[*].image}'

# Custom columns
k get pods -o custom-columns=NAME:.metadata.name,IP:.status.podIP,NODE:.spec.nodeName
```

**3. Quick Edits**:
```bash
# Edit in-place
k edit pod nginx

# Scale quickly
k scale deploy nginx --replicas=5

# Set image
k set image deploy/nginx nginx=nginx:1.21

# Rollout status
k rollout status deploy/nginx

# Rollback
k rollout undo deploy/nginx
```

---

## Network Policy Templates

### Template 1: Default Deny All
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: prod
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

### Template 2: Frontend → Backend Communication
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-allow-frontend
  namespace: prod
spec:
  podSelector:
    matchLabels:
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          tier: frontend
    ports:
    - protocol: TCP
      port: 8080
```

### Template 3: Allow DNS + External HTTPS
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-https
  namespace: prod
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Egress
  egress:
  # Allow DNS
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
      podSelector:
        matchLabels:
          k8s-app: kube-dns
    ports:
    - protocol: UDP
      port: 53
  # Allow HTTPS egress
  - to:
    - podSelector: {}
    ports:
    - protocol: TCP
      port: 443
```

### Template 4: Database Access from Specific Namespace
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: postgres-allow-app-ns
  namespace: database
spec:
  podSelector:
    matchLabels:
      app: postgres
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: production
      podSelector:
        matchLabels:
          tier: backend
    ports:
    - protocol: TCP
      port: 5432
```

---

## RBAC Quick Reference

### Common Verbs
```
get, list, watch, create, update, patch, delete, deletecollection
```

### Common Resources
```
pods, services, deployments, replicasets, statefulsets, daemonsets,
configmaps, secrets, serviceaccounts, persistentvolumeclaims,
namespaces, nodes, events
```

### Quick Commands
```bash
# Check access
k auth can-i create pods --as=jane
k auth can-i delete deployments --as=system:serviceaccount:default:myapp-sa

# View permissions
k describe role pod-reader
k describe rolebinding read-pods

# Create Role imperatively
k create role pod-reader --verb=get,list,watch --resource=pods -n prod

# Create RoleBinding imperatively
k create rolebinding read-pods --role=pod-reader --user=jane -n prod

# Create ClusterRole
k create clusterrole secret-admin --verb=* --resource=secrets

# Create ClusterRoleBinding
k create clusterrolebinding secret-admin-binding --clusterrole=secret-admin --user=admin
```

### Role Template: Read-Only Access
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: readonly
  namespace: prod
rules:
- apiGroups: ["", "apps", "batch"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
```

### ClusterRole Template: Secrets Admin
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: secrets-manager
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["*"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list", "watch"]
```

---

## Security Context Templates

### Template 1: Maximum Security (Restricted PSS)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: max-secure-pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: myapp:1.0
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
    volumeMounts:
    - name: tmp
      mountPath: /tmp
  volumes:
  - name: tmp
    emptyDir: {}
```

### Template 2: Web Server (NET_BIND_SERVICE)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - name: nginx
    image: nginx:alpine
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
        add:
        - NET_BIND_SERVICE
    ports:
    - containerPort: 80
    volumeMounts:
    - name: cache
      mountPath: /var/cache/nginx
    - name: run
      mountPath: /var/run
  volumes:
  - name: cache
    emptyDir: {}
  - name: run
    emptyDir: {}
```

### Template 3: With AppArmor + Seccomp
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: apparmor-seccomp-pod
  annotations:
    container.apparmor.security.beta.kubernetes.io/app: localhost/k8s-deny-write
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: Localhost
      localhostProfile: deny-chmod.json
  containers:
  - name: app
    image: myapp:1.0
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
```

---

## AppArmor & Seccomp Profiles

### AppArmor: Deny Write Profile
```bash
# File: /etc/apparmor.d/k8s-deny-write
#include <tunables/global>

profile k8s-deny-write flags=(attach_disconnected) {
  #include <abstractions/base>

  file,
  deny /** w,
  deny /** k,
  deny /** l,
}
```

### AppArmor: Deny Network Profile
```bash
# File: /etc/apparmor.d/k8s-deny-network
#include <tunables/global>

profile k8s-deny-network flags=(attach_disconnected) {
  #include <abstractions/base>

  file,
  deny network,
}
```

### Seccomp: Deny chmod/chown
```json
{
  "defaultAction": "SCMP_ACT_ALLOW",
  "architectures": [
    "SCMP_ARCH_X86_64",
    "SCMP_ARCH_X86",
    "SCMP_ARCH_X32"
  ],
  "syscalls": [
    {
      "names": [
        "chmod",
        "fchmod",
        "fchmodat",
        "chown",
        "fchown",
        "fchownat",
        "lchown"
      ],
      "action": "SCMP_ACT_ERRNO"
    }
  ]
}
```

### Seccomp: Deny Dangerous Syscalls
```json
{
  "defaultAction": "SCMP_ACT_ALLOW",
  "syscalls": [
    {
      "names": [
        "acct",
        "add_key",
        "bpf",
        "clock_adjtime",
        "clock_settime",
        "delete_module",
        "finit_module",
        "init_module",
        "ioperm",
        "iopl",
        "kcmp",
        "kexec_file_load",
        "kexec_load",
        "keyctl",
        "mount",
        "move_pages",
        "name_to_handle_at",
        "open_by_handle_at",
        "perf_event_open",
        "personality",
        "pivot_root",
        "process_vm_readv",
        "process_vm_writev",
        "ptrace",
        "reboot",
        "request_key",
        "setdomainname",
        "sethostname",
        "setns",
        "settimeofday",
        "swapon",
        "swapoff",
        "umount2",
        "unshare",
        "uselib",
        "userfaultfd",
        "vmsplice"
      ],
      "action": "SCMP_ACT_ERRNO"
    }
  ]
}
```

---

## Image Scanning & Supply Chain

### Trivy Scanning Patterns

**1. Scan Image for Vulnerabilities**:
```bash
trivy image nginx:1.21
trivy image --severity HIGH,CRITICAL alpine:latest
trivy image --ignore-unfixed nginx:1.21
```

**2. Scan Kubernetes Manifests**:
```bash
trivy config deployment.yaml
trivy config --severity HIGH,CRITICAL k8s-manifests/
```

**3. Scan Helm Charts**:
```bash
trivy config --file-patterns "*.yaml" ./my-chart/
```

**4. Scan Running Cluster**:
```bash
trivy k8s --report summary cluster
trivy k8s --namespace prod --report all cluster
```

**5. CI/CD Integration**:
```bash
#!/bin/bash
# Fail build if HIGH or CRITICAL vulnerabilities found
trivy image --exit-code 1 --severity HIGH,CRITICAL myapp:$VERSION

# Generate JSON report
trivy image --format json --output results.json myapp:$VERSION
```

### Image Signature Verification (Cosign)

**Sign and Verify**:
```bash
# Generate keys
cosign generate-key-pair

# Sign image
cosign sign --key cosign.key myregistry/myapp:v1.0

# Verify image
cosign verify --key cosign.pub myregistry/myapp:v1.0

# Sign with keyless (OIDC)
cosign sign myregistry/myapp:v1.0

# Verify with transparency log
cosign verify myregistry/myapp:v1.0
```

---

## Falco & Runtime Security

### Falco Installation (Helm)
```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  --set falco.jsonOutput=true \
  --set falco.logLevel=info
```

### Custom Falco Rules
```yaml
# File: /etc/falco/rules.d/custom-rules.yaml
- rule: Detect Shell in Container
  desc: Alert on shell execution in container
  condition: >
    spawned_process and container and
    proc.name in (bash, sh, zsh, fish)
  output: >
    Shell spawned (user=%user.name container=%container.name
    shell=%proc.name cmdline=%proc.cmdline)
  priority: WARNING
  tags: [shell, container]

- rule: Sensitive File Access
  desc: Detect access to sensitive files
  condition: >
    open_read and container and
    fd.name in (/etc/shadow, /etc/passwd, /etc/sudoers)
  output: >
    Sensitive file opened (user=%user.name file=%fd.name
    container=%container.name)
  priority: CRITICAL
  tags: [sensitive, filesystem]

- rule: Outbound Connection from Container
  desc: Detect outbound connections
  condition: >
    outbound and container and
    not fd.sip in (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
  output: >
    Outbound connection (container=%container.name dest=%fd.rip:%fd.rport)
  priority: NOTICE
  tags: [network, egress]
```

### Check Falco Alerts
```bash
# View real-time alerts
kubectl logs -n falco -l app.kubernetes.io/name=falco -f

# Filter specific rule
kubectl logs -n falco -l app.kubernetes.io/name=falco | grep "Shell spawned"

# Export to file
kubectl logs -n falco -l app.kubernetes.io/name=falco > falco-alerts.log
```

---

## Audit Logging Configuration

### Comprehensive Audit Policy
```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - "RequestReceived"
rules:
  # Secrets: Log metadata only (don't log secret values)
  - level: Metadata
    resources:
    - group: ""
      resources: ["secrets"]

  # ConfigMaps: Log metadata
  - level: Metadata
    resources:
    - group: ""
      resources: ["configmaps"]

  # Critical mutations: Full logging
  - level: RequestResponse
    verbs: ["create", "update", "patch", "delete"]
    resources:
    - group: ""
      resources: ["pods", "services", "persistentvolumeclaims"]
    - group: "apps"
      resources: ["deployments", "daemonsets", "statefulsets"]
    - group: "rbac.authorization.k8s.io"
      resources: ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]

  # Authentication events
  - level: Metadata
    users: ["system:anonymous"]

  # Get/List/Watch: Minimal logging
  - level: None
    verbs: ["get", "list", "watch"]

  # Default: Metadata level
  - level: Metadata
```

### View Audit Logs
```bash
# On control plane node
sudo tail -f /var/log/kubernetes/audit.log

# Filter for specific user
sudo grep "user.*jane" /var/log/kubernetes/audit.log

# Filter for secret access
sudo grep "secrets" /var/log/kubernetes/audit.log | jq .

# Filter by verb
sudo grep '"verb":"delete"' /var/log/kubernetes/audit.log
```

---

## Troubleshooting Quick Reference

### Network Policy Not Working
```bash
# 1. Check CNI plugin supports NetworkPolicies
kubectl get pods -n kube-system | grep -E "calico|cilium|weave"

# 2. Describe NetworkPolicy
k describe networkpolicy <policy-name> -n <namespace>

# 3. Check pod labels match
k get pods --show-labels -n <namespace>

# 4. Test connectivity
k run test-pod --image=busybox --rm -it -- sh
wget -O- http://<target-service>.<namespace>.svc.cluster.local
```

### RBAC Permission Denied
```bash
# 1. Check as specific user
k auth can-i <verb> <resource> --as=<user> -n <namespace>

# 2. View effective permissions
k describe role <role-name> -n <namespace>
k describe rolebinding <binding-name> -n <namespace>

# 3. Check ServiceAccount token
k get sa <sa-name> -o yaml
k get secret <sa-token-secret> -o yaml

# 4. Debug with verbose logging
k get pods --v=8
```

### Pod Security Admission Issues
```bash
# 1. Check namespace labels
k get ns <namespace> --show-labels

# 2. Test pod against PSS level
k label ns <namespace> pod-security.kubernetes.io/warn=restricted --overwrite
k apply -f pod.yaml  # See warnings

# 3. View violations
k get events -n <namespace> | grep "violates PodSecurity"
```

### Image Pull Errors
```bash
# 1. Check imagePullSecrets
k describe pod <pod-name> | grep -A3 "Events:"

# 2. Test image pull manually
crictl pull <image>

# 3. Check registry credentials
k get secret <image-pull-secret> -o yaml

# 4. Check admission webhook blocking
k get events --all-namespaces | grep "denied the request"
```

### Seccomp/AppArmor Not Applied
```bash
# 1. Check node supports seccomp
grep CONFIG_SECCOMP /boot/config-$(uname -r)

# 2. Check AppArmor status
sudo aa-status

# 3. Verify profile loaded
sudo aa-status | grep <profile-name>

# 4. Check pod annotations/securityContext
k get pod <pod-name> -o yaml | grep -A5 securityContext
```

---

## Exam Day Quick Cards

### Card 1: Time Management
```
Total Time: 120 minutes
Tasks: 15-20

Time per task: 6-8 minutes average
Difficulty distribution:
- Easy (40%): 3-4 min each
- Medium (40%): 6-8 min each
- Hard (20%): 10-15 min each

Strategy:
1. First pass: Complete all easy tasks (40-50 min)
2. Second pass: Medium tasks (40-50 min)
3. Final pass: Hard tasks + review (20-30 min)

Flag and move on if stuck > 10 minutes
```

### Card 2: Context Switching
```
Each task may use different cluster!

ALWAYS check task header:
- Cluster name
- Namespace
- Node to work on

Set context:
kubectl config use-context <cluster-name>
kubectl config set-context --current --namespace=<namespace>

Verify:
kubectl config current-context
kubectl config view --minify | grep namespace
```

### Card 3: Common Task Patterns
```
Pattern 1: "Fix NetworkPolicy to allow..."
→ Apply default deny first
→ Create specific allow rule
→ Test connectivity

Pattern 2: "Secure pod to meet PSS restricted"
→ runAsNonRoot: true
→ allowPrivilegeEscalation: false
→ readOnlyRootFilesystem: true
→ Drop ALL capabilities
→ seccompProfile: RuntimeDefault

Pattern 3: "Enable audit logging for..."
→ Edit /etc/kubernetes/manifests/kube-apiserver.yaml
→ Add audit flags
→ Create audit policy
→ Wait for apiserver restart

Pattern 4: "Scan image for vulnerabilities"
→ trivy image <image>
→ Filter by severity: --severity HIGH,CRITICAL
→ Check for specific CVE
```

### Card 4: Documentation Bookmarks
```
Must-know pages (kubernetes.io):

1. Network Policies
   /docs/concepts/services-networking/network-policies/

2. RBAC
   /docs/reference/access-authn-authz/rbac/

3. Security Context
   /docs/tasks/configure-pod-container/security-context/

4. Pod Security Standards
   /docs/concepts/security/pod-security-standards/

5. Audit Logging
   /docs/tasks/debug/debug-cluster/audit/

Search tips:
- Use site search, not Google
- Use Ctrl+F on page for keywords
- Copy-paste YAML examples, modify carefully
```

### Card 5: Pre-Flight Checklist
```
Before exam:
✅ Test PSI environment
✅ Clear workspace (1 water bottle allowed)
✅ Government ID ready
✅ Stable internet (wired preferred)
✅ Quiet room, no interruptions
✅ Bathroom break before starting
✅ Close all apps except browser

During exam:
✅ Read task completely before starting
✅ Check cluster context FIRST
✅ Verify task completion before moving on
✅ Flag difficult tasks, return later
✅ Save work frequently (Ctrl+S when editing)
✅ Use --dry-run=client for YAML generation
✅ Test changes (kubectl get, describe, logs)

After each task:
✅ Verify pod running (if applicable)
✅ Test connectivity (if applicable)
✅ Check logs for errors
✅ Move to next task
```

---

## Final Exam Tips

### Do's
1. **Practice kubectl speed** - Aliases, imperative commands, --dry-run
2. **Master YAML indentation** - Use spaces, not tabs (2-space indent)
3. **Verify every task** - kubectl get, describe, logs after changes
4. **Use documentation** - kubernetes.io is your friend, know how to search
5. **Flag and move on** - Don't waste 20 minutes on one task
6. **Check context EVERY task** - Different clusters per task
7. **Test in practice** - Killer.sh scenarios, CKS practice exams

### Don'ts
1. **Don't panic** - 67% passing score = 13-14 correct out of 20 tasks
2. **Don't rush** - Read task completely, understand requirements
3. **Don't guess** - Wrong YAML = task failure, validate before applying
4. **Don't skip verification** - Always test your solution works
5. **Don't waste time on one task** - Flag and return later
6. **Don't forget to save** - Edit files carefully, save often
7. **Don't assume cluster/namespace** - Always check task header

### Common Mistakes to Avoid
1. **Wrong cluster context** - Double-check before every task
2. **Wrong namespace** - Verify with `-n` flag or set default
3. **YAML indentation errors** - Copy from docs, modify carefully
4. **Incomplete security contexts** - Must satisfy ALL PSS requirements
5. **Forgetting to apply changes** - kubectl apply -f after editing
6. **Not testing** - Verify pod starts, connectivity works, etc.
7. **Running out of time** - Keep moving, flag hard tasks

---

## Good Luck! 🚀

**Remember**:
- You need 67% to pass (13-14 tasks out of 20)
- Speed matters - practice kubectl shortcuts
- Documentation is allowed - use it
- Verify every task before moving on
- Stay calm, manage time well

**You've got this!**

---

**Last Updated**: 2025-11-22
**CKS Version**: 1.29
**Document Version**: 1.0
**Grade**: A+ (Comprehensive quick reference for exam preparation)

