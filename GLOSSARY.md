# Glossary

Quick reference for all terminology used in the 27-Month Cybersecurity Roadmap.

---

## Certifications

### CyberArk Certifications
- **CyberArk Defender**: Entry-level CyberArk PAM certification focusing on basic administration and implementation. Target: Month 5
- **CyberArk Sentry**: Advanced-level CyberArk PAM certification for complex administration scenarios. Target: Month 8
- **CyberArk Guardian**: Expert-level CyberArk PAM certification demonstrating mastery of enterprise deployments. Target: Month 11

### Cloud & Security Certifications
- **CCSP (Certified Cloud Security Professional)**: Vendor-neutral cloud security certification from (ISC)² focusing on cloud architecture, compliance, and security across AWS, Azure, and GCP. Target: Month 27
- **CISSP (Certified Information Systems Security Professional)**: Industry gold standard security certification covering 8 domains of security. Optional after Month 27 if clients require it
- **CKA (Certified Kubernetes Administrator)**: Linux Foundation certification validating Kubernetes administration skills. **You already have this!**

---

## Technologies & Platforms

### Core Technologies
- **PAM (Privileged Access Management)**: Security practice and technology for controlling, monitoring, and auditing access to critical systems and data by privileged users (admins, service accounts, etc.)
- **Conjur**: CyberArk's open-source and enterprise secrets management platform that secures secrets (passwords, API keys, certificates) for applications, containers, and DevOps pipelines
- **CyberArk PAM**: Enterprise platform providing vaulting, session monitoring, and automated password management for privileged accounts

### Container & Cloud
- **K8s**: Common abbreviation for Kubernetes, the container orchestration platform
- **Kubernetes**: Open-source container orchestration platform for automating deployment, scaling, and management of containerized applications
- **Docker**: Containerization platform for packaging applications and dependencies into portable containers
- **CI/CD (Continuous Integration/Continuous Deployment)**: Automated pipeline for building, testing, and deploying code changes

### Cloud Platforms
- **AWS (Amazon Web Services)**: Amazon's cloud computing platform (IAM, KMS, Secrets Manager are key services for this roadmap)
- **Azure**: Microsoft's cloud computing platform (Azure AD/Entra ID, Key Vault are key services)
- **Multi-cloud**: Architecture or strategy using multiple cloud providers (AWS + Azure in this roadmap)

---

## Roadmap Terminology

### Timeline Terms
- **Recovery Month**: Strategically placed light workload months (8 hrs/week instead of 10-12) at Month 12, Month 18, and Month 27 to prevent burnout, consolidate learning, and allow for vacation
- **Phase 1**: Months 1-11 - PAM + Kubernetes Mastery
- **Phase 2**: Months 12-18 - Conjur + DevSecOps
- **Phase 3**: Months 19-27 - Cloud Security + CCSP

### Project Terms
- **Portfolio Project**: Documented technical implementations demonstrating expertise (target: 7-8 projects by Month 27). These are showcased to potential clients
- **Capstone Project**: The comprehensive enterprise project built continuously from Month 1-27, integrating PAM + Conjur + Kubernetes + Multi-cloud + Compliance. Your ultimate portfolio showpiece
- **Deliverable**: Specific output expected at the end of a week, month, or phase (e.g., "Defender certification," "Project 3 documentation," "Lab environment operational")

### Study Terms
- **Hands-on Labs**: Practical implementation work (70% of study time). Building, configuring, troubleshooting actual systems
- **Study/Reading**: Theory, documentation reading, video courses (30% of study time)
- **Practice Tests**: Certification exam simulation tests. Goal: 90%+ before taking real exam

---

## Consulting & Business Terms

### Consulting Documents
- **RFP (Request for Proposal)**: Document from potential client requesting proposals for a project. You'll need to respond to these professionally
- **SOW (Statement of Work)**: Detailed agreement defining scope, deliverables, timeline, and pricing for a consulting engagement
- **Case Study**: Written analysis of a real or hypothetical project showing problem, solution, and business value. Used to demonstrate expertise to potential clients

