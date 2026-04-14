# Phase 1: Security Foundations + PAM Mastery (Months 1-6)

**Duration**: 6 months (24 weeks)
**Weekly Commitment**: 12-13 hrs/week standard (13-14 hrs exam push week; 8 hrs/week recovery in M6)
**Focus**: CyberArk PAM mastery, offensive security foundations, DevSecOps baseline
**Calendar**: May 2026 – October 2026

---

## Overview

Phase 1 establishes the twin pillars of the 18-month program: deep CyberArk PAM expertise and an offensive security mindset built from Day 1. You will earn two CyberArk certifications (Defender and Sentry) while simultaneously learning how attackers think. By Month 6 you will have published two portfolio projects and completed the foundational work needed to tackle the Guardian certification and pentesting fundamentals in Phase 2.

### Primary Objectives

1. **Master CyberArk PAM** — install, configure, and operate a full Vault / CPM / PVWA / PSM stack from scratch. Understand the architecture deeply enough to defend it in an interview or a client engagement.
2. **Build offensive security foundation** — start Kali Linux on Day 1. Learn Linux fundamentals, network scanning, and web application security (DVWA, OWASP Top 10, Burp Suite basics) so that when you implement PAM you already understand what you are defending against.
3. **Establish DevSecOps security practices** — integrate SAST (Semgrep), secret scanning (gitleaks), and container scanning (Trivy) into a personal CI/CD pipeline. These become baseline consulting deliverables.

### Certifications Earned

- **CyberArk Defender (M4, August 2026)** — validates you can install, configure, and operate the core PAM platform. The entry ticket for any CyberArk consulting work.
- **CyberArk Sentry (M6, October 2026)** — validates advanced administration, troubleshooting, and safe/policy management. Paired with Defender, this is the credential floor for implementation engineer roles.

### Dual-Track Design

Phase 1 runs two tracks in parallel, every single week:

- **PAM Track (Defensive)**: Vault install → CPM → PVWA → PSM → advanced configuration → Sentry-level troubleshooting.
- **Offensive Track**: Kali Linux setup → Linux security fundamentals → network scanning (Nmap) → web application security (DVWA, OWASP Top 10, Burp Suite) → privilege escalation basics on TryHackMe.

**Why this matters**: PAM consultants who only know PAM build brittle implementations. You need to know how Kerberoasting works to argue for service account vaulting. You need to understand Pass-the-Hash to justify session isolation via PSM. The offensive mindset is not a side project — it is what makes your PAM implementations credible. Every attack you learn in the offensive track maps to a CyberArk control you will implement in the defensive track.

### Success Metrics (by Month 6)

- [ ] CyberArk Defender certification passed
- [ ] CyberArk Sentry certification passed
- [ ] Full PAM lab operational (Vault + CPM + PVWA + PSM)
- [ ] Kali Linux lab environment with DVWA and internal target network
- [ ] Portfolio Project 1 (PAM Lab Documentation) published to GitHub
- [ ] Personal CI/CD pipeline with Semgrep + gitleaks + Trivy operational

---

## Phase Structure

### Months 1-2: Lab Architecture + PAM Foundations

**Objective**: Build both labs (PAM stack on Windows Server 2022, Kali Linux as attack host) and get through Vault + CPM + PVWA installation. Begin Linux fundamentals and Nmap on the offensive side.

**Time Allocation**:
- Study (docs, videos, reading): 3 hrs/week
- Labs (hands-on build): 9-10 hrs/week
- **Total**: 12-13 hrs/week

**Key Activities**:
- Install VirtualBox or VMware Workstation; build isolated lab network (flat /24, routed to Kali)
- Windows Server 2022 evaluation VMs for Vault, CPM, PVWA
- CyberArk Vault installation from media; hardening checklist
- CPM installation and first platform/account onboarding
- PVWA installation with IIS and authentication integration
- Kali Linux 2026.x install, update, tooling inventory
- Linux fundamentals on Kali (systemd, permissions, journalctl, iptables)
- Nmap basic and service scans against lab; Wireshark capture of PAM auth traffic
- Netcat / socat fundamentals for reverse shells (lab only)

**Deliverables**:
- Lab network diagram (draw.io or Excalidraw)
- Vault, CPM, PVWA operational with at least 5 onboarded accounts
- Kali Linux host with personal tooling baseline documented
- GitHub repo initialized with `README`, `/labs`, `/notes`, `/reports` structure

---

### Month 3: Advanced PAM + Defender Prep + Web Security Intro

**Objective**: Complete Defender exam preparation (85%+ on practice tests) and finish the PSM install. Open the web application security track with DVWA and Burp Suite Community.

**Time Allocation**:
- Study + practice tests: 5 hrs/week
- PAM labs: 5 hrs/week
- Offensive labs: 3 hrs/week
- **Total**: 13 hrs/week

**Key Activities**:
- CyberArk Defender official practice tests until ≥85% consistently
- PSM (Privileged Session Manager) installation and RDP/SSH connector config
- Safes, platforms, master policy tuning — hands-on troubleshooting drills
- DVWA deployed on Kali; walk through OWASP Top 10 at Low → Medium
- Burp Suite Community Edition installed; proxy configured; first intercepts
- OWASP Top 10 2021 reading and mapping each item to DVWA exercises

