# OSCP Certification Guide

The OffSec PEN-200 course and OSCP exam — the gold standard practical penetration testing certification. This guide covers preparation, lab strategy, exam-day tactics, and recovery planning for candidates targeting OSCP as part of the 18-month PAM + DevSecOps + Pentesting roadmap.

---

## Overview

### What Is OSCP

The Offensive Security Certified Professional (OSCP) is a hands-on, practical penetration testing certification offered by OffSec (Offensive Security). It is earned by completing the PEN-200 course ("Penetration Testing with Kali Linux") and passing a rigorous 24-hour proctored practical exam.

Unlike multiple-choice certifications, OSCP requires candidates to actually compromise live target machines, escalate privileges, and document their work in a professional report. There are no "brain dumps" that can substitute for real exploitation skill.

### Why OSCP Matters

- The most respected hands-on pentesting certification in the industry
- Demonstrates real exploitation capability, not just theoretical knowledge
- Required by many security firms for junior and mid-level pentester roles
- Unlocks $150-250/hr penetration testing engagements in consulting practice
- Serves as a forcing function to develop methodology, discipline, and reporting skills that translate directly to billable client work
- Recognized by government and regulated industries as meeting DoD 8570 / 8140 requirements at IAT Level III

### Exam Format

- **Duration**: 24-hour practical exam, proctored via webcam and screen share
- **Passing score**: 70+ points out of 100
- **Active Directory set**: Worth 40 points — all-or-nothing. The full AD chain must be compromised (typically 3 machines culminating in Domain Admin) for the 40 points.
- **Standalone machines**: 3 machines, each worth up to 10 points (user flag 5pts + root/SYSTEM flag 5pts, with partial credit for demonstrated progress on some)
- **Bonus points**: 10 bonus points previously available for course exercise completion — verify current policy at exam booking
- **Report window**: Additional 24 hours after exam ends to submit a professional PDF report to OffSec

### Pass Rate

- Industry-wide first-attempt pass rate: approximately 53%
- With disciplined preparation (Challenge Labs completed, methodology honed), first-attempt pass rates of 75%+ are realistic
- Most failures stem from incomplete AD compromise (losing all 40 AD points) rather than from standalone machines

### Cost

| Option | Price | Notes |
|--------|-------|-------|
| PEN-200 90-day lab + 1 exam attempt | $1,499 | Recommended for this roadmap |
| Retake | $249 | 1 retake allowed within 12 months |
| 60-day option | $999 | Too tight for most first-timers |
| 365-day option | $2,599 | Not recommended — too expensive and encourages complacency |

### Timeline in Roadmap

- **M13 (2027-05-01)**: Purchase PEN-200 90-day lab bundle, start course modules
- **M13-M15**: Complete course content and lab machines within the 90-day window
- **M16 (2027-08)**: Dedicated exam preparation — Challenge Labs, methodology refinement
- **M17 (2027-09)**: Take OSCP exam

---

## Prerequisites Checklist

Candidates must be solid on these fundamentals before purchasing PEN-200. In this roadmap, earning eJPT first validates most of these prerequisites.

- [ ] Kali Linux proficiency (tools, terminal, networking, package management)
- [ ] Nmap: full port scans, NSE scripts, output parsing, performance tuning
- [ ] Metasploit: module types, msfvenom payload generation, meterpreter post-exploitation
- [ ] Burp Suite: proxy configuration, Repeater, Intruder, scope management for web app attacks
- [ ] Web application attacks: SQLi (manual and with SQLmap), XSS, file inclusion, directory traversal
- [ ] Active Directory: BloodHound collection and analysis, Kerberoasting, AS-REP Roasting, Pass-the-Hash
- [ ] Linux privilege escalation: SUID binaries, `sudo -l`, cron jobs, Linux capabilities
- [ ] Windows privilege escalation: token impersonation, unquoted service paths, AlwaysInstallElevated
- [ ] Pivoting: proxychains, SSH tunneling, SOCKS proxy setup
- [ ] Technical report writing: findings, evidence, CVSS scoring, remediation recommendations

---

## The PEN-200 Course

### Course Structure

- 17 content modules covering the full penetration testing lifecycle (some editions number sub-modules separately, yielding 21 numbered sections)
- Approximately 150-200 hours of video and written content, worked through at the student's pace within the lab period
- OffSec lab access: 70+ vulnerable machines arranged in multiple network topologies
- Challenge Labs: OSCP-A, OSCP-B, OSCP-C — full Active Directory network environments that simulate actual exam conditions

### Module Overview Table

