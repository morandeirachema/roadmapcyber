# 18-Month Detailed Schedule: Week-by-Week Activities

**Weekly Commitment**: 12-15 hours/week standard (sustainable for a working professional); 8 hours/week in recovery months (M6, M12, M18)
- **Weekdays**: 1.5-2 hours/day (Mon-Fri) = ~7.5-10 hours
- **Weekends**: 3-5 hours total across Saturday and Sunday
- **Total Study Hours**: ~972-1,080 hours over 18 months
- **English practice**: 30 min/day embedded in study time from M1 — see [ENGLISH_LEARNING.md](ENGLISH_LEARNING.md)
- **Networking**: 15 min/day (LinkedIn, CyberArk Commons, community) from M1 — see [docs/NETWORKING_STRATEGY.md](../docs/NETWORKING_STRATEGY.md)

**Program Start**: May 4, 2026 | **Program End**: ~October 2027

**Philosophy**: 90% hands-on. Every module you read is followed by a lab you build. Every attack technique you study is executed against a target you own. The portfolio is the curriculum.

---

## Visual Timeline

```text
18-MONTH ROADMAP AT A GLANCE
══════════════════════════════════════════════════════════════════════════════════════

MONTHS   1─2─3─4─5─6    │    7─8─9─10─11─12   │   13─14─15─16─17─18
         PAM+Foundations │    Pentesting+PAM    │   Cloud+OSCP+Launch

PHASE 1  ███████████████║    ░░░░░░░░░░░░░░░░░ ║   ░░░░░░░░░░░░░░░░░░
PHASE 2  ░░░░░░░░░░░░░░░║    █████████████████ ║   ░░░░░░░░░░░░░░░░░░
PHASE 3  ░░░░░░░░░░░░░░░║    ░░░░░░░░░░░░░░░░░ ║   ██████████████████

CERTS    │    [DEF] [SEN]│  [GUA]       [eJPT] │         [OSCP] [GO!]
         │     M4    M6  │   M8           M12  │           M17    M18

RECOVERY │            🏖 │                 🏖  │                 🏖🚀
         │            M6 │                M12  │                M18

══════════════════════════════════════════════════════════════════════════════════════
KEY: ██ = Active phase  ░░ = Inactive   [DEF]=Defender [SEN]=Sentry [GUA]=Guardian
     🏖 = Recovery month (8 hrs/week)   🚀 = Consulting Launch
```

### Quick Reference: Key Milestones

| Month | Week  | Milestone                                         | Hours/Week |
|:-----:|:-----:|:--------------------------------------------------|:----------:|
| M1    | 1-4   | Lab built (PAM stack + Kali Linux)                | 12-13      |
| M4    | 13-16 | **CyberArk Defender certification**               | 13-14      |
| M6    | 21-24 | **CyberArk Sentry certification + recovery**      | **8**      |
| M8    | 29-32 | **CyberArk Guardian certification**               | 13-14      |
| M12   | 45-48 | **eJPT certification + recovery**                 | **8**      |
| M13   | 49-52 | OSCP PEN-200 begins (90-day lab purchase)         | 14-15      |
| M17   | 65-68 | **OSCP 24-hour exam**                             | 14-15      |
| M18   | 69-72 | **Consulting practice launch + recovery**         | **8**      |

---

## Cross-Program Activities (All 18 Months)

These activities run every month, in parallel with the technical track. They are not optional — they are what converts technical skill into a consulting practice.

### English Practice (30 min/day, every day)

| Phase | Months | Focus |
|-------|--------|-------|
| 1 | M1-5 | 30 min/day technical reading in English (docs, blog posts, CVEs) |
| 2 | M6-10 | Add language exchange partner (italki / Tandem) 30 min/week; monthly self-recording |
| 3 | M11-15 | Write English articles; practice presenting out loud in English |
| 4 | M16-18 | Client communication scenarios: discovery calls, proposals, executive summaries |

### Networking (15 min/day)

