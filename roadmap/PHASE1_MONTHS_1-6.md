# Phase 1: Security Foundations + PAM Mastery (Months 1-6)

**Duration**: 6 months (24 weeks)
**Weekly Commitment**: 12-13 hrs/week standard (13-14 hrs exam push week; 8 hrs/week recovery in M6)
**Focus**: CyberArk PAM mastery, offensive security foundations, DevSecOps baseline
**Calendar**: May 2026 – October 2026

---

## Overview

Phase 1 establishes the twin pillars of the 18-month program: deep CyberArk PAM expertise and an offensive security mindset built from Day 1. You will earn two CyberArk certifications (Defender and Sentry) while simultaneously learning how attackers think. By Month 6 you will have published three portfolio projects and completed the foundational work needed to tackle the Guardian certification and advanced pentesting in Phase 2.

> **Your starting point is not zero.** You have architected and implemented Wallix PAM + FortiAuthenticator MFA for a multinational enterprise. You understand vault architecture, session proxying, password rotation at scale, and MFA integration with PAM platforms at a production level. Phase 1 for you is **not** PAM fundamentals — it is CyberArk product mastery and offensive security acceleration. Theory hours are cut in half. Lab and pentesting hours go up. The Defender exam moves to Month 3 (not Month 4) and Sentry to Month 5 (not Month 6), freeing an entire month for pentesting ramp-up and a multi-vendor portfolio project that almost no other consultant can produce.

### Primary Objectives

1. **CyberArk product mastery** — you already know PAM. The goal is to learn CyberArk-specific architecture, configuration, and tooling fast: where Vault differs from Wallix Bastion, how CPM handles platforms differently from Wallix Password Manager, what PVWA adds that Wallix's web console doesn't. Install and operate the full stack from scratch and map every component to your existing mental model.
2. **Build offensive security foundation** — start Kali Linux on Day 1. Learn Linux fundamentals, network scanning, and web application security (DVWA, OWASP Top 10, Burp Suite basics). Begin TryHackMe from Month 1, not Month 4. The offensive mindset is not a side project — it is what makes your PAM implementations credible.
3. **Publish the multi-vendor PAM differentiator** — produce a professional Wallix vs CyberArk comparison document covering architecture, deployment model, licensing, and use-case fit. This is the consulting asset that separates you from every single CyberArk-only consultant in the market.
4. **Establish DevSecOps security practices** — integrate SAST (Semgrep), secret scanning (gitleaks), and container scanning (Trivy) into a personal CI/CD pipeline. These become baseline consulting deliverables.

### Certifications Earned

- **CyberArk Defender (M3, July 2026)** — validates you can install, configure, and operate the core PAM platform. The entry ticket for any CyberArk consulting work. With your Wallix background, this is a product knowledge exam, not a PAM concepts exam. Three weeks of focused CyberArk-specific study gets you there.
- **CyberArk Sentry (M5, September 2026)** — validates advanced administration, troubleshooting, and safe/policy management. Paired with Defender, this is the credential floor for implementation engineer roles.

### Dual-Track Design

Phase 1 runs two tracks in parallel, every single week:

- **PAM Track (Defensive)**: Vault install → CPM → PVWA → PSM → advanced configuration → Sentry-level troubleshooting.
- **Offensive Track**: Kali Linux setup → Linux security fundamentals → network scanning (Nmap) → web application security (DVWA, OWASP Top 10, Burp Suite) → privilege escalation basics on TryHackMe.

**Why this matters**: PAM consultants who only know PAM build brittle implementations. You need to know how Kerberoasting works to argue for service account vaulting. You need to understand Pass-the-Hash to justify session isolation via PSM. The offensive mindset is not a side project — it is what makes your PAM implementations credible. Every attack you learn in the offensive track maps to a CyberArk control you will implement in the defensive track.

### Success Metrics (by Month 6)

- [ ] CyberArk Defender certification passed (Month 3)
- [ ] CyberArk Sentry certification passed (Month 5)
- [ ] Full PAM lab operational (Vault + CPM + PVWA + PSM)
- [ ] Kali Linux lab environment with DVWA and internal target network
- [ ] **Portfolio Project 1**: CyberArk PAM Lab Documentation published to GitHub
- [ ] **Portfolio Project 2**: Wallix vs CyberArk Multi-Vendor Comparison published (unique differentiator)
- [ ] Personal CI/CD pipeline with Semgrep + gitleaks + Trivy operational
- [ ] TryHackMe Jr Pentester path 40%+ complete — entering Phase 2 with real offensive momentum

---

## Phase Structure

