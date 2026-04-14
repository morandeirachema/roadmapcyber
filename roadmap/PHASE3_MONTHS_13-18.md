# Phase 3: Cloud Security + Advanced Pentesting + Consulting Launch (Months 13-18)

**Duration**: 6 months (24 weeks)
**Weekly Commitment**: 14-15 hrs/week standard; 8 hrs/week recovery in M18
**Focus**: OSCP, multi-cloud Conjur, cloud pentesting, consulting practice launch
**Calendar**: May 2027 – October 2027

---

## Overview

Phase 3 is the hardest and most rewarding stretch. You will spend five months grinding on OSCP (the industry-standard offensive certification), stand up Conjur across AWS and Azure, learn cloud pentesting by actually attacking AWS and Azure AD labs, and finally launch your consulting practice. By Month 18 you have 3 CyberArk certifications, eJPT, OSCP, and 6 portfolio projects — a rare and defensible credential stack.

### Primary Objectives

1. **Earn OSCP (M17, September 2027)** — OffSec's flagship practical certification. The single credential that validates your offensive security skills to any buyer.
2. **Deploy Conjur multi-cloud** — AWS IAM integration and Azure Entra ID integration, with Kubernetes workloads consuming secrets.
3. **Build cloud pentesting skills** — CloudGoat for AWS, ROADtools for Azure AD / Entra. Cloud pentesting is the fastest-growing niche in the industry.
4. **Launch consulting practice** — by Month 18: business entity, contracts, rate card, website, LinkedIn presence, first outreach.

### The OSCP Challenge (Honest Framing)

OSCP is the hardest milestone in this program. Industry first-attempt pass rate hovers around 53%. With proper preparation — eJPT already earned + five months of dedicated study + two mock 24-hour exams — you should target a **75%+ probability** of passing on the first attempt.

The OSCP exam is 24 hours hands-on + 24 hours to write the report. Passing requires 70 points, and the AD chain is worth 40 points as a single unit. The exam tests **methodology discipline** — can you enumerate thoroughly, document every step, pivot cleanly, and keep your head after hour 14 — not raw technical wizardry. This is why eJPT first matters: you build the habits on an easier exam.

If you fail the first attempt, OffSec gives one free retake within 12 months. The Month 17 contingency plan covers this.

### Cloud Pentesting = Cloud Security

The fastest way to learn AWS and Azure security is to attack it. CloudGoat (Rhino Security Labs) drops you into deliberately vulnerable AWS environments and walks you through IAM privilege escalation, S3 exposure, SSRF-to-IMDS, and EC2 credential theft. ROADtools enumerates Azure AD / Entra ID the way an attacker would. When you build the M15 portfolio project (Multi-Cloud Secrets Architecture), you will already understand the attack surface you are defending.

### Consulting Launch Strategy

By Month 18 you will hold:
- 3 CyberArk certifications (Defender, Sentry, Guardian)
- 2 offensive certifications (eJPT, OSCP)
- 6 portfolio projects on GitHub
- 18 months of documented deliberate practice

This unlocks **two revenue streams in one** — PAM consulting and penetration testing services. Few independent consultants can credibly sell both. The M17-M18 launch sequence converts this into a live business.

### Success Metrics (by Month 18)

- [ ] OSCP certification passed
- [ ] Conjur multi-cloud (AWS + Azure) operational
- [ ] 6 portfolio projects published
- [ ] Consulting practice launched (entity + contracts + website + first outreach)
- [ ] First paying engagement in pipeline or signed

---

## Phase Structure

### Month 13: OSCP PEN-200 Begins + Conjur in Kubernetes HA

**Objective**: Buy OSCP 90-day lab access at the start of May 2027 (the window expires roughly late August, which lines up with M16 exam prep). Start the PEN-200 course. Build a Conjur HA deployment on Kubernetes and publish Portfolio Project 3's CI/CD secrets integration.

**Purchase timing**: Buy OSCP at the **start of May 2027**. This maximizes the 90-day lab window so it is still active during exam prep in M16.

