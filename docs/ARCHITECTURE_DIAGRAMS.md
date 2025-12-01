# Architecture Diagrams

Visual representations of key security architectures covered in the 27-month roadmap. Use these diagrams for:
- Understanding complex relationships
- Client presentations
- Documentation
- Study reference

---

## Table of Contents

1. [CyberArk PAM Architecture](#cyberark-pam-architecture)
2. [Conjur Secrets Management](#conjur-secrets-management)
3. [Kubernetes Security Architecture](#kubernetes-security-architecture)
4. [Multi-Cloud Security](#multi-cloud-security)
5. [CI/CD Security Pipeline](#cicd-security-pipeline)
6. [Certification Progression](#certification-progression)

---

## CyberArk PAM Architecture

### Core Components

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        CYBERARK PAM ARCHITECTURE                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│    ┌─────────────────────────────────────────────────────────────────────┐     │
│    │                         USERS / ADMINS                              │     │
│    └────────────────────────────────┬────────────────────────────────────┘     │
│                                     │                                          │
│                                     ▼                                          │
│    ┌─────────────────────────────────────────────────────────────────────┐     │
│    │                    PVWA (Password Vault Web Access)                 │     │
│    │    ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐      │     │
│    │    │   WEB     │  │   API     │  │   SAML    │  │   RADIUS  │      │     │
│    │    │  PORTAL   │  │  ACCESS   │  │   SSO     │  │   MFA     │      │     │
│    │    └───────────┘  └───────────┘  └───────────┘  └───────────┘      │     │
│    └────────────────────────────────┬────────────────────────────────────┘     │
│                                     │                                          │
│    ┌────────────────────────────────┼────────────────────────────────────┐     │
│    │                                │                                    │     │
│    ▼                                ▼                                    ▼     │
│  ┌──────────────┐        ┌──────────────────┐              ┌──────────────┐   │
│  │     CPM      │        │   DIGITAL VAULT  │              │     PSM      │   │
│  │   (Central   │        │   ┌──────────┐   │              │  (Privileged │   │
│  │    Policy    │◀──────▶│   │  SAFES   │   │◀────────────▶│   Session    │   │
│  │   Manager)   │        │   │ ┌──────┐ │   │              │   Manager)   │   │
│  │              │        │   │ │CREDS │ │   │              │              │   │
│  │ • Rotates    │        │   │ └──────┘ │   │              │ • Proxies    │   │
│  │   passwords  │        │   └──────────┘   │              │   sessions   │   │
│  │ • Verifies   │        │                  │              │ • Records    │   │
│  │   accounts   │        │ • Encrypted      │              │   activity   │   │
│  │ • Reconciles │        │ • HA available   │              │ • Isolates   │   │
│  └──────┬───────┘        │ • Audit logs     │              │   endpoints  │   │
│         │                └────────┬─────────┘              └──────┬───────┘   │
│         │                         │                               │           │
│         ▼                         ▼                               ▼           │
│  ┌────────────────────────────────────────────────────────────────────────┐   │
│  │                         TARGET SYSTEMS                                 │   │
│  │   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐    │   │
│  │   │ Windows │  │  Linux  │  │   AWS   │  │  Azure  │  │   DB    │    │   │
│  │   │ Servers │  │ Servers │  │ Console │  │  Portal │  │ Servers │    │   │
│  │   └─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘    │   │
│  └────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### PAM Data Flow

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        PAM ACCESS FLOW                                          │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   USER                                                                          │
│    │                                                                            │
│    │ 1. Login Request                                                           │
│    ▼                                                                            │
│   ┌────────────┐   2. MFA Challenge   ┌────────────┐                           │
│   │    PVWA    │◀────────────────────▶│    MFA     │                           │
│   └─────┬──────┘                      │  Provider  │                           │
│         │                             └────────────┘                           │
│         │ 3. Authenticated                                                      │
│         ▼                                                                       │
│   ┌────────────┐   4. Check Access    ┌────────────┐                           │
│   │   VAULT    │◀────────────────────▶│  AD/LDAP   │                           │
│   │ (Policies) │                      │  (Groups)  │                           │
│   └─────┬──────┘                      └────────────┘                           │
│         │                                                                       │
│         │ 5. Access Granted                                                     │
│         ▼                                                                       │
│   ┌────────────┐   6. Retrieve Cred   ┌────────────┐                           │
│   │    PSM     │◀────────────────────▶│   SAFE     │                           │
│   │  (Proxy)   │                      │ (Encrypted)│                           │
│   └─────┬──────┘                      └────────────┘                           │
│         │                                                                       │
│         │ 7. Isolated Session (Recorded)                                        │
│         ▼                                                                       │
│   ┌────────────┐                                                                │
│   │   TARGET   │                                                                │
│   │   SYSTEM   │                                                                │
│   └────────────┘                                                                │
│                                                                                 │
│   8. Session Recording → SIEM Integration → Audit & Compliance                  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Conjur Secrets Management

### Conjur in Kubernetes

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    CONJUR + KUBERNETES INTEGRATION                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │                    KUBERNETES CLUSTER                                   │  │
│   │                                                                         │  │
│   │    ┌─────────────────────────────────────────────────────────────┐     │  │
│   │    │  NAMESPACE: production                                       │     │  │
│   │    │                                                              │     │  │
│   │    │   ┌─────────────┐          ┌─────────────┐                  │     │  │
│   │    │   │  APP POD    │          │  SIDECAR    │                  │     │  │
│   │    │   │             │◀────────▶│  (Secrets   │                  │     │  │
│   │    │   │  [App]      │ Inject   │   Broker)   │                  │     │  │
│   │    │   │             │ Secrets  │             │                  │     │  │
│   │    │   └─────────────┘          └──────┬──────┘                  │     │  │
│   │    │                                   │                          │     │  │
│   │    └───────────────────────────────────┼──────────────────────────┘     │  │
│   │                                        │                                │  │
│   │   ┌───────────────────┐               │                                │  │
│   │   │  ServiceAccount   │               │                                │  │
│   │   │  + K8s Token      │───────────────┤                                │  │
│   │   └───────────────────┘               │                                │  │
│   │                                        │                                │  │
│   └────────────────────────────────────────┼────────────────────────────────┘  │
│                                            │                                   │
│                                            │ 1. Authenticate with K8s token    │
│                                            ▼                                   │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │                         CONJUR SERVER                                   │  │
│   │                                                                         │  │
│   │   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                │  │
│   │   │ KUBERNETES  │    │   POLICY    │    │   SECRETS   │                │  │
│   │   │AUTHENTICATOR│───▶│   ENGINE    │───▶│   STORE     │                │  │
│   │   │             │    │             │    │             │                │  │
│   │   │ Validates   │    │ Checks if   │    │ Returns     │                │  │
│   │   │ K8s SA      │    │ host can    │    │ secret      │                │  │
│   │   │ token       │    │ access      │    │ value       │                │  │
│   │   └─────────────┘    └─────────────┘    └─────────────┘                │  │
│   │                                                                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│   SECRET INJECTION METHODS:                                                     │
│   ├── Sidecar Container (Secrets Broker)                                       │
│   ├── Init Container (one-time fetch)                                          │
│   ├── Secretless Broker (proxy mode)                                           │
│   └── Push-to-File (volume mount)                                              │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Conjur Multi-Cloud Architecture

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    CONJUR MULTI-CLOUD SECRETS                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│                         ┌──────────────────────┐                               │
│                         │    CONJUR LEADER     │                               │
│                         │    (Primary Node)    │                               │
│                         │                      │                               │
│                         │  ┌────────────────┐  │                               │
│                         │  │   POLICIES     │  │                               │
│                         │  │   (Policy as   │  │                               │
│                         │  │   Code - YAML) │  │                               │
│                         │  └────────────────┘  │                               │
│                         │                      │                               │
│                         │  ┌────────────────┐  │                               │
│                         │  │   SECRETS      │  │                               │
│                         │  │   (Encrypted)  │  │                               │
│                         │  └────────────────┘  │                               │
│                         └──────────┬───────────┘                               │
│                                    │                                            │
│              ┌─────────────────────┼─────────────────────┐                     │
│              │                     │                     │                     │
│              ▼                     ▼                     ▼                     │
│   ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐            │
│   │       AWS        │  │      AZURE       │  │       GCP        │            │
│   │                  │  │                  │  │                  │            │
│   │  ┌────────────┐  │  │  ┌────────────┐  │  │  ┌────────────┐  │            │
│   │  │    EKS     │  │  │  │    AKS     │  │  │  │    GKE     │  │            │
│   │  │  Cluster   │  │  │  │  Cluster   │  │  │  │  Cluster   │  │            │
│   │  └─────┬──────┘  │  │  └─────┬──────┘  │  │  └─────┬──────┘  │            │
│   │        │         │  │        │         │  │        │         │            │
│   │  ┌─────▼──────┐  │  │  ┌─────▼──────┐  │  │  ┌─────▼──────┐  │            │
│   │  │   Conjur   │  │  │  │   Conjur   │  │  │  │   Conjur   │  │            │
│   │  │  Follower  │  │  │  │  Follower  │  │  │  │  Follower  │  │            │
│   │  │(Read-only) │  │  │  │(Read-only) │  │  │  │(Read-only) │  │            │
│   │  └────────────┘  │  │  └────────────┘  │  │  └────────────┘  │            │
│   │                  │  │                  │  │                  │            │
│   │  Authenticator:  │  │  Authenticator:  │  │  Authenticator:  │            │
│   │  • IAM Roles     │  │  • Managed ID    │  │  • Workload ID   │            │
│   │  • EKS IRSA      │  │  • AKS Pod ID    │  │  • GKE Workload  │            │
│   └──────────────────┘  └──────────────────┘  └──────────────────┘            │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Kubernetes Security Architecture

### Defense in Depth

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                KUBERNETES SECURITY - DEFENSE IN DEPTH                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   LAYER 1: CLUSTER INFRASTRUCTURE                                               │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │  • Hardened OS images        • Node network isolation                   │  │
│   │  • CIS benchmark compliance  • Encrypted etcd                           │  │
│   │  • Minimal node access       • Regular patching                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                     │                                          │
│                                     ▼                                          │
│   LAYER 2: CLUSTER ACCESS                                                       │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │  • API Server authentication (certs, OIDC)                              │  │
│   │  • RBAC authorization (least privilege)                                 │  │
│   │  • Admission controllers (OPA/Gatekeeper, Kyverno)                      │  │
│   │  • Audit logging enabled                                                │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                     │                                          │
│                                     ▼                                          │
│   LAYER 3: NAMESPACE ISOLATION                                                  │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │  • Resource quotas            • Network policies (default deny)         │  │
│   │  • LimitRanges                • Separate SA per namespace               │  │
│   │  • RBAC per namespace         • PSA labels (restricted)                 │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                     │                                          │
│                                     ▼                                          │
│   LAYER 4: WORKLOAD SECURITY                                                    │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │  • Pod Security Standards     • Seccomp profiles                        │  │
│   │  • Security contexts          • AppArmor/SELinux                        │  │
│   │  • Read-only root filesystem  • Non-root execution                      │  │
│   │  • Dropped capabilities       • Resource limits                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                     │                                          │
│                                     ▼                                          │
│   LAYER 5: CONTAINER SECURITY                                                   │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │  • Image scanning (Trivy)     • Signed images (Cosign)                  │  │
│   │  • Minimal base images        • No latest tags                          │  │
│   │  • Private registries         • Image pull secrets                      │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                     │                                          │
│                                     ▼                                          │
│   LAYER 6: RUNTIME SECURITY                                                     │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │  • Runtime monitoring (Falco) • Behavioral analysis                     │  │
│   │  • Syscall filtering          • Process monitoring                      │  │
│   │  • File integrity             • Network anomaly detection               │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                     │                                          │
│                                     ▼                                          │
│   LAYER 7: DATA SECURITY                                                        │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │  • Secrets encryption (KMS)   • External secrets (Conjur/Vault)         │  │
│   │  • mTLS (service mesh)        • Data classification                     │  │
│   │  • Backup encryption          • Key rotation                            │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### RBAC Model

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    KUBERNETES RBAC MODEL                                        │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   ┌─────────────┐                           ┌─────────────┐                    │
│   │   USER      │                           │   SERVICE   │                    │
│   │  (Human)    │                           │   ACCOUNT   │                    │
│   └──────┬──────┘                           └──────┬──────┘                    │
│          │                                         │                           │
│          │         ┌────────────────────┐          │                           │
│          └────────▶│   ROLEBINDING /    │◀─────────┘                           │
│                    │CLUSTERROLEBINDING  │                                      │
│                    └─────────┬──────────┘                                      │
│                              │                                                 │
│                              │ binds subject to role                           │
│                              ▼                                                 │
│                    ┌────────────────────┐                                      │
│                    │   ROLE / CLUSTER   │                                      │
│                    │       ROLE         │                                      │
│                    └─────────┬──────────┘                                      │
│                              │                                                 │
│                              │ defines permissions                             │
│                              ▼                                                 │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │                         RULES                                           │  │
│   │                                                                         │  │
│   │   apiGroups: [""]           resources: ["pods"]                         │  │
│   │   verbs: ["get", "list", "watch"]                                       │  │
│   │                                                                         │  │
│   │   apiGroups: ["apps"]       resources: ["deployments"]                  │  │
│   │   verbs: ["get", "list", "watch", "create", "update"]                   │  │
│   │                                                                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│   SCOPE:                                                                        │
│   ┌─────────────────────────────┐   ┌─────────────────────────────┐            │
│   │   Role + RoleBinding        │   │ ClusterRole + ClusterRole   │            │
│   │   (Namespace-scoped)        │   │   Binding (Cluster-wide)    │            │
│   └─────────────────────────────┘   └─────────────────────────────┘            │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Multi-Cloud Security

### Unified Security Architecture

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    MULTI-CLOUD SECURITY ARCHITECTURE                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │                    UNIFIED SECURITY LAYER                               │  │
│   │                                                                         │  │
│   │   ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐              │  │
│   │   │ CyberArk │  │  Conjur  │  │   SIEM   │  │  SOAR    │              │  │
│   │   │   PAM    │  │ Secrets  │  │ (Splunk/ │  │(Incident │              │  │
│   │   │          │  │          │  │ Sentinel)│  │Response) │              │  │
│   │   └──────────┘  └──────────┘  └──────────┘  └──────────┘              │  │
│   │                                                                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                     │                                          │
│        ┌────────────────────────────┼────────────────────────────┐             │
│        │                            │                            │             │
│        ▼                            ▼                            ▼             │
│   ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐        │
│   │       AWS        │    │      AZURE       │    │       GCP        │        │
│   ├──────────────────┤    ├──────────────────┤    ├──────────────────┤        │
│   │                  │    │                  │    │                  │        │
│   │ IDENTITY:        │    │ IDENTITY:        │    │ IDENTITY:        │        │
│   │ • IAM            │    │ • Entra ID       │    │ • Cloud IAM      │        │
│   │ • IAM Identity   │    │ • Managed ID     │    │ • Workload ID    │        │
│   │   Center         │    │ • PIM            │    │                  │        │
│   │                  │    │                  │    │                  │        │
│   │ NETWORK:         │    │ NETWORK:         │    │ NETWORK:         │        │
│   │ • VPC            │    │ • VNet           │    │ • VPC            │        │
│   │ • Security Groups│    │ • NSG            │    │ • Firewall Rules │        │
│   │ • PrivateLink    │    │ • Private Endpt  │    │ • Private Google │        │
│   │                  │    │                  │    │                  │        │
│   │ SECRETS:         │    │ SECRETS:         │    │ SECRETS:         │        │
│   │ • Secrets Mgr    │    │ • Key Vault      │    │ • Secret Mgr     │        │
│   │ • KMS            │    │ • CMK            │    │ • Cloud KMS      │        │
│   │                  │    │                  │    │                  │        │
│   │ MONITORING:      │    │ MONITORING:      │    │ MONITORING:      │        │
│   │ • CloudTrail     │    │ • Activity Log   │    │ • Cloud Audit    │        │
│   │ • GuardDuty      │    │ • Defender       │    │ • SCC            │        │
│   │ • Security Hub   │    │ • Sentinel       │    │ • Chronicle      │        │
│   │                  │    │                  │    │                  │        │
│   └──────────────────┘    └──────────────────┘    └──────────────────┘        │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## CI/CD Security Pipeline

### DevSecOps Pipeline

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    DEVSECOPS PIPELINE WITH CONJUR                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   DEVELOPER                                                                     │
│      │                                                                          │
│      │ 1. Code Commit                                                           │
│      ▼                                                                          │
│   ┌────────────┐                                                                │
│   │    GIT     │  ←── Pre-commit hooks (secrets scanning)                      │
│   │ Repository │                                                                │
│   └─────┬──────┘                                                                │
│         │                                                                       │
│         │ 2. Trigger Pipeline                                                   │
│         ▼                                                                       │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │                        CI/CD PIPELINE                                   │  │
│   │                                                                         │  │
│   │   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐              │  │
│   │   │  SAST   │──▶│  BUILD  │──▶│  IMAGE  │──▶│  DAST   │              │  │
│   │   │ (Code   │   │         │   │  SCAN   │   │ (Dynamic│              │  │
│   │   │ Analysis│   │         │   │ (Trivy) │   │  Test)  │              │  │
│   │   └─────────┘   └────┬────┘   └─────────┘   └─────────┘              │  │
│   │                      │                                                 │  │
│   │                      │ 3. Need credentials for build                   │  │
│   │                      ▼                                                 │  │
│   │               ┌────────────┐                                           │  │
│   │               │   CONJUR   │ ←── Pipeline identity authenticated      │  │
│   │               │  (Secrets) │                                           │  │
│   │               └────────────┘                                           │  │
│   │                      │                                                 │  │
│   │                      │ 4. Inject secrets (never exposed in logs)       │  │
│   │                      ▼                                                 │  │
│   │   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐              │  │
│   │   │ POLICY  │──▶│ DEPLOY  │──▶│ SMOKE   │──▶│PRODUCTION│             │  │
│   │   │  CHECK  │   │ STAGING │   │  TEST   │   │ DEPLOY  │              │  │
│   │   │(OPA/Kyv)│   │         │   │         │   │         │              │  │
│   │   └─────────┘   └─────────┘   └─────────┘   └─────────┘              │  │
│   │                                                                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│   SECURITY GATES:                                                               │
│   ✓ Pre-commit: Secrets scanning (GitLeaks, TruffleHog)                        │
│   ✓ SAST: Static code analysis (SonarQube, Checkmarx)                          │
│   ✓ Build: Dependency scanning (Snyk, OWASP Dependency-Check)                  │
│   ✓ Image: Container scanning (Trivy, Clair)                                   │
│   ✓ Policy: Kubernetes manifests (OPA, Kyverno)                                │
│   ✓ DAST: Dynamic testing (OWASP ZAP)                                          │
│   ✓ Deploy: Runtime protection (Falco)                                         │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Certification Progression

### 27-Month Certification Path

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    CERTIFICATION PROGRESSION                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   MONTH:  1    5    8    11   12   18   27                                     │
│           │    │    │    │    │    │    │                                      │
│           │    │    │    │    │    │    │                                      │
│   ┌───────▼────▼────▼────▼────┴────┴────▼───────────────────────────────────┐  │
│   │                                                                         │  │
│   │   PHASE 1: PAM + KUBERNETES                                            │  │
│   │   ═══════════════════════════                                          │  │
│   │                                                                         │  │
│   │   M5: ┌─────────────────┐                                              │  │
│   │       │    CYBERARK     │  Foundation level                            │  │
│   │       │    DEFENDER     │  PAM basics, Vault concepts                  │  │
│   │       └────────┬────────┘                                              │  │
│   │                │                                                        │  │
│   │                ▼                                                        │  │
│   │   M8: ┌─────────────────┐                                              │  │
│   │       │    CYBERARK     │  Advanced administration                     │  │
│   │       │     SENTRY      │  CPM, PSM, advanced config                   │  │
│   │       └────────┬────────┘                                              │  │
│   │                │                                                        │  │
│   │                ▼                                                        │  │
│   │   M11:┌─────────────────┐                                              │  │
│   │       │    CYBERARK     │  Expert level                                │  │
│   │       │    GUARDIAN     │  Architecture, HA/DR, enterprise            │  │
│   │       └─────────────────┘                                              │  │
│   │                                                                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │                                                                         │  │
│   │   PHASE 2: CONJUR + DEVSECOPS (M12-18)                                 │  │
│   │   ════════════════════════════════════                                 │  │
│   │                                                                         │  │
│   │   No formal certification - hands-on mastery:                          │  │
│   │   • Conjur deployment (Docker, K8s, multi-cloud)                       │  │
│   │   • Policy-as-Code                                                     │  │
│   │   • CI/CD integration                                                  │  │
│   │                                                                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │                                                                         │  │
│   │   PHASE 3: CLOUD SECURITY + CCSP (M19-27)                              │  │
│   │   ═══════════════════════════════════════                              │  │
│   │                                                                         │  │
│   │   M27:┌─────────────────┐                                              │  │
│   │       │      CCSP       │  Cloud security professional                 │  │
│   │       │   (ISC²)        │  6 domains, enterprise cloud                 │  │
│   │       └─────────────────┘                                              │  │
│   │                                                                         │  │
│   │   🚀 CONSULTING LAUNCH                                                 │  │
│   │                                                                         │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│   OPTIONAL (Post-Launch):                                                       │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐                                    │
│   │  CISSP   │  │ CYBERARK │  │   AWS/   │                                    │
│   │ (ISC²)   │  │ TRUSTEE  │  │  AZURE   │                                    │
│   │          │  │          │  │ Security │                                    │
│   └──────────┘  └──────────┘  └──────────┘                                    │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Related Documents

- **CyberArk Certifications**: [CYBERARK_CERTIFICATIONS.md](CYBERARK_CERTIFICATIONS.md)
- **CKS Certification**: [CKS_CERTIFICATION_GUIDE.md](CKS_CERTIFICATION_GUIDE.md)
- **CCSP Certification**: [CCSP_CERTIFICATION_GUIDE.md](CCSP_CERTIFICATION_GUIDE.md)
- **Zero Trust**: [ZERO_TRUST_ARCHITECTURE.md](ZERO_TRUST_ARCHITECTURE.md)
- **Hands-On Labs**: [HANDS_ON_LABS_PHASE1.md](HANDS_ON_LABS_PHASE1.md)

---

**Last Updated**: 2025-12-01
**Version**: 1.0