### Months 1-2: CyberArk Product Mastery + Offensive Foundation

**Objective**: Build the full CyberArk PAM stack (Vault + CPM + PVWA + PSM), map every component against your Wallix mental model, and run Kali offensively against your own lab from Day 1. You are not learning what PAM is — you are learning what CyberArk specifically does and how it differs from what you already know.

**Time Allocation**:
- Study (CyberArk-specific docs only — no PAM theory): 1-2 hrs/week
- Labs (CyberArk build + offensive): 11 hrs/week
- **Total**: 12-13 hrs/week

**Key Activities — PAM Track**:
- Build the lab network: 7 VMs on isolated /24 (see HANDS_ON_LABS_PHASE1.md for topology)
- Install Vault, CPM, PVWA, PSM — treat it as a client deployment, not a tutorial
- Immediately after each component: compare it to the Wallix equivalent. Document what is the same, what is different, what CyberArk does better, and what Wallix does better. This becomes the draft for Portfolio Project 2.
- Configure PVWA RADIUS authentication — you already know FortiAuthenticator integration patterns; validate how CyberArk handles the same flow
- Onboard 10+ accounts across Windows local, Windows domain, and Linux SSH platforms
- Run Nmap from Kali against your PAM stack: what ports expose, what CyberArk hides vs Wallix

**Key Activities — Offensive Track (starts Month 1, Week 1)**:
- Kali Linux setup + full tooling baseline (see Lab 6 in HANDS_ON_LABS_PHASE1.md)
- TryHackMe: complete **Linux Fundamentals 1-3** and **Pre-Security path** (~15 hrs)
- TryHackMe: start **Jr Pentester path** from Week 3 — Nmap, network enumeration rooms
- Nmap NSE scans against your own PAM lab — document every open port and service
- Wireshark capture of CyberArk auth traffic: understand what travels over port 1858

**Deliverables**:
- Lab network diagram (draw.io or Excalidraw) — professional quality, usable in portfolio
- Full PAM stack operational: Vault + CPM + PVWA + PSM with 10+ onboarded accounts
- Wallix vs CyberArk comparison draft: component mapping table (first draft of Portfolio Project 2)
- Kali tooling baseline documented in GitHub repo
- TryHackMe: Linux Fundamentals 1-3 complete + 5+ Jr Pentester rooms done
- GitHub repo initialized: `README`, `/labs`, `/notes`, `/reports`, `/comparisons`

---

### Month 3: Defender Certification + Web Security

**Objective**: Pass the CyberArk Defender exam in Month 3. With your Wallix background, 3 weeks of CyberArk-specific practice test grinding gets you to 85%+. Use the fourth week to sit the exam. In parallel, open the web application security track with DVWA and Burp Suite.

**Time Allocation**:
- Defender practice tests + CyberArk-specific gaps: 4 hrs/week
- PAM advanced labs (PSM, safe policies, troubleshooting drills): 5 hrs/week
- Offensive labs (DVWA + Burp Suite): 4 hrs/week
- **Total**: 13 hrs/week

**Key Activities**:
- CyberArk Defender official practice tests until ≥85% consistently — focus on CyberArk terminology and product-specific behaviour, not PAM concepts you already own
- PSM RDP/SSH connector configuration and troubleshooting drills
- Safes, platforms, master policy tuning — aim for 3 distinct failure scenarios you can troubleshoot blind
- **EXAM WEEK (Week 3 or 4): CyberArk Defender exam**
- DVWA deployed on Kali; walk through OWASP Top 10 at Low → Medium
- Burp Suite Community Edition: proxy, Repeater, Intruder against DVWA
- TryHackMe: continue Jr Pentester path — web fundamentals rooms

**Deliverables**:
- **CyberArk Defender certification**
- Defender practice test log (≥85% average last 5 attempts)
- PSM operational with at least 3 connection components and one troubleshooting scenario documented
- DVWA walkthrough notes (SQLi, XSS, CSRF, file upload) in GitHub repo
- TryHackMe: Jr Pentester path 20%+ complete

---

### Month 4: Pentesting Acceleration + Multi-Vendor Portfolio

**Objective**: Defender is already done. This month is fully offensive and portfolio-focused. Push hard on TryHackMe, complete Linux privilege escalation, publish Portfolio Project 1 (PAM Lab Documentation), and produce the first full draft of Portfolio Project 2 (Wallix vs CyberArk comparison). This is the month that builds your market differentiation.

**Time Allocation**:
- TryHackMe Jr Pentester path: 6 hrs/week
- Portfolio writing (Projects 1 and 2): 4 hrs/week
- CyberArk advanced labs (PSM session recording, breakglass, HA basics): 3 hrs/week
- **Total**: 13 hrs/week