| Month | Activity |
|:-----:|----------|
| M1 | Create LinkedIn + CyberArk Commons accounts; connect with 5 PAM professionals |
| M1–M18 | 1 LinkedIn post or comment per week; 1 CyberArk Commons reply per week |
| M4 | Post Defender achievement; write first "lessons learned" article |
| M6 | Post Sentry achievement; Phase 1 retrospective article |
| M8 | Post Guardian achievement |
| M10 | **Attend first BSides conference** (register by M9) |
| M11 | Publish first full technical article on LinkedIn |
| M12 | Post eJPT achievement; Phase 2 retrospective article |
| M15 | **CyberArk Impact conference** — attend and network with partner firms |
| M17 | Post OSCP achievement; consulting announcement preparation |
| M18 | **Consulting launch announcement** on LinkedIn |

Full month-by-month networking plan: [docs/NETWORKING_STRATEGY.md](../docs/NETWORKING_STRATEGY.md)

---

## PHASE 1: Security Foundations + PAM Mastery (Months 1-6)

---

## MONTH 1 (May 2026): Lab Architecture + PAM Foundations

**Monthly Objective**: Build the lab environment (PAM stack on Windows Server 2022 + Kali Linux attack host) and install Vault + CPM + PVWA. Start offensive mindset from Day 1.

### Week 1-4 Schedule

| Week | Monday–Friday (1.5-2 hrs/day) | Weekend (3-4 hrs total) | Deliverables |
|:----:|:------------------------------|:------------------------|:-------------|
| 1 | VirtualBox / VMware install, lab network planning, Windows Server 2022 eval install, Kali Linux VM install | Kali update + tooling inventory, lab network diagram in draw.io | Lab VMs created, network diagram |
| 2 | CyberArk Vault installation on Windows Server, hardening checklist | Kali: Nmap install, first scans of lab network, nmap output review | Vault installed |
| 3 | CPM installation and integration with Vault, first platform onboarded | Kali: Netcat / socat fundamentals, Wireshark capture of PAM auth traffic | CPM operational |
| 4 | PVWA installation and IIS config, auth method setup | GitHub repo initialized with /labs, /notes, /reports structure | PVWA live, repo created |

### Daily Activities
- **Weekday evenings (1.5-2 hrs)**: Rotate PAM labs (3 days/wk) and Kali / offensive (2 days/wk)
- **Weekend (3-4 hrs total)**: Hands-on lab work, screenshots, notes commits
- **English (30 min/day)**: Technical reading in English — CyberArk docs, Kali tutorials, CVE writeups
- **Networking (15 min/day)**: LinkedIn profile setup, CyberArk Commons account, first 5 connections

### Monthly Checkpoints
- [ ] Week 1: Lab network diagram committed
- [ ] Week 1: LinkedIn profile live + CyberArk Commons account created
- [ ] Week 2: Vault running, first admin login
- [ ] Week 3: CPM managing at least 1 platform
- [ ] Week 4: PVWA accessible, GitHub repo initialized

### Deliverables
- Lab environment (4+ VMs: Vault, CPM, PVWA, Kali) on an isolated network
- Architecture diagram
- GitHub repository scaffolded
- 10+ pages of study notes

---

## MONTH 2 (June 2026): PVWA Advanced + PSM Install + Nmap NSE

**Monthly Objective**: Complete the core PAM stack (add PSM) and deepen Nmap / enumeration skills.

### Week 5-8 Schedule

| Week | Monday–Friday Focus | Weekend Lab | Deliverables |
|:----:|:--------------------|:------------|:-------------|
| 5 | PVWA advanced config: auth methods, LDAP integration | Kali: Nmap NSE scripts against lab | PVWA with LDAP auth |
| 6 | PSM installation and connector config (RDP, SSH) | Kali: Service enumeration techniques (smbclient, enum4linux) | PSM operational |
| 7 | CPM platform policies, password rotation rules | Kali: Custom NSE script draft | Policy documentation |
| 8 | PSM recording safe and first recorded session | Weekend review + notes cleanup | First PSM recording |