**Deliverables**:
- Defender practice test log (≥85% average last 5 attempts)
- PSM operational with at least 2 connection components
- DVWA walkthrough notes (SQLi, XSS, CSRF, file upload) in GitHub repo
- Burp Suite proxy chain documented (Kali → Burp → DVWA)

---

### Month 4: Defender Certification + CI/CD Security

**Objective**: Pass the Defender exam (exam week). Expand PSM expertise to session recording. Start Linux privilege escalation on TryHackMe. Publish Portfolio Project 1.

**Time Allocation**:
- Exam push week: 13-14 hrs/week
- Other weeks: 12-13 hrs/week

**Key Activities**:
- **EXAM WEEK**: CyberArk Defender exam (proctored)
- PSM session recording deep dive (recording safes, universal connector)
- TryHackMe: Linux PrivEsc room (SUID, sudo misconfig, cron, PATH)
- TryHackMe: Linux Fundamentals 1-3 if not already done
- Portfolio Project 1: PAM Lab Documentation (20+ page write-up of the full Vault/CPM/PVWA/PSM build, architecture diagrams, troubleshooting scenarios)

**Deliverables**:
- **CyberArk Defender certification**
- **Portfolio Project 1 (PAM Lab Documentation)** published on GitHub with professional README
- TryHackMe Linux PrivEsc room completed
- PSM session recording demo (screen capture or written walkthrough)

---

### Month 5: Sentry Prep + DevSecOps Pipeline Security

**Objective**: Drive Sentry practice test scores to 85%+. Build the DevSecOps baseline pipeline: SAST, secret scanning, container scanning. Enter the TryHackMe Intro to Offensive Security path.

**Time Allocation**:
- Study + practice tests: 5 hrs/week
- PAM labs (Sentry-level): 4 hrs/week
- DevSecOps pipeline + TryHackMe: 4 hrs/week
- **Total**: 13 hrs/week

**Key Activities**:
- CyberArk Sentry practice tests until ≥85% consistently
- Advanced Sentry topics: policy inheritance, CPM plugins, custom platforms
- Semgrep installed locally and wired into a GitHub Actions workflow on a sample repo
- gitleaks integrated to scan commit history for secrets
- Trivy scanning container images in the pipeline
- TryHackMe Intro to Offensive Security path (beginner rooms: Nmap, web enum, basic exploitation)

**Deliverables**:
- Sentry practice test log (≥85% average)
- Public GitHub repo with working SAST + secret scan + container scan workflow
- TryHackMe Intro to OffSec path completion badge
- Draft of Portfolio Project 2 (outline only, full write-up lands in M6)

---

### Month 6: Sentry Certification + RECOVERY

**Objective**: Pass Sentry in the first week of October, then drop to an 8 hrs/week recovery pace. Rest, read ahead for Phase 2, finalize Portfolio Project 2.

**Time Allocation**:
- Exam week: 12-13 hrs/week
- Recovery weeks 2-4: **8 hrs/week**

**Key Activities**:
- **EXAM WEEK**: CyberArk Sentry exam (proctored)
- Recovery: light TryHackMe rooms for fun (no forced progression)
- Conjur preview reading (CyberArk Conjur documentation, architecture overview) — no hands-on yet
- Finalize and publish Portfolio Project 2 (DevSecOps Pipeline baseline)
- Phase 1 retrospective: what worked, what to change for Phase 2

**Deliverables**:
- **CyberArk Sentry certification**
- Portfolio Project 2 (DevSecOps baseline pipeline) published
- Phase 1 retrospective notes committed to repo
- Phase 1 closeout: 2 portfolio projects published, 2 CyberArk certs earned

---

## Resources

### CyberArk Resources
- [docs/CYBERARK_CERTIFICATIONS.md](../docs/CYBERARK_CERTIFICATIONS.md) — Defender and Sentry objectives, exam structure, study plan
- [docs/HANDS_ON_LABS_PHASE1.md](../docs/HANDS_ON_LABS_PHASE1.md) — step-by-step lab builds for Vault, CPM, PVWA, PSM
- CyberArk Docs: https://docs.cyberark.com
- CyberArk Campus (official training): https://training.cyberark.com

### Pentesting Resources
- TryHackMe: https://tryhackme.com
- TryHackMe Intro to Offensive Security path: https://tryhackme.com/path/outline/introtooffensivesecurity
- PortSwigger Web Security Academy: https://portswigger.net/web-security
- DVWA (GitHub): https://github.com/digininja/DVWA
- OWASP Top 10: https://owasp.org/www-project-top-ten/
- Kali Linux: https://www.kali.org

### DevSecOps Resources
- [docs/DEVOPS_CI_CD_GUIDE.md](../docs/DEVOPS_CI_CD_GUIDE.md) — pipeline security baseline for consulting engagements
- Semgrep: https://semgrep.dev
- gitleaks: https://github.com/gitleaks/gitleaks
- Trivy: https://github.com/aquasecurity/trivy

---

**Last Updated**: 2026-04-14
**Version**: 1.0
