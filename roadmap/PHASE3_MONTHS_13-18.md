# Phase 3: Cloud Security + Advanced Pentesting + Consulting Launch (Months 13-18)

**Duration**: 6 months (24 weeks)
**Weekly Commitment**: 14-15 hrs/week standard; 8 hrs/week recovery in M18
**Focus**: OSCP, multi-cloud Conjur, cloud pentesting, consulting practice launch
**Calendar**: May 2027 – October 2027

---

## Overview

Phase 3 is the hardest and most rewarding stretch. You will spend five months grinding on OSCP (the industry-standard offensive certification), stand up Conjur across AWS and Azure, learn cloud pentesting by actually attacking AWS and Azure AD labs, and finally launch your consulting practice. By Month 18 you have 3 CyberArk certifications, eJPT, OSCP, and 7 portfolio projects — a rare and defensible credential stack.

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
- 7 portfolio projects on GitHub
- 18 months of documented deliberate practice

This unlocks **two revenue streams in one** — PAM consulting and penetration testing services. Few independent consultants can credibly sell both. The M17-M18 launch sequence converts this into a live business.

### Success Metrics (by Month 18)

- [ ] OSCP certification passed
- [ ] Conjur multi-cloud (AWS + Azure) operational
- [ ] 7 portfolio projects published
- [ ] Consulting practice launched (entity + contracts + website + first outreach)
- [ ] First paying engagement in pipeline or signed

---

## Phase Structure

### Month 13: OSCP PEN-200 Begins + Conjur in Kubernetes HA

**Objective**: Buy OSCP **120-day** lab access at the start of May 2027 (+$200 vs 90-day, eliminates the cliff at Month 16). Start PEN-200 course. Machine grinding starts Week 1 — the course is reference material, not a gate. Build Conjur HA on Kubernetes.

**Purchase timing**: Buy OSCP at the **start of May 2027** with **120-day** lab access. Window expires mid-September, giving buffer for exam prep and a potential retake window.

**Time Allocation**: 14-15 hrs/week — **70% hands-on, 30% course reading**
- OSCP lab machines: **8 hrs/week**
- PEN-200 course: 4 hrs/week (read chapters that match what you're stuck on, not cover-to-cover)
- Conjur K8s HA: 3 hrs/week

**Key Activities**:
- Start with PEN-200 Report Writing module first — understand exactly what the grader expects before you touch a machine
- PEN-200 modules 1-5 as reference: Information Gathering, Vulnerability Scanning, Web Attacks, SQL Injection
- **OSCP lab machines Week 1**: start immediately. Read the PEN-200 chapter only if you get stuck on a specific technique
- Conjur Kubernetes authenticator with pod-level secrets injection (secretless broker pattern or sidecar)
- HA considerations: Conjur cluster, load balancer, PostgreSQL backup/restore
- 8 OSCP lab machines documented (Obsidian / CherryTree — see HANDS_ON_LABS_PHASE3.md for the machine note template and stuck protocol)
- Portfolio Project 5 final polish and publish: Conjur + CI/CD Secrets Management

**Deliverables**:
- PEN-200 course 25% complete
- **8 OSCP lab machines documented** (increased from 5 — lab grinding starts immediately)
- Conjur K8s HA deployment working
- **Portfolio Project 5 (Conjur + CI/CD Secrets Management) published**

---

### Month 14: OSCP Lab Grinding + AD Chain Mastery + Multi-Cloud Secrets

**Objective**: This month is machine grinding first, course second. The AD chain (40 of 70 exam points) is all-or-nothing — master it here. Stand up AWS IAM integration with Conjur in the remaining hours.

**Time Allocation**: 14-15 hrs/week — **70% hands-on, 30% course**
- OSCP lab machines + AD chain practice: **10 hrs/week**
- PEN-200 course modules: 4-5 hrs/week
- AWS + Conjur multi-cloud: 3 hrs/week (reduced from plan to protect lab time)

**Key Activities**:
- PEN-200 AD modules as primary focus: Active Directory Introduction and Enumeration, Attacking AD Authentication, Lateral Movement in AD — read these chapters AND immediately replicate every technique in your own AD lab
- PEN-200 modules 6-10 as reference: Tunneling, AV Evasion, Password Attacks — read when you encounter these in lab machines
- **AD chain practice**: run the full attack chain (foothold → AS-REP/Kerberoasting → lateral movement → DCSync) in your own lab 3+ times until it is muscle memory
- 20 OSCP lab machines cumulative (12 more this month — push harder than M13)
- AWS IAM roles + instance profile + Conjur integration

**Deliverables**:
- PEN-200 course 55% complete
- **20 OSCP lab machines cumulative** (aggressive but achievable at 10 hrs/week)
- AWS + Conjur integration working and documented
- AD chain executed from scratch 3+ times, notes capturing every step

---

### Month 15: OSCP Challenge Labs + Cloud Pentesting

**Objective**: Finish PEN-200 course content. Complete one OSCP Challenge Lab network under exam conditions — this is your first real exam simulation. Attack CloudGoat and Azure AD with ROADtools.

**Time Allocation**: 14-15 hrs/week — **70% hands-on, 30% course**
- OSCP Challenge Lab + OffSec Proving Grounds machines: **8 hrs/week**
- PEN-200 finish (remaining modules): 3 hrs/week
- CloudGoat + ROADtools: 4 hrs/week

**Key Activities**:
- PEN-200 modules 11-end (remaining Windows/Linux privesc + capstone)
- OSCP-A / OSCP-B / OSCP-C Challenge Labs: pick one AD-focused lab and complete under exam conditions (enumeration → foothold → AD chain → report)
- CloudGoat AWS scenarios (at least 2): S3 exposure, IAM privilege escalation, SSRF to IMDS
- Azure AD enumeration with ROADtools and ROADrecon
- Entra ID service principal abuse walkthrough
- Portfolio Project 6 drafted: Multi-Cloud Secrets Architecture (AWS + Azure + Conjur)

**Deliverables**:
- PEN-200 course 100% complete
- 1 Challenge Lab network completed end-to-end with a written report
- 2 CloudGoat scenarios documented
- **Portfolio Project 6 (Multi-Cloud Secrets Architecture) published**

---

### Month 16: OSCP Exam Prep + DevSecOps Security Audit

**Objective**: Two full 24-hour mock exam attempts. Write the DevSecOps security audit of your own Phase 1 CI/CD pipeline — this is a consulting methodology deliverable, not a numbered portfolio project.

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
- **DevSecOps Security Audit published** (consulting methodology deliverable — not a numbered portfolio project)
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
- Polished GitHub portfolio landing page (index of all 7 projects)
- Portfolio Project 7 (Enterprise Capstone) started

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
- **Week 4**: Portfolio Project 7 (Enterprise Capstone: PAM + Conjur + Pentest Assessment) final publish. **GO LIVE** — website published, LinkedIn announcement, first outreach to network.

**Rate Card Guidance** (North American market, April 2026 baseline, adjust for your market):
- Pentesting: **$175 – $225 / hr**
- PAM implementation: **$200 – $275 / hr**
- Combined assessment + implementation engagements: **$250 – $350 / hr**

**Deliverables**:
- Consulting practice **launched**
- 7 portfolio projects published
- OSCP certification
- Business entity registered, rate card published, contracts templated
- **Portfolio Project 7 (Enterprise Capstone: PAM + Conjur + Pentest Assessment) published**

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

**Last Updated**: 2026-04-15
**Version**: 2.0
