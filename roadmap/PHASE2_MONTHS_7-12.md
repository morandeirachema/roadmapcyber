# Phase 2: Pentesting Foundations + Advanced PAM (Months 7-12)

**Duration**: 6 months (24 weeks)
**Weekly Commitment**: 13-15 hrs/week standard; 8 hrs/week recovery in M12
**Focus**: PTES methodology, Active Directory attacks, Conjur deployment, Guardian and eJPT certifications
**Calendar**: November 2026 – April 2027

---

## Overview

Phase 2 is the hinge of the program. You arrive with two CyberArk certifications, three portfolio projects published, and a TryHackMe Jr Pentester path that is 65%+ complete — significantly ahead of a standard Phase 1 exit. The Wallix project also ends in November 2026 (Month 7), freeing up time and mental energy exactly when the pentesting and Conjur work intensifies. Now you learn to attack what you defend. By the end of Phase 2 you will have earned the top CyberArk certification (Guardian) and the eJPT, proving you can execute a full internal network pentest. In parallel you stand up Conjur, which becomes the spine of Phase 3's secrets work.

### Primary Objectives

1. **Earn eJPT (M12, April 2027)** — practical 48-hour exam validating network pentesting, web exploitation, and basic post-exploitation.
2. **Earn CyberArk Guardian (M8, December 2026)** — the top CyberArk certification; validates enterprise-level architecture and design.
3. **Master Active Directory pentesting and network pentesting** — Kerberoasting, AS-REP roasting, Pass-the-Hash, BloodHound attack paths, pivoting.
4. **Deploy Conjur** — start with Docker in M9, move to a Kubernetes authenticator pattern in M11. Conjur is the bridge from PAM to DevSecOps secrets management.

### Certifications Earned

- **CyberArk Guardian (M8)** — enterprise architecture, DR/HA design, complex platform plugins, integration with SIEM/ITSM. The consulting credential.
- **eJPT (M12)** — INE's entry-level practical pentesting certification. Not as prestigious as OSCP, but it proves real hands-on capability and is the correct stepping stone.

### The Pentesting-PAM Connection

Active Directory pentesting is **directly relevant** to PAM consultants. Every AD attack you learn maps to a PAM control you will later sell:

- **Kerberoasting** (offline cracking of service account TGS) → you understand why service account vaulting and long/random passwords matter. PAM rotates these; the attack teaches you why.
- **AS-REP Roasting** (accounts without pre-auth) → you understand why PAM compliance scans should flag `DONT_REQ_PREAUTH`.
- **Pass-the-Hash / Overpass-the-Hash** → you understand why PSM session isolation matters — the operator never sees or types the credential, so the hash cannot leak to the jumpbox.
- **BloodHound attack paths** → you understand why tier-0 / tier-1 / tier-2 separation is the foundation of any PAM rollout.

A PAM consultant who cannot articulate these attacks is reciting marketing slides. After Phase 2, you can draw the attack on the whiteboard and then draw the CyberArk control that kills it.

### Success Metrics (by Month 12)

- [ ] CyberArk Guardian certification passed
- [ ] eJPT certification passed
- [ ] Capable of executing a full internal network pentest end-to-end (AD attacks, web exploitation, reporting)
- [ ] Conjur operational in Docker and in Kubernetes
- [ ] Portfolio Project 4 (CyberArk Guardian Enterprise Architecture) published
- [ ] **5 portfolio projects total** published to GitHub (3 from Phase 1 + 2 from Phase 2)
- [ ] TryHackMe Jr Pentester path 100% complete
- [ ] Mock pentest report written and peer-reviewed

---

## Phase Structure

### Month 7: Pentesting Methodology + AD Lab Build + Guardian Prep

**Objective**: The Wallix project ends this month — use that freed energy. Learn pentesting methodology rigorously (PTES), build the AD lab that you will attack in Month 8-9, and push Guardian course to 50% completion. You arrive with TryHackMe Jr Pentester 65% done, so methodology and AD lab build replace the beginner rooms that would have been here.

