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

CERTS    │  [DEF] [SEN]  │  [GUA]       [eJPT] │         [OSCP] [GO!]
         │   M3    M5    │   M8           M12  │           M17    M18

RECOVERY │            🏖 │                 🏖  │                 🏖🚀
         │            M6 │                M12  │                M18

══════════════════════════════════════════════════════════════════════════════════════
KEY: ██ = Active phase  ░░ = Inactive   [DEF]=Defender [SEN]=Sentry [GUA]=Guardian
     🏖 = Recovery month (8 hrs/week)   🚀 = Consulting Launch
```

### Quick Reference: Key Milestones

| Month | Week  | Milestone                                         | Hours/Week |
|:-----:|:-----:|:--------------------------------------------------|:----------:|
| M1    | 1-4   | Lab built (PAM stack + Kali Linux + Lab 0 Wallix translation) | 12-13 |
| M3    | 9-12  | **CyberArk Defender certification**               | 13-14      |
| M5    | 17-20 | **CyberArk Sentry certification**                 | 13-14      |
| M6    | 21-24 | **Recovery + Portfolio Projects 2 and 3 published** | **8**    |
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
| M3 | Post Defender achievement; write first "lessons learned" note |
| M5 | Post Sentry achievement |
| M6 | Phase 1 retrospective article; publish Portfolio Projects 2 and 3 |
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

## MONTH 1 (May 2026): Lab Architecture + PAM Foundations + Lab 0 (Wallix Translation)

**Monthly Objective**: Build the lab environment (PAM stack + Kali Linux). Complete Lab 0: translate your existing Wallix knowledge into CyberArk terms. You are not a PAM beginner — you are a multi-vendor expert learning a new product. That distinction changes how you use this month.

### Week 1-4 Schedule

| Week | Monday–Friday (1.5-2 hrs/day) | Weekend (3-4 hrs total) | Deliverables |
|:----:|:------------------------------|:------------------------|:-------------|
| 1 | VirtualBox / VMware install, lab network planning, Windows Server 2022 eval install, Kali Linux VM install | Kali update + tooling inventory, lab network diagram in draw.io | Lab VMs created, network diagram |
| 2 | CyberArk Vault + CPM install; **Lab 0**: build Wallix→CyberArk component mapping (Bastion→PSM, Password Manager→CPM, Web Interface→PVWA) | Kali: Nmap scan lab network; Lab 0 continued — document FortiAuthenticator→PVWA RADIUS mapping | Vault + CPM installed; Lab 0 component map drafted |
| 3 | PVWA install + IIS config; Lab 0: document what CyberArk has that Wallix does not (Conjur, CPM platform plugins, DNA, AAM) | Kali: Netcat / Wireshark capture of PAM auth traffic; Lab 0: commit `comparisons/wallix_vs_cyberark_mapping.md` | PVWA live; Lab 0 mapping committed |
| 4 | PSM installation + first RDP / SSH connector; GitHub repo initialized | Lab 0 final: document what Wallix does differently (appliance-based, PEDM integrated, target-based licensing) | Full PAM stack running; Lab 0 complete |

### Daily Activities
- **Weekday evenings (1.5-2 hrs)**: Rotate PAM labs (3 days/wk) and Kali / Lab 0 writing (2 days/wk)
- **Weekend (3-4 hrs total)**: Hands-on lab work, screenshots, notes commits
- **English (30 min/day)**: Technical reading in English — CyberArk docs, Kali tutorials, CVE writeups
- **Networking (15 min/day)**: LinkedIn profile setup, CyberArk Commons account, first 5 connections

### Monthly Checkpoints
- [ ] Week 1: Lab network diagram committed
- [ ] Week 1: LinkedIn profile live + CyberArk Commons account created
- [ ] Week 2: Vault + CPM running; Lab 0 component mapping started
- [ ] Week 3: PVWA live; Lab 0 `wallix_vs_cyberark_mapping.md` committed
- [ ] Week 4: Full PAM stack (Vault + CPM + PVWA + PSM) operational; Lab 0 complete

### Deliverables
- Lab environment (4+ VMs: Vault, CPM, PVWA + PSM, Kali) on an isolated network
- Architecture diagram
- **Lab 0: `comparisons/wallix_vs_cyberark_mapping.md`** committed to GitHub repo
- GitHub repository scaffolded
- 10+ pages of study notes

---

## MONTH 2 (June 2026): Advanced PAM Config + TryHackMe Foundations + Nmap NSE

**Monthly Objective**: Advanced CyberArk configuration (LDAP auth, CPM policies, PSM recording). Launch the TryHackMe Jr Pentester path in parallel. Your Wallix background means PAM concepts are not new — this month is about product-specific configuration depth, not fundamentals.

### Week 5-8 Schedule

| Week | PAM Config | TryHackMe / Kali | Deliverables |
|:----:|:-----------|:-----------------|:-------------|
| 5 | PVWA advanced config: LDAP integration, auth methods, RADIUS (maps to FortiAuthenticator pattern) | TryHackMe: Linux Fundamentals 1 + 2 | PVWA with LDAP auth |
| 6 | CPM platform policies, password rotation rules, custom platform draft | TryHackMe: Linux Fundamentals 3 + Pre-Security path | CPM rotating passwords |
| 7 | PSM recording safe: first RDP + SSH recorded sessions; connector hardening | Kali: Nmap NSE scripts against lab; TryHackMe: Nmap room | PSM recording demo |
| 8 | CyberArk DNA (Discovery and Audit) — scan lab for unmanaged accounts | Kali: Custom NSE script draft; TryHackMe: Network Services 1 | DNA scan report |

### Daily Activities
- **PAM labs**: 4 hrs/wk weekdays, 2 hrs/wk weekend
- **TryHackMe + Kali**: 4 hrs/wk
- **Study / reading**: 2-3 hrs/wk
- **English (30 min/day)**: CyberArk official docs, Nmap reference, OffSec blog — all in English
- **Networking (15 min/day)**: 1 LinkedIn comment on a PAM post; 1 CyberArk Commons reply

### Monthly Checkpoints
- [ ] Week 5: PVWA with LDAP integration working
- [ ] Week 6: CPM rotating passwords on schedule
- [ ] Week 7: PSM recording demonstrated for RDP and SSH
- [ ] Week 8: DNA scan run against lab; custom NSE script committed; TryHackMe Linux Fundamentals 1-3 + Nmap done

### Deliverables
- Full PAM stack operational with LDAP auth + CPM policies + PSM recording
- CyberArk DNA scan report (even if just the lab — documents unmanaged accounts)
- Custom Nmap NSE script in repo
- TryHackMe: Linux Fundamentals 1-3, Nmap, Network Services 1 rooms completed

---

## MONTH 3 (July 2026): Defender EXAM + Web Security + TryHackMe Acceleration

**Monthly Objective**: Pass the Defender exam. Your Wallix background means the PAM concepts are already internalized — use the freed study time for offensive content (DVWA, Burp Suite, TryHackMe Jr Pentester path). Exam is targeted for Week 9-10.

### Week 9-12 Schedule — **EXAM WEEK: Week 9-10**

| Week | Defender / PAM | Offensive / TryHackMe | Deliverables |
|:----:|:---------------|:----------------------|:-------------|
| 9  | Defender practice tests: target 90%+; book the exam | DVWA deployed + OWASP Top 10 reading; TryHackMe: Passive Recon + Active Recon | Exam booked, DVWA live |
| 10 | **DEFENDER EXAM** (proctored); light PAM review | TryHackMe: Vulnversity + Network Services 2; DVWA: SQLi Low/Medium | **Defender certification** |
| 11 | CyberArk AAM (Application Access Manager) overview — key for Conjur comparison | Burp Suite Community: proxy, intercept, Repeater; TryHackMe: Burp Suite Basics | Burp Suite proxy chain working |
| 12 | CPM custom platform plugin walkthrough (the feature Wallix lacks) | DVWA: CSRF + file upload + command injection; TryHackMe: Burp Suite Repeater | DVWA walkthrough notes |

### Daily Activities
- **Defender final prep + exam**: 5 hrs/wk (weeks 9-10)
- **PAM labs + AAM reading**: 4 hrs/wk (weeks 11-12)
- **Offensive / web security / TryHackMe**: 5-6 hrs/wk
- **English (30 min/day)**: Defender study materials in English; OWASP Top 10 docs; post Defender achievement
- **Networking (15 min/day)**: Post Defender certification on LinkedIn (Week 10); CyberArk Commons — answer 1 question about Vault configuration

### Monthly Checkpoints
- [ ] Week 9: Defender practice tests ≥90%; exam booked
- [ ] Week 10: **Defender exam passed**; achievement posted on LinkedIn
- [ ] Week 11: TryHackMe Burp Suite Basics complete
- [ ] Week 12: DVWA SQLi + XSS + file upload walkthroughs in notes; TryHackMe Jr Pentester path ~30%

### Deliverables
- **CyberArk Defender certification**
- DVWA walkthrough notes
- Burp Suite proxy chain documented
- TryHackMe Jr Pentester path ~30% complete

---

## MONTH 4 (August 2026): Pentesting Acceleration + Portfolio Projects 1 and 2

**Monthly Objective**: Defender is already earned. This month is pentesting push + portfolio writing. Publish Portfolio Project 1 (PAM Lab). Draft Portfolio Project 2 (Wallix vs CyberArk comparison — your strongest differentiator). Advance TryHackMe Jr Pentester path to 55%+.

### Week 13-16 Schedule

| Week | Portfolio Work | TryHackMe / Offensive | Deliverables |
|:----:|:---------------|:----------------------|:-------------|
| 13 | Portfolio Project 1 draft: PAM lab documentation (architecture, install notes, troubleshooting) | TryHackMe: OWASP Top 10 (2021) — 10-challenge room | Project 1 50% |
| 14 | Portfolio Project 1 polish + publish to GitHub | TryHackMe: OWASP Juice Shop; Linux PrivEsc (SUID, sudo, cron) | **Portfolio Project 1 published** |
| 15 | Portfolio Project 2 draft: Wallix vs CyberArk comparison — write from memory, then fill gaps from lab | TryHackMe: Windows PrivEsc; Steel Mountain (guided Metasploit) | Project 2 draft |
| 16 | Portfolio Project 2 continued: add FortiAuthenticator→PVWA RADIUS comparison, architecture diagrams | TryHackMe: Blue (EternalBlue — foundational Windows exploitation) | Project 2 structural draft |

### Daily Activities
- **Portfolio writing**: 4 hrs/wk
- **TryHackMe**: 6 hrs/wk
- **CyberArk lab continued**: 3 hrs/wk
- **English (30 min/day)**: Portfolio documentation writing; review Defender achievement LinkedIn post
- **Networking (15 min/day)**: CyberArk Commons — answer 2 questions; connect with 10 new PAM practitioners

### Monthly Checkpoints
- [ ] Week 14: Portfolio Project 1 published to GitHub (20+ pages, architecture diagrams)
- [ ] Week 15: Portfolio Project 2 structural draft committed
- [ ] Week 16: TryHackMe Jr Pentester path ≥50%; Blue machine completed

### Deliverables
- **Portfolio Project 1: PAM Lab Documentation** published (20+ pages, diagrams, troubleshooting scenarios)
- Portfolio Project 2: Wallix vs CyberArk Comparison — structural draft committed to GitHub (publishes M6)
- TryHackMe Jr Pentester path ≥50% complete

---

## MONTH 5 (September 2026): Sentry EXAM + DevSecOps Pipeline + Portfolio Project 3

**Monthly Objective**: Pass the Sentry exam. Build the DevSecOps CI/CD pipeline (Portfolio Project 3: Semgrep + gitleaks + Trivy in GitHub Actions). Complete TryHackMe Jr Pentester path to 65%+. Exam is targeted for Week 17-18.

### Week 17-20 Schedule — **EXAM WEEK: Week 17-18**

| Week | Sentry / PAM | DevSecOps / TryHackMe | Deliverables |
|:----:|:-------------|:----------------------|:-------------|
| 17 | Sentry practice tests: target 90%+; book the exam | Semgrep installed in GitHub Actions with custom rule set | Exam booked; Semgrep CI working |
| 18 | **SENTRY EXAM** (proctored) | gitleaks scanning commit history + Trivy container scanning | **Sentry certification** + CI pipeline running |
| 19 | CyberArk Sentry lab: policy inheritance, CPM custom platform plugins | TryHackMe: Metasploit Introduction + Blue (unguided); Portfolio Project 3 write-up start | Portfolio Project 3 draft |
| 20 | Portfolio Project 3 polish: document pipeline + findings + what it detected | TryHackMe: Ice + Kenobi + Simple CTF; Portfolio Project 3 draft ≥80% | Portfolio Project 3 ready for M6 publish |

### Daily Activities
- **Sentry final prep + exam**: 5 hrs/wk (weeks 17-18)
- **DevSecOps pipeline + Portfolio writing**: 5 hrs/wk
- **TryHackMe**: 4 hrs/wk
- **English (30 min/day)**: Sentry and DevSecOps study materials in English; draft "DevSecOps pipeline security" content
- **Networking (15 min/day)**: Post Sentry achievement on LinkedIn (Week 18); CyberArk Commons — answer 2+ questions this month

### Monthly Checkpoints
- [ ] Week 17: Sentry practice tests ≥90%; exam booked
- [ ] Week 18: **Sentry exam passed**; achievement posted on LinkedIn
- [ ] Week 19: Full CI pipeline (Semgrep + gitleaks + Trivy) operational in GitHub Actions
- [ ] Week 20: Portfolio Project 3 draft ≥80% complete; TryHackMe Jr Pentester path ≥65%

### Deliverables
- **CyberArk Sentry certification**
- Working CI/CD security pipeline (SAST + secret scan + container scan) committed to GitHub
- Portfolio Project 3 (DevSecOps Pipeline) draft ready to publish in M6
- TryHackMe Jr Pentester path ≥65% complete

---

## MONTH 6 (October 2026): RECOVERY + Publish Portfolio Projects 2 and 3

**Monthly Objective**: Recovery at 8 hrs/week. Finalize and publish Portfolio Projects 2 (Wallix vs CyberArk Comparison) and 3 (DevSecOps Pipeline). Start language exchange partner. Phase 1 retrospective article on LinkedIn.

### Week 21-24 Schedule — **RECOVERY** (8 hrs/week)

| Week | Focus | Activities | Hours |
|:----:|:------|:-----------|:-----:|
| 21 | Recovery | Rest. Light TryHackMe for fun. Start language exchange partner search on italki / Tandem | **8** |
| 22 | Recovery + language | Language exchange partner first session; English self-recording #1 (5 min — explain one PAM concept) | **8** |
| 23 | Portfolio Project 2 polish | Finalize Wallix vs CyberArk comparison: add architecture diagrams, comparison tables, "what I learned" narrative; Conjur documentation preview reading | **8** |
| 24 | Portfolio Projects 2 + 3 publish | **Publish both projects to GitHub**; write Phase 1 retrospective article for LinkedIn; plan Phase 2 | **8** |

### Monthly Checkpoints
- [ ] Week 21: Language exchange partner session scheduled; actual rest taken
- [ ] Week 22: First language exchange session completed; self-recording #1 done
- [ ] Week 23: Portfolio Project 2 polished with diagrams and comparison tables
- [ ] Week 24: **Portfolio Projects 2 and 3 published to GitHub**
- [ ] Week 24: Phase 1 retrospective article published on LinkedIn

### Deliverables
- **Portfolio Project 2: Wallix vs CyberArk Multi-Vendor Comparison** (public GitHub repo)
- **Portfolio Project 3: DevSecOps CI/CD Security Pipeline** (public GitHub repo)
- Phase 1 retrospective notes
- Language exchange partner found; first session completed
- Phase 1 closeout: 2 CyberArk certifications + 3 portfolio projects

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
- Portfolio Project 4 draft started

---

## MONTH 9 (January 2027): Active Directory Attacks + Conjur Docker + INE PTS

**Monthly Objective**: THE crown jewel month. Build AD lab, attack with BloodHound + Impacket, stand up Conjur in Docker, start INE PTS.

### Week 33-36 Schedule

| Week | AD / Offensive | Conjur / PAM | Deliverables |
|:----:|:---------------|:-------------|:-------------|
| 33 | AD lab: DC + 2 members + 1 workstation; BloodHound + SharpHound | Conjur OSS in Docker install | AD lab up, Conjur running |
| 34 | Kerberoasting (GetUserSPNs.py), AS-REP Roasting (GetNPUsers.py), Hashcat cracking | Conjur: first policy + secret | Kerberoast demo |
| 35 | Pass-the-Hash: psexec.py / wmiexec.py / smbexec.py; LDAP enum | Conjur host factories | PtH demo |
| 36 | INE PTS sections 1-3 (info gathering, footprinting, scanning) | Portfolio Project 4 final polish | **Portfolio Project 4 published** |

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
- **Portfolio Project 4: CyberArk Guardian Enterprise Architecture** published
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

**Monthly Objective**: Buy OSCP 120-day lab access at the start of May 2027. PEN-200 modules 1-5. Conjur K8s HA. Publish Portfolio Project 5 (Conjur + CI/CD secrets integration).

### Week 49-52 Schedule

| Week | PEN-200 | Conjur / Portfolio | Deliverables |
|:----:|:--------|:-------------------|:-------------|
| 49 | Purchase OSCP **120-day**; PEN-200 Module 1 (Report Writing) + Module 2 (Info Gathering) | Conjur HA cluster on K8s | PEN-200 10% |
| 50 | Module 3 (Vuln Scanning) + Module 4 (Web Attacks) | Conjur cluster LB + Postgres backup | PEN-200 15% |
| 51 | Module 5 (SQLi); first 2 OSCP lab machines | Portfolio 3 polish | PEN-200 20%, 2 OSCP machines |
| 52 | 3 more OSCP lab machines | **Portfolio Project 5 (Conjur + CI/CD) published** | PEN-200 25%, 5 OSCP machines |

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
- **Portfolio Project 5 (Conjur + CI/CD Secrets Management) published**

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
| 60 | PEN-200 capstone complete; Portfolio 6 publish | Entra ID service principal abuse | **PEN-200 100%** |

### Daily Activities
- **PEN-200 finish + Challenge Lab**: 10 hrs/wk
- **CloudGoat + ROADtools**: 4-5 hrs/wk
- **English (30 min/day)**: Cloud pentesting docs; write multi-cloud architecture article for LinkedIn
- **Networking**: **CyberArk Impact conference** (attend, meet PAM partners, collect contacts); CyberArk Commons article submitted

### Deliverables
- PEN-200 course 100%
- 1 Challenge Lab network completed end-to-end
- 2 CloudGoat scenarios documented
- **Portfolio Project 6: Multi-Cloud Secrets Architecture** published

---

## MONTH 16 (August 2027): OSCP Exam Prep + DevSecOps Security Audit

**Monthly Objective**: Two full 24-hour mock exam attempts. Publish the DevSecOps security audit of Phase 1 CI/CD pipeline (consulting methodology deliverable).

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
- **DevSecOps Security Audit published** (consulting methodology deliverable)
- OSCP exam scheduled for M17

---

## MONTH 17 (September 2027): OSCP EXAM + Consulting Pre-Launch

**Monthly Objective**: Pass OSCP. Begin consulting launch preparations in parallel.

### Week 65-68 Schedule — **EXAM WEEK: Week 66 or 67**

| Week | Activities | Deliverables |
|:----:|:-----------|:-------------|
| 65 | Final prep: notes review, 1 HackTheBox machine, rest; practice 5-minute capability pitch in English | Ready for exam |
| 66 | **OSCP 24-HOUR EXAM** + 24-hour report submission | **OSCP certification** |
| 67 | Rest + report polish if retake needed; plan Portfolio 7; OSCP achievement announcement written | Decompress |
| 68 | Consulting website draft, **LinkedIn OSCP announcement**, GitHub polish, Portfolio 7 start | Website draft, LinkedIn live |

### Contingency
If OSCP exam fails, OffSec provides one free retake within 12 months. **Launch consulting anyway** — Guardian + eJPT is a strong credential stack. Schedule the retake for later and keep moving.

### Deliverables
- **OSCP certification** (expected)
- Consulting website draft
- Updated LinkedIn
- Portfolio Project 7 (Enterprise Capstone) started

---

## MONTH 18 (October 2027): RECOVERY + CONSULTING LAUNCH

**Monthly Objective**: Recovery pace (8 hrs/week). Launch the consulting practice. Publish final portfolio project.

### Week 69-72 Schedule — **RECOVERY + LAUNCH**

| Week | Activities | Hours |
|:----:|:-----------|:-----:|
| 69 | Rest after OSCP. No forced work. | **8** |
| 70 | Rest + light Portfolio 7 writing; practice consulting launch announcement in English | **8** |
| 71 | Business entity registration, MSA / SOW templates, rate card finalized; warm outreach emails drafted | **8** |
| 72 | **Portfolio Project 7 final publish + GO LIVE** (website, **LinkedIn consulting launch announcement**, first warm outreach sent) | **8** |

### Rate Card Guidance (April 2026 North American baseline, adjust for your market)
- **Pentesting**: $175 – $225 / hr
- **PAM implementation**: $200 – $275 / hr
- **Combined assessment + implementation**: $250 – $350 / hr

### Deliverables
- Consulting practice **launched**
- 7 portfolio projects published
- **Portfolio Project 7: Enterprise Capstone (PAM + Conjur + Pentest Assessment)** published
- Business entity registered, rate card published, contracts templated
- First outreach emails sent

---

**Last Updated**: 2026-04-15
**Version**: 2.0
