# Glossary

Quick reference for all terminology used in the 18-Month Cybersecurity Roadmap.

---

## Certifications

### CyberArk Certifications
- **CyberArk Defender**: Entry-level CyberArk PAM certification focusing on basic administration and implementation. Target: Month 4
- **CyberArk Sentry**: Advanced-level CyberArk PAM certification for complex administration scenarios. Target: Month 6
- **CyberArk Guardian**: Expert-level CyberArk PAM certification demonstrating mastery of enterprise deployments. Target: Month 8

### Penetration Testing Certifications
- **eJPT (eLearnSecurity Junior Penetration Tester)**: INE entry-level practical pentesting certification. Target: Month 12
- **OSCP (Offensive Security Certified Professional)**: OffSec's flagship practical penetration testing certification requiring 90-day lab access and a 24-hour hands-on exam. Target: Month 17

### Cloud & Security Certifications
- **CCSP (Certified Cloud Security Professional)**: Vendor-neutral cloud security certification from (ISC)² focusing on cloud architecture, compliance, and security across AWS, Azure, and GCP. Archived from primary path; optional post-M18
- **CISSP (Certified Information Systems Security Professional)**: Industry gold standard security certification covering 8 domains of security. Optional after Month 18 if clients require it
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
- **Azure**: Microsoft's cloud computing platform (Microsoft Entra ID, Key Vault are key services)
- **Multi-cloud**: Architecture or strategy using multiple cloud providers (AWS + Azure in this roadmap)

---

## Roadmap Terminology

### Timeline Terms
- **Recovery Month**: Strategically placed light workload months to prevent burnout, consolidate learning, and allow for vacation
- **Phase 1**: Months 1-6 - PAM Foundations
- **Phase 2**: Months 7-12 - Pentesting + Advanced PAM
- **Phase 3**: Months 13-18 - Cloud + OSCP + Launch

### Project Terms
- **Portfolio Project**: Documented technical implementations demonstrating expertise (target: 6-8 projects by Month 18). These are showcased to potential clients
- **Capstone Project**: The comprehensive enterprise project built continuously from Month 1-18, integrating PAM + Conjur + Kubernetes + Pentesting + Compliance. Your ultimate portfolio showpiece
- **Deliverable**: Specific output expected at the end of a week, month, or phase (e.g., "Defender certification," "Project 3 documentation," "Lab environment operational")

### Study Terms
- **Hands-on Labs**: Practical implementation work (70% of study time). Building, configuring, troubleshooting actual systems
- **Study/Reading**: Theory, documentation reading, video courses (30% of study time)
- **Practice Tests**: Certification exam simulation tests. Goal: 90%+ before taking real exam
- **TryHackMe**: Online platform for guided cybersecurity training via interactive labs and learning paths; used in Phase 2 for pentesting foundations
- **HackTheBox**: Online platform with realistic "capture the flag" machines for advanced pentesting practice; used during OSCP prep in Phase 3

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

## Penetration Testing

- **Penetration Testing (Pentest)**: Authorized simulated attack on a system to find vulnerabilities before attackers do
- **OSCP**: Offensive Security Certified Professional; OffSec's flagship practical penetration testing certification
- **eJPT**: eLearnSecurity Junior Penetration Tester; INE entry-level practical pentesting certification
- **OffSec**: Offensive Security; the company behind OSCP, Kali Linux, and Proving Grounds
- **Kali Linux**: Debian-based Linux distribution purpose-built for penetration testing; pre-installed with security tools
- **Metasploit**: Open-source exploitation framework for developing and executing exploit code
- **Burp Suite**: Web application security testing platform; Community (free) and Pro (paid) versions
- **Nmap**: Network scanner for host discovery, port scanning, service detection, and OS fingerprinting
- **BloodHound**: Tool for visualizing Active Directory attack paths using graph theory
- **Impacket**: Python library for network protocols; key for Active Directory attacks (Kerberoasting, Pass-the-Hash, DCSync)
- **TryHackMe**: Online platform for guided cybersecurity training via interactive labs and learning paths
- **HackTheBox**: Online platform with realistic "capture the flag" machines for advanced pentesting practice
- **Kerberoasting**: Attack that requests Kerberos service tickets for accounts with SPNs, then cracks them offline; mitigated by CyberArk service account vaulting
- **Pass-the-Hash (PtH)**: Attack using captured NTLM hash for authentication without knowing the plaintext password; mitigated by CyberArk PSM session isolation
- **Privilege Escalation**: Gaining higher permissions on a compromised system (Linux: SUID, sudo; Windows: token impersonation)
- **PTES**: Penetration Testing Execution Standard; methodology framework for professional pentests
- **CVSS**: Common Vulnerability Scoring System; standardized method for rating vulnerability severity (0-10 scale)
- **Red Team**: Security team that simulates adversary attacks to test defenses; distinct from penetration testing
- **Rules of Engagement (ROE)**: Written agreement defining scope, authorized activities, and emergency procedures for a pentest
- **msfvenom**: Metasploit tool for generating shellcode and payloads for various platforms
- **Lateral Movement**: Technique attackers use to progressively move through a network after initial access
- **OSINT**: Open Source Intelligence; gathering information from publicly available sources during reconnaissance

---

## Related Documents

- **Need help with terms not listed?** → Ask in [FAQ.md](FAQ.md)
- **Understanding the timeline?** → See [roadmap/OVERVIEW.md](roadmap/OVERVIEW.md)
- **First time here?** → Start with [GETTING_STARTED.md](GETTING_STARTED.md)

---

**Last Updated**: 2026-04-14
**Version**: 2.0