**Time Allocation**: 13-14 hrs/week
- Methodology + AD lab build: 5 hrs/week
- Guardian course + labs: 5 hrs/week
- TryHackMe: AD-specific and network rooms: 3-4 hrs/week

**Key Activities**:
- PTES methodology study — read all 7 phases (pre-engagement to reporting) end to end
- Write your own methodology notes document (this becomes a consulting deliverable template)
- **Build the AD lab now** (Windows Server 2022 DC + 2 member servers + 1 workstation) — you will attack it in M8-9. Building it in M7 gives you a full month to get comfortable with it before the attacks start.
- Nmap NSE scripting — write one custom NSE script against your AD lab
- theHarvester + Maltego Community for OSINT phase walkthroughs
- Guardian course on CyberArk Campus: enterprise architecture modules — target 50% completion
- TryHackMe: Active Directory Basics, Attacktive Directory, Breaching AD rooms

**Deliverables**:
- Methodology document (5-10 pages, your own words — becomes a consulting template)
- Guardian course 50% complete with notes
- AD lab operational (domain `lab.local`, 4 VMs, users and groups configured)
- TryHackMe: AD rooms complete + Jr Pentester path 80%+
- Custom NSE script committed to repo

---

### Month 8: Guardian Certification + Exploitation Fundamentals

**Objective**: Pass the Guardian exam in weeks 1-2 of December. Then pivot hard into Metasploit and web exploitation fundamentals.

**Time Allocation**: 13-14 hrs/week (exam push early)

**Key Activities**:
- **Guardian EXAM** (weeks 1-2 of December 2026)
- Metasploit module structure (auxiliary, exploit, post), msfvenom payload generation
- Meterpreter core commands, session handling, migration
- Burp Suite intermediate — Intruder (sniper, pitchfork, clusterbomb), Repeater workflows
- SQLmap automated SQL injection against DVWA and vulnerable WordPress lab
- Gobuster / ffuf for directory and vhost brute-forcing
- Portfolio Project 4 drafted: CyberArk Guardian Enterprise Architecture (HA/DR design, multi-site vault, integration patterns)

**Deliverables**:
- **CyberArk Guardian certification**
- Web exploitation lab notes covering SQLi, XSS, LFI/RFI, file upload bypass
- 8+ TryHackMe Jr Pentester rooms cumulative
- Portfolio Project 4 draft complete (publishes M9)

---

### Month 9: Active Directory Attacks + eJPT Prep Begins + Conjur Docker

**Objective**: The crown jewel month for PAM consultants. Build an AD lab and attack it with BloodHound, Kerberoasting, AS-REP roasting, Impacket. Stand up Conjur in Docker. Begin INE Penetration Testing Student (PTS) course.

**Time Allocation**: 14-15 hrs/week
- AD lab + attacks: 6 hrs/week
- INE PTS course: 4 hrs/week
- Conjur Docker: 2 hrs/week
- TryHackMe AD rooms: 2-3 hrs/week

**Key Activities**:
- Windows Server 2022 AD lab (1 DC + 2 member servers + 1 workstation) in VirtualBox/VMware
- BloodHound CE + SharpHound collector; ingest AD and map attack paths
- Kerberoasting with `GetUserSPNs.py` (Impacket); crack TGS tickets offline with Hashcat
- AS-REP Roasting with `GetNPUsers.py`; crack with Hashcat
- Pass-the-Hash with `psexec.py` / `wmiexec.py` / `smbexec.py`
- LDAP enumeration with `ldapsearch` and `windapsearch`
- INE PTS course sections 1-3 (information gathering, footprinting, scanning)
- Conjur OSS in Docker: policy authoring, load, host factories, basic secrets retrieval

**Deliverables**:
- AD lab operational and documented
- BloodHound attack paths screenshot + written explanation of at least 3 paths
- Conjur running in Docker with a sample policy and secret
- **Portfolio Project 4 (CyberArk Guardian Enterprise Architecture) published**
- INE PTS course 30% complete

---

### Month 10: Network Pentesting + Password Attacks + eJPT Intensive