**Time Allocation**: 14-15 hrs/week
- PEN-200 course: 7 hrs/week
- OSCP lab machines: 4 hrs/week
- Conjur K8s HA: 3 hrs/week

**Key Activities**:
- PEN-200 modules 1-5: Report Writing, Information Gathering, Vulnerability Scanning, Introduction to Web Application Attacks, SQL Injection
- Conjur Kubernetes authenticator with pod-level secrets injection (secretless broker pattern or sidecar)
- HA considerations: Conjur cluster, load balancer, PostgreSQL backup/restore
- 5 OSCP lab machines documented (Obsidian / CherryTree notes)
- Portfolio Project 3 final polish and publish: Conjur + CI/CD Secrets Management

**Deliverables**:
- PEN-200 course 25% complete
- 5 OSCP lab machines in notes
- Conjur K8s HA deployment working
- **Portfolio Project 3 (Conjur + CI/CD Secrets Management) published**

---

### Month 14: OSCP Deep Dive + Multi-Cloud Secrets

**Objective**: Power through the core PEN-200 modules including the AD chain. Stand up AWS IAM integration with Conjur.

**Time Allocation**: 14-15 hrs/week
- PEN-200 + OSCP labs: 10 hrs/week
- Cloud / Conjur multi-cloud: 4-5 hrs/week

**Key Activities**:
- PEN-200 modules 6-10: Client-Side Attacks / Antivirus Evasion, Fixing Exploits, Locating Public Exploits, SSH Tunneling, Advanced Tunneling, Metasploit Framework, Password Attacks
- OSCP AD modules: Active Directory Introduction and Enumeration, Attacking AD Authentication, Lateral Movement in AD, AD Persistence
- 15 OSCP lab machines cumulative (10 more this month)
- AWS IAM roles + instance profile + Conjur integration (Conjur as secret broker for AWS resources)

**Deliverables**:
- PEN-200 course 55% complete
- 15 OSCP lab machines cumulative
- AWS + Conjur integration working and documented
- AD chain practiced at least twice in lab

---

### Month 15: OSCP Challenge Labs + Cloud Pentesting

**Objective**: Finish PEN-200 course content. Complete one OSCP Challenge Lab network under exam conditions. Attack CloudGoat and Azure AD with ROADtools.

**Time Allocation**: 14-15 hrs/week
- PEN-200 finish + Challenge Lab: 10 hrs/week
- CloudGoat + ROADtools: 4-5 hrs/week

**Key Activities**:
- PEN-200 modules 11-end (remaining Windows/Linux privesc + capstone)
- OSCP-A / OSCP-B / OSCP-C Challenge Labs: pick one AD-focused lab and complete under exam conditions (enumeration → foothold → AD chain → report)
- CloudGoat AWS scenarios (at least 2): S3 exposure, IAM privilege escalation, SSRF to IMDS
- Azure AD enumeration with ROADtools and ROADrecon
- Entra ID service principal abuse walkthrough
- Portfolio Project 4 drafted: Multi-Cloud Secrets Architecture (AWS + Azure + Conjur)

**Deliverables**:
- PEN-200 course 100% complete
- 1 Challenge Lab network completed end-to-end with a written report
- 2 CloudGoat scenarios documented
- **Portfolio Project 4 (Multi-Cloud Secrets Architecture) published**

---

### Month 16: OSCP Exam Prep + DevSecOps Security Audit

**Objective**: Two full 24-hour mock exam attempts. Write Portfolio Project 5: a DevSecOps security audit of your own Phase 1 CI/CD pipeline.

**Time Allocation**: 14-15 hrs/week

**Key Activities**:
- Buy the OffSec 10-day lab extension if the 90-day window is closing
- Focused drilling on the AD chain (40 points of the 70 needed to pass)
- **Mock Exam #1**: full 24-hour practical attempt, notes in Obsidian/CherryTree, write the report afterwards
- **Mock Exam #2**: same, two weeks later
- Write 3 full pentest reports from previous lab machines (practice the report format)
- Security audit of your Phase 1 CI/CD pipeline: SAST findings triage, DAST run, secrets-in-git-history scan, container image CVE triage
- Schedule OSCP exam for Month 17

