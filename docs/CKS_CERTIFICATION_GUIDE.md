# CKS (Certified Kubernetes Security Specialist) Certification Guide

**The Ultimate A+ Guide to CKS Certification Preparation and Kubernetes Security Mastery**

---

## Table of Contents

- [Overview](#overview)
- [CKS vs Other Kubernetes Certifications](#cks-vs-other-kubernetes-certifications)
- [Prerequisites and Preparation](#prerequisites-and-preparation)
- [The Six CKS Domains](#the-six-cks-domains)
- [Study Timeline (Integrated with 27-Month Roadmap)](#study-timeline-integrated-with-27-month-roadmap)
- [Domain-by-Domain Study Guide](#domain-by-domain-study-guide)
- [Hands-On Labs and Practice](#hands-on-labs-and-practice)
- [Study Resources](#study-resources)
- [Exam Environment and Format](#exam-environment-and-format)
- [Exam Day Preparation](#exam-day-preparation)
- [Common Mistakes to Avoid](#common-mistakes-to-avoid)
- [Post-Exam Next Steps](#post-exam-next-steps)

---

## Overview

### What is CKS?

**CKS (Certified Kubernetes Security Specialist)** is a performance-based certification offered by the Cloud Native Computing Foundation (CNCF) and the Linux Foundation, focusing exclusively on Kubernetes security.

**Certification Authority**: CNCF (Cloud Native Computing Foundation) + Linux Foundation

**First Introduced**: November 2020

**Current Version**: CKS 1.29 (Updates regularly with Kubernetes versions)

### Why CKS?

**Value Proposition:**
- ✅ **Security-Focused**: Only Kubernetes certification dedicated to security
- ✅ **Hands-On**: 100% practical exam (no multiple choice)
- ✅ **Industry Recognition**: CNCF certifications highly respected
- ✅ **Career Advancement**: Average 20-30% salary increase
- ✅ **Consulting Credibility**: Essential for Kubernetes security consultants
- ✅ **Complements PAM/Conjur**: Perfect fit for secrets management in K8s

**CKS Holders Worldwide (2025)**: ~15,000+ professionals

**Average Salary Impact:**
- Without CKS: $95,000-120,000
- With CKS: $120,000-150,000
- **With CKS + CKA + CKAD**: $130,000-170,000
- **Consultant Rates**: $200-400/hour (CKS adds $50-100/hour premium)

### CKS in the 27-Month Roadmap

**Recommended Timeline**: **Month 9-10** (after 8-9 months K8s practice)

**Why Month 9-10?**
- ✅ You have 8-9 months continuous K8s hands-on experience (M1-9)
- ✅ CKA prerequisite already met (5+ years sysadmin experience + extensive K8s practice)
- ✅ Between Guardian (M11) and Conjur intensive (M12-18)
- ✅ Complements PAM security expertise
- ✅ Prepares for Conjur K8s integration (M14-15)

**Integration Benefits:**
- Kubernetes security + PAM expertise = powerful combination
- CKS knowledge applies directly to Conjur K8s deployment (Phase 2)
- Enhances portfolio projects (K8s security implementation)
- Strengthens consulting value proposition

---

## CKS vs Other Kubernetes Certifications

### CNCF/Linux Foundation Kubernetes Certification Path

```
CKA (Certified Kubernetes Administrator)
  ↓
CKAD (Certified Kubernetes Application Developer)
  ↓
CKS (Certified Kubernetes Security Specialist) ← YOU ARE HERE
```

### Certification Comparison Matrix

| Certification | Level | Focus | Prerequisite | Exam Duration | Pass Score | Best For |
|---------------|-------|-------|--------------|---------------|------------|----------|
| **CKA** | Associate | K8s Administration | None | 2 hours | 66% | Administrators, DevOps |
| **CKAD** | Associate | Application Development | None | 2 hours | 66% | Developers, DevOps |
| **CKS** | Expert | **Security** | **CKA required** | 2 hours | 67% | Security engineers, Consultants |

### CKS Prerequisites

**Hard Requirement:**
- ✅ **Valid CKA certification** (must be current, not expired)
  - If you don't have CKA: Need to pass CKA first
  - CKA validity: 3 years from passing
  - **27-Month Roadmap**: Your 5+ years sysadmin experience + 8-9 months K8s hands-on qualifies you for CKA

**Recommended Prerequisites:**
- ✅ 6+ months hands-on Kubernetes experience
- ✅ Strong Linux system administration skills
- ✅ Understanding of container security
- ✅ Familiarity with security concepts (encryption, RBAC, network policies)
- ✅ Command-line proficiency (kubectl, crictl, etc.)

**27-Month Roadmap Alignment:**
- ✅ By Month 9, you have 8-9 months K8s hands-on (exceeds 6-month requirement)
- ✅ 5+ years sysadmin experience (strong Linux skills)
- ✅ PAM security background (Defender M5, Sentry prep M6-8)
- ✅ Command-line proficient from PAM work

---

## The Six CKS Domains

### Domain Breakdown (CKS 1.29)

| Domain | Weight | Exam Tasks (~) | Study Hours |
|--------|--------|----------------|-------------|
| **Domain 1**: Cluster Setup | 10% | 2-3 tasks | 10-12 hours |
| **Domain 2**: Cluster Hardening | 15% | 3-4 tasks | 15-18 hours |
| **Domain 3**: System Hardening | 15% | 3-4 tasks | 15-18 hours |
| **Domain 4**: Minimize Microservice Vulnerabilities | 20% | 4-5 tasks | 20-25 hours |
| **Domain 5**: Supply Chain Security | 20% | 4-5 tasks | 20-25 hours |
| **Domain 6**: Monitoring, Logging, Runtime Security | 20% | 4-5 tasks | 20-25 hours |
| **TOTAL** | 100% | 20-25 tasks | **100-120 hours** |

---

### Domain 1: Cluster Setup (10%)

**Key Topics:**

1. **Network Policies**
   - Create and configure network policies
   - Deny all ingress/egress by default
   - Allow specific traffic flows
   - CNI plugin considerations (Calico, Cilium)

2. **CIS Benchmarks**
   - Run CIS benchmark scans (kube-bench)
   - Interpret scan results
   - Remediate common findings
   - Understand scoring and severity

3. **Ingress Security**
   - Configure TLS for Ingress
   - Certificate management
   - HTTPS enforcement

4. **Node Security**
   - Verify node endpoints protection
   - kubelet configuration security
   - API server secure access

**Must-Know Commands:**
```bash
# Network Policies
kubectl apply -f networkpolicy.yaml
kubectl get networkpolicies
kubectl describe networkpolicy <name>

# CIS Benchmark
kube-bench run --targets=master
kube-bench run --targets=node

# Ingress TLS
kubectl create secret tls <name> --cert=path/to/cert --key=path/to/key
kubectl apply -f ingress-tls.yaml
```

**Sample Task:**
```
Task: Create a NetworkPolicy in namespace 'production' that:
- Denies all ingress traffic by default
- Allows ingress on port 80 from pods labeled 'role=frontend'
- Allows egress to pods labeled 'role=database' on port 5432

Time: 5-8 minutes
```

**Solution Approach:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: production-netpol
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 80
  egress:
  - to:
    - podSelector:
        matchLabels:
          role: database
    ports:
    - protocol: TCP
      port: 5432
```

---

### Domain 2: Cluster Hardening (15%)

**Key Topics:**

1. **RBAC (Role-Based Access Control)**
   - Create Roles and RoleBindings
   - Create ClusterRoles and ClusterRoleBindings
   - ServiceAccount security
   - Least privilege principle
   - Audit RBAC permissions

2. **ServiceAccount Security**
   - Disable automountServiceAccountToken
   - Create dedicated ServiceAccounts
   - Token security and rotation

3. **Upgrade Kubernetes Components**
   - Safe upgrade procedures
   - Version compatibility
   - kubeadm upgrade process

4. **Protect API Server**
   - API server flags and security settings
   - Authentication and authorization
   - Admission controllers

**Must-Know Commands:**
```bash
# RBAC
kubectl create role <name> --verb=get,list --resource=pods
kubectl create rolebinding <name> --role=<role> --user=<user>
kubectl create clusterrole <name> --verb=* --resource=*
kubectl create clusterrolebinding <name> --clusterrole=<role> --user=<user>
kubectl auth can-i <verb> <resource> --as=<user>

# ServiceAccount
kubectl create serviceaccount <name>
kubectl get sa
kubectl describe sa <name>

# Upgrades
kubeadm upgrade plan
kubeadm upgrade apply v1.29.0
kubectl drain <node> --ignore-daemonsets
kubectl uncordon <node>
```

**Sample Task:**
```
Task: Create a Role in namespace 'app' that allows:
- get, list, watch on pods
- get, list on services
Bind this role to user 'developer'

Time: 5-7 minutes
```

**Solution Approach:**
```bash
# Create Role
kubectl create role app-reader \
  --verb=get,list,watch \
  --resource=pods \
  -n app

kubectl create role app-reader \
  --verb=get,list \
  --resource=services \
  -n app \
  --dry-run=client -o yaml | kubectl apply -f -

# OR combined YAML:
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-reader
  namespace: app
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list"]
EOF

# Create RoleBinding
kubectl create rolebinding app-reader-binding \
  --role=app-reader \
  --user=developer \
  -n app

# Verify
kubectl auth can-i get pods -n app --as=developer
```

---

### Domain 3: System Hardening (15%)

**Key Topics:**

1. **Minimize Host OS Footprint**
   - Reduce attack surface
   - Remove unnecessary packages
   - Disable unnecessary services
   - systemctl commands

2. **Minimize IAM Roles**
   - Least privilege for nodes
   - IAM instance profiles (AWS)
   - Managed identities (Azure)

3. **Kernel Hardening**
   - AppArmor profiles
   - Seccomp profiles
   - Apply security contexts to pods

4. **Restrict Network Access**
   - Firewall configuration (iptables, ufw)
   - Limit SSH access
   - Port restrictions

**Must-Know Commands:**
```bash
# AppArmor
aa-status
aa-enforce /path/to/profile
aa-complain /path/to/profile
apparmor_parser -r /etc/apparmor.d/profile

# Seccomp
# Applied via Pod securityContext

# systemctl
systemctl list-units --type=service
systemctl stop <service>
systemctl disable <service>

# iptables
iptables -L
iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
```

**Sample Task:**
```
Task: Apply AppArmor profile 'docker-default' to container 'nginx' in pod 'web-app'

Time: 3-5 minutes
```

**Solution Approach:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
  annotations:
    container.apparmor.security.beta.kubernetes.io/nginx: localhost/docker-default
spec:
  containers:
  - name: nginx
    image: nginx:1.21
```

---

### Domain 4: Minimize Microservice Vulnerabilities (20%)

**Key Topics:**

1. **Security Contexts**
   - runAsNonRoot
   - runAsUser
   - readOnlyRootFilesystem
   - capabilities (drop ALL, add specific)
   - privileged: false

2. **Pod Security Standards (PSS)**
   - Privileged, Baseline, Restricted
   - Pod Security Admission
   - Enforce, Audit, Warn modes

3. **Secrets Management**
   - Create and use Secrets
   - Mount Secrets as volumes or environment variables
   - Encrypt Secrets at rest
   - External secrets management (integration points for Conjur)

4. **Container Runtime Security**
   - Runtime sandboxing (gVisor, Kata Containers)
   - Container isolation
   - Use distroless/minimal images

**Must-Know Commands:**
```bash
# Secrets
kubectl create secret generic <name> --from-literal=key=value
kubectl create secret generic <name> --from-file=path/to/file
kubectl get secrets
kubectl describe secret <name>

# Security Context (via YAML)
kubectl run pod --image=nginx --dry-run=client -o yaml > pod.yaml
# Edit pod.yaml to add securityContext

# Pod Security Standards
kubectl label namespace <ns> pod-security.kubernetes.io/enforce=restricted
kubectl label namespace <ns> pod-security.kubernetes.io/audit=baseline
kubectl label namespace <ns> pod-security.kubernetes.io/warn=baseline
```

**Sample Task:**
```
Task: Create a Pod named 'secure-app' with:
- Image: nginx:1.21
- Run as user 1000
- Run as non-root
- Read-only root filesystem
- Drop ALL capabilities

Time: 5-7 minutes
```

**Solution Approach:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
  containers:
  - name: nginx
    image: nginx:1.21
    securityContext:
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
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

### Domain 5: Supply Chain Security (20%)

**Key Topics:**

1. **Image Security**
   - Minimize base images (distroless, Alpine)
   - Image vulnerability scanning (Trivy, Clair)
   - Image signing and verification
   - Private registries

2. **Admission Controllers**
   - ImagePolicyWebhook
   - AlwaysPullImages
   - PodSecurityPolicy (deprecated, replaced by PSS)
   - Validating and Mutating webhooks

3. **Container Image Scanning**
   - Use Trivy to scan images
   - Interpret CVE results
   - Fix vulnerabilities

4. **Static Analysis**
   - kubesec for manifest security scoring
   - YAML linting
   - Misconfigurations detection

**Must-Know Commands:**
```bash
# Trivy (image scanning)
trivy image nginx:1.21
trivy image --severity HIGH,CRITICAL nginx:1.21
trivy image --ignore-unfixed nginx:1.21

# kubesec (static analysis)
kubesec scan pod.yaml
docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < pod.yaml

# kubectl
kubectl run test --image=nginx:1.21 --dry-run=client -o yaml | kubesec scan /dev/stdin
```

**Sample Task:**
```
Task: Scan image 'nginx:1.21' for vulnerabilities using Trivy.
      Identify all HIGH and CRITICAL vulnerabilities.
      Output results to file 'scan-results.txt'

Time: 3-5 minutes
```

**Solution Approach:**
```bash
# Install Trivy (if not already installed)
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy

# Scan image
trivy image --severity HIGH,CRITICAL nginx:1.21 > scan-results.txt

# View results
cat scan-results.txt
```

---

### Domain 6: Monitoring, Logging, Runtime Security (20%)

**Key Topics:**

1. **Behavioral Analytics**
   - Falco for runtime security
   - Detect anomalous behavior
   - Custom Falco rules
   - Alerts and responses

2. **Audit Logging**
   - Enable audit logging
   - Audit policy configuration
   - Log analysis
   - Audit log locations

3. **Immutability**
   - Immutable infrastructure
   - Read-only root filesystems
   - ConfigMaps and Secrets (not writable)

4. **Container Runtime Monitoring**
   - crictl commands
   - Container inspection
   - Runtime security events

**Must-Know Commands:**
```bash
# Falco
falco
journalctl -fu falco
cat /etc/falco/falco_rules.yaml
cat /etc/falco/falco_rules.local.yaml

# Audit logs
cat /var/log/kubernetes/audit/audit.log
cat /var/log/kube-apiserver/audit.log
grep -i "secret" /var/log/kubernetes/audit/audit.log

# crictl (container runtime)
crictl ps
crictl inspect <container-id>
crictl logs <container-id>
crictl exec <container-id> <command>
```

**Sample Task:**
```
Task: Configure Falco to detect when:
- A shell is opened in a container
- Alert to file '/var/log/falco-alerts.log'

Time: 5-8 minutes
```

**Solution Approach:**
```yaml
# /etc/falco/falco_rules.local.yaml
- rule: Shell Opened in Container
  desc: Detect shell opened in container
  condition: >
    container.id != host and proc.name in (bash, sh, zsh)
  output: >
    Shell opened in container (user=%user.name container_id=%container.id
    container_name=%container.name shell=%proc.name)
  priority: WARNING

# /etc/falco/falco.yaml
file_output:
  enabled: true
  filename: /var/log/falco-alerts.log

# Restart Falco
systemctl restart falco
```

---

## Study Timeline (Integrated with 27-Month Roadmap)

### CKS Preparation Overview (Month 9-10)

**Total Study Time**: 8 weeks
**Weekly Commitment**: 10-12 hours/week (same as roadmap pace)
**Total Hours**: ~100-120 hours

**Timing Rationale:**
- **Month 9**: You have 8 months K8s hands-on experience (M1-8)
- **Post-Guardian prep**: Guardian exam prep focused (M6-8), but CKS doesn't conflict
- **Pre-Conjur intensive**: Before heavy Conjur focus (M12-18)
- **Optimal**: Solidifies K8s security before applying to Conjur K8s (M14-15)

### Month 9: CKS Preparation Weeks 1-4 (Weeks 33-36)

**Week 33** (First CKS Week):
- **Study** (6 hrs): Domain 1 (Cluster Setup) + Domain 2 (Cluster Hardening)
  - Network Policies deep dive
  - RBAC fundamentals and advanced
  - CIS benchmarks introduction
- **Labs** (4 hrs): Setup CKS practice environment
  - Install Kubernetes cluster (kubeadm or kind)
  - Install kube-bench, Trivy, Falco
  - Practice basic network policies
- **Portfolio**: Continue K8s pattern review (background activity)
- **Total**: 10 hrs

**Week 34** (CKS Intensive):
- **Study** (6 hrs): Domain 3 (System Hardening)
  - AppArmor profiles
  - Seccomp profiles
  - Host OS hardening
  - Kernel security
- **Labs** (4 hrs): System hardening practice
  - Apply AppArmor to pods
  - Create custom Seccomp profiles
  - Harden systemctl services
  - iptables practice
- **Practice**: 10-15 hands-on tasks (Domains 1-3)
- **Total**: 10 hrs

**Week 35** (CKS Intensive):
- **Study** (6 hrs): Domain 4 (Minimize Microservice Vulnerabilities)
  - Security contexts deep dive
  - Pod Security Standards (PSS)
  - Secrets management
  - Container runtime security
- **Labs** (4 hrs): Microservice security practice
  - Create pods with restrictive security contexts
  - Implement Pod Security Standards
  - Secrets creation and mounting
  - Practice with distroless images
- **Practice**: 15-20 hands-on tasks (Domains 1-4)
- **Total**: 10 hrs

**Week 36** (CKS Intensive):
- **Study** (6 hrs): Domain 5 (Supply Chain Security) + Domain 6 (Monitoring)
  - Trivy image scanning
  - Admission controllers
  - Falco runtime security
  - Audit logging
- **Labs** (4 hrs): Supply chain and monitoring practice
  - Scan images with Trivy
  - Configure Falco rules
  - Review audit logs
  - Practice with kubesec
- **Practice**: Full domain coverage (20+ tasks)
- **Total**: 10 hrs

**Week 36 Checkpoint:**
- ✅ All 6 domains studied
- ✅ CKS practice environment fully configured
- ✅ 40-50 hands-on tasks completed
- ✅ Ready for Week 37-40 intensive practice

---

### Month 10: CKS Exam Prep Weeks 5-8 (Weeks 37-40)

**Week 37** (Practice Intensive):
- **Study** (3 hrs): Review weak domains
  - Focus on lowest-scoring practice areas
  - Review exam tips and strategies
- **Labs** (7 hrs): Full practice exams
  - Killer.sh practice exam #1 (2 hrs timed)
  - Review and understand all solutions (3 hrs)
  - Redo failed tasks (2 hrs)
- **Target Score**: 60%+ on first attempt
- **Total**: 10 hrs

**Week 38** (Practice Intensive):
- **Study** (3 hrs): Domain deep dives on weak areas
  - Personalized based on Week 37 results
  - Common weak areas: Falco rules, Seccomp, complex RBAC
- **Labs** (7 hrs): Targeted practice
  - 30-40 hands-on tasks from weak domains
  - Killer.sh practice scenarios
  - Time-boxed tasks (simulate exam pressure)
- **Total**: 10 hrs

**Week 39** (Final Prep):
- **Study** (3 hrs): Exam strategies and final review
  - Time management strategies
  - kubectl shortcuts and aliases
  - Kubernetes documentation navigation
  - Final review of all 6 domains
- **Labs** (7 hrs): Killer.sh practice exam #2
  - Full 2-hour timed exam (2 hrs)
  - Review all solutions thoroughly (3 hrs)
  - Redo all tasks for speed (2 hrs)
- **Target Score**: 75%+ (ready for exam)
- **Total**: 10 hrs

**Week 40** (EXAM WEEK):
- **Monday-Wednesday** (6 hrs total): Light review
  - Review domain cheat sheets
  - Practice kubectl speed commands
  - Review common pitfalls
  - NO new material
- **Thursday** (2 hrs): Rest and mental preparation
  - Light review only (1 hr)
  - Exam environment check (PSI Bridge)
  - Rest and relax
- **Friday or Saturday**: **CKS EXAM DAY**
  - 2-hour performance-based exam
  - 15-20 tasks
  - Passing score: 67%
  - **PASS** ✅
- **Weekend**: Celebrate and document learnings
- **Total**: 8 hrs + exam

**Week 40 Checkpoint:**
- ✅ CKS certification achieved
- ✅ 8 weeks intensive K8s security study
- ✅ 100+ hours hands-on practice
- ✅ Ready to apply to Conjur K8s (M14-15)

---

### Integration with Roadmap Phases

**Month 9 Activities (Parallel):**
```
CKS Preparation (Primary Focus):
  - Weeks 33-36: Study all 6 domains
  - 40 hrs total (10 hrs/week)

Roadmap Activities (Background):
  - K8s patterns review (3 hrs/week)
  - Capstone planning (1 hr/week)
  - Consulting proposal template development (2 hrs/week)

Total: 10-12 hrs/week (sustainable pace maintained)
```

**Month 10 Activities (Parallel):**
```
CKS Exam Prep (Primary Focus):
  - Weeks 37-40: Practice and exam
  - 40 hrs total (10 hrs/week)

Roadmap Activities (Light):
  - PAM + Conjur foundation reading (2 hrs/week)
  - Portfolio project 4 preparation (1 hr/week)

Total: 10-12 hrs/week
```

**Post-CKS (Month 11+):**
```
CKS knowledge applied to:
  - Month 11: Guardian prep + K8s security consolidation
  - Month 14-15: Conjur K8s deployment (use CKS security practices)
  - Month 19-26: Cloud K8s security (EKS, AKS, GKE)
  - Portfolio projects: Enhanced with K8s security implementations
```

---

## Domain-by-Domain Study Guide

### Domain 1: Cluster Setup (10%) - Study Guide

#### Network Policies

**Concepts to Master:**
```
1. Default Deny Policies
   - Deny all ingress
   - Deny all egress
   - Always start with default deny

2. Label Selectors
   - podSelector
   - namespaceSelector
   - Combined selectors

3. Port Specifications
   - protocol: TCP/UDP
   - port: container port
   - endPort: port range

4. Common Patterns
   - Allow from same namespace
   - Allow from specific namespace
   - Allow to external services
   - Allow DNS (port 53)
```

**Practice Tasks:**
```
Task 1: Deny all ingress in namespace 'production'
Task 2: Allow ingress from namespace 'monitoring' to port 9090
Task 3: Allow egress only to pods labeled 'db=postgres' on port 5432
Task 4: Allow DNS traffic (port 53 UDP) to kube-system
Task 5: Create network policy allowing ingress from specific IP block
```

**NetworkPolicy Templates:**

**Template 1: Deny All**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: <namespace>
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

**Template 2: Allow Specific Ingress**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-ingress
  namespace: <namespace>
spec:
  podSelector:
    matchLabels:
      app: <app-name>
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: <role>
    ports:
    - protocol: TCP
      port: <port>
```

**Template 3: Allow DNS**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: <namespace>
spec:
  podSelector: {}
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
```

#### CIS Benchmarks

**kube-bench Commands:**
```bash
# Run on master
kube-bench run --targets=master

# Run on node
kube-bench run --targets=node

# Run specific check
kube-bench run --check=1.2.1

# Output JSON
kube-bench run --json > results.json

# Common remediations
# Edit /etc/kubernetes/manifests/kube-apiserver.yaml
# Edit /var/lib/kubelet/config.yaml
```

**Common Findings and Fixes:**
```
Finding: Anonymous auth enabled on kubelet
Fix: Set authentication.anonymous.enabled: false in kubelet config

Finding: API server insecure port enabled
Fix: Remove --insecure-port flag from kube-apiserver

Finding: Weak cipher suites
Fix: Add --tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256...

Finding: Audit logging not enabled
Fix: Configure --audit-log-path and --audit-policy-file
```

---

### Domain 2: Cluster Hardening (15%) - Study Guide

#### RBAC Deep Dive

**RBAC Components:**
```
Role → RoleBinding (namespace-scoped)
ClusterRole → ClusterRoleBinding (cluster-scoped)
ServiceAccount → Authentication identity

Permissions:
  - verbs: get, list, watch, create, update, patch, delete
  - resources: pods, services, deployments, secrets, etc.
  - apiGroups: "", apps, extensions, etc.
```

**Common RBAC Patterns:**

**Pattern 1: Read-Only Access**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: production
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: production
subjects:
- kind: User
  name: developer
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

**Pattern 2: ServiceAccount with Specific Permissions**
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
  namespace: production
automountServiceAccountToken: false
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-role
  namespace: production
rules:
- apiGroups: [""]
  resources: ["secrets"]
  resourceNames: ["app-secret"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-binding
  namespace: production
subjects:
- kind: ServiceAccount
  name: app-sa
  namespace: production
roleRef:
  kind: Role
  name: app-role
  apiGroup: rbac.authorization.k8s.io
```

**RBAC Testing Commands:**
```bash
# Test permissions
kubectl auth can-i get pods --as=developer
kubectl auth can-i create deployments --as=developer -n production
kubectl auth can-i '*' '*' --as=developer

# List permissions
kubectl get roles -n production
kubectl describe role <name> -n production
kubectl get rolebindings -n production
kubectl describe rolebinding <name> -n production

# ServiceAccount token
kubectl get sa app-sa -o yaml
kubectl describe sa app-sa
```

---

### Domain 3: System Hardening (15%) - Study Guide

#### AppArmor

**AppArmor Basics:**
```bash
# Check status
aa-status

# Load profile
apparmor_parser -r /etc/apparmor.d/profile-name

# Enforce mode
aa-enforce /etc/apparmor.d/profile-name

# Complain mode (logging only)
aa-complain /etc/apparmor.d/profile-name

# Disable profile
aa-disable /etc/apparmor.d/profile-name
ln -s /etc/apparmor.d/profile-name /etc/apparmor.d/disable/
```

**Apply AppArmor to Pod:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: apparmor-pod
  annotations:
    container.apparmor.security.beta.kubernetes.io/container-name: localhost/profile-name
spec:
  containers:
  - name: container-name
    image: nginx
```

**Common AppArmor Profiles:**
```
docker-default: Default Docker profile (restrictive)
unconfined: No restrictions
custom: Custom-defined profile
```

#### Seccomp

**Seccomp Profile Types:**
```
Unconfined: No restrictions (default)
RuntimeDefault: Container runtime default profile
Localhost: Custom profile from node
```

**Apply Seccomp to Pod:**
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
  - name: nginx
    image: nginx
```

**Custom Seccomp Profile:**
```json
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": ["SCMP_ARCH_X86_64"],
  "syscalls": [
    {
      "names": ["read", "write", "open", "close"],
      "action": "SCMP_ACT_ALLOW"
    }
  ]
}
```

---

### Domain 4: Minimize Microservice Vulnerabilities (20%) - Study Guide

#### Security Context Best Practices

**Pod-Level Security Context:**
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
    volumeMounts:
    - name: tmp
      mountPath: /tmp
  volumes:
  - name: tmp
    emptyDir: {}
```

**Security Context Checklist:**
```
Pod Level:
□ runAsNonRoot: true
□ runAsUser: <non-zero UID>
□ fsGroup: <GID>
□ seccompProfile: RuntimeDefault

Container Level:
□ allowPrivilegeEscalation: false
□ readOnlyRootFilesystem: true
□ capabilities.drop: [ALL]
□ privileged: false (default, but verify)
□ runAsNonRoot: true (redundant but explicit)

Volumes (if readOnlyRootFilesystem: true):
□ Mount emptyDir for /tmp, /var/run, etc.
```

#### Pod Security Standards (PSS)

**Three Levels:**
```
1. Privileged: Unrestricted (default)
2. Baseline: Minimally restrictive
3. Restricted: Heavily restricted (best practice)
```

**Apply PSS to Namespace:**
```bash
# Enforce restricted
kubectl label namespace production \
  pod-security.kubernetes.io/enforce=restricted

# Audit baseline
kubectl label namespace production \
  pod-security.kubernetes.io/audit=baseline

# Warn on privileged
kubectl label namespace production \
  pod-security.kubernetes.io/warn=privileged

# Specify version
kubectl label namespace production \
  pod-security.kubernetes.io/enforce-version=v1.29
```

**PSS Requirements for Each Level:**

**Baseline Restrictions:**
```
- Host namespaces: forbidden (hostNetwork, hostPID, hostIPC)
- Privileged containers: forbidden
- Capabilities: Only safe capabilities allowed
- HostPath volumes: forbidden
- Host ports: forbidden
- AppArmor: Must not be unconfined
- SELinux: Restricted types
- /proc mount mask: Required
```

**Restricted Restrictions (Baseline +):**
```
- Volume types: Only emptyDir, configMap, secret, downwardAPI, etc.
- Privilege escalation: allowPrivilegeEscalation: false
- runAsNonRoot: true
- Seccomp: RuntimeDefault or Localhost
- Capabilities: Must drop ALL
```

---

### Domain 5: Supply Chain Security (20%) - Study Guide

#### Image Scanning with Trivy

**Trivy Commands:**
```bash
# Scan image
trivy image nginx:1.21

# Filter by severity
trivy image --severity HIGH,CRITICAL nginx:1.21

# Ignore unfixed vulnerabilities
trivy image --ignore-unfixed nginx:1.21

# Output formats
trivy image --format json nginx:1.21
trivy image --format table nginx:1.21

# Scan tarball
trivy image --input image.tar

# Scan filesystem
trivy fs /path/to/project

# Scan Kubernetes manifests
trivy config pod.yaml
```

**Interpreting Trivy Results:**
```
CVE-2021-XXXXX (CRITICAL)
  - Package: openssl
  - Installed Version: 1.1.1k
  - Fixed Version: 1.1.1l
  - Description: Buffer overflow vulnerability

Action:
  - Update base image to include fixed version
  - OR rebuild with newer base image
  - OR use distroless image (fewer packages = less attack surface)
```

#### Static Analysis with kubesec

**kubesec Commands:**
```bash
# Scan manifest
kubesec scan pod.yaml

# Scan from stdin
cat pod.yaml | kubesec scan /dev/stdin

# Docker (if kubesec not installed)
docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < pod.yaml

# Scan and filter
kubectl run test --image=nginx --dry-run=client -o yaml | \
  kubesec scan /dev/stdin
```

**kubesec Scoring:**
```
Score >= 0: PASS
Score < 0: FAIL

Positive Points:
  +1: readOnlyRootFilesystem: true
  +1: runAsNonRoot: true
  +1: capabilities.drop: [ALL]
  +3: securityContext.runAsUser > 10000

Negative Points:
  -7: privileged: true
  -1: capabilities.add
  -3: runAsUser: 0 (root)
```

---

### Domain 6: Monitoring, Logging, Runtime Security (20%) - Study Guide

#### Falco Runtime Security

**Falco Installation:**
```bash
# Install Falco
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | \
  tee -a /etc/apt/sources.list.d/falcosecurity.list
apt update
apt install falco

# Start Falco
systemctl start falco
systemctl enable falco

# Check status
systemctl status falco
journalctl -fu falco
```

**Falco Rules Structure:**
```yaml
- rule: Shell Spawned in Container
  desc: Detect shell spawned in container
  condition: >
    container.id != host and
    proc.name in (bash, sh, zsh) and
    spawned_process
  output: >
    Shell spawned in container (user=%user.name
    container_id=%container.id container_name=%container.name
    shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline)
  priority: WARNING
  tags: [shell, container]
```

**Common Falco Rules to Know:**
```
- Terminal shell in container
- File opened for writing in /etc
- Sensitive file read (e.g., /etc/shadow)
- Outbound connection to unexpected port
- Privileged container launched
- Package management process launched
```

**Custom Falco Rule Example:**
```yaml
# /etc/falco/falco_rules.local.yaml
- rule: Unauthorized Network Connection
  desc: Detect outbound connection to suspicious IP
  condition: >
    outbound and
    fd.sip = "192.168.1.100"
  output: >
    Unauthorized connection detected (user=%user.name
    connection=%fd.name container=%container.name)
  priority: CRITICAL
```

#### Audit Logging

**Enable Audit Logging:**
```yaml
# /etc/kubernetes/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  resources:
  - group: ""
    resources: ["secrets"]
- level: RequestResponse
  resources:
  - group: ""
    resources: ["pods"]
  namespaces: ["production"]
- level: Metadata
  omitStages:
  - RequestReceived
```

**kube-apiserver Configuration:**
```yaml
# /etc/kubernetes/manifests/kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - --audit-policy-file=/etc/kubernetes/audit-policy.yaml
    - --audit-log-path=/var/log/kubernetes/audit/audit.log
    - --audit-log-maxage=30
    - --audit-log-maxbackup=10
    - --audit-log-maxsize=100
    volumeMounts:
    - mountPath: /etc/kubernetes/audit-policy.yaml
      name: audit
      readOnly: true
    - mountPath: /var/log/kubernetes/audit
      name: audit-log
  volumes:
  - name: audit
    hostPath:
      path: /etc/kubernetes/audit-policy.yaml
      type: File
  - name: audit-log
    hostPath:
      path: /var/log/kubernetes/audit
      type: DirectoryOrCreate
```

**Analyze Audit Logs:**
```bash
# View audit log
cat /var/log/kubernetes/audit/audit.log

# Search for secret access
grep -i "secret" /var/log/kubernetes/audit/audit.log

# Filter by user
jq '.user.username' /var/log/kubernetes/audit/audit.log | sort | uniq

# Filter by namespace
jq 'select(.objectRef.namespace=="production")' /var/log/kubernetes/audit/audit.log

# Count by verb
jq '.verb' /var/log/kubernetes/audit/audit.log | sort | uniq -c
```

---

## Hands-On Labs and Practice

### Lab Environment Setup

**Option 1: kubeadm Cluster (Recommended for CKS)**
```bash
# Prerequisites
- 2-3 VMs (1 control plane, 1-2 workers)
- Ubuntu 20.04/22.04 or similar
- 2 CPU, 4 GB RAM minimum per node

# Install kubeadm
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Initialize cluster (control plane)
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Install CNI (Calico for NetworkPolicy support)
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Join worker nodes
sudo kubeadm join <control-plane-ip>:6443 --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash>
```

**Option 2: kind (Kubernetes in Docker)**
```bash
# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create cluster
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

# Install Calico for NetworkPolicy
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

**Install CKS Tools:**
```bash
# Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | \
  sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy

# kube-bench
wget https://github.com/aquasecurity/kube-bench/releases/download/v0.7.0/kube-bench_0.7.0_linux_amd64.tar.gz
tar -xvf kube-bench_0.7.0_linux_amd64.tar.gz
sudo mv kube-bench /usr/local/bin/

# Falco
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | sudo apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | \
  sudo tee -a /etc/apt/sources.list.d/falcosecurity.list
sudo apt update
sudo apt install falco

# kubesec
wget https://github.com/controlplaneio/kubesec/releases/download/v2.13.0/kubesec_linux_amd64.tar.gz
tar -xvf kubesec_linux_amd64.tar.gz
sudo mv kubesec /usr/local/bin/
```

### Practice Scenarios (20 Essential Tasks)

**Scenario 1: Network Policy (Domain 1)**
```
Create a NetworkPolicy in namespace 'webapp' that:
- Denies all ingress and egress by default
- Allows ingress from pods labeled 'tier=frontend' on port 8080
- Allows egress to pods labeled 'tier=database' on port 3306
- Allows DNS resolution (kube-system namespace, port 53 UDP)

Time: 8 minutes
```

**Scenario 2: RBAC (Domain 2)**
```
Create ServiceAccount 'deploy-sa' in namespace 'cicd'.
Create Role 'deployer' that allows: create, update, delete on deployments and services.
Bind the role to the ServiceAccount.
Verify the ServiceAccount can create deployments.

Time: 7 minutes
```

**Scenario 3: AppArmor (Domain 3)**
```
Create a Pod 'secure-nginx' using image nginx:1.21.
Apply AppArmor profile 'docker-default' to the container.
Verify the pod starts successfully.

Time: 5 minutes
```

**Scenario 4: Security Context (Domain 4)**
```
Create a Pod 'locked-down' with:
- runAsNonRoot: true
- runAsUser: 2000
- readOnlyRootFilesystem: true
- Drop ALL capabilities
- Mount emptyDir at /tmp

Time: 7 minutes
```

**Scenario 5: Pod Security Standards (Domain 4)**
```
Label namespace 'production' to:
- Enforce 'restricted' PSS level
- Audit 'baseline' level
- Warn on 'privileged' level

Time: 3 minutes
```

**Scenario 6: Image Scanning (Domain 5)**
```
Scan image 'nginx:1.19' for vulnerabilities using Trivy.
Identify all CRITICAL vulnerabilities.
Export results to 'nginx-scan.json' in JSON format.

Time: 5 minutes
```

**Scenario 7: Static Analysis (Domain 5)**
```
Use kubesec to analyze file 'pod.yaml'.
Identify security issues and calculate score.
Fix issues to achieve score >= 10.

Time: 10 minutes
```

**Scenario 8: Falco Rule (Domain 6)**
```
Create a Falco rule that detects:
- Any process writing to /etc directory in containers
- Priority: WARNING
- Output includes container name, process name, file path

Time: 10 minutes
```

**Scenario 9: Audit Logging (Domain 6)**
```
Enable audit logging for namespace 'sensitive'.
Log all RequestResponse level events for secrets.
Log Metadata level for all other resources.
Verify logs are written to /var/log/k8s-audit.log.

Time: 12 minutes
```

**Scenario 10: CIS Benchmark (Domain 1)**
```
Run kube-bench on the master node.
Identify 3 FAIL findings.
Remediate at least 2 findings.
Re-run kube-bench to verify fixes.

Time: 15 minutes
```

**Scenario 11: Secrets Management (Domain 4)**
```
Create a Secret 'db-creds' with keys 'username' and 'password'.
Create a Pod that mounts the secret as environment variables.
Verify the secret is encrypted at rest (etcd encryption).

Time: 8 minutes
```

**Scenario 12: Immutable Container (Domain 6)**
```
Create a Deployment 'immutable-app' where:
- Root filesystem is read-only
- All writable directories use emptyDir volumes
- Container runs as non-root user

Time: 10 minutes
```

**Scenario 13: Admission Controller (Domain 5)**
```
Configure ImagePolicyWebhook admission controller.
Create policy that only allows images from 'myregistry.io'.
Test by attempting to create pod with docker.io image (should fail).

Time: 15 minutes (complex)
```

**Scenario 14: Runtime Monitoring (Domain 6)**
```
Use crictl to:
- List all running containers
- Inspect container with name 'app'
- View logs for the container
- Verify container is using RuntimeDefault seccomp profile

Time: 6 minutes
```

**Scenario 15: System Hardening (Domain 3)**
```
On worker node:
- Disable unnecessary systemd services (telnet, ftp)
- Configure iptables to allow only SSH from 10.0.0.0/8
- Verify kubelet is running with --anonymous-auth=false

Time: 10 minutes
```

**Scenario 16: ServiceAccount Security (Domain 2)**
```
Create a Pod that:
- Uses a custom ServiceAccount 'app-sa'
- Does NOT automount the ServiceAccount token
- Manually mounts the token to /var/run/secrets/custom-location

Time: 8 minutes
```

**Scenario 17: Network Policy Advanced (Domain 1)**
```
Create a NetworkPolicy that:
- Allows ingress from namespace 'ingress' AND pods labeled 'app=nginx'
- Allows egress to external IP 8.8.8.8 on port 53 (DNS)
- Denies all other traffic

Time: 10 minutes
```

**Scenario 18: Seccomp Profile (Domain 3)**
```
Create a custom Seccomp profile that allows only:
- read, write, open, close, stat syscalls
Save to /var/lib/kubelet/seccomp/custom.json
Apply to a Pod 'restricted-app'

Time: 12 minutes
```

**Scenario 19: Upgrade Cluster (Domain 2)**
```
Upgrade kubeadm cluster from 1.28.0 to 1.29.0:
- Drain control plane node
- Upgrade kubeadm, kubelet, kubectl
- Apply upgrade with kubeadm
- Uncordon node
- Verify cluster version

Time: 15 minutes (provided cluster is running)
```

**Scenario 20: Multi-Domain Challenge (All Domains)**
```
Deploy a secure application:
1. Create namespace 'secure-app' with restricted PSS
2. Create NetworkPolicy: deny all, allow from 'ingress' namespace
3. Create Pod with:
   - Image scanned with Trivy (no CRITICAL CVEs)
   - Security context: runAsNonRoot, readOnlyRootFilesystem
   - AppArmor: docker-default
   - Seccomp: RuntimeDefault
4. Configure Falco to alert on shell in container
5. Verify audit logs capture pod creation

Time: 25 minutes
```

---

## Study Resources

### Official Resources (Free)

**Kubernetes Documentation:**
- https://kubernetes.io/docs/concepts/security/
- https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/
- https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- https://kubernetes.io/docs/concepts/services-networking/network-policies/

**CKS Curriculum:**
- https://github.com/cncf/curriculum/blob/master/CKS_Curriculum.pdf

**Important**: Bookmark frequently used sections for exam

### Practice Platforms

**Killer.sh (Included with Exam Registration):**
- 2 free practice exams (2 hours each)
- Most realistic exam simulation
- Harder than actual exam (good preparation)
- **Cost**: Included with CKS exam fee

**KodeKloud CKS Course:**
- Comprehensive video course
- Hands-on labs in browser
- Practice tests
- **Cost**: ~$15-30/month

**Linux Foundation CKS Course:**
- Official training
- Includes labs and practice
- **Cost**: ~$299 (often bundled with exam)

### Books and Guides

**Recommended Reading:**
```
1. "Kubernetes Security" - Liz Rice & Michael Hausenblas (Free O'Reilly)
2. "Hacking Kubernetes" - Andrew Martin & Michael Hausenblas
3. "Container Security" - Liz Rice
4. Linux Foundation CKS Study Guide (if purchased)
```

### Video Courses

**Free:**
- CNCF YouTube Channel (security webinars)
- Kubernetes Security Best Practices (various speakers)

**Paid:**
- KodeKloud CKS Course (~$30/month)
- A Cloud Guru CKS Course (~$40/month)
- Linux Foundation CKS Training (~$299)

### Tools to Install

**Required for Exam:**
```
kubectl (latest version)
vim or nano (text editor)
crictl (container runtime CLI)
```

**Required for Practice:**
```
kube-bench (CIS benchmarks)
Trivy (image scanning)
Falco (runtime security)
kubesec (static analysis)
AppArmor utilities
```

### Community Resources

**GitHub Repositories:**
- https://github.com/walidshaari/Certified-Kubernetes-Security-Specialist
- https://github.com/spurin/cks-crash-course
- https://github.com/ibrahimjelliti/CKSS-Certified-Kubernetes-Security-Specialist

**Slack/Discord:**
- Kubernetes Slack (#cks channel)
- CNCF Slack

---

## Exam Environment and Format

### Exam Details

**Format**: Performance-based (hands-on tasks in live Kubernetes clusters)
**Duration**: 2 hours
**Tasks**: 15-20 tasks
**Passing Score**: 67%
**Delivery**: Online proctored (PSI Bridge Secure Browser)
**Cost**: $395 USD (includes 1 free retake + 2 Killer.sh practice exams)

**Clusters Provided:**
- 4-8 Kubernetes clusters (different versions, configurations)
- Switch between clusters using `kubectl config use-context <context-name>`
- Each task specifies which cluster to use

### Exam Environment

**What You Have:**
- Terminal access to clusters via kubectl
- Root access to nodes via SSH
- One additional browser tab for Kubernetes documentation
- Notepad for scratch work
- Copy/paste enabled

**What You Can Use:**
- Kubernetes official documentation (https://kubernetes.io/docs)
- kubectl cheat sheet
- YAML manifests from documentation

**What You CANNOT Use:**
- Google search
- GitHub
- Stack Overflow
- Your own notes
- Multiple browser tabs (only 1 additional tab allowed)

### kubectl Essentials for Exam

**Speed Commands:**
```bash
# Aliases (set at exam start)
alias k=kubectl
alias kgp='kubectl get pods'
alias kgn='kubectl get nodes'
export do="--dry-run=client -o yaml"

# Generate YAML quickly
k run pod --image=nginx $do > pod.yaml
k create deploy nginx --image=nginx $do > deploy.yaml
k create sa mysa $do > sa.yaml
k create secret generic mysecret --from-literal=key=value $do > secret.yaml
k create role myrole --verb=get --resource=pods $do > role.yaml

# Imperative commands (faster than YAML)
k run pod --image=nginx --labels=app=web
k expose pod nginx --port=80
k scale deploy nginx --replicas=3
k set image deploy/nginx nginx=nginx:1.21
```

**Context Switching:**
```bash
# List contexts
kubectl config get-contexts

# Switch context
kubectl config use-context <cluster-name>

# Verify current context
kubectl config current-context

# IMPORTANT: Always verify you're in correct context before each task!
```

**vim Tips for Exam:**
```vim
" Set in ~/.vimrc before exam
set nu                  " Line numbers
set tabstop=2           " Tab width
set shiftwidth=2        " Indent width
set expandtab           " Spaces instead of tabs
set paste               " Paste mode (important for copying YAML)

" Useful commands during exam
:set paste              " Enable paste mode before pasting
:set nopaste            " Disable after pasting
:wq                     " Save and quit
:q!                     " Quit without saving
dd                      " Delete line
yy                      " Copy line
p                       " Paste
u                       " Undo
Ctrl+r                  " Redo
/search                 " Search
n                       " Next search result
```

### Time Management Strategy

**2 Hours = 120 Minutes**
**15-20 Tasks**
**Average: 6-8 minutes per task**

**Strategy:**
```
First Pass (60-70 minutes):
  - Do all tasks you know immediately
  - Skip complex/uncertain tasks
  - Flag difficult tasks
  - Aim to complete 70% of tasks

Second Pass (30-40 minutes):
  - Return to flagged tasks
  - Use documentation if needed
  - Attempt all remaining tasks
  - Don't leave anything unanswered

Final Pass (10-20 minutes):
  - Verify task requirements met
  - Check for typos in names/namespaces
  - Test solutions if time permits
  - Double-check context switches
```

**Task Difficulty Estimation:**
```
Easy (3-5 min):
  - Create NetworkPolicy from template
  - Create Role/RoleBinding
  - Run Trivy scan
  - Enable audit logging

Medium (6-10 min):
  - Create Pod with complex SecurityContext
  - Apply PSS to namespace
  - Create custom Falco rule
  - Remediate CIS benchmark findings

Hard (10-15 min):
  - Multi-step admission controller setup
  - Custom Seccomp profile creation
  - Complex RBAC scenario
  - Multi-requirement security challenge
```

---

## Exam Day Preparation

### One Week Before Exam

**Study Activities:**
```
□ Complete Killer.sh practice exam #2
□ Review all 6 domains (high-level)
□ Practice 20 essential tasks (listed earlier)
□ Review kubectl cheat sheet
□ Practice context switching
□ Focus on weak areas only
□ NO new topics after Wednesday
```

**Technical Preparation:**
```
□ Test PSI Bridge Secure Browser
  - Download from PSI website
  - Run compatibility check
  - Ensure webcam and microphone work
□ Clear workspace
  - Remove all papers, books, electronics
  - Only allowed: computer, mouse, keyboard, water
□ Prepare secondary device for proctor communication
  - Smartphone or tablet
  - PSI Bridge app installed
□ Test internet connection
  - Minimum 300 Kbps upload/download
  - Wired connection preferred
```

### Day Before Exam

**Study:**
```
□ Light review only (1-2 hours max)
□ Review domain cheat sheet
□ Practice kubectl aliases
□ Review common task patterns
□ NO practice exams (too stressful)
```

**Logistics:**
```
□ Verify exam appointment time (check timezone!)
□ Set 2 alarms for exam day
□ Prepare workspace
  - Clear desk completely
  - Good lighting on face
  - Quiet room (no interruptions)
□ Prepare ID
  - Government-issued photo ID required
  - Name must match exam registration
□ Plan for 3-hour block
  - 30 min check-in
  - 2 hours exam
  - 30 min buffer
□ Get 8 hours sleep
```

**Mental Preparation:**
```
□ Positive affirmations
□ Visualize success
□ Trust your preparation
□ Remember: You can retake once for free
□ Relax and rest
```

### Exam Day Morning

**2-3 Hours Before:**
```
□ Eat light breakfast (protein + complex carbs)
□ Hydrate well (but not excessively)
□ Use restroom
□ Coffee/tea (1 cup max, avoid jitters)
```

**1 Hour Before:**
```
□ Final workspace check
  - 360-degree clear space
  - Remove wall decorations if required
  - Close all applications except PSI Bridge
□ Close all browser tabs
□ Set phone to silent (but keep nearby for proctor)
□ Test webcam/mic one more time
□ Deep breathing exercises
```

**30 Minutes Before:**
```
□ Launch PSI Bridge Secure Browser
□ Begin check-in process
  - Upload photo of ID
  - Take selfie
  - Take photos of workspace (all 4 walls)
  - Wait for proctor to connect
□ Proctor will:
  - Verify ID
  - Inspect workspace via webcam
  - Confirm rules and regulations
  - Authorize exam start
□ Deep breath, stay calm
```

### During the Exam

**First 5 Minutes:**
```
□ Read all instructions carefully
□ Set up kubectl aliases:
  alias k=kubectl
  alias kgp='kubectl get pods'
  alias kgn='kubectl get nodes'
  export do="--dry-run=client -o yaml"
  export now="--grace-period=0 --force"

□ Test clipboard (copy/paste)
□ Open Kubernetes documentation tab
□ Bookmark frequently used pages:
  - NetworkPolicy
  - RBAC
  - Pod securityContext
  - Pod Security Standards
```

**Task Execution:**
```
□ Read task requirements TWICE
□ Note the context/cluster name
□ Switch to correct context: kubectl config use-context <name>
□ Verify context: kubectl config current-context
□ Execute task
□ Verify result
□ Move to next task
```

**Common Pitfalls to Avoid:**
```
❌ Wrong context/cluster
❌ Typo in namespace/name
❌ Forgetting to apply YAML (kubectl apply -f)
❌ Not verifying pod started successfully
❌ Spending too long on one task (move on, come back later)
```

**If You Get Stuck:**
```
1. Flag the task (note it down)
2. Move to next task
3. Return later with fresh perspective
4. Use documentation tab if needed
5. Make your best attempt (partial credit possible)
6. NEVER leave task unattempted
```

---

## Common Mistakes to Avoid

### Study Phase Mistakes

**Mistake #1: Skipping Hands-On Practice**
- ❌ **Problem**: Watching videos but not practicing
- ✅ **Solution**: 100+ hours hands-on labs required
  - Build your own cluster with kubeadm
  - Practice all 20 essential tasks
  - Complete Killer.sh exams multiple times

**Mistake #2: Not Practicing with Documentation**
- ❌ **Problem**: Memorizing commands without understanding
- ✅ **Solution**: Practice using K8s documentation during labs
  - Time yourself using docs
  - Learn to navigate quickly
  - Bookmark important pages

**Mistake #3: Ignoring Weak Domains**
- ❌ **Problem**: Focusing only on comfortable topics
- ✅ **Solution**: Track weak areas and practice more
  - Common weak: Falco rules, Seccomp, Admission controllers
  - Spend 2x time on weak domains

**Mistake #4: Not Taking Killer.sh Seriously**
- ❌ **Problem**: Rushing through Killer.sh, not reviewing
- ✅ **Solution**: Treat like real exam
  - Full 2 hours, no interruptions
  - Review EVERY solution
  - Redo until 80%+ score

**Mistake #5: Neglecting kubectl Speed**
- ❌ **Problem**: Slow with kubectl, typing full commands
- ✅ **Solution**: Practice imperative commands and aliases
  - Use `$do` for --dry-run=client -o yaml
  - Generate YAML, edit, apply (faster than writing from scratch)

### Exam Day Mistakes

**Mistake #6: Not Verifying Context**
- ❌ **Problem**: Working in wrong cluster
- ✅ **Solution**: ALWAYS verify context before each task
  ```bash
  kubectl config use-context <cluster-name>
  kubectl config current-context  # VERIFY
  ```

**Mistake #7: Typos in Names/Namespaces**
- ❌ **Problem**: Creating resources with wrong names
- ✅ **Solution**: Copy/paste names from task description
  - Use kubectl completion for tab-complete
  - Verify with `kubectl get` after creation

**Mistake #8: Not Testing Solutions**
- ❌ **Problem**: Moving to next task without verifying
- ✅ **Solution**: Always verify task is complete
  ```bash
  kubectl get pod <name> -n <namespace>  # Verify created
  kubectl describe pod <name>  # Check events
  kubectl logs <name>  # Verify running
  ```

**Mistake #9: Spending Too Long on One Task**
- ❌ **Problem**: 20 minutes on one complex task, panicking
- ✅ **Solution**: Time-box tasks
  - If stuck >10 minutes, flag and move on
  - Return later with fresh perspective
  - Aim for 70% completion first pass

**Mistake #10: Forgetting to Apply Changes**
- ❌ **Problem**: Editing YAML but not applying
- ✅ **Solution**: Always apply after editing
  ```bash
  vi pod.yaml
  kubectl apply -f pod.yaml  # DON'T FORGET THIS
  kubectl get pod  # VERIFY
  ```

**Mistake #11: Not Using Documentation**
- ❌ **Problem**: Trying to remember everything, struggling
- ✅ **Solution**: Use documentation tab strategically
  - Don't waste time guessing syntax
  - Quick lookup for templates
  - Copy/paste/modify faster than typing

**Mistake #12: Panic When Behind Schedule**
- ❌ **Problem**: Panicking at 1 hour mark with 10 tasks left
- ✅ **Solution**: Stay calm, work methodically
  - Easy tasks are quick points
  - Partial credit exists
  - 67% passing score, not 100%

---

## Post-Exam Next Steps

### Immediately After Exam

**Provisional Pass:**
```
□ You'll see results IMMEDIATELY on screen
  - "Congratulations, you passed!" = YOU PASSED!
  - Score will be shown (e.g., 78/100)
□ Take screenshot if allowed
□ Exit PSI Bridge browser
□ Official email arrives within 24-36 hours
```

**Provisional Fail (If Applicable):**
```
□ Don't panic - you get ONE free retake
□ Review score breakdown (which domains were weak)
□ Wait 24 hours, then schedule retake
□ Focus study on failed domains only
□ Retake within exam validity period (12 months)
```

### Certificate and Digital Badge

**Within 24-36 Hours:**
```
□ Check email from Linux Foundation
□ Subject: "Congratulations on passing CKS"
□ Certificate PDF attached
□ Digital badge link (Credly)
```

**Digital Badge Setup:**
```
□ Click Credly link in email
□ Create Credly account (if don't have one)
□ Accept CKS badge
□ Share on LinkedIn, Twitter, etc.
□ Add to email signature
```

### Update Professional Profiles

**LinkedIn:**
```
□ Add CKS to Licenses & Certifications section
  - Issuing Organization: The Linux Foundation
  - Issue Date: <exam date>
  - Expiration Date: <+3 years>
  - Credential ID: (from certificate)
  - Credential URL: (from Credly)

□ Update headline:
  "Kubernetes Security Specialist | CKS | PAM/Conjur Consultant"

□ Post announcement:
  "Excited to announce I've earned my Certified Kubernetes Security
   Specialist (CKS) certification from @CNCF and @LinuxFoundation!

   This validates my expertise in securing Kubernetes clusters, from
   cluster hardening to runtime security monitoring.

   Combined with my PAM/Conjur background, I can now deliver end-to-end
   security solutions for cloud-native environments."

□ Add Credly badge to profile picture/banner
```

**Resume/CV:**
```
□ Add to Certifications section:
  "Certified Kubernetes Security Specialist (CKS)
   The Linux Foundation & CNCF | <Month Year> - <Month Year +3>
   Credential ID: <ID>"

□ Update skills section:
  - Kubernetes Security
  - Network Policies
  - RBAC
  - Runtime Security (Falco)
  - Container Image Scanning
  - Supply Chain Security

□ Update summary:
  "Certified Kubernetes Security Specialist with expertise in
   securing cloud-native applications, PAM, and secrets management."
```

### Certification Maintenance

**Validity Period:**
- CKS certification valid for 3 years from pass date
- Must recertify before expiration

**Recertification Options:**
- **Option 1**: Retake CKS exam before expiration
- **Option 2**: Pass CKA + CKS again
- **Cost**: Same as initial exam (~$395)

**Plan Recertification:**
```
Year 1: Maintain skills through work/projects
Year 2: Stay current with K8s security trends
Year 3 (6 months before expiry): Begin recertification study
```

### Apply CKS Knowledge to 27-Month Roadmap

**Immediate Application (Month 11-18):**
```
Month 11:
  - Apply K8s security practices to capstone project
  - Harden K8s clusters used for PAM/Conjur labs
  - Document security configurations

Month 14-15 (Conjur K8s):
  - Deploy Conjur with CKS security best practices
  - NetworkPolicies for Conjur pods
  - RBAC for Conjur ServiceAccounts
  - Pod Security Standards (restricted)
  - Image scanning for Conjur containers

Month 19-27 (Cloud Security):
  - Apply CKS knowledge to EKS, AKS, GKE
  - Cloud-specific K8s security (IAM roles, managed policies)
  - Runtime security in cloud environments
```

**Portfolio Enhancement:**
```
□ Update existing K8s projects with security improvements
□ Create new "Kubernetes Security" portfolio project:
  - Demonstrate all CKS domains
  - Network Policies, RBAC, Security Contexts
  - Falco rules, Audit logging
  - Image scanning pipeline
  - Document architecture and security controls

□ Write LinkedIn article: "5 Essential K8s Security Practices"
□ Create case study: "Securing Production K8s Cluster"
```

### Consulting Value Proposition

**With CKS Certification:**
```
Before CKS:
  "PAM/Conjur Consultant with Kubernetes experience"
  Rate: $250-350/hour

After CKS:
  "PAM/Conjur + Kubernetes Security Specialist (CKS Certified)"
  Rate: $300-450/hour

CKS Premium: +$50-100/hour
```

**Updated Service Offerings:**
```
1. Kubernetes Security Assessment
   - CIS benchmark review
   - RBAC audit
   - Network policy review
   - Runtime security setup
   - Price: $8,000-15,000 (2-4 weeks)

2. Secure Conjur Deployment on Kubernetes
   - K8s cluster hardening
   - Conjur HA setup with security best practices
   - RBAC and NetworkPolicies
   - Integration with cloud IAM
   - Price: $20,000-40,000 (4-8 weeks)

3. Cloud-Native Security Architecture
   - Multi-cloud K8s security
   - PAM + Conjur + K8s integrated
   - Compliance frameworks (PCI-DSS, HIPAA)
   - Price: $30,000-60,000 (6-12 weeks)
```

---

## Success Metrics

### Weekly Progress Tracking

| Week | Domains | Practice Score | Status |
|------|---------|---------------|--------|
| 33 | Domains 1-2 | - | Study phase |
| 34 | Domain 3 | - | Study phase |
| 35 | Domain 4 | - | Study phase |
| 36 | Domains 5-6 | All domains complete | ✅ Ready for practice |
| 37 | All domains | Killer.sh #1: 60%+ | Practice phase |
| 38 | Weak areas | Custom labs: 70%+ | Improving |
| 39 | All domains | Killer.sh #2: 75%+ | **EXAM READY** |
| 40 | - | - | **EXAM WEEK** |

### Final Readiness Checklist

**Technical Readiness:**
```
□ All 6 CKS domains studied (100+ hours)
□ Practice environment setup complete
□ Killer.sh practice exam #1 completed (60%+)
□ Killer.sh practice exam #2 completed (75%+)
□ 20 essential tasks practiced multiple times
□ kubectl speed optimized (aliases, imperative commands)
□ Kubernetes documentation navigation practiced
□ Weak areas identified and improved
□ Context switching practiced
```

**Exam Logistics:**
```
□ PSI Bridge browser tested
□ Workspace prepared and clear
□ Internet connection tested (300 Kbps+)
□ Webcam and microphone tested
□ Government-issued photo ID ready
□ Exam appointment confirmed (check timezone!)
□ 3-hour time block reserved (no interruptions)
```

**Mental Readiness:**
```
□ Confident with all 6 domains
□ Practiced under time pressure
□ Calm and focused
□ Remember: 67% to pass, not 100%
□ One free retake available
□ Trust your preparation
```

---

**You're ready to pass the CKS exam and become a Certified Kubernetes Security Specialist! Combined with your PAM/Conjur expertise, you're unstoppable.** 🚀☸️🔒

**Last Updated**: 2025-12-01
**Version**: 1.0
**Aligned with**: CKS 1.29, Kubernetes 1.29