### Daily Activities
- **PAM labs**: 4 hrs/wk weekdays, 2 hrs/wk weekend
- **Kali / enumeration**: 3 hrs/wk
- **Study / reading**: 3-4 hrs/wk
- **English (30 min/day)**: CyberArk official docs, Nmap reference, OffSec blog — all in English
- **Networking (15 min/day)**: 1 LinkedIn comment on a PAM post; 1 CyberArk Commons reply

### Monthly Checkpoints
- [ ] Week 5: PVWA authenticates to lab LDAP
- [ ] Week 6: PSM connector working
- [ ] Week 7: CPM rotating passwords on schedule
- [ ] Week 8: Session recording demonstrated

### Deliverables
- Full PAM stack operational (Vault + CPM + PVWA + PSM)
- Custom Nmap NSE script in repo
- 5+ onboarded accounts under rotation

---

## MONTH 3 (July 2026): Defender Prep + Web Security Intro + DVWA

**Monthly Objective**: Drive Defender practice tests to 85%+ and open the web application security track with DVWA and Burp Suite Community.

### Week 9-12 Schedule

| Week | PAM Study | Offensive Lab | Deliverables |
|:----:|:----------|:--------------|:-------------|
| 9  | CyberArk Defender course: core modules | DVWA deployed on Kali, OWASP Top 10 reading | Defender 40% |
| 10 | Defender: platform management, safes | DVWA: SQLi + XSS (Low/Medium) | Defender 65% |
| 11 | Defender practice tests (target 75%+) | Burp Suite Community: proxy, intercept, Repeater | Defender 85% |
| 12 | Defender practice tests (target 85%+) + weak areas | DVWA: CSRF + file upload + command injection | Practice test log ≥85% |

### Daily Activities
- **Defender study + practice**: 5 hrs/wk
- **PAM labs**: 5 hrs/wk
- **Offensive / web security**: 3 hrs/wk
- **English (30 min/day)**: Defender study materials in English; OWASP Top 10 docs
- **Networking (15 min/day)**: CyberArk Commons — read and comment on PAM implementation threads

### Monthly Checkpoints
- [ ] Week 9: Defender course 40%
- [ ] Week 10: DVWA SQLi walkthroughs in notes
- [ ] Week 11: Burp Suite proxy chain working
- [ ] Week 12: Defender practice tests ≥85%

### Deliverables
- Defender practice test log
- DVWA walkthrough notes
- Burp Suite proxy chain documented

---

## MONTH 4 (August 2026): Defender EXAM + CI/CD Security + Portfolio Project 1

**Monthly Objective**: Pass the Defender exam. Publish Portfolio Project 1 (PAM Lab Documentation). Start Linux privilege escalation on TryHackMe.

### Week 13-16 Schedule — **EXAM WEEK: Week 13**

| Week | PAM / Exam | Offensive / Portfolio | Deliverables |
|:----:|:-----------|:----------------------|:-------------|
| 13 | **DEFENDER EXAM** (proctored) | Light TryHackMe | **Defender certification** |
| 14 | PSM session recording deep dive | TryHackMe: Linux PrivEsc room (SUID, sudo, cron) | PSM recording demo |
| 15 | Start Portfolio Project 1 write-up | TryHackMe: Linux PrivEsc continued | Project 1 draft |
| 16 | Portfolio Project 1 polish and publish | TryHackMe: Linux Fundamentals review | **Portfolio Project 1 published** |

### Daily Activities
- **Exam push week**: 13-14 hrs
- **Other weeks**: 12-13 hrs
- **English (30 min/day)**: Continue technical reading; draft LinkedIn post for Defender achievement
- **Networking**: Post Defender certification on LinkedIn (Week 13); write 1 CyberArk Commons article draft

### Monthly Checkpoints
- [ ] Week 13: Defender exam passed
- [ ] Week 13: Defender achievement posted on LinkedIn
- [ ] Week 14: TryHackMe Linux PrivEsc complete
- [ ] Week 15: Project 1 draft complete
- [ ] Week 16: Project 1 published to GitHub

### Deliverables
- **CyberArk Defender certification**
- **Portfolio Project 1: PAM Lab Documentation** (20+ page write-up, diagrams, troubleshooting scenarios)
- TryHackMe Linux PrivEsc room completion