**Key Activities**:
- TryHackMe: Linux PrivEsc room (SUID, sudo misconfig, cron, PATH hijacking)
- TryHackMe: Jr Pentester path — Metasploit introduction, network exploitation rooms
- TryHackMe: complete the **Burp Suite** module series
- PSM session recording deep dive: recording safes, universal connector, playback review
- **Portfolio Project 1**: Publish CyberArk PAM Lab Documentation — 20+ pages, architecture diagrams, troubleshooting scenarios, professional GitHub README
- **Portfolio Project 2 (first draft)**: Wallix vs CyberArk — vendor comparison document. Sections: architecture comparison, component mapping table (Bastion→PSM, Password Manager→CPM, etc.), deployment model differences, MFA integration patterns (FortiAuthenticator vs CyberArk RADIUS), licensing model, use-case fit matrix (when to recommend each), your recommendation framework as a consultant

**Deliverables**:
- **Portfolio Project 1 published** — PAM Lab Documentation on GitHub
- **Portfolio Project 2 first draft** — Wallix vs CyberArk comparison (internal, not published yet)
- TryHackMe: Jr Pentester path 40%+ complete
- TryHackMe: Linux PrivEsc room completed
- PSM session recording demo documented with screenshots

---

### Month 5: Sentry Certification + DevSecOps Pipeline

**Objective**: Pass the Sentry exam in Month 5. Sentry is the advanced admin cert — safe design, policy inheritance, CPM plugins, custom platforms. You understand the PAM concepts already; this is a 3-week focused CyberArk Sentry-specific drill. In parallel, build the DevSecOps baseline pipeline.

**Time Allocation**:
- Sentry practice tests + advanced labs: 6 hrs/week
- DevSecOps pipeline build: 3 hrs/week
- TryHackMe Jr Pentester path: 3 hrs/week
- **Total**: 12-13 hrs/week (exam push week: 14)

**Key Activities**:
- CyberArk Sentry practice tests until ≥85% — focus on: policy inheritance hierarchy, CPM plugin architecture, custom platform scripting, breakglass scenarios, safe design patterns
- Advanced CPM labs: create a custom platform plugin for a non-standard target
- PVWA policy deep dive: dual control, one-time password, exclusive access settings
- **EXAM WEEK (Week 3 or 4): CyberArk Sentry exam**
- Semgrep + gitleaks + Trivy wired into GitHub Actions on a sample repo
- TryHackMe: Jr Pentester path continued — exploitation and post-exploitation rooms

**Deliverables**:
- **CyberArk Sentry certification**
- Sentry practice test log (≥85% average last 5 attempts)
- Custom CPM platform plugin committed to GitHub
- Public GitHub repo with working SAST + secret scan + container scan pipeline
- TryHackMe: Jr Pentester path 60%+ complete

---

### Month 6: RECOVERY + Portfolio Polish + Phase 2 Prep

**Objective**: Sentry is already done. Month 6 is full recovery at 8 hrs/week. Use light, enjoyable activity to consolidate: finalize and publish Portfolio Projects 1 and 2, do some TryHackMe rooms you enjoy, preview Conjur, and write the Phase 1 retrospective. Arrive at Phase 2 rested, with 2 certs and 3 portfolio projects done.

**Time Allocation**:
- Recovery pace: **8 hrs/week for all 4 weeks**

**Key Activities**:
- Finalize and publish **Portfolio Project 2**: Wallix vs CyberArk Multi-Vendor Comparison — professional polish, diagrams, executive summary section, posted to GitHub and LinkedIn
- Light TryHackMe rooms: choose any that interest you — no forced path, no pressure
- Conjur preview: read the CyberArk Conjur OSS architecture overview only — no hands-on yet
- DevSecOps pipeline: finalize and publish **Portfolio Project 3** (DevSecOps Baseline Pipeline)
- Phase 1 retrospective: what took longer than expected, what was easier than expected, any cert timing adjustments for Phase 2
- LinkedIn: announce Defender + Sentry certifications, post first article (PAM implementation lessons)

**Deliverables**:
- **Portfolio Project 2 published** — Wallix vs CyberArk comparison on GitHub (the unique differentiator)
- **Portfolio Project 3 published** — DevSecOps baseline pipeline
- Phase 1 retrospective notes committed to repo
- Phase 1 closeout: **2 CyberArk certs, 3 portfolio projects, Jr Pentester path 65%+ complete**

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

**Last Updated**: 2026-04-15
**Version**: 2.0
