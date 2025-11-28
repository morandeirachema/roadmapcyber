# CCSP Certification - Cheat Sheets & Quick Reference

Comprehensive quick reference guide for the Certified Cloud Security Professional (CCSP) exam. Print-friendly, exam-focused, and designed for rapid recall.

**Exam**: CCSP (Certified Cloud Security Professional)
**Provider**: (ISC)²
**Duration**: 4 hours
**Questions**: 150 questions (CAT format)
**Passing Score**: 700/1000 (~70%)
**Prerequisites**: 5 years experience (or 4 years + degree)

---

## Table of Contents

1. [CCSP Exam Quick Card](#ccsp-exam-quick-card)
2. [Domain 1: Cloud Concepts, Architecture, Design (17%)](#domain-1-cloud-concepts-architecture-design-17)
3. [Domain 2: Cloud Data Security (20%)](#domain-2-cloud-data-security-20)
4. [Domain 3: Cloud Platform & Infrastructure Security (17%)](#domain-3-cloud-platform--infrastructure-security-17)
5. [Domain 4: Cloud Application Security (17%)](#domain-4-cloud-application-security-17)
6. [Domain 5: Cloud Security Operations (17%)](#domain-5-cloud-security-operations-17)
7. [Domain 6: Legal, Risk, and Compliance (12%)](#domain-6-legal-risk-and-compliance-12)
8. [Shared Responsibility Model Quick Reference](#shared-responsibility-model-quick-reference)
9. [Compliance Framework Quick Reference](#compliance-framework-quick-reference)
10. [Encryption & Key Management Quick Reference](#encryption--key-management-quick-reference)
11. [Cloud Provider Comparison](#cloud-provider-comparison)
12. [Acronyms & Definitions](#acronyms--definitions)
13. [Exam Day Quick Cards](#exam-day-quick-cards)

---

## CCSP Exam Quick Card

### Exam Format
- **Type**: Computer Adaptive Testing (CAT)
- **Duration**: 4 hours (240 minutes)
- **Questions**: 150 questions
- **Passing Score**: 700/1000 (~70%)
- **Question Types**: Multiple choice, drag-and-drop
- **Testing Centers**: Pearson VUE (worldwide)

### Weight Distribution

| Domain | Weight | Questions (~) |
|--------|--------|---------------|
| Cloud Concepts, Architecture, Design | 17% | ~25 |
| Cloud Data Security | 20% | ~30 |
| Cloud Platform & Infrastructure | 17% | ~25 |
| Cloud Application Security | 17% | ~25 |
| Cloud Security Operations | 17% | ~25 |
| Legal, Risk, and Compliance | 12% | ~20 |

### Time Management
- **Average per question**: ~1.5 minutes
- **First pass**: Answer confidently, mark uncertain (90 min)
- **Second pass**: Review marked questions (60 min)
- **Third pass**: Final review of all answers (90 min)

### (ISC)² Exam Mindset
```
Think like a SECURITY MANAGER, not a technician:
- Security over convenience
- Compliance over cost savings
- Process over quick fixes
- Risk-based decisions over absolute security
- Governance before technology
```

### Critical Success Factors
1. **Understand shared responsibility** - Know who owns what in each service model
2. **Know compliance frameworks** - GDPR, HIPAA, PCI-DSS, SOC 2
3. **Data lifecycle mastery** - Security controls at every phase
4. **Multi-cloud thinking** - Vendor-neutral concepts
5. **Risk-based approach** - Not all security, all the time

---

## Domain 1: Cloud Concepts, Architecture, Design (17%)

### NIST Cloud Definition - 5 Essential Characteristics

```
┌─────────────────────────────────────────────────────────────┐
│                 5 ESSENTIAL CHARACTERISTICS                  │
├─────────────────────────────────────────────────────────────┤
│ 1. ON-DEMAND SELF-SERVICE                                   │
│    - Provision resources without human interaction          │
│    - Self-service portal, API, CLI                          │
├─────────────────────────────────────────────────────────────┤
│ 2. BROAD NETWORK ACCESS                                     │
│    - Available over the network                             │
│    - Standard mechanisms (HTTP, HTTPS, APIs)                │
├─────────────────────────────────────────────────────────────┤
│ 3. RESOURCE POOLING                                         │
│    - Multi-tenant model                                     │
│    - Resources dynamically assigned                         │
│    - Location independence                                  │
├─────────────────────────────────────────────────────────────┤
│ 4. RAPID ELASTICITY                                         │
│    - Scale up/down automatically                            │
│    - Appears unlimited to consumer                          │
├─────────────────────────────────────────────────────────────┤
│ 5. MEASURED SERVICE                                         │
│    - Pay-per-use model                                      │
│    - Metering, monitoring, reporting                        │
│    - Transparency for provider and consumer                 │
└─────────────────────────────────────────────────────────────┘
```

### Cloud Service Models

```
┌─────────────────────────────────────────────────────────────┐
│                      SERVICE MODELS                          │
├─────────────────────────────────────────────────────────────┤
│ SaaS (Software as a Service)                                │
│   Examples: Salesforce, Office 365, Gmail                   │
│   Customer manages: Data, access controls                   │
│   Provider manages: Everything else                         │
├─────────────────────────────────────────────────────────────┤
│ PaaS (Platform as a Service)                                │
│   Examples: Heroku, Azure App Service, Google App Engine    │
│   Customer manages: Apps, data, access controls             │
│   Provider manages: Runtime, middleware, OS, hardware       │
├─────────────────────────────────────────────────────────────┤
│ IaaS (Infrastructure as a Service)                          │
│   Examples: AWS EC2, Azure VMs, GCP Compute Engine          │
│   Customer manages: Apps, data, runtime, middleware, OS     │
│   Provider manages: Virtualization, servers, storage, net   │
└─────────────────────────────────────────────────────────────┘
```

### Cloud Deployment Models

| Model | Description | Use Case |
|-------|-------------|----------|
| **Public** | Shared infrastructure, multi-tenant | Cost-effective, scalable |
| **Private** | Dedicated to single organization | Compliance, control |
| **Hybrid** | Public + Private connected | Flexibility, burst capacity |
| **Community** | Shared by organizations with common concerns | Healthcare, government |

### Security Design Principles

```
□ Defense in Depth    - Multiple layers of security
□ Zero Trust          - Never trust, always verify
□ Least Privilege     - Minimum necessary access
□ Separation of Duties - No single person has all control
□ Security by Design  - Built-in, not bolted-on
□ Privacy by Design   - Data protection from the start
□ Fail Secure         - Default to secure state on failure
```

### Cryptography Quick Reference

| Type | Algorithm | Key Size | Use Case |
|------|-----------|----------|----------|
| **Symmetric** | AES | 128/192/256 bits | Data encryption (fast) |
| **Symmetric** | 3DES | 168 bits | Legacy systems |
| **Asymmetric** | RSA | 2048/4096 bits | Key exchange, signatures |
| **Asymmetric** | ECC | 256/384 bits | Mobile, IoT (efficient) |
| **Hashing** | SHA-256 | 256 bits | Integrity verification |
| **Hashing** | SHA-3 | 256/384/512 | Modern integrity |

### Key Management Terms

| Term | Definition |
|------|------------|
| **BYOK** | Bring Your Own Key - Customer generates/manages keys |
| **HYOK** | Hold Your Own Key - Keys never leave customer premises |
| **HSM** | Hardware Security Module - Tamper-resistant key storage |
| **KMS** | Key Management Service - Cloud-native key management |
| **CMK** | Customer Master Key - Root key in cloud KMS |
| **DEK** | Data Encryption Key - Key that encrypts actual data |
| **KEK** | Key Encryption Key - Key that encrypts other keys |

---

## Domain 2: Cloud Data Security (20%)

### Data Lifecycle - Security at Each Phase

```
┌────────────────────────────────────────────────────────────────┐
│                      DATA LIFECYCLE                             │
├──────────┬─────────────────────────────────────────────────────┤
│ CREATE   │ Classification, ownership, DLP policies             │
│          │ Controls: Tagging, labeling, access control         │
├──────────┼─────────────────────────────────────────────────────┤
│ STORE    │ Encryption at rest, access controls, backup         │
│          │ Controls: AES-256, IAM policies, versioning         │
├──────────┼─────────────────────────────────────────────────────┤
│ USE      │ Processing controls, monitoring, DLP                │
│          │ Controls: Masking, tokenization, audit logs         │
├──────────┼─────────────────────────────────────────────────────┤
│ SHARE    │ Encryption in transit, access restrictions          │
│          │ Controls: TLS, VPN, data loss prevention            │
├──────────┼─────────────────────────────────────────────────────┤
│ ARCHIVE  │ Long-term storage, retention policies               │
│          │ Controls: Immutable storage, compliance holds       │
├──────────┼─────────────────────────────────────────────────────┤
│ DESTROY  │ Secure deletion, crypto-shredding                   │
│          │ Controls: NIST 800-88, certificate of destruction   │
└──────────┴─────────────────────────────────────────────────────┘
```

### Data Classification Levels

| Level | Description | Examples | Controls |
|-------|-------------|----------|----------|
| **Public** | No harm if disclosed | Marketing materials | None required |
| **Internal** | Internal use only | Policies, procedures | Basic access control |
| **Confidential** | Business sensitive | Financial data, HR | Encryption, NDA |
| **Restricted** | Highly sensitive | PII, PHI, credit cards | Full encryption, DLP, audit |

### Data Protection Methods Comparison

```
┌─────────────────────────────────────────────────────────────┐
│                DATA PROTECTION METHODS                       │
├────────────────┬────────────────────────────────────────────┤
│ ENCRYPTION     │ Mathematical transformation                 │
│                │ - Reversible with key                       │
│                │ - Output same size as input                 │
│                │ - Performance impact                        │
├────────────────┼────────────────────────────────────────────┤
│ TOKENIZATION   │ Substitute with random token                │
│                │ - Reversible via lookup table               │
│                │ - Token vault required                      │
│                │ - No performance impact on apps             │
│                │ - Preferred for PCI-DSS                     │
├────────────────┼────────────────────────────────────────────┤
│ MASKING        │ Obscure portions of data                    │
│                │ - NOT reversible                            │
│                │ - Example: XXX-XX-1234                      │
│                │ - Used for display purposes                 │
├────────────────┼────────────────────────────────────────────┤
│ ANONYMIZATION  │ Remove identifying information              │
│                │ - NOT reversible                            │
│                │ - Used for analytics, research              │
│                │ - GDPR compliant (no longer personal data)  │
├────────────────┼────────────────────────────────────────────┤
│ PSEUDONYMIZATION│ Replace identifiers with aliases           │
│                │ - Reversible with mapping table             │
│                │ - Still personal data under GDPR            │
└────────────────┴────────────────────────────────────────────┘
```

### DLP (Data Loss Prevention) Components

```
□ Content Inspection   - Analyze data patterns (SSN, credit card)
□ Contextual Analysis  - Who, when, where, how data accessed
□ Policy Enforcement   - Block, quarantine, encrypt, alert
□ Endpoint DLP         - USB, print, clipboard controls
□ Network DLP          - Email, web, cloud app monitoring
□ Cloud DLP            - SaaS, storage bucket scanning
```

### Data Residency vs. Data Sovereignty

| Concept | Definition | Example |
|---------|------------|---------|
| **Data Residency** | Physical location where data is stored | "Data must stay in EU" |
| **Data Sovereignty** | Data subject to laws of country where stored | GDPR applies to EU data |
| **Data Localization** | Laws requiring data to stay in country | Russia, China data laws |

---

## Domain 3: Cloud Platform & Infrastructure Security (17%)

### Compute Security Comparison

```
┌─────────────────────────────────────────────────────────────┐
│              COMPUTE SECURITY COMPARISON                     │
├─────────────────────────────────────────────────────────────┤
│ VIRTUAL MACHINES (IaaS)                                     │
│ Customer: OS patching, hardening, antivirus, config         │
│ Provider: Hypervisor, physical security                     │
│ Risks: VM escape, snapshot exposure, image vulnerabilities  │
├─────────────────────────────────────────────────────────────┤
│ CONTAINERS (PaaS/IaaS)                                      │
│ Customer: Image security, runtime config, secrets           │
│ Provider: Container runtime, orchestration platform         │
│ Risks: Image vulnerabilities, escape, privilege escalation  │
├─────────────────────────────────────────────────────────────┤
│ SERVERLESS (FaaS)                                           │
│ Customer: Function code, permissions, event validation      │
│ Provider: Everything else (runtime, OS, scaling)            │
│ Risks: Function permissions, event injection, cold start    │
└─────────────────────────────────────────────────────────────┘
```

### Network Security Controls

| Control | Description | Cloud Service |
|---------|-------------|---------------|
| **VPC/VNet** | Isolated virtual network | AWS VPC, Azure VNet, GCP VPC |
| **Subnet** | Network segmentation | Public, private, isolated |
| **Security Group** | Stateful firewall (instance-level) | Allow rules only |
| **NACL** | Stateless firewall (subnet-level) | Allow + Deny rules |
| **WAF** | Web Application Firewall | OWASP protection |
| **DDoS Protection** | Distributed attack mitigation | AWS Shield, Azure DDoS |

### Security Groups vs. NACLs

| Feature | Security Group | NACL |
|---------|----------------|------|
| **Level** | Instance/ENI | Subnet |
| **State** | Stateful | Stateless |
| **Rules** | Allow only | Allow + Deny |
| **Evaluation** | All rules | Numbered order |
| **Default** | Deny all inbound | Allow all |

### Kubernetes Security Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│              KUBERNETES SECURITY LAYERS                      │
├─────────────────────────────────────────────────────────────┤
│ CLUSTER SECURITY                                            │
│ □ RBAC (Role-Based Access Control)                          │
│ □ API server authentication/authorization                   │
│ □ etcd encryption                                           │
│ □ Node security (CIS benchmarks)                            │
├─────────────────────────────────────────────────────────────┤
│ NETWORK SECURITY                                            │
│ □ Network Policies (default deny)                           │
│ □ Service mesh (mTLS)                                       │
│ □ Ingress controller security                               │
├─────────────────────────────────────────────────────────────┤
│ POD SECURITY                                                │
│ □ Pod Security Standards (restricted, baseline, privileged) │
│ □ Security contexts (runAsNonRoot, readOnlyRootFilesystem) │
│ □ Resource limits (CPU, memory)                             │
├─────────────────────────────────────────────────────────────┤
│ CONTAINER SECURITY                                          │
│ □ Image scanning (Trivy, Clair)                             │
│ □ Signed images (Notary, Cosign)                            │
│ □ Private registries                                        │
│ □ Minimal base images (distroless, Alpine)                  │
└─────────────────────────────────────────────────────────────┘
```

### IaC Security Scanning Tools

| Tool | Target | Description |
|------|--------|-------------|
| **Checkov** | Terraform, CloudFormation, K8s | Policy-as-code scanner |
| **tfsec** | Terraform | Security scanner |
| **Terrascan** | Terraform, K8s, Helm | Multi-cloud security |
| **KICS** | Multiple IaC formats | Keeping IaC Secure |
| **Snyk IaC** | Terraform, CloudFormation | Developer-friendly |

---

## Domain 4: Cloud Application Security (17%)

### DevSecOps Pipeline Security

```
┌─────────────────────────────────────────────────────────────┐
│                  DEVSECOPS PIPELINE                          │
├─────────────────────────────────────────────────────────────┤
│ CODE          │ Pre-commit hooks, IDE security plugins      │
│               │ Secret scanning (git-secrets, detect-secrets)│
├───────────────┼─────────────────────────────────────────────┤
│ BUILD         │ SAST (Static Analysis)                      │
│               │ SCA (Software Composition Analysis)          │
│               │ Container image scanning                     │
├───────────────┼─────────────────────────────────────────────┤
│ TEST          │ DAST (Dynamic Analysis)                     │
│               │ IAST (Interactive Analysis)                  │
│               │ Security unit tests                          │
├───────────────┼─────────────────────────────────────────────┤
│ DEPLOY        │ IaC security scanning                       │
│               │ Configuration validation                     │
│               │ Signed artifacts only                        │
├───────────────┼─────────────────────────────────────────────┤
│ OPERATE       │ RASP (Runtime Protection)                   │
│               │ WAF, monitoring, logging                     │
│               │ Vulnerability management                     │
└───────────────┴─────────────────────────────────────────────┘
```

### Application Security Testing Comparison

| Type | When | What | Examples |
|------|------|------|----------|
| **SAST** | Build | Source code (no execution) | SonarQube, Checkmarx, Fortify |
| **DAST** | Test | Running application | OWASP ZAP, Burp Suite |
| **IAST** | Test | Inside running app (agent) | Contrast, Seeker |
| **SCA** | Build | Dependencies, libraries | Snyk, Dependabot, WhiteSource |
| **RASP** | Runtime | Production protection | Contrast, Imperva |

### API Security - OAuth 2.0 Flows

```
┌─────────────────────────────────────────────────────────────┐
│                  OAUTH 2.0 GRANT TYPES                       │
├─────────────────────────────────────────────────────────────┤
│ AUTHORIZATION CODE (Most Secure for Web Apps)               │
│ User → App → Auth Server → Code → App → Token               │
│ Use: Server-side web applications                           │
├─────────────────────────────────────────────────────────────┤
│ AUTHORIZATION CODE + PKCE (Mobile/SPA)                      │
│ Same as above with code_verifier/code_challenge             │
│ Use: Mobile apps, single-page applications                  │
├─────────────────────────────────────────────────────────────┤
│ CLIENT CREDENTIALS (Machine-to-Machine)                     │
│ App → Auth Server → Token (no user)                         │
│ Use: Service accounts, backend services                     │
├─────────────────────────────────────────────────────────────┤
│ IMPLICIT (DEPRECATED - Do Not Use)                          │
│ Token returned directly in URL fragment                     │
│ Risk: Token exposure in browser history                     │
└─────────────────────────────────────────────────────────────┘
```

### Secrets Management Best Practices

```
❌ ANTI-PATTERNS (Never Do This):
□ Hardcoded secrets in source code
□ Secrets in environment variables (visible in logs)
□ Secrets in config files (committed to git)
□ Shared secrets across environments

✅ BEST PRACTICES:
□ Use secrets management service (Vault, AWS Secrets Manager)
□ Rotate secrets automatically
□ Audit all secret access
□ Least privilege for secret access
□ Different secrets per environment
□ Encrypt secrets at rest and in transit
```

### Cloud Secrets Management Services

| Provider | Service | Features |
|----------|---------|----------|
| **AWS** | Secrets Manager | Rotation, RDS integration, cross-account |
| **AWS** | Parameter Store | Hierarchical, free tier, KMS integration |
| **Azure** | Key Vault | HSM-backed, certificates, RBAC |
| **GCP** | Secret Manager | Versioning, IAM, replication |
| **HashiCorp** | Vault | Multi-cloud, dynamic secrets, PKI |
| **CyberArk** | Conjur | Enterprise PAM integration, K8s native |

---

## Domain 5: Cloud Security Operations (17%)

### Logging Services by Provider

| Provider | Service | Purpose |
|----------|---------|---------|
| **AWS** | CloudTrail | API activity logging |
| **AWS** | CloudWatch Logs | Application/system logs |
| **AWS** | VPC Flow Logs | Network traffic |
| **Azure** | Activity Log | Control plane operations |
| **Azure** | Monitor Logs | Metrics and logs |
| **Azure** | NSG Flow Logs | Network traffic |
| **GCP** | Cloud Audit Logs | Admin/data access |
| **GCP** | Cloud Logging | Application logs |
| **GCP** | VPC Flow Logs | Network traffic |

### Incident Response Process (NIST SP 800-61)

```
┌─────────────────────────────────────────────────────────────┐
│              INCIDENT RESPONSE PHASES                        │
├─────────────────────────────────────────────────────────────┤
│ 1. PREPARATION                                              │
│    □ IR plan and playbooks                                  │
│    □ Team training and tools                                │
│    □ Communication channels                                 │
│    □ Evidence collection procedures                         │
├─────────────────────────────────────────────────────────────┤
│ 2. DETECTION & ANALYSIS                                     │
│    □ Monitor alerts and logs                                │
│    □ Validate incident (true positive?)                     │
│    □ Determine scope and impact                             │
│    □ Document everything                                    │
├─────────────────────────────────────────────────────────────┤
│ 3. CONTAINMENT, ERADICATION, RECOVERY                       │
│    □ Short-term containment (isolate)                       │
│    □ Evidence preservation                                  │
│    □ Long-term containment                                  │
│    □ Eradicate threat                                       │
│    □ Recovery and validation                                │
├─────────────────────────────────────────────────────────────┤
│ 4. POST-INCIDENT ACTIVITY                                   │
│    □ Lessons learned meeting                                │
│    □ Update IR plan                                         │
│    □ Implement improvements                                 │
│    □ Report to stakeholders                                 │
└─────────────────────────────────────────────────────────────┘
```

### Digital Forensics in Cloud - Challenges

```
CLOUD FORENSICS CHALLENGES:
□ Data volatility (VMs can be destroyed instantly)
□ Multi-tenancy (shared infrastructure)
□ Jurisdictional issues (data location)
□ Chain of custody (prove integrity)
□ Provider cooperation (need their help)
□ Encryption (may not have keys)

CLOUD FORENSICS BEST PRACTICES:
□ Pre-negotiate with CSP for forensic support
□ Enable comprehensive logging (retain 1+ year)
□ Snapshot VMs before investigation
□ Use write-blockers for disk images
□ Document chain of custody
□ Consider legal holds for data
```

### BC/DR - RPO and RTO

```
┌─────────────────────────────────────────────────────────────┐
│                    RPO vs RTO                                │
├─────────────────────────────────────────────────────────────┤
│ RPO (Recovery Point Objective)                              │
│ "How much data can we afford to lose?"                      │
│                                                             │
│ ◄────── RPO ──────►│                                        │
│ Last Backup         │  Disaster                             │
│                                                             │
│ RPO = 1 hour → Max 1 hour of data loss acceptable           │
│ RPO = 0 → No data loss (synchronous replication)            │
├─────────────────────────────────────────────────────────────┤
│ RTO (Recovery Time Objective)                               │
│ "How long can we be down?"                                  │
│                                                             │
│                     │◄────── RTO ──────►│                   │
│           Disaster  │                   │  Recovery         │
│                                                             │
│ RTO = 4 hours → System must be back in 4 hours              │
│ RTO = 0 → No downtime (hot standby)                         │
└─────────────────────────────────────────────────────────────┘
```

### BC/DR Strategies by RTO/RPO

| Strategy | RTO | RPO | Cost | Description |
|----------|-----|-----|------|-------------|
| **Backup/Restore** | Hours-Days | Hours | $ | Restore from backups |
| **Pilot Light** | Hours | Minutes | $$ | Core systems ready, scale up |
| **Warm Standby** | Minutes | Seconds | $$$ | Scaled-down running copy |
| **Hot Standby** | Near-zero | Near-zero | $$$$ | Active-active, instant failover |

---

## Domain 6: Legal, Risk, and Compliance (12%)

### Compliance Framework Quick Reference

| Framework | Scope | Key Requirements | Penalty |
|-----------|-------|------------------|---------|
| **GDPR** | EU personal data | Consent, breach notify (72h), DPO | 4% revenue or €20M |
| **HIPAA** | US healthcare | BAA, PHI protection, audit | Up to $1.5M/year |
| **PCI-DSS** | Payment cards | 12 requirements, SAQ/ROC | Fines, lose card processing |
| **SOX** | US public companies | Internal controls, audit trail | Criminal penalties |
| **CCPA/CPRA** | California residents | Opt-out, deletion rights | $7,500/violation |
| **FedRAMP** | US federal agencies | Authorization, continuous monitoring | Lose federal contracts |

### GDPR Key Principles (Know These!)

```
THE 7 GDPR PRINCIPLES:
1. Lawfulness, Fairness, Transparency
2. Purpose Limitation
3. Data Minimization
4. Accuracy
5. Storage Limitation
6. Integrity and Confidentiality
7. Accountability

DATA SUBJECT RIGHTS:
□ Right to be informed
□ Right of access
□ Right to rectification
□ Right to erasure ("right to be forgotten")
□ Right to restrict processing
□ Right to data portability
□ Right to object
□ Rights related to automated decision making
```

### SOC Reports Comparison

| Type | Description | Use Case |
|------|-------------|----------|
| **SOC 1** | Financial controls | Financial audits |
| **SOC 2 Type I** | Security controls at a point in time | Initial assessment |
| **SOC 2 Type II** | Security controls over time (6-12 mo) | Ongoing assurance |
| **SOC 3** | Public summary of SOC 2 | Marketing, public trust |

### SOC 2 Trust Service Criteria

```
THE 5 TRUST SERVICE CRITERIA:
□ Security (Required) - Protection against unauthorized access
□ Availability - System available for operation
□ Processing Integrity - Processing is complete and accurate
□ Confidentiality - Confidential info is protected
□ Privacy - Personal info handled properly
```

### Risk Management Quick Reference

```
RISK FORMULA:
Risk = Threat × Vulnerability × Impact

RISK TREATMENT OPTIONS:
□ Avoid     - Eliminate the risk (don't do the activity)
□ Mitigate  - Reduce likelihood or impact (controls)
□ Transfer  - Shift to third party (insurance, contract)
□ Accept    - Acknowledge and monitor (document decision)

RISK ASSESSMENT FRAMEWORKS:
□ NIST RMF (Risk Management Framework)
□ ISO 31000 (Risk Management Standard)
□ FAIR (Factor Analysis of Information Risk)
□ OCTAVE (Operationally Critical Threat, Asset, Vulnerability)
```

### Cloud Contract Essentials

```
KEY CONTRACT ELEMENTS:
□ SLA (Service Level Agreement)
  - Uptime guarantee (99.9%, 99.99%)
  - Performance metrics
  - Remedies for breach (credits)

□ DPA (Data Processing Agreement)
  - Required for GDPR compliance
  - Defines processor responsibilities
  - Sub-processor requirements

□ Right to Audit
  - Customer can audit provider
  - Usually satisfied by SOC 2

□ Data Ownership
  - Customer owns their data
  - Provider can't use for other purposes

□ Exit Strategy
  - Data portability
  - Transition assistance
  - Data deletion upon termination
```

---

## Shared Responsibility Model Quick Reference

### IaaS vs. PaaS vs. SaaS Responsibilities

```
┌──────────────────────────────────────────────────────────────┐
│          SHARED RESPONSIBILITY MODEL                          │
├──────────────┬──────────┬──────────┬──────────┬─────────────┤
│ Layer        │ On-Prem  │ IaaS     │ PaaS     │ SaaS        │
├──────────────┼──────────┼──────────┼──────────┼─────────────┤
│ Data         │ Customer │ Customer │ Customer │ Customer    │
│ Applications │ Customer │ Customer │ Customer │ Provider    │
│ Runtime      │ Customer │ Customer │ Provider │ Provider    │
│ Middleware   │ Customer │ Customer │ Provider │ Provider    │
│ O/S          │ Customer │ Customer │ Provider │ Provider    │
│ Virtualization│ Customer │ Provider │ Provider │ Provider    │
│ Servers      │ Customer │ Provider │ Provider │ Provider    │
│ Storage      │ Customer │ Provider │ Provider │ Provider    │
│ Networking   │ Customer │ Provider │ Provider │ Provider    │
│ Physical     │ Customer │ Provider │ Provider │ Provider    │
└──────────────┴──────────┴──────────┴──────────┴─────────────┘

Legend: Customer = Customer Responsibility, Provider = CSP Responsibility
```

### What the Customer ALWAYS Owns

```
CUSTOMER ALWAYS RESPONSIBLE FOR:
□ Data classification and protection
□ Identity and access management
□ Client/endpoint protection
□ Account security (MFA, passwords)
□ Compliance with regulations
□ Security awareness training
```

---

## Compliance Framework Quick Reference

### HIPAA Cloud Checklist

```
HIPAA IN CLOUD - KEY REQUIREMENTS:
□ BAA (Business Associate Agreement) with CSP
□ PHI encrypted at rest AND in transit
□ Access controls and audit logging
□ Backup and disaster recovery
□ Incident response procedures
□ Risk assessment annually

HIPAA-ELIGIBLE CLOUD SERVICES:
AWS: Most services (see BAA)
Azure: Most services (see BAA)
GCP: Most services (see BAA)
```

### PCI-DSS Cloud Quick Reference

```
PCI-DSS 12 REQUIREMENTS (Summary):
1. Install/maintain firewall
2. No vendor-supplied defaults
3. Protect stored cardholder data
4. Encrypt transmission
5. Use antivirus software
6. Develop secure systems
7. Restrict access (need-to-know)
8. Unique IDs for each person
9. Restrict physical access
10. Track and monitor access
11. Test security systems
12. Maintain security policy

CDE (Cardholder Data Environment):
- Systems that store, process, transmit CHD
- Must be segmented from other systems
- All CDE components must be PCI compliant
```

---

## Encryption & Key Management Quick Reference

### Encryption States

| State | Description | Controls |
|-------|-------------|----------|
| **At Rest** | Data stored on disk | AES-256, volume encryption |
| **In Transit** | Data moving over network | TLS 1.2+, VPN, mTLS |
| **In Use** | Data being processed | Homomorphic encryption, SGX |

### Key Management Best Practices

```
KEY MANAGEMENT LIFECYCLE:
1. Generation  - Use strong RNG, adequate key size
2. Distribution - Secure channels, never plaintext
3. Storage     - HSM, encrypted, access controls
4. Use         - Least privilege, logging
5. Rotation    - Regular intervals (90 days typical)
6. Destruction - Crypto-shredding, secure delete

KEY ROTATION GUIDELINES:
□ Data encryption keys: 1 year
□ Master keys: 2-3 years
□ After breach: Immediately
□ After personnel change: As needed
```

---

## Cloud Provider Comparison

### Security Services Mapping

| Function | AWS | Azure | GCP |
|----------|-----|-------|-----|
| **IAM** | IAM | Azure AD, RBAC | Cloud IAM |
| **Secrets** | Secrets Manager | Key Vault | Secret Manager |
| **KMS** | KMS | Key Vault | Cloud KMS |
| **HSM** | CloudHSM | Dedicated HSM | Cloud HSM |
| **WAF** | WAF | WAF | Cloud Armor |
| **DDoS** | Shield | DDoS Protection | Cloud Armor |
| **SIEM** | Security Hub | Sentinel | Chronicle |
| **Compliance** | Artifact | Compliance Manager | Compliance |
| **Logging** | CloudTrail | Activity Log | Audit Logs |

---

## Acronyms & Definitions

### Must-Know Acronyms

| Acronym | Full Form |
|---------|-----------|
| **BAA** | Business Associate Agreement |
| **BCM** | Business Continuity Management |
| **BCP** | Business Continuity Plan |
| **BYOD** | Bring Your Own Device |
| **BYOK** | Bring Your Own Key |
| **CAT** | Computer Adaptive Testing |
| **CBK** | Common Body of Knowledge |
| **CCPA** | California Consumer Privacy Act |
| **CDE** | Cardholder Data Environment |
| **CSPM** | Cloud Security Posture Management |
| **CWPP** | Cloud Workload Protection Platform |
| **DAST** | Dynamic Application Security Testing |
| **DLP** | Data Loss Prevention |
| **DPA** | Data Processing Agreement |
| **DPO** | Data Protection Officer |
| **DR** | Disaster Recovery |
| **FedRAMP** | Federal Risk and Authorization Management Program |
| **GDPR** | General Data Protection Regulation |
| **HIPAA** | Health Insurance Portability and Accountability Act |
| **HSM** | Hardware Security Module |
| **IaC** | Infrastructure as Code |
| **IAST** | Interactive Application Security Testing |
| **IR** | Incident Response |
| **KMS** | Key Management Service |
| **NACL** | Network Access Control List |
| **PCI-DSS** | Payment Card Industry Data Security Standard |
| **PHI** | Protected Health Information |
| **PIA** | Privacy Impact Assessment |
| **PII** | Personally Identifiable Information |
| **RASP** | Runtime Application Self-Protection |
| **RPO** | Recovery Point Objective |
| **RTO** | Recovery Time Objective |
| **SAST** | Static Application Security Testing |
| **SCA** | Software Composition Analysis |
| **SLA** | Service Level Agreement |
| **SOC** | Service Organization Control |
| **SOX** | Sarbanes-Oxley Act |
| **VPC** | Virtual Private Cloud |
| **WAF** | Web Application Firewall |

---

## Exam Day Quick Cards

### Card 1: NIST Cloud Essentials

```
5 CHARACTERISTICS:
On-demand, Broad network, Resource pooling, Rapid elasticity, Measured

3 SERVICE MODELS:
IaaS → PaaS → SaaS (Customer responsibility decreases →)

4 DEPLOYMENT MODELS:
Public, Private, Hybrid, Community
```

### Card 2: Data Protection Summary

```
ENCRYPTION: Reversible, mathematical, same size output
TOKENIZATION: Reversible, lookup table, preferred for PCI
MASKING: NOT reversible, for display (XXX-XX-1234)
ANONYMIZATION: NOT reversible, no longer personal data (GDPR)
PSEUDONYMIZATION: Reversible, still personal data (GDPR)
```

### Card 3: Compliance Quick Hits

```
GDPR: 72-hour breach notification, 4% revenue penalty
HIPAA: Requires BAA, protects PHI
PCI-DSS: 12 requirements, protects cardholder data
SOC 2 Type II: Covers period of time (6-12 months)
```

### Card 4: BC/DR Quick Reference

```
RPO = How much data loss acceptable (last backup → disaster)
RTO = How long downtime acceptable (disaster → recovery)

STRATEGIES (cost increasing):
Backup/Restore → Pilot Light → Warm Standby → Hot Standby
```

### Card 5: Key Exam Tips

```
(ISC)² MINDSET:
✓ Think like a manager, not technician
✓ Security > Convenience
✓ Compliance > Cost savings
✓ Process > Quick fixes
✓ Risk-based approach always

WHEN IN DOUBT:
- What protects the ORGANIZATION best?
- What follows PROPER PROCESS?
- What addresses the ROOT CAUSE?
```

---

## Final Review Checklist

### Before the Exam

```
KNOWLEDGE CHECK:
□ Can explain shared responsibility for IaaS, PaaS, SaaS
□ Know NIST 5 characteristics by heart
□ Understand data lifecycle and controls at each phase
□ Can differentiate encryption vs. tokenization vs. masking
□ Know GDPR principles and data subject rights
□ Understand RPO vs. RTO
□ Can explain SOC 2 Type I vs. Type II
□ Know incident response phases (NIST 800-61)
□ Understand OAuth 2.0 grant types
□ Can list DevSecOps pipeline security controls

LOGISTICS:
□ Two forms of ID ready
□ Exam appointment confirmed
□ Know test center location / online proctoring tested
□ Arrive 30 minutes early
```

### Success Metrics

```
PRACTICE EXAM TARGETS:
□ Domain 1 (Architecture): 85%+
□ Domain 2 (Data Security): 85%+
□ Domain 3 (Platform Security): 85%+
□ Domain 4 (App Security): 85%+
□ Domain 5 (Operations): 85%+
□ Domain 6 (Legal/Compliance): 85%+
□ Full Practice Exam: 85-90%+
```

---

**You've prepared well. Trust your knowledge, manage your time, and pass the CCSP!**

---

**Last Updated**: 2025-11-28
**Version**: 1.0