| # | Module | Key Skills | Priority |
|---|--------|------------|----------|
| 1 | Report Writing for Penetration Testers | Markdown/PDF reports, OffSec template | High (do first) |
| 2 | Information Gathering | Passive/active recon, DNS, web fingerprinting | High |
| 3 | Vulnerability Scanning | Nessus, Nmap scripts, Nikto | Medium |
| 4 | Introduction to Web Application Attacks | HTTP fundamentals, Burp Suite, OWASP Top 10 | High |
| 5 | Common Web Application Attacks | SQLi, XSS, file inclusion, path traversal | High |
| 6 | SQL Injection Attacks | Advanced SQLi, manual exploitation | High |
| 7 | Client-Side Attacks | Macro attacks, JScript, HTML applications | Medium |
| 8 | Locating Public Exploits | ExploitDB, Searchsploit, GitHub hunting | Medium |
| 9 | Fixing Exploits | Modifying public PoC to work in target environment | Medium |
| 10 | Antivirus Evasion | Encoding, obfuscation, custom shellcode | Low-Medium |
| 11 | Password Attacks | Hashcat, John the Ripper, Hydra, credential spraying | High |
| 12 | Windows Privilege Escalation | WinPEAS, token impersonation, service exploits | High |
| 13 | Linux Privilege Escalation | LinPEAS, SUID, cron, capabilities, sudo | High |
| 14 | Port Redirection and SSH Tunneling | proxychains, sshuttle, chisel, ligolo-ng | High (OSCP AD requires this) |
| 15 | Advanced Tunneling | Double pivoting, complex network routing | Medium |
| 16 | The Metasploit Framework | Advanced usage, post-exploitation modules | High |
| 17 | Active Directory Introduction and Enumeration | BloodHound, LDAP, SMB enum, AD basics | **Critical** |
| 18 | Attacking Active Directory Authentication | Kerberoasting, AS-REP Roasting, password spraying | **Critical** |
| 19 | Lateral Movement in Active Directory | Pass-the-Hash, Overpass-the-Hash, Pass-the-Ticket | **Critical** |
| 20 | Active Directory Persistence | DCSync, Golden Ticket, Silver Ticket | **Critical** |
| 21 | Assembling the Pieces | Full AD attack chain practice | **Critical** |

---

## Lab Strategy

### 90-Day Timeline (Months 13-15)

**Month 13 (Weeks 1-4)** — Foundations
- Complete modules 1-5
- Pwn 5 lab machines
- Establish note-taking workflow in CherryTree or Obsidian
- Build a personal command cheat sheet as you encounter new tools

**Month 14 (Weeks 5-8)** — Core Exploitation
- Complete modules 6-14 (exploitation fundamentals plus privilege escalation)
- Pwn 15+ total lab machines
- Begin AD modules in parallel — do NOT save AD for last

**Month 15 (Weeks 9-12)** — AD Mastery and Challenge Labs
- Complete modules 15-21
- Work through OSCP-A, OSCP-B, OSCP-C Challenge Labs
- Target 25-30 total documented machines before lab expiration
- Aim to finish at least one full Challenge Lab before lab time runs out

**Note**: A purchase date of 2027-05-01 gives a 90-day window expiring approximately 2027-07-30. The exam itself is scheduled separately through the OffSec portal and can be booked for a later date — in this roadmap, target a September 2027 exam slot to allow 4-6 weeks of dedicated exam prep after lab expiration.

### Machine Methodology

For each lab machine, follow this exact sequence:

```bash
# 1. Initial scan
nmap -sV -sC -p- --open -oA machine-name/nmap <IP>

# 2. Parse results, list every open service
# 3. Enumerate each service manually (don't trust one tool)
# 4. Web apps: check port 80, 443, 8080, 8443, and any unusual ports
# 5. Identify OS version, software versions
# 6. searchsploit for known CVEs

searchsploit <service-name> <version>

# 7. Attempt exploitation; document what worked and what didn't

# 8. Post-exploitation baseline
whoami
id
hostname
cat /etc/passwd   # Linux
systeminfo        # Windows

# 9. Read flags
cat local.txt
cat proof.txt

# 10. Write machine notes BEFORE moving on
```

### Note-Taking Structure (CherryTree)

Organize notes hierarchically so they can be searched during the exam:

- Root: OSCP Lab
  - Machine Name (IP)
    - Enumeration (full nmap output, web services, SMB, LDAP, etc.)
    - Vulnerabilities Found
    - Exploitation Steps (exact commands, no paraphrasing)
    - Post-Exploitation (privesc path, loot)
    - Flags (local.txt / proof.txt)
    - Lessons Learned

### Challenge Labs (Must Complete Before Exam)

- **OSCP-A**: Windows Active Directory environment, typically 3 machines plus a Domain Controller
- **OSCP-B**: Mixed environment (Windows + Linux + AD)
- **OSCP-C**: Full enterprise simulation with multiple network segments