**Objective**: Build a full network assessment methodology. Complete enough of the INE PTS course to take eJPT in M12. Write a mock pentest report on your own lab.

**Time Allocation**: 14-15 hrs/week
- INE PTS course: 5 hrs/week
- Hands-on network pentest + reporting: 6 hrs/week
- Conjur / DevSecOps continuation: 3 hrs/week

**Key Activities**:
- Nessus Essentials or OpenVAS scanning of the lab network; triage findings
- Hydra and Medusa for credential attacks against SSH, RDP, SMB, HTTP forms
- Hashcat with `rockyou.txt` and rule-based attacks (best64, OneRuleToRuleThemAll)
- Pivoting with `proxychains` + SSH dynamic port forwarding; Chisel for reverse SOCKS
- INE PTS course sections 4-5 (web app testing, system attacks)
- Mock pentest against own lab: full engagement simulation, report written in the format you will sell to clients
- Pentest SOW (Statement of Work) template drafted — this is a consulting deliverable

**Deliverables**:
- Mock pentest report (10+ pages) committed to a private repo
- INE PTS course ≥85% complete
- Pentest SOW template draft
- Hashcat wordlist/rules notes

---

### Month 11: eJPT Final Prep + Conjur in Kubernetes

**Objective**: Exam-pace practice for eJPT. Deploy Conjur on a Kubernetes cluster with the K8s authenticator.

**Time Allocation**: 14-15 hrs/week

**Key Activities**:
- INE practice labs at exam pace (timed 4-hour blocks)
- 2-3 HackTheBox Starting Point machines (guided, for exam-level confidence)
- Conjur deployed to K8s cluster (minikube or kind) with HA considerations documented
- Kubernetes authenticator configuration: service account JWT → Conjur policy
- Secrets injection into pods via the Kubernetes Secrets Provider sidecar pattern
- 3rd consulting-style presentation delivered (record yourself if no audience)

**Deliverables**:
- eJPT exam scheduled for M12 week 2-3
- Conjur K8s deployment documented with `kubectl apply` manifests and policy files
- 3rd consulting presentation recorded or delivered
- Secrets injection demo working end-to-end

---

### Month 12: eJPT EXAM + RECOVERY

**Objective**: Pass eJPT in the first half of April 2027, then rest before the OSCP push that begins in Phase 3.

**Time Allocation**:
- Exam week: 14-15 hrs/week
- Recovery weeks (3 weeks): **8 hrs/week**

**Key Activities**:
- **eJPT EXAM**: 48-hour practical lab + 20 multiple-choice questions, taken online
- After exam: 3 weeks of recovery at 8 hrs/week
- Light OSCP prerequisite reading: PEN-200 syllabus overview, required background on buffer overflow awareness (no longer in exam but in course), basic Windows internals
- Phase 2 retrospective: what to carry into OSCP prep

**Deliverables**:
- **eJPT certification**
- Phase 2 retrospective notes
- OSCP plan of attack document for Phase 3 kickoff

---

## Resources

- INE (Penetration Testing Student course): https://ine.com
- TryHackMe Jr Pentester path: https://tryhackme.com/path/outline/jrpenetrationtester
- HackTheBox Starting Point: https://app.hackthebox.com/starting-point
- BloodHound: https://github.com/SpecterOps/BloodHound
- Impacket: https://github.com/fortra/impacket
- PTES: http://www.pentest-standard.org
- Metasploit Unleashed: https://www.offsec.com/metasploit-unleashed/
- Conjur OSS: https://www.conjur.org
- [docs/EJPT_CERTIFICATION_GUIDE.md](../docs/EJPT_CERTIFICATION_GUIDE.md)
- [docs/ACTIVE_DIRECTORY_ATTACK_GUIDE.md](../docs/ACTIVE_DIRECTORY_ATTACK_GUIDE.md)
- [docs/PENTESTING_TOOLS_GUIDE.md](../docs/PENTESTING_TOOLS_GUIDE.md)

---

**Last Updated**: 2026-04-15
**Version**: 2.0