---

## MONTH 5 (September 2026): Sentry Prep + DevSecOps Pipeline

**Monthly Objective**: Sentry practice tests to 85%+. Build the DevSecOps baseline pipeline (Semgrep + gitleaks + Trivy). Enter TryHackMe Intro to Offensive Security path.

### Week 17-20 Schedule

| Week | Sentry Study | DevSecOps / Offensive | Deliverables |
|:----:|:-------------|:----------------------|:-------------|
| 17 | Sentry course: advanced admin | Semgrep installed, first rule set | Semgrep in GitHub Actions |
| 18 | Sentry: policy inheritance, CPM plugins | gitleaks scanning commit history | gitleaks workflow |
| 19 | Sentry practice tests (target 80%+) | Trivy container scanning | Trivy workflow |
| 20 | Sentry practice tests (target 85%+) | TryHackMe Intro to OffSec path rooms | Sentry practice log ≥85% |

### Daily Activities
- **Sentry study + practice**: 5 hrs/wk
- **Advanced PAM labs**: 4 hrs/wk
- **DevSecOps pipeline + TryHackMe**: 4 hrs/wk
- **English (30 min/day)**: DevSecOps and Sentry study materials in English; start drafting first technical article
- **Networking (15 min/day)**: LinkedIn + CyberArk Commons; begin drafting "DevSecOps pipeline with CyberArk" article

### Monthly Checkpoints
- [ ] Week 17: Semgrep running in CI
- [ ] Week 18: gitleaks running in CI
- [ ] Week 19: Trivy running in CI
- [ ] Week 20: Sentry practice tests ≥85%

### Deliverables
- Working CI/CD security pipeline (SAST + secret scan + container scan)
- Sentry practice test log
- TryHackMe Intro to OffSec path progress

---

## MONTH 6 (October 2026): Sentry EXAM + RECOVERY

**Monthly Objective**: Pass Sentry exam in the first week, then recover at 8 hrs/week.

### Week 21-24 Schedule — **EXAM WEEK: Week 21** — then **RECOVERY**

| Week | Focus | Activities | Hours |
|:----:|:------|:-----------|:-----:|
| 21 | **SENTRY EXAM** (proctored) | Final practice test, exam, light celebration | 12-13 |
| 22 | Recovery | Light TryHackMe for fun, rest; start language exchange partner (italki/Tandem) | **8** |
| 23 | Recovery | Conjur documentation preview reading; English self-recording #1 | **8** |
| 24 | Recovery + Portfolio 2 publish | Portfolio Project 2 (DevSecOps baseline) finalized; Sentry achievement + Phase 1 article on LinkedIn | **8** |

### Monthly Checkpoints
- [ ] Week 21: Sentry exam passed
- [ ] Week 21: Sentry achievement posted on LinkedIn
- [ ] Week 22: Language exchange partner session scheduled
- [ ] Week 22-23: Actual rest taken
- [ ] Week 23: Monthly self-recording #1 completed
- [ ] Week 24: Portfolio Project 2 published
- [ ] Week 24: Phase 1 retrospective article published on LinkedIn

### Deliverables
- **CyberArk Sentry certification**
- **Portfolio Project 2: DevSecOps Baseline Pipeline** (public GitHub repo)
- Phase 1 retrospective notes
- Phase 1 closeout: 2 certs + 2 portfolio projects

---

## PHASE 2: Pentesting Foundations + Advanced PAM (Months 7-12)

---

## MONTH 7 (November 2026): PTES Methodology + Kali Mastery + Guardian Prep

**Monthly Objective**: Learn pentesting methodology rigorously. Push Guardian course to 40%. Begin TryHackMe Jr Pentester path.

### Week 25-28 Schedule

| Week | Methodology / Kali | Guardian / PAM | Deliverables |
|:----:|:-------------------|:---------------|:-------------|
| 25 | PTES reading (phases 1-3), Nmap NSE deep dive | Guardian course: enterprise architecture | Methodology notes started |
| 26 | PTES phases 4-7, theHarvester OSINT | Guardian: HA/DR design modules | OSINT walkthrough |
| 27 | Maltego Community, custom recon workflow | Guardian course 30% | Recon methodology doc |
| 28 | TryHackMe Jr Pentester: first 5 rooms | Guardian course 40% | 5 rooms + notes |