Complete at least one full Challenge Lab (every machine in the network) before attempting the real exam. These labs are the closest available simulation of actual exam conditions and will expose gaps in methodology that individual lab machines will not.

---

## Exam Day Strategy

### Before the Exam (Week Of)

- Full night's sleep the night before (do NOT cram)
- Test proctoring connection the day before: webcam, screen share, ID check
- Prepare workspace: clean desk, water, snacks within reach, comfortable chair
- Verify VPN connection works by logging in the day before
- Open CherryTree template and Obsidian for report notes
- Set a countdown timer visible on-screen
- Confirm bathroom breaks policy with your proctor

### Exam Machine Priority (70 Points to Pass)

**AD Set (40 points) — Start Here**

All-or-nothing scoring: partial credit is NOT given for the AD set. The full AD chain must be compromised end-to-end.

- Enumerate thoroughly before exploiting anything
- Run BloodHound early — find the attack path before trying exploits
- If stuck after 3 hours: document what you found and pivot to standalones; return with fresh eyes

**Standalone Machines (10 points each)** — 3 machines

Some machines have 2 flags: user = 5 points, root/SYSTEM = 5 points each.

- Pick the easiest-looking machine first to build confidence and lock in points
- Do not tunnel-vision on one standalone machine — rotate if stuck

**Minimum to Pass**: 70 points

Common winning combinations:
- Full AD (40) + 3 fully-compromised standalones (30) = 70 ✓
- Full AD (40) + 2 full standalones (20) + 2 user flags (10) = 70 ✓
- No AD + 3 full standalones (30) = 30 ✗ (cannot pass without AD)

### Time Management

| Hours | Focus |
|-------|-------|
| 1-4 | Enumerate ALL machines; do not tunnel-vision |
| 5-12 | Deep exploitation attempts; swap machines every 2 hours if stuck |
| 13-18 | Focus on remaining machines; revisit AD if not complete |
| 19-24 | Screenshot everything; final enumeration; verify every flag captured |

**Critical tip**: Start writing the REPORT during the exam — not after. Write finding descriptions while the evidence is fresh in memory. The 24-hour report window is tighter than it feels.

### Post-Exam Report

- 24-hour window to write and submit a PDF report
- Must include: OffSec-required cover page, executive summary, methodology, per-machine write-up with screenshots, command outputs proving compromise
- Use OffSec's official report template: <https://github.com/noraj/OSCP-Exam-Report-Template-Markdown>
- Evidence required for every machine: screenshot of `proof.txt` contents with your IP address visible (confirm with `ipconfig` on Windows or `ip a` on Linux in the same screenshot where possible)
- Convert markdown to PDF with pandoc or a similar tool; verify the PDF renders correctly before submission

---

## If You Don't Pass (Contingency Plan)

- OffSec allows 1 retake within 12 months for $249
- Most common failure reason: not completing the AD set and losing all 40 AD points
- Post-failure checklist:
  - Review which machines you could not compromise and why
  - Practice similar machine types on HackTheBox and Proving Grounds
  - Complete any remaining Challenge Labs you skipped
  - Reattempt within 3-4 months while skills are fresh
- **Consulting impact**: The consulting practice can launch as "OSCP Candidate" with eJPT + CyberArk certifications already in hand. The OSCP is a goal to accelerate rates, not a gate that blocks billable work. Do not let a single exam outcome derail the 18-month plan.

---

## Resources

- Official PEN-200 course: <https://www.offsec.com/courses/pen-200/>
- OffSec Proving Grounds (extra practice machines): <https://www.offensive-security.com/labs/>
- TJnull's OSCP practice list (HackTheBox + Proving Grounds machines): <https://docs.google.com/spreadsheets/d/1dwSMIAPIam0PuRBkCiDI88pU3yzrqqHkDtBngUHNCw8/edit>
- OSCP exam report template: <https://github.com/noraj/OSCP-Exam-Report-Template-Markdown>
- IppSec YouTube channel (HackTheBox walkthroughs): <https://www.youtube.com/c/ippsec>
- GTFOBins (Linux privesc): <https://gtfobins.github.io>
- LOLBAS (Windows LOLBins): <https://lolbas-project.github.io>
- HackTricks pentesting reference: <https://book.hacktricks.xyz>
- Related internal docs:
  - [OSCP Cheat Sheets](./OSCP_CHEAT_SHEETS.md)
  - [Active Directory Attack Guide](./ACTIVE_DIRECTORY_ATTACK_GUIDE.md)
  - [Pentesting Methodology Guide](./PENTESTING_METHODOLOGY_GUIDE.md)
  - [eJPT Certification Guide](./EJPT_CERTIFICATION_GUIDE.md)

---

**Last Updated**: 2026-04-14
**Version**: 1.0
