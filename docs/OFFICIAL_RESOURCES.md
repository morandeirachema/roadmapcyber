# Official Resources & External Documentation

Curated collection of official documentation, training resources, and authoritative references for the 18-month PAM + Pentesting roadmap. Organized by track and technology.

---

## Table of Contents

1. [CyberArk Resources](#cyberark-resources)
2. [Penetration Testing & Offensive Security](#penetration-testing--offensive-security)
3. [Kubernetes Resources](#kubernetes-resources)
4. [Cloud Security](#cloud-security)
5. [Certification Bodies](#certification-bodies)
6. [Compliance & Standards](#compliance--standards)
7. [Security Tools](#security-tools)
8. [Learning Platforms](#learning-platforms)
9. [Community Resources](#community-resources)
10. [Quick Reference by Roadmap Phase](#quick-reference-by-roadmap-phase)

---

## CyberArk Resources

### Official Documentation

| Resource | URL | Description |
|----------|-----|-------------|
| CyberArk Docs Portal | [docs.cyberark.com](https://docs.cyberark.com) | Complete product documentation |
| CyberArk Marketplace | [marketplace.cyberark.com](https://marketplace.cyberark.com) | Integrations and extensions |
| CyberArk Campus | [cyberark.com/services-support/cyberark-campus](https://www.cyberark.com/services-support/cyberark-campus/) | Free training and labs |
| CyberArk Community | [community.cyberark.com](https://community.cyberark.com) | Forums and discussions |
| CyberArk Support | [cyberark-customers.force.com](https://cyberark-customers.force.com/s/) | Customer support portal |
| CyberArk Trust Portal | [trust.cyberark.com](https://trust.cyberark.com) | Security and compliance status |

### Product-Specific Documentation

| Product | Documentation Link |
|---------|-------------------|
| Privileged Access Manager (PAM) | [PAM Documentation](https://docs.cyberark.com/pam-self-hosted/latest/en/content/landing/landingpgs/landing-pam.htm) |
| Conjur Secrets Manager | [Conjur Documentation](https://docs.cyberark.com/conjur-cloud/latest/en/content/landing/landingpgs/landing-conjur.htm) |
| Endpoint Privilege Manager | [EPM Documentation](https://docs.cyberark.com/epm/latest/en/content/landing/landingpgs/landing-epm.htm) |
| Identity Security Platform | [Identity Documentation](https://docs.cyberark.com/identity/latest/en/content/landing/landingpgs/landing-identity.htm) |
| CyberArk Secure Browser | [Secure Browser Docs](https://docs.cyberark.com/secure-browser/latest/en/content/landing/landingpgs/landing-securebrowser.htm) |

### Certification Resources

| Certification | Study Resources |
|---------------|-----------------|
| CyberArk Defender | [Defender Exam Guide](https://www.cyberark.com/services-support/cyberark-campus/) |
| CyberArk Sentry | [Sentry Exam Guide](https://www.cyberark.com/services-support/cyberark-campus/) |
| CyberArk Guardian | [Guardian Exam Guide](https://www.cyberark.com/services-support/cyberark-campus/) |
| CyberArk Trustee | [Trustee Exam Guide](https://www.cyberark.com/services-support/cyberark-campus/) |

---

## Penetration Testing & Offensive Security

### Certifications

| Certification | URL | Description |
|---|---|---|
| OffSec OSCP (PEN-200) | https://www.offsec.com/courses/pen-200/ | The primary pentesting cert in this roadmap — 90-day lab + 24h practical exam |
| OffSec PEN-200 Syllabus | https://www.offsec.com/documentation/penetration-testing-with-kali.pdf | Full course outline |
| INE eJPT (PTS Course) | https://ine.com/learning/certifications/internal/elearnsecurity-junior-penetration-tester-cert | Entry-level practical cert (M12) |
| INE Platinum Pass | https://checkout.ine.com/starter-pass | Includes PTS course, lab access, eJPT exam voucher |
| OffSec Proving Grounds | https://www.offensive-security.com/labs/ | Practice machines for OSCP prep (optional supplement) |

### Practice Platforms

| Platform | URL | Phase | Description |
|---|---|---|---|
| TryHackMe | https://tryhackme.com | M5-M11 | Best guided learning platform; strong AD and web app paths |
| TryHackMe Jr Pentester Path | https://tryhackme.com/path/outline/jrpenetrationtester | M7-M10 | Core path for eJPT preparation |
| HackTheBox | https://www.hackthebox.com | M9-M17 | OSCP-style boxes; public profile ranks as a credential |
| HackTheBox Starting Point | https://app.hackthebox.com/starting-point | M9-M10 | Guided boxes for early practice |
| PortSwigger Web Security Academy | https://portswigger.net/web-security | M3-M8 | Best free web application security training available |
| OffSec Proving Grounds Practice | https://www.offensive-security.com/labs/ | M15-M17 | OSCP-quality practice machines |
| DVWA (GitHub) | https://github.com/digininja/DVWA | M3-M5 | Deliberately vulnerable web app for local lab |
| VulnHub | https://www.vulnhub.com | M8-M12 | Downloadable vulnerable VMs for offline practice |

### Key Tools Documentation

| Tool | URL | Description |
|---|---|---|
| Kali Linux | https://www.kali.org | Primary attack platform; official docs and tool lists |
| Kali Tools Documentation | https://www.kali.org/tools/ | Full tool index |
| Metasploit Documentation | https://docs.metasploit.com | Framework docs |
| Metasploit Unleashed | https://www.offsec.com/metasploit-unleashed/ | Free Metasploit course by OffSec |
| Impacket (GitHub) | https://github.com/fortra/impacket | Python tools for Windows/AD attacks |
| BloodHound CE (GitHub) | https://github.com/SpecterOps/BloodHound | AD attack path enumeration |
| CrackMapExec / NetExec | https://github.com/Pennyw0rth/NetExec | SMB, WMI, and AD Swiss Army knife |
| Chisel (GitHub) | https://github.com/jpillora/chisel | TCP tunneling for pivoting |
| Burp Suite | https://portswigger.net/burp | Web application proxy and scanner |
| Gobuster / Feroxbuster | https://github.com/OJ/gobuster | Directory and subdomain brute forcing |
| GTFOBins | https://gtfobins.github.io | Unix binaries for privilege escalation and bypass |
| LOLBAS | https://lolbas-project.github.io | Windows Living Off the Land Binaries |
| linpeas / winPEAS | https://github.com/peass-ng/PEASS-ng | Automated privilege escalation checks |
| CloudGoat | https://github.com/RhinoSecurityLabs/cloudgoat | Intentionally vulnerable AWS environments |
| ROADtools | https://github.com/dirkjanm/ROADtools | Azure AD / Entra ID enumeration |
| SearchSploit / ExploitDB | https://www.exploit-db.com | Public exploit database |

### Methodology and Reference

| Resource | URL | Description |
|---|---|---|
| PTES (Penetration Testing Execution Standard) | http://www.pentest-standard.org | The methodology framework used in this roadmap |
| MITRE ATT&CK | https://attack.mitre.org | Adversary tactics and techniques framework |
| OWASP Top 10 | https://owasp.org/www-project-top-ten/ | Web application vulnerability classification |
| OWASP Testing Guide | https://owasp.org/www-project-web-security-testing-guide/ | Comprehensive web pentesting methodology |
| HackTricks | https://book.hacktricks.xyz | Community pentesting knowledge base |
| PayloadsAllTheThings | https://github.com/swisskyrepo/PayloadsAllTheThings | Payloads and bypass techniques |
| IppSec YouTube | https://www.youtube.com/@ippsec | HackTheBox video walkthroughs (after machine retires) |

---

## Kubernetes Resources

### Official Documentation

| Resource | URL | Description |
|----------|-----|-------------|
| Kubernetes Docs | [kubernetes.io/docs](https://kubernetes.io/docs/) | Official documentation |
| Kubernetes Blog | [kubernetes.io/blog](https://kubernetes.io/blog/) | News and updates |
| Kubernetes GitHub | [github.com/kubernetes](https://github.com/kubernetes/kubernetes) | Source code |

### Security-Specific Documentation

| Topic | Documentation Link |
|-------|-------------------|
| Security Overview | [Kubernetes Security](https://kubernetes.io/docs/concepts/security/) |
| Pod Security Standards | [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) |
| RBAC Authorization | [RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) |
| Network Policies | [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) |
| Secrets Management | [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) |
| Service Accounts | [Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) |
| Security Best Practices | [Securing a Cluster](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/) |

### Community Resources

| Resource | URL |
|----------|-----|
| Kubernetes Slack | [slack.kubernetes.io](https://slack.kubernetes.io/) |

---

## Cloud Security

### Amazon Web Services (AWS)

| Resource | URL | Description |
|----------|-----|-------------|
| AWS Security Hub | [AWS Security](https://aws.amazon.com/security/) | Security overview |
| AWS IAM Documentation | [IAM Docs](https://docs.aws.amazon.com/iam/) | Identity management |
| AWS Secrets Manager | [Secrets Manager](https://docs.aws.amazon.com/secretsmanager/) | Secrets management |
| AWS KMS | [KMS Docs](https://docs.aws.amazon.com/kms/) | Key management |
| AWS Well-Architected (Security) | [Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/) | Best practices |
| AWS Security Best Practices | [Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/) | Architecture |

### Microsoft Azure

| Resource | URL | Description |
|----------|-----|-------------|
| Azure Security Center | [Azure Security](https://azure.microsoft.com/en-us/products/defender-for-cloud/) | Security overview |
| Azure AD / Entra ID | [Entra ID Docs](https://learn.microsoft.com/en-us/entra/identity/) | Identity management |
| Azure Key Vault | [Key Vault Docs](https://learn.microsoft.com/en-us/azure/key-vault/) | Secrets & keys |
| Azure Security Benchmark | [Security Benchmark](https://learn.microsoft.com/en-us/security/benchmark/azure/) | Best practices |
| Azure RBAC | [Azure RBAC](https://learn.microsoft.com/en-us/azure/role-based-access-control/) | Access control |

### Google Cloud Platform (GCP)

| Resource | URL | Description |
|----------|-----|-------------|
| GCP Security | [Cloud Security](https://cloud.google.com/security) | Security overview |
| Cloud IAM | [IAM Docs](https://cloud.google.com/iam/docs) | Identity management |
| Secret Manager | [Secret Manager](https://cloud.google.com/secret-manager/docs) | Secrets management |
| Security Command Center | [SCC Docs](https://cloud.google.com/security-command-center/docs) | Security posture |

---

## Certification Bodies

### OffSec

| Resource | URL |
|----------|-----|
| OffSec Official Site | https://www.offsec.com |
| OSCP (PEN-200) | https://www.offsec.com/courses/pen-200/ |
| OffSec Learning Library | https://www.offsec.com/library/ |
| OffSec Discord | https://discord.gg/offsec |

### INE Security

| Resource | URL |
|----------|-----|
| INE Official Site | https://ine.com |
| eJPT Certification | https://ine.com/learning/certifications/internal/elearnsecurity-junior-penetration-tester-cert |
| Penetration Testing Student (PTS) Course | https://ine.com/learning/paths/penetration-testing-student |
| INE Platinum Pass | https://checkout.ine.com/starter-pass |

### Linux Foundation (CKA)

| Resource | URL |
|----------|-----|
| Linux Foundation Training | https://training.linuxfoundation.org/ |
| CKA Certification | https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/ |

Note: CKS is an optional post-M18 enhancement; it is not in the primary cert path. See `docs/archive/CKS_CERTIFICATION_GUIDE.md`.

### ISC² (Optional Post-M18)

| Resource | URL |
|----------|-----|
| ISC2 Official Site | https://www.isc2.org/ |
| CISSP | https://www.isc2.org/certifications/cissp |
| CCSP | https://www.isc2.org/certifications/ccsp |

Note: Neither CCSP nor CISSP is in the 18-month primary path. Consider post-M18 based on client demand. CCSP is archived at `docs/archive/CCSP_CERTIFICATION_GUIDE.md`.

---

## Compliance & Standards

### NIST (National Institute of Standards and Technology)

| Standard | URL | Description |
|----------|-----|-------------|
| NIST Cybersecurity Framework | [CSF](https://www.nist.gov/cyberframework) | Risk management framework |
| NIST SP 800-207 (Zero Trust) | [SP 800-207](https://csrc.nist.gov/pubs/sp/800/207/final) | Zero Trust Architecture *(URL updated; old /publications/detail path redirects)* |
| NIST SP 800-53 (Security Controls) | [SP 800-53](https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final) | Security controls catalog Rev 5 Update 1 |
| NIST SP 800-63 (Digital Identity) | [SP 800-63B](https://pages.nist.gov/800-63-4/) | Identity guidelines (63-4 draft in progress as of 2026) |

### Industry Compliance

| Standard | URL | Description |
|----------|-----|-------------|
| HIPAA | [HHS HIPAA](https://www.hhs.gov/hipaa/) | Healthcare compliance |
| PCI-DSS | [PCI Security Standards](https://www.pcisecuritystandards.org/) | Payment card industry |
| SOC 2 | [AICPA SOC](https://www.aicpa.org/resources/landing/system-and-organization-controls-soc-suite-of-services) | Service organization controls |
| GDPR | [GDPR Portal](https://gdpr.eu/) | EU data protection |
| ISO 27001 | [ISO 27001](https://www.iso.org/isoiec-27001-information-security.html) | Information security |

### CIS (Center for Internet Security)

| Resource | URL |
|----------|-----|
| CIS Benchmarks | [cisecurity.org/cis-benchmarks](https://www.cisecurity.org/cis-benchmarks) |
| CIS Kubernetes Benchmark | [Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes) |
| CIS Controls | [CIS Controls](https://www.cisecurity.org/controls) |

---

## Security Tools

### Container Security

| Tool | URL | Description |
|------|-----|-------------|
| Trivy | [aquasecurity.github.io/trivy](https://aquasecurity.github.io/trivy/) | Vulnerability scanner |
| Falco | [falco.org](https://falco.org/) | Runtime security |
| kube-bench | [github.com/aquasecurity/kube-bench](https://github.com/aquasecurity/kube-bench) | CIS benchmark checker |
| kubesec | [kubesec.io](https://kubesec.io/) | Security risk analysis |
| OPA/Gatekeeper | [open-policy-agent.github.io](https://open-policy-agent.github.io/gatekeeper/) | Policy engine |
| Kyverno | [kyverno.io](https://kyverno.io/) | Policy management |
| Sigstore/cosign | [sigstore.dev](https://www.sigstore.dev/) | Image signing and supply chain security |
| Tetragon | [tetragon.io](https://tetragon.io/) | eBPF-based runtime security (Cilium project) |

### Secrets Management

| Tool | URL | Description |
|------|-----|-------------|
| HashiCorp Vault | [vaultproject.io](https://www.vaultproject.io/) | Secrets management |
| External Secrets Operator | [external-secrets.io](https://external-secrets.io/) | Kubernetes secrets sync |
| Sealed Secrets | [github.com/bitnami-labs/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets) | Encrypted secrets |
| SOPS | [github.com/getsops/sops](https://github.com/getsops/sops) | Secrets encryption |

### Infrastructure as Code

| Tool | URL | Description |
|------|-----|-------------|
| Terraform | [terraform.io](https://www.terraform.io/) | Infrastructure provisioning |
| Ansible | [ansible.com](https://www.ansible.com/) | Configuration management |
| Pulumi | [pulumi.com](https://www.pulumi.com/) | Infrastructure as code |

---

## Learning Platforms

### Free

| Platform | URL | Primary Use |
|----------|-----|-------------|
| CyberArk Campus | https://www.cyberark.com/services-support/cyberark-campus/ | CyberArk certification courses and labs |
| PortSwigger Web Security Academy | https://portswigger.net/web-security | Burp Suite and web application security |
| Metasploit Unleashed | https://www.offsec.com/metasploit-unleashed/ | Metasploit framework |
| TryHackMe (free tier) | https://tryhackme.com | Guided pentesting rooms (premium needed for full paths) |
| AWS Skill Builder | https://skillbuilder.aws/ | AWS training |
| Microsoft Learn | https://learn.microsoft.com/ | Azure and Entra ID training |
| Google Cloud Skills Boost | https://www.cloudskillsboost.google/ | GCP training |

### Paid (in the Program Budget)

| Platform | URL | Phase | Cost |
|----------|-----|-------|------|
| TryHackMe Premium | https://tryhackme.com | M5-M11 | ~$14/month |
| INE Platinum Pass | https://ine.com | M7-M12 | $199-299/year |
| HackTheBox VIP | https://www.hackthebox.com | M9-M17 | $14/month |
| OffSec PEN-200 (90-day) | https://www.offsec.com/courses/pen-200/ | M13 | $1,499 |
| OffSec Proving Grounds Practice | https://www.offensive-security.com/labs/ | M15-M17 | $19/month |
| KodeKloud | https://kodekloud.com/ | Optional | Various |
| Udemy | https://www.udemy.com/ | As needed | Per course |

---

## Community Resources

### Forums & Discussion

| Community | URL |
|-----------|-----|
| CyberArk Commons | https://community.cyberark.com |
| OffSec Discord | https://discord.gg/offsec |
| TryHackMe Discord | https://discord.com/invite/tryhackme |
| HackTheBox Discord | https://discord.com/invite/hackthebox |
| Reddit r/oscp | https://www.reddit.com/r/oscp/ |
| Reddit r/netsec | https://www.reddit.com/r/netsec/ |
| Reddit r/cybersecurity | https://www.reddit.com/r/cybersecurity/ |
| Reddit r/kubernetes | https://www.reddit.com/r/kubernetes/ |
| Kubernetes Slack | https://slack.kubernetes.io/ |

### Security News & Blogs

| Resource | URL |
|----------|-----|
| CyberArk Blog | https://www.cyberark.com/blog/ |
| OffSec Blog | https://www.offsec.com/blog/ |
| The Hacker News | https://thehackernews.com/ |
| Dark Reading | https://www.darkreading.com/ |
| Krebs on Security | https://krebsonsecurity.com/ |
| Bleeping Computer | https://www.bleepingcomputer.com/ |

### Conferences

| Conference | URL | Relevance |
|------------|-----|-----------|
| CyberArk Impact (Annual) | https://www.cyberark.com/impact/ | Primary PAM networking event; attend M15 (May 2027) |
| DEF CON | https://defcon.org | Offensive security; attend M16 (Aug 2027) if budget allows |
| BSides (local) | https://securitybsides.com | Low-cost practitioner events; attend from M10 onward |
| Black Hat | https://www.blackhat.com | Enterprise security briefings |
| RSA Conference | https://www.rsaconference.com | Broad enterprise security |

---

## Quick Reference by Roadmap Phase

### Phase 1 (Months 1-6): PAM + Offensive Foundation

**PAM Track**:
- [CyberArk Documentation](https://docs.cyberark.com)
- [CyberArk Campus (free training)](https://www.cyberark.com/services-support/cyberark-campus/)
- [CyberArk Commons (community)](https://community.cyberark.com)

**Offensive Track**:
- [Kali Linux](https://www.kali.org)
- [TryHackMe (Intro to Offensive Security)](https://tryhackme.com/path/outline/introtooffensivesecurity)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [DVWA](https://github.com/digininja/DVWA)

### Phase 2 (Months 7-12): Pentesting + Advanced PAM + Conjur

**Pentesting Track**:
- [INE PTS Course (eJPT prep)](https://ine.com/learning/paths/penetration-testing-student)
- [TryHackMe Jr Pentester Path](https://tryhackme.com/path/outline/jrpenetrationtester)
- [HackTheBox](https://www.hackthebox.com)
- [BloodHound CE](https://github.com/SpecterOps/BloodHound)
- [Impacket](https://github.com/fortra/impacket)
- [GTFOBins](https://gtfobins.github.io)

**PAM/Conjur Track**:
- [Conjur Documentation](https://docs.cyberark.com/conjur-cloud/latest/en/content/landing/landingpgs/landing-conjur.htm)
- [Conjur OSS (GitHub)](https://github.com/cyberark/conjur)

### Phase 3 (Months 13-18): OSCP + Cloud Pentesting + Consulting Launch

**OSCP Track**:
- [OffSec PEN-200](https://www.offsec.com/courses/pen-200/)
- [OffSec Proving Grounds](https://www.offensive-security.com/labs/)
- [HackTheBox](https://www.hackthebox.com)
- [MITRE ATT&CK](https://attack.mitre.org)

**Cloud Pentesting**:
- [CloudGoat](https://github.com/RhinoSecurityLabs/cloudgoat)
- [ROADtools](https://github.com/dirkjanm/ROADtools)
- [AWS IAM Documentation](https://docs.aws.amazon.com/iam/)
- [Azure Entra ID Docs](https://learn.microsoft.com/en-us/entra/identity/)

**Consulting Launch**:
- [CyberArk Partner Program](https://www.cyberark.com/partners/)
- [NETWORKING_STRATEGY.md](NETWORKING_STRATEGY.md)

---

**Last Updated**: 2026-04-15
**Version**: 2.0