### Daily Activities
- **Methodology + offensive**: 7 hrs/wk
- **Guardian course**: 5 hrs/wk
- **Review / notes**: 2 hrs/wk
- **English (30 min/day)**: PTES documentation, OffSec blog, pentesting writeups
- **Networking (15 min/day)**: Language exchange partner 30 min/week; LinkedIn + CyberArk Commons; research BSides events to attend in M10

### Deliverables
- Methodology document (5-10 pages, your own words)
- Guardian course 40% complete
- 5+ TryHackMe rooms

---

## MONTH 8 (December 2026): Guardian EXAM + Exploitation Fundamentals

**Monthly Objective**: Pass Guardian exam weeks 1-2. Metasploit and Burp intermediate, SQLmap, Gobuster.

### Week 29-32 Schedule — **EXAM WEEK: Week 29-30**

| Week | Activities | Deliverables |
|:----:|:-----------|:-------------|
| 29 | Guardian final review + practice tests | Ready for exam |
| 30 | **GUARDIAN EXAM** (proctored) | **Guardian certification** |
| 31 | Metasploit modules, msfvenom, meterpreter | Metasploit lab notes |
| 32 | Burp Intruder/Repeater, SQLmap, Gobuster | Web exploit lab notes |

### Daily Activities
- **Guardian exam push**: 13-14 hrs (Wk 29-30)
- **Exploitation fundamentals**: 13-14 hrs (Wk 31-32)
- **English (30 min/day)**: Exploitation technique writeups, Metasploit docs; post Guardian achievement
- **Networking**: Post Guardian certification on LinkedIn (Week 30); CyberArk Commons Guardian exam tips article

### Deliverables
- **CyberArk Guardian certification**
- Web exploitation lab notes
- 8+ TryHackMe Jr Pentester rooms cumulative
- Portfolio Project 3 draft started

---

## MONTH 9 (January 2027): Active Directory Attacks + Conjur Docker + INE PTS

**Monthly Objective**: THE crown jewel month. Build AD lab, attack with BloodHound + Impacket, stand up Conjur in Docker, start INE PTS.

### Week 33-36 Schedule

| Week | AD / Offensive | Conjur / PAM | Deliverables |
|:----:|:---------------|:-------------|:-------------|
| 33 | AD lab: DC + 2 members + 1 workstation; BloodHound + SharpHound | Conjur OSS in Docker install | AD lab up, Conjur running |
| 34 | Kerberoasting (GetUserSPNs.py), AS-REP Roasting (GetNPUsers.py), Hashcat cracking | Conjur: first policy + secret | Kerberoast demo |
| 35 | Pass-the-Hash: psexec.py / wmiexec.py / smbexec.py; LDAP enum | Conjur host factories | PtH demo |
| 36 | INE PTS sections 1-3 (info gathering, footprinting, scanning) | Portfolio Project 3 final polish | **Portfolio Project 3 published** |

### Daily Activities
- **AD attacks + offensive**: 6 hrs/wk
- **INE PTS**: 4 hrs/wk
- **Conjur Docker**: 2-3 hrs/wk
- **TryHackMe AD rooms**: 2-3 hrs/wk
- **English (30 min/day)**: AD attack writeups, BloodHound docs, Conjur docs in English
- **Networking (15 min/day)**: Language exchange partner weekly; draft LinkedIn article on AD pentesting

### Deliverables
- AD lab operational, BloodHound attack paths documented
- Conjur running in Docker with sample policy
- **Portfolio Project 3: CyberArk Guardian Enterprise Architecture** published
- INE PTS course ~30%

---

## MONTH 10 (February 2027): Network Pentesting + Password Attacks + INE Intensive

**Monthly Objective**: Full network assessment methodology. INE PTS sections 4-5. Mock pentest report.

### Week 37-40 Schedule

