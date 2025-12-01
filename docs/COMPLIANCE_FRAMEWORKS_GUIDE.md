# Compliance Frameworks Guide

Comprehensive guide to major compliance frameworks relevant to PAM, Conjur, Kubernetes, and cloud security consulting.

---

## Table of Contents

1. [Framework Overview](#framework-overview)
2. [NIST Cybersecurity Framework](#nist-cybersecurity-framework)
3. [HIPAA Technical Safeguards](#hipaa-technical-safeguards)
4. [PCI-DSS Requirements](#pci-dss-requirements)
5. [SOC 2 Controls](#soc-2-controls)
6. [ISO 27001](#iso-27001)
7. [CyberArk Control Mapping](#cyberark-control-mapping)
8. [Audit Preparation](#audit-preparation)
9. [Compliance Documentation Templates](#compliance-documentation-templates)

---

## Framework Overview

### Quick Reference Matrix

| Framework | Industry | Focus | Audit Type | CyberArk Relevance |
|-----------|----------|-------|------------|-------------------|
| **NIST CSF** | All | Risk management | Voluntary/Required | High - privileged access |
| **HIPAA** | Healthcare | PHI protection | Annual/Ongoing | Critical - access controls |
| **PCI-DSS** | Payment cards | Cardholder data | Annual QSA/SAQ | Critical - credential mgmt |
| **SOC 2** | Service providers | Trust services | Annual Type II | High - security controls |
| **ISO 27001** | All | ISMS | Certification audit | High - access control |
| **FedRAMP** | US Government | Cloud security | Authorization | High - privileged access |
| **GDPR** | EU data | Privacy | Supervisory authority | Moderate - access logs |

### Framework Selection Guide

```text
┌─────────────────────────────────────────────────────────────────────────┐
│           WHICH FRAMEWORKS APPLY TO YOUR CLIENT?                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Q1: Do they process payment cards?                                     │
│      YES → PCI-DSS required                                             │
│                                                                         │
│  Q2: Do they handle healthcare data (US)?                               │
│      YES → HIPAA required                                               │
│                                                                         │
│  Q3: Are they a service provider to other businesses?                   │
│      YES → SOC 2 highly recommended                                     │
│                                                                         │
│  Q4: Do they handle EU personal data?                                   │
│      YES → GDPR required                                                │
│                                                                         │
│  Q5: Do they work with US federal government?                           │
│      YES → FedRAMP required                                             │
│                                                                         │
│  Q6: Do they want industry-recognized security certification?           │
│      YES → ISO 27001 recommended                                        │
│                                                                         │
│  ALWAYS RECOMMENDED:                                                    │
│  • NIST CSF as baseline framework                                       │
│  • CIS Benchmarks for technical hardening                               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## NIST Cybersecurity Framework

### Overview

**NIST CSF** provides a voluntary framework for managing cybersecurity risk. Version 2.0 (released 2024) is the current standard.

**Structure**: 6 Core Functions → Categories → Subcategories → Informative References

### The Six Core Functions

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    NIST CSF 2.0 CORE FUNCTIONS                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   ┌─────────┐                                                          │
│   │ GOVERN  │ ← NEW in 2.0: Organizational context & risk management   │
│   └────┬────┘                                                          │
│        │                                                               │
│   ┌────▼────┐    ┌─────────┐    ┌─────────┐                           │
│   │IDENTIFY │───►│ PROTECT │───►│ DETECT  │                           │
│   └─────────┘    └─────────┘    └────┬────┘                           │
│                                      │                                 │
│                  ┌─────────┐    ┌────▼────┐                           │
│                  │ RECOVER │◄───│ RESPOND │                           │
│                  └─────────┘    └─────────┘                           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### NIST CSF Categories & PAM Relevance

| Function | Category | PAM Controls |
|----------|----------|--------------|
| **GOVERN** | GV.RR - Risk Management | Privileged account inventory, risk assessment |
| **IDENTIFY** | ID.AM - Asset Management | Account discovery, credential inventory |
| **IDENTIFY** | ID.RA - Risk Assessment | Privileged access risk analysis |
| **PROTECT** | PR.AA - Identity Management | PAM authentication, MFA, session control |
| **PROTECT** | PR.AC - Access Control | Least privilege, credential vaulting |
| **PROTECT** | PR.DS - Data Security | Credential encryption, secure storage |
| **PROTECT** | PR.PS - Platform Security | Hardened PAM infrastructure |
| **DETECT** | DE.CM - Continuous Monitoring | Session recording, anomaly detection |
| **DETECT** | DE.AE - Adverse Event Analysis | Privileged activity analytics |
| **RESPOND** | RS.AN - Analysis | Incident investigation with session data |
| **RESPOND** | RS.MA - Mitigation | Credential revocation, session termination |
| **RECOVER** | RC.RP - Recovery Planning | PAM DR/BC procedures |

### CyberArk NIST CSF Control Mapping

```yaml
# NIST CSF PR.AA-01: Identities and credentials are issued, managed, verified
CyberArk Controls:
  - Vault: Centralized credential storage
  - CPM: Automated credential management
  - PVWA: Identity verification before access

# NIST CSF PR.AC-03: Remote access managed
CyberArk Controls:
  - PSM: Session isolation and recording
  - PVWA: Secure remote access portal
  - MFA: Multi-factor authentication integration

# NIST CSF DE.CM-01: Networks monitored for potential cybersecurity events
CyberArk Controls:
  - PTA: Privileged Threat Analytics
  - Session recordings: Activity audit
  - SIEM integration: Real-time alerting
```

---

## HIPAA Technical Safeguards

### Overview

**HIPAA** (Health Insurance Portability and Accountability Act) requires protection of Protected Health Information (PHI). The Security Rule defines technical safeguards.

### Technical Safeguard Requirements

```text
┌─────────────────────────────────────────────────────────────────────────┐
│              HIPAA TECHNICAL SAFEGUARDS (45 CFR 164.312)                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ §164.312(a) ACCESS CONTROL                                      │   │
│  │ • Unique user identification (Required)                         │   │
│  │ • Emergency access procedure (Required)                         │   │
│  │ • Automatic logoff (Addressable)                                │   │
│  │ • Encryption and decryption (Addressable)                       │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ §164.312(b) AUDIT CONTROLS                                      │   │
│  │ • Hardware, software, procedural mechanisms for activity        │   │
│  │   recording and examination (Required)                          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ §164.312(c) INTEGRITY                                           │   │
│  │ • Mechanism to authenticate ePHI (Addressable)                  │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ §164.312(d) AUTHENTICATION                                      │   │
│  │ • Verify person/entity seeking access is claimed (Required)     │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ §164.312(e) TRANSMISSION SECURITY                               │   │
│  │ • Integrity controls (Addressable)                              │   │
│  │ • Encryption (Addressable)                                      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Note: "Required" = must implement; "Addressable" = implement or       │
│        document why alternative is reasonable and appropriate          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### CyberArk HIPAA Control Mapping

| HIPAA Requirement | CyberArk Solution | Evidence |
|-------------------|-------------------|----------|
| **Unique User ID** (§164.312(a)(2)(i)) | PVWA user accounts, AD integration | User access reports |
| **Emergency Access** (§164.312(a)(2)(ii)) | Break-glass procedures, dual control | Emergency access logs |
| **Automatic Logoff** (§164.312(a)(2)(iii)) | Session timeout in PVWA/PSM | Configuration settings |
| **Encryption** (§164.312(a)(2)(iv)) | Vault encryption (AES-256), TLS | Encryption configuration |
| **Audit Controls** (§164.312(b)) | Session recording, audit logs | Recording archives, logs |
| **Person Authentication** (§164.312(d)) | MFA integration, certificate auth | Authentication logs |
| **Transmission Security** (§164.312(e)) | TLS 1.2+, encrypted sessions | Network configuration |

### HIPAA Implementation Checklist

```text
HIPAA Compliance Checklist for PAM Implementation:

Access Controls:
□ Unique user IDs for all privileged users
□ Role-based access control implemented
□ Emergency access procedures documented and tested
□ Automatic session timeout configured (15 min recommended)
□ Credential encryption at rest (AES-256)

Audit Controls:
□ All privileged sessions recorded
□ Session recordings retained (6 years minimum)
□ Audit logs tamper-evident
□ SIEM integration for real-time monitoring
□ Regular audit log review process

Authentication:
□ MFA enabled for all privileged access
□ Strong password policy enforced by CPM
□ Certificate-based authentication where applicable
□ Failed login attempt lockout

Transmission Security:
□ TLS 1.2+ for all connections
□ No plaintext credential transmission
□ VPN for remote access to PAM infrastructure
```

---

## PCI-DSS Requirements

### Overview

**PCI-DSS** (Payment Card Industry Data Security Standard) version 4.0 is the current standard, mandatory for organizations handling cardholder data.

### PCI-DSS Requirements Overview

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    PCI-DSS v4.0 REQUIREMENTS                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  BUILD AND MAINTAIN A SECURE NETWORK AND SYSTEMS                       │
│    1. Install and maintain network security controls                    │
│    2. Apply secure configurations to all system components              │
│                                                                         │
│  PROTECT ACCOUNT DATA                                                   │
│    3. Protect stored account data                                       │
│    4. Protect cardholder data with strong cryptography                  │
│                                                                         │
│  MAINTAIN A VULNERABILITY MANAGEMENT PROGRAM                           │
│    5. Protect systems from malicious software                           │
│    6. Develop and maintain secure systems and software                  │
│                                                                         │
│  IMPLEMENT STRONG ACCESS CONTROL MEASURES                              │
│    7. Restrict access to cardholder data by business need-to-know  ←   │
│    8. Identify users and authenticate access to system components  ←   │
│    9. Restrict physical access to cardholder data                       │
│                                                                         │
│  REGULARLY MONITOR AND TEST NETWORKS                                   │
│   10. Log and monitor access to system components and data         ←   │
│   11. Test security of systems and networks regularly                   │
│                                                                         │
│  MAINTAIN AN INFORMATION SECURITY POLICY                               │
│   12. Support information security with policies and programs           │
│                                                                         │
│  ← Requirements directly addressed by CyberArk PAM                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### PCI-DSS Requirements 7, 8, 10 Deep Dive

These requirements are most relevant to PAM consulting.

#### Requirement 7: Restrict Access

| Sub-Requirement | Description | CyberArk Control |
|-----------------|-------------|------------------|
| 7.1 | Processes for restricting access defined | Safe-based access policies |
| 7.2 | Access granted based on job function | Role-based access in PVWA |
| 7.2.1 | Access control model defined | PAM policy documentation |
| 7.2.2 | Access assigned based on job classification | AD group → Safe mapping |
| 7.2.3 | Privileged access requires approval | Dual control, approvals |
| 7.2.4 | Access reviews performed | CyberArk access reports |
| 7.2.5 | All access assigned with privilege documented | Account onboarding records |
| 7.2.6 | All user access to query cardholder data restricted | Database account vaulting |

#### Requirement 8: Identify and Authenticate

| Sub-Requirement | Description | CyberArk Control |
|-----------------|-------------|------------------|
| 8.2.1 | Unique IDs for all users | PVWA user accounts |
| 8.2.2 | Shared accounts documented and managed | Shared account check-out |
| 8.3.1 | Strong authentication for all access | MFA integration |
| 8.3.4 | Invalid authentication attempts locked | Account lockout policy |
| 8.3.6 | Passwords meet complexity requirements | CPM password policy |
| 8.3.7 | Passwords changed at least every 90 days | CPM auto-rotation |
| 8.3.9 | Passwords not same as previous 4 | CPM password history |
| 8.3.10 | Service account passwords rotated | CPM service account mgmt |
| 8.3.11 | MFA for all non-console admin access | PSM with MFA |
| 8.6.1 | Interactive login for service accounts restricted | PSM connection components |

#### Requirement 10: Log and Monitor

| Sub-Requirement | Description | CyberArk Control |
|-----------------|-------------|------------------|
| 10.2.1 | Audit logs enabled | Session recording, Vault logs |
| 10.2.1.1 | All individual user access logged | PVWA access logs |
| 10.2.1.2 | All actions by administrative accounts logged | PSM recordings |
| 10.2.1.3 | Access to audit logs logged | Vault audit log access |
| 10.2.1.5 | All changes to credentials logged | CPM activity logs |
| 10.3.1 | Logs include user identification | User ID in all logs |
| 10.3.2 | Logs include event type | Action type recorded |
| 10.3.3 | Logs include date/time | Timestamps on all events |
| 10.4.1 | Audit logs protected from modification | Vault log integrity |
| 10.5.1 | Retain audit logs for 12 months | Recording retention policy |

### PCI-DSS Compliance Documentation

```text
PCI-DSS Audit Evidence for CyberArk:

Requirement 7 Evidence:
├── Access control policies (PDF)
├── Safe membership reports (PVWA export)
├── Role-to-safe mapping documentation
├── Approval workflow screenshots
└── Quarterly access review records

Requirement 8 Evidence:
├── User account inventory (PVWA report)
├── MFA configuration screenshots
├── CPM password policy settings
├── Password rotation reports
├── Service account management procedures
└── Failed login audit report

Requirement 10 Evidence:
├── Session recording samples (redacted)
├── Audit log retention policy
├── SIEM integration documentation
├── Log review procedures
├── 12-month log retention proof
└── Log integrity verification process
```

---

## SOC 2 Controls

### Overview

**SOC 2** (Service Organization Control 2) is an audit framework developed by AICPA based on Trust Services Criteria.

### Trust Services Criteria

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    SOC 2 TRUST SERVICES CRITERIA                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ SECURITY (CC - Common Criteria) - ALWAYS REQUIRED               │   │
│  │ Protection against unauthorized access                          │   │
│  │ • Logical access controls                                       │   │
│  │ • Network security                                              │   │
│  │ • Change management                                             │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ AVAILABILITY (A) - OPTIONAL                                     │   │
│  │ System available for operation and use                          │   │
│  │ • Disaster recovery                                             │   │
│  │ • Business continuity                                           │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ PROCESSING INTEGRITY (PI) - OPTIONAL                            │   │
│  │ System processing is complete, accurate, timely                 │   │
│  │ • Data validation                                               │   │
│  │ • Processing monitoring                                         │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ CONFIDENTIALITY (C) - OPTIONAL                                  │   │
│  │ Information designated confidential is protected                │   │
│  │ • Data classification                                           │   │
│  │ • Encryption                                                    │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ PRIVACY (P) - OPTIONAL                                          │   │
│  │ Personal information collected/used/retained/disclosed properly │   │
│  │ • Notice and consent                                            │   │
│  │ • Data subject rights                                           │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### SOC 2 Common Criteria (CC) & PAM

| Criteria | Description | CyberArk Control |
|----------|-------------|------------------|
| **CC6.1** | Logical access security software | PVWA authentication, Vault access |
| **CC6.2** | New user registration and authorization | Account onboarding workflow |
| **CC6.3** | User access removal when terminated | Account offboarding, access revocation |
| **CC6.4** | Access reviews | Privileged access reports |
| **CC6.5** | Credentials protected | Vault encryption, secret rotation |
| **CC6.6** | Infrastructure access restricted | Network isolation, firewall rules |
| **CC6.7** | Data transmission protected | TLS encryption, secure protocols |
| **CC6.8** | Malicious software prevented | Endpoint protection on PAM servers |
| **CC7.1** | Detect security events | PTA, SIEM integration |
| **CC7.2** | Monitor system components | Session recording, audit logs |
| **CC7.3** | Evaluate security events | Incident response procedures |
| **CC7.4** | Respond to security incidents | Credential revocation, containment |
| **CC8.1** | Change management | PAM change control procedures |

### SOC 2 Type I vs Type II

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    SOC 2 TYPE I vs TYPE II                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  TYPE I                           TYPE II                               │
│  ─────────────                    ─────────────                         │
│  • Point-in-time assessment       • Period of time (6-12 months)        │
│  • Controls DESIGNED              • Controls OPERATING EFFECTIVELY      │
│  • Faster to obtain               • More rigorous                       │
│  • Less auditor evidence          • Extensive evidence collection       │
│  • Good for: New organizations    • Good for: Established services      │
│  • Audit duration: 2-4 weeks      • Audit duration: Ongoing + 4-8 weeks │
│                                                                         │
│  ENTERPRISE CLIENT EXPECTATIONS:                                        │
│  • Most require Type II                                                 │
│  • Healthcare/Banking: Type II mandatory                                │
│  • Type I acceptable for first year only                                │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### SOC 2 Audit Evidence from CyberArk

```text
SOC 2 Evidence Collection from CyberArk:

CC6.1 - Logical Access:
├── PVWA authentication configuration
├── AD integration settings
├── MFA configuration
└── Network access controls

CC6.2 - User Registration:
├── Account provisioning procedures
├── Safe assignment approvals
├── New user access requests (ticketing)
└── Onboarding workflow documentation

CC6.3 - Access Removal:
├── Offboarding procedures
├── Access revocation logs
├── Terminated user reports
└── Safe membership audit trails

CC6.4 - Access Reviews:
├── Quarterly access review reports
├── Privileged user list
├── Review sign-off documentation
└── Exception handling records

CC6.5 - Credential Protection:
├── Vault encryption settings
├── CPM rotation policies
├── Password complexity requirements
└── Rotation audit logs

CC7.1/CC7.2 - Monitoring:
├── Session recording samples
├── Alert configuration
├── SIEM integration logs
├── Monitoring dashboard screenshots
└── PTA configuration
```

---

## ISO 27001

### Overview

**ISO/IEC 27001** is the international standard for Information Security Management Systems (ISMS). Certification requires third-party audit.

### ISO 27001 Annex A Controls (2022)

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                ISO 27001:2022 ANNEX A CONTROL THEMES                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  A.5  ORGANIZATIONAL CONTROLS (37 controls)                            │
│       Policies, roles, responsibilities, threat intelligence            │
│                                                                         │
│  A.6  PEOPLE CONTROLS (8 controls)                                     │
│       Screening, awareness, disciplinary process                        │
│                                                                         │
│  A.7  PHYSICAL CONTROLS (14 controls)                                  │
│       Physical security perimeters, equipment                           │
│                                                                         │
│  A.8  TECHNOLOGICAL CONTROLS (34 controls)                             │
│       ← Most relevant to PAM                                            │
│       • A.8.2  Privileged access rights                                │
│       • A.8.3  Information access restriction                          │
│       • A.8.4  Access to source code                                   │
│       • A.8.5  Secure authentication                                   │
│       • A.8.6  Capacity management                                     │
│       • A.8.7  Protection against malware                              │
│       • A.8.15 Logging                                                 │
│       • A.8.16 Monitoring activities                                   │
│       • A.8.17 Clock synchronization                                   │
│       • A.8.18 Use of privileged utility programs                      │
│                                                                         │
│  TOTAL: 93 controls (reduced from 114 in 2013 version)                 │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### ISO 27001 PAM-Relevant Controls

| Control | Title | CyberArk Implementation |
|---------|-------|------------------------|
| **A.8.2** | Privileged access rights | PAM for all privileged accounts |
| **A.8.3** | Information access restriction | Safe-based access control |
| **A.8.5** | Secure authentication | MFA, strong passwords via CPM |
| **A.8.15** | Logging | Session recording, audit logs |
| **A.8.16** | Monitoring activities | PTA, SIEM integration |
| **A.8.18** | Privileged utility programs | PSM isolation, command limiting |
| **A.5.15** | Access control policy | PAM policy documentation |
| **A.5.16** | Identity management | Account lifecycle management |
| **A.5.17** | Authentication information | Credential vaulting, rotation |
| **A.5.18** | Access rights | Role-based access to Safes |

### ISO 27001 Statement of Applicability (SoA)

```text
Statement of Applicability - Privileged Access Management Controls:

Control A.8.2 - Privileged Access Rights
┌────────────────────────────────────────────────────────────────────────┐
│ Applicability: APPLICABLE                                              │
│ Implementation Status: FULLY IMPLEMENTED                               │
│                                                                        │
│ Control Description:                                                   │
│ The allocation and use of privileged access rights shall be           │
│ restricted and managed.                                                │
│                                                                        │
│ Implementation:                                                        │
│ • CyberArk PAM deployed for all privileged account management         │
│ • All privileged credentials stored in CyberArk Vault                 │
│ • Access requires approval workflow for sensitive systems             │
│ • Privileged sessions recorded via PSM                                │
│ • Quarterly access reviews conducted                                  │
│                                                                        │
│ Evidence:                                                              │
│ • PAM architecture documentation                                       │
│ • Privileged account inventory                                         │
│ • Access review records                                                │
│ • Session recording retention policy                                   │
│                                                                        │
│ Risk Assessment: Privileged access is highest risk for data breach.   │
│ Mitigated by defense-in-depth PAM controls.                           │
└────────────────────────────────────────────────────────────────────────┘
```

---

## CyberArk Control Mapping

### Master Control Mapping Table

| CyberArk Component | NIST CSF | HIPAA | PCI-DSS | SOC 2 | ISO 27001 |
|-------------------|----------|-------|---------|-------|-----------|
| **Vault (Credential Storage)** | PR.AC, PR.DS | §164.312(a)(2)(iv) | 3.5, 8.3.6 | CC6.5 | A.8.5, A.5.17 |
| **CPM (Password Rotation)** | PR.AC | §164.312(d) | 8.3.7, 8.3.10 | CC6.5 | A.8.5 |
| **PSM (Session Management)** | DE.CM | §164.312(b) | 10.2.1.2 | CC7.2 | A.8.15, A.8.16 |
| **PVWA (Web Access)** | PR.AA | §164.312(d) | 8.2.1, 8.3.1 | CC6.1 | A.8.5 |
| **PTA (Threat Analytics)** | DE.AE | §164.312(b) | 10.6 | CC7.1 | A.8.16 |
| **MFA Integration** | PR.AA | §164.312(d) | 8.3.11 | CC6.1 | A.8.5 |
| **Audit Logs** | DE.CM | §164.312(b) | 10.2, 10.3 | CC7.2 | A.8.15 |
| **Safe Access Control** | PR.AC | §164.312(a)(1) | 7.1, 7.2 | CC6.1 | A.8.3 |

### Conjur Control Mapping

| Conjur Feature | NIST CSF | HIPAA | PCI-DSS | SOC 2 | ISO 27001 |
|---------------|----------|-------|---------|-------|-----------|
| **Secret Storage** | PR.DS | §164.312(a)(2)(iv) | 3.5 | CC6.5 | A.5.17 |
| **Policy-as-Code** | PR.AC | §164.312(a)(1) | 7.2 | CC6.1 | A.5.15 |
| **K8s Authentication** | PR.AA | §164.312(d) | 8.3.1 | CC6.1 | A.8.5 |
| **Secret Rotation** | PR.AC | §164.312(d) | 8.3.7 | CC6.5 | A.8.5 |
| **Audit Logging** | DE.CM | §164.312(b) | 10.2 | CC7.2 | A.8.15 |

---

## Audit Preparation

### Pre-Audit Checklist

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                    PRE-AUDIT PREPARATION CHECKLIST                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  4 WEEKS BEFORE AUDIT:                                                 │
│  □ Gather all policy documentation                                      │
│  □ Export privileged account inventory                                  │
│  □ Generate access review reports                                       │
│  □ Verify session recording availability                                │
│  □ Test audit log retrieval                                            │
│  □ Schedule stakeholder interviews                                      │
│  □ Prepare system architecture diagrams                                 │
│                                                                         │
│  2 WEEKS BEFORE AUDIT:                                                 │
│  □ Conduct internal pre-audit review                                    │
│  □ Remediate identified gaps                                            │
│  □ Organize evidence folders                                            │
│  □ Brief relevant personnel                                             │
│  □ Prepare demonstration environment                                    │
│  □ Test all reports and exports                                         │
│                                                                         │
│  1 WEEK BEFORE AUDIT:                                                  │
│  □ Final evidence review                                                │
│  □ Confirm auditor logistics                                            │
│  □ Prepare conference room/remote access                                │
│  □ Create evidence index/table of contents                              │
│  □ Brief executives on audit scope                                      │
│                                                                         │
│  DURING AUDIT:                                                         │
│  □ Designate audit liaison                                              │
│  □ Track evidence requests                                              │
│  □ Daily progress meetings                                              │
│  □ Document any findings immediately                                    │
│  □ Escalate blockers quickly                                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Common Audit Findings & Remediation

| Finding | Risk | Remediation |
|---------|------|-------------|
| **Shared accounts without management** | High | Onboard to CyberArk, implement check-out |
| **Password rotation not enforced** | High | Configure CPM policies, verify rotation |
| **Missing session recordings** | Medium | Verify PSM configuration, storage space |
| **Incomplete access reviews** | Medium | Implement quarterly review process |
| **No MFA for privileged access** | High | Enable MFA integration |
| **Orphaned accounts** | Medium | Account discovery, cleanup process |
| **Excessive permissions** | Medium | Implement least privilege, review safes |
| **Audit logs not retained** | Medium | Configure retention policy (12+ months) |

### Audit Response Template

```markdown
# Audit Finding Response

**Finding ID**: [AUDIT-2025-001]
**Finding**: [Description of finding]
**Risk Level**: [High/Medium/Low]
**Affected Control**: [e.g., PCI-DSS 8.3.7]

## Root Cause Analysis
[Explain why the issue exists]

## Remediation Plan
| Action | Owner | Target Date | Status |
|--------|-------|-------------|--------|
| [Action 1] | [Name] | [Date] | [Open/In Progress/Complete] |
| [Action 2] | [Name] | [Date] | [Open/In Progress/Complete] |

## Evidence of Remediation
[List evidence that will demonstrate remediation]

## Preventive Measures
[Steps to prevent recurrence]

## Management Sign-off
Approved by: _________________ Date: _________
```

---

## Compliance Documentation Templates

### Policy Document Structure

```markdown
# [Policy Name] Policy

**Document ID**: POL-[XXX]-[001]
**Version**: 1.0
**Effective Date**: YYYY-MM-DD
**Review Date**: YYYY-MM-DD
**Owner**: [Title/Department]
**Classification**: Internal

---

## 1. Purpose
[Why this policy exists]

## 2. Scope
[Who and what this policy applies to]

## 3. Policy Statements
### 3.1 [Policy Area 1]
[Specific requirements]

### 3.2 [Policy Area 2]
[Specific requirements]

## 4. Roles and Responsibilities
| Role | Responsibility |
|------|----------------|
| [Role] | [Responsibility] |

## 5. Compliance
[How compliance is measured and enforced]

## 6. Exceptions
[Process for requesting exceptions]

## 7. Related Documents
- [Document 1]
- [Document 2]

## 8. Definitions
| Term | Definition |
|------|------------|
| [Term] | [Definition] |

## 9. Revision History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Name] | Initial release |

---

**Approved by**: _________________ **Date**: _________
```

### Control Evidence Matrix Template

```markdown
# Control Evidence Matrix - [Framework Name]

| Control ID | Control Description | Implementation | Evidence Location | Owner | Last Reviewed |
|------------|---------------------|----------------|-------------------|-------|---------------|
| [ID] | [Description] | [How implemented] | [Path/Link] | [Name] | [Date] |
```

### Access Review Template

```markdown
# Privileged Access Review - Q[X] YYYY

**Review Period**: [Start Date] - [End Date]
**Reviewer**: [Name]
**Review Date**: [Date]

## Summary
- Total privileged users reviewed: [X]
- Access changes recommended: [X]
- Exceptions documented: [X]

## Review Results

| User | Role | Safe Access | Status | Action Required |
|------|------|-------------|--------|-----------------|
| [User] | [Role] | [Safes] | Appropriate/Excessive | [None/Remove/Modify] |

## Sign-off
Reviewed by: _________________ Date: _________
Approved by: _________________ Date: _________
```

---

## Quick Reference: Framework Contacts

### Official Resources

| Framework | Official Site | Certification Body |
|-----------|---------------|-------------------|
| NIST CSF | [nist.gov/cyberframework](https://www.nist.gov/cyberframework) | N/A (voluntary) |
| HIPAA | [hhs.gov/hipaa](https://www.hhs.gov/hipaa/) | HHS OCR |
| PCI-DSS | [pcisecuritystandards.org](https://www.pcisecuritystandards.org/) | QSA companies |
| SOC 2 | [aicpa.org/soc](https://www.aicpa.org/resources/landing/system-and-organization-controls-soc-suite-of-services) | CPA firms |
| ISO 27001 | [iso.org](https://www.iso.org/isoiec-27001-information-security.html) | Accredited certification bodies |
| FedRAMP | [fedramp.gov](https://www.fedramp.gov/) | 3PAO |

---

**Last Updated**: 2025-12-01
**Version**: 1.0
