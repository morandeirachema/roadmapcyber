# eJPT Certification Guide

Comprehensive preparation guide for the eLearnSecurity Junior Penetration Tester (eJPT) certification, aligned with months M7-M12 of the Cyber-Roadmap for PAM consultants adding offensive security to their service line.

---

## Overview

The eJPT (eLearnSecurity Junior Penetration Tester) is INE's entry-level penetration testing credential — originally developed by eLearnSecurity and now delivered by INE after the 2021 acquisition. Unlike most entry-level certifications, the eJPT is a fully practical exam: candidates must actually compromise systems, pivot through networks, and collect flags to answer exam questions. This makes it the most respected entry-level pentest certification on the market and a natural predecessor to OSCP.

### What Is the eJPT

- Entry-level penetration testing certification issued by INE (formerly eLearnSecurity)
- Demonstrates ability to perform basic to intermediate network and web application penetration tests
- Validates hands-on skill, not memorization — all questions are answered by actually exploiting lab systems
- Recognized by employers as proof of practical pentest capability, unlike purely theoretical certs
- Vendor-neutral — teaches methodology and tools that transfer to any pentest engagement

### Exam Format

- 48-hour practical exam, fully online, no proctoring
- 20 questions delivered as multiple-choice or flag-based (IP addresses, hostnames, credentials, specific command outputs)
- Candidates connect to a lab environment via OpenVPN and attack real systems
- Multiple hosts across multiple network segments — pivoting is required
- Pass score: 70% (14 of 20 questions correct)
- No formal written report required (unlike OSCP)
- Can be taken from anywhere — no webcam or in-person proctoring

### Difficulty

The eJPT is entry-level but not trivial. It is designed to verify that the candidate can actually perform a penetration test, not just describe one. Candidates who have only watched videos and read books — without running the tools against real systems — will fail. The good news: anyone who consistently practices on TryHackMe and completes the official INE labs has an excellent chance of passing on the first attempt.

### Cost

- Standalone voucher: $200 USD
- INE Platinum Annual Pass: $299/year — includes the full Penetration Testing Student (PTS) course, unlimited lab access, and the eJPT voucher
- Platinum is strongly recommended: the $99 difference buys the entire course plus unlimited practice time, which directly translates to exam readiness

### Timeline in Roadmap

- Study period: Months M7 through M11 (5 months of focused preparation)
- Exam window: Month M12 (target: 2027-04)
- Prerequisites complete by M6: CKA certification, basic CyberArk Defender work, Linux/networking fundamentals

---

## Prerequisites Checklist

Before starting PTS coursework, confirm you are comfortable with each of the following. If any item is unchecked, spend a weekend on TryHackMe fundamentals rooms before beginning the official course.

- [ ] Linux command line proficiency (file system navigation, permissions model, systemd services, package management)
- [ ] Networking fundamentals (TCP/IP stack, IPv4 subnetting, common ports and protocols, OSI model basics)
- [ ] Nmap scanning (host discovery, port scanning, service/version detection, NSE scripts, output formats)
- [ ] Metasploit basics (module types, setting options, payloads, msfvenom, meterpreter sessions)
- [ ] Burp Suite basics (proxy configuration, intercept/forward, Repeater tab, Target sitemap)
- [ ] Web application vulnerabilities (SQL injection, reflected/stored XSS, file inclusion — practiced on DVWA or OWASP Juice Shop)
- [ ] Password attacks (Hydra for online attacks, Hashcat for offline hash cracking, wordlist selection)
- [ ] Pivoting basics (proxychains configuration, SSH local/remote port forwarding, Metasploit autoroute)

---

## Study Path

### Official Course: INE Penetration Testing Student (PTS)

- Course URL: https://ine.com/learning/certifications/internal/elearnsecurity-junior-penetration-tester-cert
- Content volume: approximately 145 hours of video lessons, slide decks, and guided labs
- Free Starter tier: enough theoretical content to pass with supplementary TryHackMe practice
- Platinum tier ($299/year): recommended — unlimited lab access, full PTS course, eJPT voucher included

### Course Sections Overview (PTS)

| Section | Topics | Priority |
| --- | --- | --- |
| 1. Networking | TCP/IP, ports, protocols, packet analysis with Wireshark | High |
| 2. Web Application Security | HTTP/HTTPS, OWASP Top 10, SQLi, XSS, file inclusion, CSRF | High |
| 3. Penetration Testing Basics | Methodology, PTES framework, tool selection | High |
| 4. Information Gathering | Passive and active recon, OSINT sources | Medium |
| 5. Scanning | Nmap deep dive, Nessus, OpenVAS basics | High |
| 6. Exploitation | Metasploit workflow, msfvenom, manual exploitation | High |
| 7. Post-Exploitation | Persistence theory, lateral movement basics, pivoting | Medium |
| 8. Social Engineering | Theory only — not tested heavily on eJPT | Low |
| 9. Auditing | Process documentation, report structure basics | Medium |