| Week | Activities | Deliverables |
|:----:|:-----------|:-------------|
| 37 | Nessus Essentials / OpenVAS scanning of lab | Vuln scan report |
| 38 | Hydra / Medusa brute-force, Hashcat rockyou.txt + rules | Cracking notes |
| 39 | Pivoting with proxychains + SSH dynamic forwarding, Chisel | Pivoting walkthrough |
| 40 | INE PTS sections 4-5 + mock pentest report writing | Mock pentest report (10+ pg) |

### Daily Activities
- **INE PTS**: 5 hrs/wk
- **Hands-on network pentest + reporting**: 6 hrs/wk
- **Conjur / DevSecOps continuation**: 3 hrs/wk
- **English (30 min/day)**: Pentest report writing practice in English; read public pentest reports
- **Networking (15 min/day)**: Register for BSides (target M10); LinkedIn engagement; language exchange partner

### Deliverables
- Mock pentest report (10+ pages) in private repo
- INE PTS course ≥85%
- Pentest SOW template draft

---

## MONTH 11 (March 2027): eJPT Final Prep + Conjur in Kubernetes

**Monthly Objective**: Exam-pace INE practice, HackTheBox Starting Point, Conjur on K8s with authenticator and pod injection.

### Week 41-44 Schedule

| Week | eJPT Prep | Conjur K8s | Deliverables |
|:----:|:----------|:-----------|:-------------|
| 41 | INE practice lab (timed 4-hour block) | Conjur on minikube / kind | Conjur K8s running |
| 42 | HackTheBox Starting Point machine 1 (guided) | Conjur K8s authenticator config | K8s auth working |
| 43 | HackTheBox Starting Point machines 2-3 | Secrets injection to pods (sidecar pattern) | Pod injection demo |
| 44 | INE final practice + eJPT exam scheduling | 3rd consulting presentation delivered | eJPT scheduled |

### Daily Activities
- **eJPT prep**: 8-10 hrs/wk
- **Conjur K8s**: 4-5 hrs/wk
- **English (30 min/day)**: Write first LinkedIn technical article (Conjur + Kubernetes); eJPT exam prep materials in English
- **Networking**: **Attend BSides** (Month 10 target); publish first LinkedIn article; eJPT achievement post planned

### Deliverables
- eJPT exam scheduled
- Conjur K8s deployment with manifests in repo
- 3rd consulting presentation recorded
- 3 HackTheBox Starting Point machines completed

---

## MONTH 12 (April 2027): eJPT EXAM + RECOVERY

**Monthly Objective**: Pass eJPT, then recover at 8 hrs/week.

### Week 45-48 Schedule — **EXAM WEEK: Week 45-46** — then **RECOVERY**

| Week | Activities | Hours |
|:----:|:-----------|:-----:|
| 45 | Final prep + **eJPT 48-hour practical lab** | 14-15 |
| 46 | **eJPT 20 MCQ** + exam completion + report | 14-15 |
| 47 | Recovery — light OSCP prereq reading; eJPT achievement posted on LinkedIn | **8** |
| 48 | Recovery — Phase 2 retrospective; OSCP plan drafted; Phase 2 retrospective article on LinkedIn | **8** |

### Deliverables
- **eJPT certification**
- Phase 2 retrospective
- OSCP plan of attack document
- Phase 2 retrospective article published on LinkedIn

---

## PHASE 3: Cloud Security + Advanced Pentesting + Consulting Launch (Months 13-18)

---

## MONTH 13 (May 2027): OSCP PEN-200 Begins + Conjur K8s HA

**Monthly Objective**: Buy OSCP 90-day lab access at the start of May 2027. PEN-200 modules 1-5. Conjur K8s HA. Publish Portfolio Project 3's CI/CD secrets integration.

### Week 49-52 Schedule