**Deliverables**:
- 2 mock 24-hour exams completed with reports
- 3 additional pentest reports written
- **Portfolio Project 5 (DevSecOps Security Audit) published**
- OSCP exam scheduled

---

### Month 17: OSCP EXAM + Consulting Pre-Launch

**Objective**: Pass OSCP. Begin consulting launch preparations in parallel (post-exam).

**Time Allocation**: 14-15 hrs/week

**Key Activities**:
- **Week 1**: Final prep (review notes, one HackTheBox machine for confidence, rest)
- **Weeks 2-3**: **OSCP 24-HOUR EXAM** + 24-hour report submission
- **Week 4**: Consulting website draft, LinkedIn profile update, GitHub portfolio polish, capstone project (Project 6) started

**Contingency — If exam fails**:
OffSec provides one free retake within 12 months. **Launch consulting anyway** — do not wait. Guardian + eJPT alone is a strong credential stack for a first engagement, and "OSCP candidate" status is acceptable. Schedule the retake for M20 or M21 and keep moving. The consulting practice does not depend on a single exam result.

**Deliverables**:
- **OSCP certification** (expected; retake plan if not)
- Consulting website draft
- Updated LinkedIn profile
- Polished GitHub portfolio landing page (index of all 6 projects)
- Portfolio Project 6 (Enterprise Capstone) started

---

### Month 18: RECOVERY + CONSULTING LAUNCH

**Objective**: Recovery pace (8 hrs/week). Launch the consulting practice.

**Time Allocation**: **8 hrs/week** (recovery)

**Key Activities**:
- **Week 1-2**: Rest after OSCP. No forced work.
- **Week 3**: Finalize `CONSULTING_LAUNCH_CHECKLIST` — register business entity, finalize MSA / SOW contract templates, publish rate card, lock in service offerings:
  - PAM implementation (CyberArk Defender / Sentry / Guardian work)
  - Security assessment (internal network + AD pentest)
  - DevSecOps pipeline security audits
- **Week 4**: Portfolio Project 6 (Enterprise Capstone: PAM + Conjur + Pentest Assessment) final publish. **GO LIVE** — website published, LinkedIn announcement, first outreach to network.

**Rate Card Guidance** (North American market, April 2026 baseline, adjust for your market):
- Pentesting: **$175 – $225 / hr**
- PAM implementation: **$200 – $275 / hr**
- Combined assessment + implementation engagements: **$250 – $350 / hr**

**Deliverables**:
- Consulting practice **launched**
- 6 portfolio projects published
- OSCP certification
- Business entity registered, rate card published, contracts templated
- **Portfolio Project 6 (Enterprise Capstone: PAM + Conjur + Pentest Assessment) published**

---

## Resources

- OffSec PEN-200: https://www.offsec.com/courses/pen-200/
- OffSec Proving Grounds: https://www.offensive-security.com/labs/
- CloudGoat: https://github.com/RhinoSecurityLabs/cloudgoat
- ROADtools: https://github.com/dirkjanm/ROADtools
- HackTheBox: https://www.hackthebox.com
- AWS IAM documentation: https://docs.aws.amazon.com/iam/
- Microsoft Entra ID documentation: https://learn.microsoft.com/entra/
- [docs/OSCP_CERTIFICATION_GUIDE.md](../docs/OSCP_CERTIFICATION_GUIDE.md)
- [docs/ACTIVE_DIRECTORY_ATTACK_GUIDE.md](../docs/ACTIVE_DIRECTORY_ATTACK_GUIDE.md)
- [docs/CONSULTING_LAUNCH_CHECKLIST.md](../docs/CONSULTING_LAUNCH_CHECKLIST.md)

---

**Last Updated**: 2026-04-14
**Version**: 1.0