### Consulting Skills
- **Client-facing**: Work or communication directly with clients (presentations, meetings, deliverables)
- **C-level/Executive communication**: Ability to explain technical concepts to CEOs, CIOs, and other executives in business terms
- **Technical presentation**: Presenting architecture, solutions, or recommendations to technical audiences
- **Proposal writing**: Creating professional responses to RFPs including technical solution, timeline, and pricing

---

## Security & Compliance Frameworks

### Compliance Regulations
- **HIPAA (Health Insurance Portability and Accountability Act)**: U.S. healthcare data protection regulation. Critical for healthcare clients
- **PCI-DSS (Payment Card Industry Data Security Standard)**: Security standard for organizations handling credit card data. Critical for banking/fintech clients
- **GDPR (General Data Protection Regulation)**: European Union data protection regulation with global impact
- **SOC 2 (Service Organization Control 2)**: Audit framework for service providers demonstrating security controls

### Security Concepts
- **Zero Trust**: Security model assuming no implicit trust, verifying every access request
- **Principle of Least Privilege (PoLP)**: Security practice of granting minimum access rights needed to perform a job
- **Secrets Management**: Practice and technology for securely storing, distributing, and rotating sensitive credentials
- **DevSecOps**: Integration of security practices into DevOps workflows and CI/CD pipelines
- **Session Recording**: Capturing privileged user sessions for audit and compliance purposes

---

## CyberArk Component Terminology

### PAM Components
- **Password Vault**: Core component storing and encrypting all privileged credentials
- **CPM (Central Policy Manager)**: Component that automatically rotates and manages passwords according to policies
- **PSM (Privileged Session Manager)**: Component that proxies and records privileged sessions
- **PVWA (Password Vault Web Access)**: Web interface for users to access the PAM system
- **Safe**: Logical container in CyberArk Vault for organizing and securing related accounts/credentials

### Conjur Components
- **Policy-as-Code**: Defining access control rules in YAML/code format rather than GUI configuration
- **Conjur Policy**: YAML-based access control rules defining who/what can access which secrets
- **Host Identity**: Authentication method where machines/containers prove their identity to Conjur
- **Kubernetes Authenticator**: Conjur component enabling K8s pods to authenticate using their service account
- **Secretless Broker**: Sidecar pattern allowing applications to access secrets without embedding credentials

---

## English Learning Terms

### Proficiency Levels (Roadmap-specific)
- **Phase 1 English** (Months 1-6): Reading technical documentation, taking notes in English
- **Phase 2 English** (Months 7-12): Writing technical documentation and participating in forums
- **Phase 3 English** (Months 13-18): Professional communication, blog articles, presentations
- **Phase 4 English** (Months 19-24): Consulting materials, proposals, executive communication
- **Phase 5 English** (Months 25-27): Consulting-level fluency, client-ready communication

---

## Common Abbreviations

- **M[number]**: Month abbreviation (e.g., M12 = Month 12)
- **HA**: High Availability
- **DR**: Disaster Recovery
- **IAM**: Identity and Access Management (also AWS IAM service)
- **RBAC**: Role-Based Access Control
- **MFA**: Multi-Factor Authentication
- **API**: Application Programming Interface
- **JWT**: JSON Web Token (authentication method)
- **OIDC**: OpenID Connect (authentication protocol)
- **SIEM**: Security Information and Event Management

---

## Related Documents

- **Need help with terms not listed?** → Ask in [FAQ.md](FAQ.md)
- **Understanding the timeline?** → See [roadmap/OVERVIEW.md](roadmap/OVERVIEW.md)
- **First time here?** → Start with [GETTING_STARTED.md](GETTING_STARTED.md)

---

**Last Updated**: 2025-11-21
**Version**: 1.0