| Week | PEN-200 | Conjur / Portfolio | Deliverables |
|:----:|:--------|:-------------------|:-------------|
| 49 | Purchase OSCP 90-day; PEN-200 Module 1 (Report Writing) + Module 2 (Info Gathering) | Conjur HA cluster on K8s | PEN-200 10% |
| 50 | Module 3 (Vuln Scanning) + Module 4 (Web Attacks) | Conjur cluster LB + Postgres backup | PEN-200 15% |
| 51 | Module 5 (SQLi); first 2 OSCP lab machines | Portfolio 3 polish | PEN-200 20%, 2 OSCP machines |
| 52 | 3 more OSCP lab machines | **Portfolio Project 3 CI/CD integration published** | PEN-200 25%, 5 OSCP machines |

### Daily Activities
- **PEN-200 course**: 7 hrs/wk
- **OSCP lab machines**: 4 hrs/wk
- **Conjur K8s HA**: 3 hrs/wk
- **English (30 min/day)**: PEN-200 course materials in English; write LinkedIn article on Conjur + CI/CD
- **Networking (15 min/day)**: LinkedIn article published; language exchange partner weekly; begin registering for CyberArk Impact

### Deliverables
- PEN-200 course 25%
- 5 OSCP lab machines documented
- Conjur K8s HA working
- **Portfolio Project 3 (Conjur + CI/CD Secrets Management) published**

---

## MONTH 14 (June 2027): OSCP Deep Dive + Multi-Cloud Secrets

**Monthly Objective**: PEN-200 modules 6-10 + AD modules. AWS IAM + Conjur. Azure Entra ID + Conjur.

### Week 53-56 Schedule

| Week | PEN-200 + OSCP Labs | Cloud + Conjur | Deliverables |
|:----:|:--------------------|:---------------|:-------------|
| 53 | Modules 6-7 (AV Evasion, SSH Tunneling); 3 OSCP machines | AWS IAM roles + Conjur integration | PEN-200 35% |
| 54 | Modules 8-9 (Adv Tunneling, Metasploit); 3 OSCP machines | AWS Conjur secret retrieval from EC2 | PEN-200 45% |
| 55 | Module 10 (Password Attacks); 2 OSCP machines | Azure Entra ID tenant + service principal | PEN-200 50% |
| 56 | OSCP AD modules (Enum, Auth Attacks, Lateral, Persistence); 2 machines | Azure + Conjur integration | PEN-200 55%, 15 OSCP machines |

### Daily Activities
- **PEN-200 + OSCP labs**: 10 hrs/wk
- **Cloud + Conjur multi-cloud**: 4-5 hrs/wk
- **English (30 min/day)**: OSCP course content (English-only); cloud pentesting writeups
- **Networking (15 min/day)**: LinkedIn article on cloud pentesting; language exchange partner

### Deliverables
- PEN-200 course 55%
- 15 OSCP lab machines cumulative
- AWS + Conjur working
- Azure Entra ID + Conjur working

---

## MONTH 15 (July 2027): OSCP Challenge Labs + Cloud Pentesting

**Monthly Objective**: Finish PEN-200. Complete one OSCP Challenge Lab network under exam conditions. Attack CloudGoat and Azure AD with ROADtools.

### Week 57-60 Schedule

| Week | OSCP | Cloud Pentesting | Deliverables |
|:----:|:-----|:-----------------|:-------------|
| 57 | PEN-200 modules 11-12 + privesc finish | CloudGoat scenario 1 (IAM privesc) | PEN-200 75% |
| 58 | OSCP-A Challenge Lab — enumeration + foothold | CloudGoat scenario 2 (SSRF-to-IMDS) | Challenge Lab 50% |
| 59 | OSCP-A — AD chain + full report | ROADtools Azure AD enumeration | Challenge Lab 100% |
| 60 | PEN-200 capstone complete; Portfolio 4 publish | Entra ID service principal abuse | **PEN-200 100%** |

### Daily Activities
- **PEN-200 finish + Challenge Lab**: 10 hrs/wk
- **CloudGoat + ROADtools**: 4-5 hrs/wk
- **English (30 min/day)**: Cloud pentesting docs; write multi-cloud architecture article for LinkedIn
- **Networking**: **CyberArk Impact conference** (attend, meet PAM partners, collect contacts); CyberArk Commons article submitted