### Supplementary Resources

- TryHackMe Jr Penetration Tester path: https://tryhackme.com/path/outline/jrpenetrationtester (~56 hours; closely mirrors eJPT scope)
- PortSwigger Web Security Academy: https://portswigger.net/web-security (free, best-in-class web app training)
- HackTheBox Starting Point machines: https://app.hackthebox.com/starting-point (guided beginner machines)
- PentesterLab (optional, paid): https://pentesterlab.com (web-focused exercises)
- OverTheWire Bandit: https://overthewire.org/wargames/bandit/ (Linux command line fluency)

---

## Exam Domain Breakdown

| Domain | Coverage | Key Skills Tested |
| --- | --- | --- |
| Host & Network Penetration Testing | ~50% | Nmap scanning, service exploitation, Metasploit usage, pivoting, password attacks |
| Web Application Penetration Testing | ~35% | SQL injection, XSS, file inclusion, Burp Suite, directory enumeration, authentication bypass |
| Auditing Fundamentals | ~15% | Methodology, CVSS scoring basics, scope interpretation, evidence documentation |

---

## Exam Strategy

### Before Exam Day

- Practice with INE labs until scoring 90% or higher on practice material
- Pre-configure Kali Linux with every tool you might need (Metasploit, Burp Suite, Gobuster, SQLmap, Hydra, Nikto)
- Have CherryTree or Obsidian open and ready for note-taking during the exam
- Confirm stable internet connectivity and OpenVPN configuration works
- Sleep the night before — the exam is 48 hours, not a single sitting; pace yourself
- Print or bookmark your personal methodology cheat sheet

### During the 48-Hour Window

- Start with methodical reconnaissance — enumerate every in-scope host before attempting any exploitation
- Document everything: IP addresses, open ports, services, credentials found, successful commands
- Use Metasploit's database (`msfdb init`) to organize findings across multiple hosts
- If stuck on a host, move to another and return later — the exam has multiple interconnected systems
- Answer MCQ questions incrementally as you find evidence (flags, credentials, system access)
- Take breaks — 48 hours is more than enough time if used wisely

### Workflow Checklist (For Each Target)

1. `nmap -sV -sC -p- <target>` — full port scan with version and default scripts
2. Enumerate web services with Gobuster and Nikto
3. Check for default credentials on identified services (Tomcat, Jenkins, phpMyAdmin, routers)
4. Search for known exploits via searchsploit or Metasploit `search`
5. Exploit -> gain shell -> enumerate for privilege escalation
6. Document: hostname, IP, operating system, services, credentials, flags

---

## Common Mistakes to Avoid

- Skipping full port scans and missing services on non-standard ports
- Not documenting findings as you go — relying on memory at hour 36 is a losing strategy
- Spending too much time on one host — time-box each attempt to 2-3 hours then pivot
- Forgetting to enumerate and exploit internal network segments through pivoting
- Not checking for web applications on non-standard ports (8080, 8443, 8888, 10000)
- Ignoring UDP services — DNS, SNMP, and TFTP can yield quick wins
- Failing to try default or weak credentials before launching exploits
- Not reading question text carefully — some answers are literal strings from command output

---

## After the eJPT: The OSCP Path

The eJPT validates pentesting fundamentals; OSCP remains the professional standard that commands premium consulting rates. Earning eJPT first is a smart strategy because the skills transfer directly, and the confidence built from passing a practical exam prepares you mentally for the much harder OSCP attempt.

Key differences between eJPT and OSCP:

- OSCP is 24 hours of exam time (vs 48 for eJPT)
- OSCP machines are significantly harder and include Active Directory chains
- OSCP requires a formal written penetration test report (worth significant points)
- OSCP has no MCQ — every point comes from proof files and the report
- OSCP pass rate is roughly 50% on first attempt; eJPT is much higher

The recommended gap between eJPT and OSCP in the Cyber-Roadmap is approximately 5 months of focused HackTheBox practice, cloud pentesting fundamentals, and the OffSec PEN-200 course. See `docs/OSCP_CERTIFICATION_GUIDE.md` for the full OSCP preparation pathway.

---

## Relationship to PAM Consulting

The eJPT skill set directly applies to CyberArk consulting engagements. Web application testing skills map to attacking the Password Vault Web Access (PVWA) interface; network reconnaissance skills apply when mapping a client's PAM environment; service exploitation validates why session isolation and credential vaulting matter. After earning the eJPT, you can credibly offer a light-touch penetration testing engagement as a pre-PAM-implementation assessment — demonstrating specific attack paths that your subsequent CyberArk deployment will close. This bundling transforms a single service line into a higher-value, multi-phase consulting engagement.

---

**Last Updated**: 2026-04-14
**Version**: 1.0