### Deliverables
- PEN-200 course 100%
- 1 Challenge Lab network completed end-to-end
- 2 CloudGoat scenarios documented
- **Portfolio Project 4: Multi-Cloud Secrets Architecture** published

---

## MONTH 16 (August 2027): OSCP Exam Prep + DevSecOps Security Audit

**Monthly Objective**: Two full 24-hour mock exam attempts. Publish Portfolio Project 5 (DevSecOps security audit of Phase 1 pipeline).

### Week 61-64 Schedule

| Week | Activities | Deliverables |
|:----:|:-----------|:-------------|
| 61 | Buy 10-day lab extension (if needed); AD chain drilling | AD chain practiced 3x |
| 62 | **Mock Exam #1** (24-hour attempt) + report | Mock Exam 1 report |
| 63 | 3 pentest reports from previous machines | 3 reports in repo |
| 64 | **Mock Exam #2** (24-hour attempt) + report; OSCP exam scheduled | Mock Exam 2 report, exam scheduled |

### Daily Activities
- **Mock exam / drilling**: 10-11 hrs/wk
- **Security audit of Phase 1 CI/CD**: 3-4 hrs/wk
- **English (30 min/day)**: Practice OSCP report writing in English; consulting discovery call scripts
- **Networking (15 min/day)**: LinkedIn article on DevSecOps audit methodology; warm outreach drafts to former employer contacts

### Deliverables
- 2 mock 24-hour exams completed with reports
- 3 additional pentest reports written
- **Portfolio Project 5: DevSecOps Security Audit** published
- OSCP exam scheduled for M17

---

## MONTH 17 (September 2027): OSCP EXAM + Consulting Pre-Launch

**Monthly Objective**: Pass OSCP. Begin consulting launch preparations in parallel.

### Week 65-68 Schedule — **EXAM WEEK: Week 66 or 67**

| Week | Activities | Deliverables |
|:----:|:-----------|:-------------|
| 65 | Final prep: notes review, 1 HackTheBox machine, rest; practice 5-minute capability pitch in English | Ready for exam |
| 66 | **OSCP 24-HOUR EXAM** + 24-hour report submission | **OSCP certification** |
| 67 | Rest + report polish if retake needed; plan Portfolio 6; OSCP achievement announcement written | Decompress |
| 68 | Consulting website draft, **LinkedIn OSCP announcement**, GitHub polish, Portfolio 6 start | Website draft, LinkedIn live |

### Contingency
If OSCP exam fails, OffSec provides one free retake within 12 months. **Launch consulting anyway** — Guardian + eJPT is a strong credential stack. Schedule the retake for later and keep moving.

### Deliverables
- **OSCP certification** (expected)
- Consulting website draft
- Updated LinkedIn
- Portfolio Project 6 (Enterprise Capstone) started

---

## MONTH 18 (October 2027): RECOVERY + CONSULTING LAUNCH

**Monthly Objective**: Recovery pace (8 hrs/week). Launch the consulting practice. Publish final portfolio project.

### Week 69-72 Schedule — **RECOVERY + LAUNCH**

| Week | Activities | Hours |
|:----:|:-----------|:-----:|
| 69 | Rest after OSCP. No forced work. | **8** |
| 70 | Rest + light Portfolio 6 writing; practice consulting launch announcement in English | **8** |
| 71 | Business entity registration, MSA / SOW templates, rate card finalized; warm outreach emails drafted | **8** |
| 72 | **Portfolio Project 6 final publish + GO LIVE** (website, **LinkedIn consulting launch announcement**, first warm outreach sent) | **8** |

### Rate Card Guidance (April 2026 North American baseline, adjust for your market)
- **Pentesting**: $175 – $225 / hr
- **PAM implementation**: $200 – $275 / hr
- **Combined assessment + implementation**: $250 – $350 / hr

### Deliverables
- Consulting practice **launched**
- 6 portfolio projects published
- **Portfolio Project 6: Enterprise Capstone (PAM + Conjur + Pentest Assessment)** published
- Business entity registered, rate card published, contracts templated
- First outreach emails sent

---

**Last Updated**: 2026-04-14
**Version**: 1.1
