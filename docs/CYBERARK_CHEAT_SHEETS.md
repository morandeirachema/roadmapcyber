# CyberArk Certification Cheat Sheets - A+ Grade Reference

**Quick reference guide for CyberArk Defender, Sentry, and Guardian certifications**

---

## Table of Contents

- [How to Use These Cheat Sheets](#how-to-use-these-cheat-sheets)
- [Defender Cheat Sheet](#defender-cheat-sheet)
- [Sentry Cheat Sheet](#sentry-cheat-sheet)
- [Guardian Cheat Sheet](#guardian-cheat-sheet)
- [Quick Reference Tables](#quick-reference-tables)
- [Troubleshooting Quick Reference](#troubleshooting-quick-reference)
- [Exam Day Quick Cards](#exam-day-quick-cards)

---

## How to Use These Cheat Sheets

**Purpose**: Quick review materials for last-minute exam preparation and on-the-job reference

**Best Practices**:
1. **Week before exam**: Review relevant cheat sheet daily (10-15 min)
2. **Day before exam**: Read through once in evening
3. **Exam day morning**: Quick glance (5 min) before entering test center
4. **On the job**: Keep accessible for quick lookups

**Format**: Each section is designed for rapid scanning with key information highlighted

---

## Defender Cheat Sheet

### Architecture & Components (20%)

**Core Components:**
```
┌─────────────────────────────────────┐
│ DIGITAL VAULT (Password Vault)      │
│ - Central secure repository         │
│ - Port: 1858 (Vault), 18923 (DR)   │
│ - Stores: Passwords, SSH keys, etc.│
│ - Clustering: Active/Active or DR   │
└─────────────────────────────────────┘
           │
           ├──> PVWA (Password Vault Web Access)
           │    - Web interface for users
           │    - IIS-based application
           │    - Ports: 443 (HTTPS)
           │
           ├──> CPM (Central Policy Manager)
           │    - Automated password management
           │    - Change, Verify, Reconcile
           │    - Platform-based management
           │
           └──> PSM (Privileged Session Manager)
                - Session isolation and recording
                - RDP, SSH, SQL, custom protocols
                - Records all session activity
```

**Deployment Models:**
- **Standalone**: All components on separate servers
- **Combined**: PVWA + CPM on one server (small deployments)
- **Distributed**: Components across multiple data centers
- **Cloud**: Hosted on AWS, Azure, or CyberArk Cloud

**Key Ports to Remember:**
| Component | Port | Protocol | Purpose |
|-----------|------|----------|---------|
| Vault | 1858 | Proprietary | Primary Vault communication |
| PVWA | 443 | HTTPS | Web interface |
| PSM | 3389 | RDP | Windows connections |
| PSM | 22 | SSH | Unix/Linux connections |
| DR Vault | 18923 | Proprietary | Disaster Recovery replication |

---

### Account Management (25%)

**The 3 CPM Operations:**

1. **Change** (Password Rotation)
   - Scheduled or on-demand
   - Uses "Change" password (new random password)
   - Updates password on target system
   - Updates password in Vault
   - Frequency: Set in platform policy

2. **Verify** (Password Verification)
   - Confirms password in Vault matches target system
   - Uses current password to login
   - No changes made if successful
   - If fails → triggers Reconcile
   - Frequency: More often than Change (e.g., daily)

3. **Reconcile** (Password Reset)
   - Triggered when Verify fails
   - Uses **Reconcile Account** (privileged account)
   - Resets password on target to match Vault
   - Emergency recovery mechanism

**Platform Types:**
```
Windows Domain Accounts
  └─> Change method: Windows API, PowerShell
  └─> Verify method: WinRM, PowerShell
  └─> Requires: AD integration

Unix (via SSH)
  └─> Change method: SSH + passwd command
  └─> Verify method: SSH login test
  └─> Requires: SSH keys or password

Database (SQL Server, Oracle, MySQL)
  └─> Change method: SQL ALTER USER
  └─> Verify method: SQL login test
  └─> Requires: Database drivers

Custom/API
  └─> Change method: REST API calls
  └─> Verify method: API authentication test
  └─> Requires: API endpoints
```

**Account Properties (Must Know):**
- **Address**: Target system (IP or FQDN)
- **Username**: Account name on target
- **Platform**: Determines management method
- **Safe**: Where account is stored
- **Automatic Management**: Enabled/Disabled
- **Change Frequency**: Days between password changes
- **Verify Frequency**: Days between verifications

**Onboarding Accounts:**
```
Manual (via PVWA):
  1. Navigate to Accounts
  2. Add Account
  3. Select Platform
  4. Enter Address, Username, Password
  5. Select Safe
  6. Save

Bulk (via Password Upload Utility):
  1. Prepare CSV file
  2. Run Password Upload Utility
  3. Map columns to account properties
  4. Upload and verify

API (via REST):
  POST /PasswordVault/API/Accounts
  {
    "name": "Operating System-WinDomain-admin",
    "address": "server01.domain.com",
    "userName": "admin",
    "platformId": "WinDomain",
    "safeName": "Windows-Admins",
    "secret": "P@ssw0rd",
    "platformAccountProperties": {},
    "secretManagement": {
      "automaticManagementEnabled": true
    }
  }
```

---

### Safe Management (20%)

**Safe = Secure Container for Accounts**

**Safe Permissions (Key Ones for Exam):**

| Permission | Description | Typical Use |
|-----------|-------------|-------------|
| **Use Accounts** | Connect via PSM without seeing password | End users |
| **Retrieve Accounts** | View/copy password | Power users |
| **List Accounts** | See accounts in Safe | Required with Retrieve |
| **Add Accounts** | Onboard new accounts | PAM admins |
| **Update Account Content** | Modify account properties | PAM admins |
| **Update Account Properties** | Change metadata | PAM admins |
| **Initiate CPM Management** | Enable auto password management | PAM admins |
| **Authorize Password Requests** | Approve access requests | Managers |
| **Access Without Confirmation** | Skip approval workflow | Trusted users |

**Master Policy:**
- Applies to all Safes by default
- Can be overridden at Safe level
- Controls default retention, versioning
- Best practice: Configure at Master level, override sparingly

**Approval Workflows:**
```
User requests password:
  1. User clicks "Request Access"
  2. Request sent to Authorizers
  3. Authorizer approves/denies
  4. If approved, user granted temp access
  5. Access expires after timeout

Requirements for approval:
  - User has "List Accounts" permission
  - User does NOT have "Access Without Confirmation"
  - Safe requires authorization
```

**Safe Naming Best Practices:**
- Max 28 characters
- Use consistent naming: `[Type]-[Region]-[Environment]`
- Examples:
  - `Windows-US-Production`
  - `Unix-EU-Dev`
  - `Database-APAC-Test`

---

### User Management (15%)

**User Types:**

1. **Vault Users** (Internal)
   - Stored in Vault
   - Authenticated by Vault
   - Use case: Small deployments, service accounts

2. **LDAP Users** (External)
   - Stored in AD/LDAP
   - Authenticated by AD/LDAP
   - Use case: Enterprise deployments
   - Best practice: Use groups, not individual users

3. **RADIUS Users**
   - Authenticated via RADIUS server
   - Use case: MFA integration

**Authentication Methods Priority:**
```
1. PKI (Certificate)
2. RADIUS
3. LDAP
4. Vault (Internal)
5. Windows (Deprecated)
6. SAML (Modern deployments)
```

**User Groups:**
- **Built-in Groups**: Vault Admins, Auditors, Users, etc.
- **Custom Groups**: Created for specific needs
- **LDAP Groups**: Synced from Active Directory
- **Best Practice**: Assign permissions to groups, not individual users

**Important Built-in Accounts:**
- **Administrator**: Master Vault admin (DO NOT DELETE)
- **Master**: CD image authentication (system use)
- **Auditor**: Read-only audit access
- **Backup Users**: Vault backup operations

---

### Monitoring & Reporting (10%)

**Vault Audit Log:**
- **Location**: Vault server (italog.log)
- **What's logged**: All Vault operations (login, account access, password changes)
- **Format**: Proprietary binary format, viewable via PrivateArk Client
- **Retention**: Configurable, default 30 days

**Safe Audit:**
- **Location**: Each Safe has audit trail
- **What's logged**: Safe-specific operations
- **View in**: PVWA → Monitoring → Safe Audit

**Session Recordings:**
- **Location**: Vault (large files)
- **View in**: PVWA → Monitoring → Privileged Sessions → Recordings
- **Format**: Video-like playback
- **Retention**: Configurable, consider storage

**SIEM Integration:**
- **Method**: Syslog forwarding
- **Format**: CEF (Common Event Format)
- **Configure in**: PrivateArk Client → Tools → Options → SIEM
- **Events**: Configurable filters (e.g., only password retrievals, failures)

**Reports (PVWA):**
- **Accounts Inventory**: All accounts in Vault
- **Password Expiration**: Upcoming password changes
- **Compliance**: Audit compliance reports
- **Custom**: Build custom reports via Audit

---

### Troubleshooting (10%)

**Common Issues & Solutions:**

**Issue 1: User cannot login to PVWA**
```
Symptoms: "Invalid username or password" error

Troubleshooting Steps:
1. Verify user exists in Vault or LDAP
2. Check LDAP configuration if using AD
3. Test LDAP connectivity: Tools → Test LDAP
4. Check Vault connectivity from PVWA server
5. Review PVWA logs (IIS logs, CyberArk logs)
6. Verify user is not locked (PrivateArk Client)

Common Causes:
- LDAP/AD connectivity failure
- User account locked after failed attempts
- Vault connectivity issue (port 1858 blocked)
- Incorrect LDAP bind credentials
```

**Issue 2: CPM password change fails**
```
Symptoms: Account shows "Change Failed" status

Troubleshooting Steps:
1. Check CPM logs: pm.log, pm_error.log
2. Verify network connectivity to target system
3. Test platform configuration (Connection Test)
4. Verify reconcile account credentials (if exists)
5. Check platform credentials (username, password correct?)
6. Review target system logs (Windows Event Log, syslog)

Common Causes:
- Network firewall blocking access
- Platform misconfiguration (wrong change command)
- Reconcile account password incorrect
- Target system policy preventing password change
- Account locked on target system
```

**Issue 3: PSM session fails to launch**
```
Symptoms: "Cannot connect" or session doesn't launch

Troubleshooting Steps:
1. Check PSMConsole.log, PSMTrace.log
2. Verify connection component exists for protocol
3. Test network connectivity from PSM to target
4. Verify PSM service is running
5. Check Safe permissions (Use Accounts granted?)
6. Test RDP/SSH directly from PSM server to target

Common Causes:
- Connection component not configured
- Network connectivity issue
- PSM service stopped
- User lacks "Use Accounts" permission
- Target system RDP/SSH disabled
```

**Log File Locations (Windows Default):**
```
Vault:
  C:\Program Files (x86)\PrivateArk\Server\Logs\italog.log

PVWA:
  C:\inetpub\wwwroot\PasswordVault\Logs\
  C:\Windows\System32\LogFiles\W3SVC1\ (IIS logs)

CPM:
  C:\Program Files (x86)\CyberArk\Password Manager\Logs\pm.log
  C:\Program Files (x86)\CyberArk\Password Manager\Logs\pm_error.log

PSM:
  C:\Program Files (x86)\CyberArk\PSM\Logs\PSMConsole.log
  C:\Program Files (x86)\CyberArk\PSM\Logs\PSMTrace.log
```

---

### Exam-Specific Quick Facts

**Must-Know Numbers:**
- Safe name max length: **28 characters**
- Vault primary port: **1858**
- DR Vault port: **18923**
- Default Verify frequency: **Daily (1 day)**
- Default Change frequency: **Weekly (7 days)**
- Password versions retained: **Configurable** (default 3-5)
- Maximum concurrent PSM sessions: **License dependent**

**Must-Know Concepts:**
1. **Shared Responsibility**: Vault stores, CPM manages, PSM isolates
2. **Least Privilege**: Grant minimum permissions needed
3. **Dual Control**: Require 2 approvals for critical accounts
4. **Just-in-Time Access**: Temporary, time-limited access
5. **Zero Standing Privilege**: No permanent elevated access

**CPM Logic (Exam Favorite):**
```
IF password change scheduled:
  → Perform Change operation
ELSE IF verify scheduled:
  → Perform Verify operation
  → IF Verify fails:
    → Perform Reconcile operation (if reconcile account exists)
```

**Exam Keywords to Watch:**
- **"FIRST"** → What should be done first? (Usually: Check logs)
- **"BEST"** → Multiple correct answers, choose best
- **"PRIMARY"** → Main reason/concern
- **"LEAST"** → Opposite of most/best

---

## Sentry Cheat Sheet

### Advanced Architecture & HA/DR (15%)

**High Availability (HA):**
```
┌──────────────────────────────────────────────┐
│ Load Balancer (Active/Active)               │
│   - Distributes user traffic                 │
│   - Health checks on PVWA instances          │
│   - Sticky sessions for user experience      │
└──────────┬───────────────────┬────────────────┘
           │                   │
    ┌──────▼─────┐      ┌─────▼───────┐
    │  PVWA #1   │      │  PVWA #2    │
    └──────┬─────┘      └─────┬───────┘
           │                   │
    ┌──────▼───────────────────▼───────┐
    │   Vault (Clustered or DR)        │
    │   - Active/Active cluster (2+)   │
    │   - OR Active/Passive DR          │
    └──────────────────────────────────┘
```

**Vault Clustering vs. DR:**

| Feature | Clustering (Active/Active) | DR (Active/Passive) |
|---------|----------------------------|---------------------|
| **Purpose** | High availability | Disaster recovery |
| **Nodes** | 2-5 active nodes | 1 active + 1 passive |
| **Failover** | Automatic (seconds) | Manual or automatic (minutes) |
| **Data Sync** | Real-time synchronous | Asynchronous replication |
| **Distance** | Same datacenter/region | Different datacenter/region |
| **Use Case** | Business continuity | Site failure recovery |

**DR Replication:**
- **Port**: 18923 (DR replication)
- **Mode**: Asynchronous (eventual consistency)
- **Failover**: Manual or automatic (with monitoring)
- **Failback**: After primary Vault restored

**Component Redundancy Best Practices:**
```
Production Enterprise Deployment:

PVWA:
  - Minimum: 2 instances (load balanced)
  - Medium: 3-4 instances
  - Large: 5+ instances
  - Sizing: 2 CPU, 8 GB RAM per instance (minimum)

CPM:
  - Minimum: 1 (2 recommended for redundancy)
  - Separate CPMs for different environments (prod, dev)
  - Load balancing: Automatic (based on Safe ownership)

PSM:
  - Minimum: 2 instances (load balanced)
  - Sizing: 4 CPU, 8 GB RAM minimum
  - Isolation: Separate PSM per security zone

Vault:
  - Clustered: 3-5 nodes (odd number recommended)
  - DR: 1 primary + 1 DR site
  - Sizing: 4+ CPU, 16+ GB RAM (depends on scale)
```

---

### Implementation & Installation (25%)

**Installation Order (Critical for Exam):**
```
1. Digital Vault (Primary)
   - Install Vault software
   - Configure Vault.ini
   - Initialize Vault (PrivateArk Server)
   - Create Master CD (recovery)

2. PrivateArk Client (Admin Workstation)
   - Install client
   - Connect to Vault
   - Configure Safes, users

3. PVWA (Web Interface)
   - Prerequisites: IIS, .NET Framework
   - Install PVWA
   - Configure DBParm.ini (Vault connectivity)
   - Configure IIS (SSL, application pool)
   - Test web access (https://pvwa.domain.com/PasswordVault)

4. CPM (Password Manager)
   - Prerequisites: .NET Framework
   - Install CPM
   - Configure Vault.ini (Vault connectivity)
   - Create CPM user in Vault
   - Grant CPM permissions
   - Test password change on sample account

5. PSM (Session Manager)
   - Prerequisites: Terminal services, .NET
   - Install PSM
   - Configure Vault.ini
   - Create PSM user and groups
   - Configure connection components
   - Test RDP/SSH session

6. DR Vault (if applicable)
   - Install DR Vault
   - Configure replication (port 18923)
   - Test failover procedures
```

**Key Configuration Files:**

**Vault.ini** (Vault Connection Config):
```ini
[Main]
Address=vault.domain.com
Port=1858
Timeout=30
```

**DBParm.ini** (PVWA → Vault):
```ini
[Main]
VaultAddress=vault.domain.com
VaultPort=1858
VaultUser=VaultUser
VaultPassword=<encrypted>
```

**Prerequisites Checklist:**
```
Windows Server:
  □ OS: Windows Server 2016/2019/2022
  □ .NET Framework 4.8+
  □ IIS (for PVWA)
  □ Ports: Open firewall rules
  □ SSL Certificate: Valid and trusted
  □ Service Account: For CyberArk services

Linux (for PSM SSH):
  □ OS: RHEL 7/8, Ubuntu 18/20
  □ Ports: 22 (SSH), 1858 (Vault)
  □ Packages: OpenSSH, specific libraries
```

---

### Advanced Account Management (20%)

**Custom Platform Creation:**

**Use Cases:**
- Unsupported applications
- Custom authentication methods
- Legacy systems
- API-based password changes

**Platform XML Structure:**
```xml
<Platform>
  <PolicyID>CustomApp</PolicyID>
  <PolicyName>Custom Application</PolicyName>
  <PolicyType>Generic</PolicyType>

  <Properties>
    <Required>
      <Property Name="Address"/>
      <Property Name="UserName"/>
    </Required>
    <Optional>
      <Property Name="Port" DefaultValue="443"/>
      <Property Name="APIEndpoint"/>
    </Optional>
  </Properties>

  <PasswordChangePolicy>
    <ScriptName>ChangeCustomApp.ps1</ScriptName>
    <Frequency>7</Frequency>
  </PasswordChangePolicy>

  <VerifyPolicy>
    <ScriptName>VerifyCustomApp.ps1</ScriptName>
    <Frequency>1</Frequency>
  </VerifyPolicy>
</Platform>
```

**Reconcile Account Deep Dive:**

**What is it?**
- Privileged account used to reset passwords when Verify fails
- Has administrative rights on target system
- Stored in same Safe as managed accounts
- NOT automatically managed by CPM (manual password rotation)

**Configuration:**
```
1. Create reconcile account on target system
   - Example: "reconcile_admin" with Domain Admin rights

2. Onboard reconcile account to Vault
   - Platform: Same as managed accounts
   - Automatic Management: DISABLED
   - Safe: Same Safe as managed accounts

3. Link to managed accounts
   - PVWA → Account → Reconcile Account tab
   - Select the reconcile account

4. Test reconciliation
   - Change password on target manually (simulate Verify failure)
   - Trigger Verify operation
   - CPM should detect mismatch and Reconcile
```

**Advanced Password Policies:**

**Complex Password Rules:**
```
Minimum Length: 12-16 characters
Complexity Requirements:
  - Uppercase: 2+ (A-Z)
  - Lowercase: 2+ (a-z)
  - Numbers: 2+ (0-9)
  - Special Characters: 2+ (!@#$%^&*)
  - No repeating characters: >2
  - No username in password
  - No dictionary words

Example Generated Password:
  Kp9@mTv2$Lq4Wx7#

Excluded Characters:
  - Ambiguous: 0O, 1Il
  - Special cases: Quotes, backslash (for scripts)
```

**Account Discovery (ADE):**
- **Purpose**: Find privileged accounts across network
- **Methods**: Windows (AD, local), Unix (SSH), AWS (IAM)
- **Process**: Scan → Discover → Report → Onboard

---

### Privileged Session Management (15%)

**PSM Components:**

```
User Request (PVWA)
  │
  └──> PSM Server (Session Broker)
        │
        ├──> Connection Component (RDP, SSH, SQL, etc.)
        │     └──> Target System Connection
        │
        ├──> Session Recording Engine
        │     └──> Recording stored in Vault
        │
        └──> Session Isolation
              └──> User never sees password
```

**Connection Components:**

| Type | Protocol | Target Systems | Use Case |
|------|----------|----------------|----------|
| **PSM-RDP** | RDP | Windows Servers | Remote desktop |
| **PSM-SSH** | SSH | Unix/Linux | Shell access |
| **PSM-WinSCP** | SFTP | File servers | Secure file transfer |
| **PSM-SQLPlus** | Oracle Net | Oracle DB | Database admin |
| **PSM-SQLServer** | TDS | SQL Server | Database admin |
| **PSM-VMware** | HTTPS | vCenter | VMware management |

**Session Recording:**

**What's recorded:**
- All keystrokes
- All screen activity
- All commands executed
- Clipboard operations
- File transfers

**Storage:**
- Recordings stored in Vault (large)
- Can be offloaded to external storage
- Retention policy configurable

**Playback:**
- PVWA → Monitoring → Privileged Sessions → Recordings
- Search by user, target, time
- Can skip idle time
- Export capability

---

### Integration (15%)

**LDAP/AD Integration:**

**Configuration Steps:**
1. **Configure LDAP Directory**
   - PVWA → Administration → LDAP Integration
   - Add LDAP directory
   - Bind credentials (service account)
   - Base DN (e.g., DC=domain,DC=com)

2. **Map LDAP Groups to Vault Roles**
   - LDAP Group: "PAM-Admins"
   - Maps to: Vault Admin role

3. **Test Authentication**
   - Login with AD user
   - Verify group mapping

**REST API Usage:**

**Common Operations:**

**Logon:**
```bash
POST /PasswordVault/API/Auth/Cyberark/Logon
Content-Type: application/json

{
  "username": "apiuser",
  "password": "P@ssw0rd"
}

Response:
{
  "CyberArkLogonResult": "SessionToken123..."
}
```

**List Accounts:**
```bash
GET /PasswordVault/API/Accounts?search=targetserver
Authorization: SessionToken123...

Response:
{
  "Accounts": [
    {
      "id": "42_5",
      "name": "Operating System-WinDomain-admin",
      "address": "targetserver.domain.com",
      "userName": "admin",
      "platformId": "WinDomain",
      "safeName": "WindowsAdmins"
    }
  ]
}
```

**Retrieve Password:**
```bash
POST /PasswordVault/API/Accounts/42_5/Password/Retrieve
Authorization: SessionToken123...

Response:
"CurrentP@ssw0rd123"
```

**SIEM Integration (Advanced):**

**Syslog Configuration:**
```
PrivateArk Client → Tools → Options → SIEM

Settings:
  - Syslog Server: siem.domain.com
  - Port: 514 (UDP) or 6514 (TCP/TLS)
  - Format: CEF (Common Event Format)
  - Events to Send:
    ☑ Password Retrievals
    ☑ Failed Login Attempts
    ☑ Safe Access Violations
    ☑ Account Modifications
    ☐ CPM Operations (optional, high volume)
```

**Sample CEF Log:**
```
CEF:0|CyberArk|Vault|11.5|300|Password Retrieved|8|
  suser=john.doe dvc=10.1.1.100 dvchost=vault.domain.com
  fname=OS-WinDomain-admin dst=targetserver.domain.com
  act=Retrieve Password cs1Label=Safe cs1=WindowsAdmins
```

---

### Security & Compliance (10%)

**Hardening Checklist:**

**Vault Hardening:**
```
□ Change default Administrator password
□ Disable unused authentication methods
□ Enable Vault audit logging
□ Configure Master Policy (password retention, versioning)
□ Enable SIEM forwarding
□ Regular backups (daily recommended)
□ Master CD stored securely offsite
```

**PVWA Hardening:**
```
□ SSL/TLS only (HTTPS)
□ Strong cipher suites
□ Disable HTTP
□ IIS hardening (remove default pages, limit methods)
□ Session timeout (15-30 min)
□ IP whitelisting (if applicable)
□ WAF integration (Web Application Firewall)
```

**Network Hardening:**
```
□ Firewall rules (allow only required ports)
□ Network segmentation (PAM in dedicated VLAN/subnet)
□ No direct internet access to Vault
□ Jump host for administration
□ IDS/IPS monitoring
```

**Compliance Frameworks:**

**PCI-DSS:**
- **Requirement 8**: Unique IDs for access
- **Requirement 8.2.3**: Strong passwords
- **Requirement 8.2.4**: Change passwords every 90 days
- **Requirement 8.7**: Access to databases restricted
- **CyberArk Role**: Manages privileged accounts, enforces rotation

**HIPAA:**
- **164.308(a)(3)**: Access controls for ePHI
- **164.308(a)(4)**: Access logs and audits
- **164.312(a)(1)**: Unique user identification
- **CyberArk Role**: Restricts access, provides audit trails

---

## Guardian Cheat Sheet

### Enterprise Architecture & Design (30%)

**Sizing & Capacity Planning:**

**Vault Sizing Formula:**
```
Users: 10,000 active users
Accounts: 50,000 managed accounts
Sessions: 500 concurrent PSM sessions

Vault Server:
  CPU: 8+ cores (2.5 GHz+)
  RAM: 32 GB (16 GB base + 16 MB per 1,000 accounts)
  Disk: 500 GB (200 GB base + 100 MB per 1,000 accounts + recordings)
  IOPS: 3,000+ (SSD recommended)

Calculation:
  RAM = 16 GB + (50,000/1,000 × 16 MB) = 16 GB + 800 MB ≈ 17 GB (32 GB safe)
  Disk = 200 GB + (50,000/1,000 × 100 MB) = 200 GB + 5 GB = 205 GB (500 GB safe)
```

**PVWA Sizing:**
```
Concurrent Users: 1,000 users

PVWA Instances: 4 (load balanced)
  Per Instance:
    CPU: 4 cores
    RAM: 16 GB
    Disk: 100 GB

Calculation:
  - ~250-300 users per PVWA instance
  - 1,000 / 250 = 4 instances minimum
  - Add 20% buffer = 5 instances recommended
```

**Network Architecture:**

**Security Zones:**
```
┌─────────────────────────────────────────────────┐
│  INTERNET                                       │
└────────────────┬────────────────────────────────┘
                 │
        ┌────────▼─────────┐
        │  DMZ (Perimeter) │
        │  - WAF            │
        │  - Load Balancer  │
        └────────┬─────────┘
                 │ (HTTPS 443)
        ┌────────▼───────────┐
        │  SECURED ZONE      │
        │  - PVWA Servers    │
        │  - PSM Servers     │
        └────────┬───────────┘
                 │ (Port 1858)
        ┌────────▼──────────┐
        │  RESTRICTED ZONE  │
        │  - Vault Cluster  │
        │  - CPM Servers    │
        └───────────────────┘
                 │
        (Firewall: Deny All, Allow Explicit)
                 │
        ┌────────▼─────────────┐
        │  TARGET SYSTEMS       │
        │  - Prod Servers       │
        │  - Databases          │
        └───────────────────────┘
```

**Firewall Rules (Minimum):**
```
Source          → Destination    Port      Protocol  Purpose
─────────────────────────────────────────────────────────────────
Users           → Load Balancer  443       HTTPS     Web access
Load Balancer   → PVWA           443       HTTPS     Backend
PVWA            → Vault          1858      Proprietary  Vault connection
CPM             → Vault          1858      Proprietary  Vault connection
PSM             → Vault          1858      Proprietary  Vault connection
CPM             → Targets        Various   RDP/SSH/SQL  Password management
PSM             → Targets        Various   RDP/SSH/SQL  Session access
Vault Primary   → Vault DR       18923     Proprietary  DR replication
Admin           → All            22/3389   SSH/RDP      Management (restricted IPs)
```

---

### Advanced Implementation (25%)

**Migration from Competitive Products:**

**Migration Strategies:**

**1. Phased Migration (Recommended):**
```
Phase 1: Setup (Weeks 1-2)
  - Install CyberArk in parallel
  - Configure Safes, policies
  - No migration yet

Phase 2: Pilot (Weeks 3-4)
  - Migrate 50-100 accounts (low-risk)
  - Test workflows
  - Validate functionality
  - Gather feedback

Phase 3: Production Migration (Weeks 5-12)
  - Batch migration by application
  - 500-1,000 accounts per week
  - Parallel run (both systems active)
  - Gradual cutover

Phase 4: Decommission (Weeks 13-16)
  - Verify all accounts migrated
  - Run final reports
  - Decommission old system
  - Archive old data
```

**2. Big Bang Migration (Risky):**
```
Weekend cutover:
  Friday 6 PM: Begin migration
  Friday 6 PM - Saturday 8 AM: Bulk import all accounts
  Saturday 8 AM - 12 PM: Validation and testing
  Saturday 12 PM - 6 PM: Remediation
  Sunday: Final validation
  Monday 6 AM: Go-live

Risks:
  - High stress
  - Rollback difficult
  - Extended outage if issues
  - Not recommended for >1,000 accounts
```

**Migration Tools:**
- **Password Upload Utility**: Bulk CSV import
- **REST API**: Automated scripting
- **Custom Scripts**: PowerShell, Python for complex transformations
- **Account Discovery**: Auto-discover accounts in target systems

**Data Transformation:**
```
Old System Format → CyberArk Format

Example CSV Transformation:
Old: ServerName, AccountName, Password, Description
New: Address, UserName, Secret, PlatformId, SafeName

Mapping:
  ServerName    → Address
  AccountName   → UserName
  Password      → Secret
  Description   → Name + Properties
  [Derived]     → PlatformId (based on OS type)
  [Defined]     → SafeName (based on environment)
```

---

### Performance & Optimization (15%)

**Performance Tuning:**

**Vault Optimization:**
```
Configuration Settings (Vault.ini / DBPARM.ini):

ConcurrentConnectionsLimit=500
  - Max concurrent connections to Vault
  - Increase for large deployments
  - Requires RAM scaling

SessionTimeout=1800
  - Session timeout (seconds)
  - Balance security vs. usability

MaxConcurrentTasks=20
  - CPM parallel operations
  - Increase for faster password changes
  - Monitor CPU/RAM impact
```

**PVWA Optimization:**
```
IIS Application Pool:
  - Queue Length: 5,000
  - CPU Limit: None (0%)
  - Recycling: Time-based (daily 2 AM)
  - Idle Timeout: 20 minutes

.NET Settings:
  - Disable debugging (compilation debug="false")
  - Enable view state MAC validation
  - Use release builds (not debug)

Caching:
  - Enable output caching for static content
  - Cache Safe lists, Platform lists (TTL: 5 min)
```

**Database Tuning (Vault Database):**
```
Index Optimization:
  - Ensure indexes on frequently queried columns
  - Rebuild fragmented indexes weekly

Maintenance:
  - Shrink database monthly (offline window)
  - Update statistics weekly
  - Check for corruption (DBCC CHECKDB)

Backup Optimization:
  - Differential backups daily (faster)
  - Full backup weekly (complete)
  - Transaction log backups hourly
```

**Monitoring Metrics:**

```
Vault Performance:
  - CPU Utilization: <70% average
  - RAM Utilization: <80% average
  - Disk I/O: <70% IOPS capacity
  - Network: <50% bandwidth
  - Response Time: <500ms for Vault operations

PVWA Performance:
  - Page Load Time: <2 seconds
  - Concurrent Users: Within capacity
  - IIS Requests/sec: Monitor trends
  - Failed Requests: <1%

CPM Performance:
  - Password Changes/hour: Expected rate
  - Failed Changes: <5%
  - Queue Depth: <100 pending

PSM Performance:
  - Concurrent Sessions: Within license limit
  - Session Launch Time: <5 seconds
  - Recording Write Speed: No backlog
```

---

### Security Architecture (15%)

**Zero Trust Architecture:**

**Principles:**
1. **Never Trust, Always Verify**: Authenticate every access
2. **Least Privilege**: Minimum permissions required
3. **Assume Breach**: Design as if network is compromised
4. **Segment and Isolate**: Network micro-segmentation

**CyberArk in Zero Trust:**
```
┌──────────────────────────────────────┐
│  Identity Verification (MFA)         │
│    └─> RADIUS/SAML integration       │
└───────────────┬──────────────────────┘
                │
┌───────────────▼──────────────────────┐
│  Just-in-Time Access (PAM)           │
│    └─> Temporary elevated privilege  │
└───────────────┬──────────────────────┘
                │
┌───────────────▼──────────────────────┐
│  Session Monitoring (PSM)            │
│    └─> Record and audit all actions  │
└───────────────┬──────────────────────┘
                │
┌───────────────▼──────────────────────┐
│  Automated Rotation (CPM)            │
│    └─> Continuous password changes   │
└───────────────┬──────────────────────┘
                │
┌───────────────▼──────────────────────┐
│  Analytics & Threat Detection        │
│    └─> Anomaly detection (future)    │
└──────────────────────────────────────┘
```

**Compliance Framework Mapping:**

**PCI-DSS 4.0 (Payment Card Industry):**
```
Requirement 8: Identify users and authenticate access
  - CyberArk: Central identity management for privileged accounts

Requirement 8.2: Ensure strong authentication
  - CyberArk: MFA integration via RADIUS/SAML

Requirement 8.3: Secure all access to system components
  - CyberArk: PSM isolates sessions, no direct access

Requirement 10: Log and monitor all access
  - CyberArk: Comprehensive audit logs, SIEM integration

Requirement 10.4: Retain audit trail for 12 months
  - CyberArk: Configurable retention, archive capabilities
```

**HIPAA (Healthcare):**
```
164.308(a)(3): Workforce access controls
  - CyberArk: Role-based access, approval workflows

164.308(a)(4): Information access management
  - CyberArk: Audit all ePHI access, session recordings

164.312(a)(1): Unique user identification
  - CyberArk: Every access tied to unique user

164.312(b): Audit controls
  - CyberArk: Detailed logs, tamper-proof audit trail

164.312(d): Person or entity authentication
  - CyberArk: MFA support, strong authentication
```

---

### Migration & Transformation (15%)

**Legacy System Retirement:**

**Strategy:**
```
1. Assessment Phase (Weeks 1-2)
   □ Inventory all accounts in legacy system
   □ Document workflows and dependencies
   □ Identify integrations
   □ Define success criteria

2. Design Phase (Weeks 3-4)
   □ Map legacy accounts to CyberArk Safes
   □ Define Platform requirements
   □ Design network architecture
   □ Plan migration batches

3. Build Phase (Weeks 5-6)
   □ Configure CyberArk (Safes, Platforms, Policies)
   □ Build migration scripts
   □ Setup test environment
   □ Conduct UAT

4. Migration Phase (Weeks 7-12)
   □ Pilot migration (100 accounts)
   □ Production migration (batches of 500-1,000)
   □ Parallel run (both systems active)
   □ Cutover per application

5. Optimization Phase (Weeks 13-16)
   □ Performance tuning
   □ User training
   □ Process refinement
   □ Legacy system decommission
```

**Complex Integration Scenarios:**

**Scenario 1: Multi-Forest Active Directory**
```
Challenge:
  - Company has 3 AD forests (acquired companies)
  - Users in Forest A need access to accounts in Forest B/C

Solution:
  1. Configure LDAP integration for each forest
     - Forest A: ldap://forestA.company.com
     - Forest B: ldap://forestB.company.com
     - Forest C: ldap://forestC.company.com

  2. Create separate LDAP directories in CyberArk

  3. Map AD groups from all forests to Vault roles

  4. Use LDAP Group Mapping
     - Forest A "PAM-Admins" → Vault Admin
     - Forest B "PAM-Admins" → Vault Admin
     - Forest C "PAM-Admins" → Vault Admin

  5. Test cross-forest authentication
```

**Scenario 2: Cloud-Hybrid Deployment**
```
Challenge:
  - On-prem servers + AWS + Azure
  - Need unified PAM across all environments

Solution:
  1. Central Vault (on-prem or cloud)

  2. Distributed PSM servers
     - PSM-OnPrem: For on-prem RDP/SSH
     - PSM-AWS: EC2 instance in AWS VPC
     - PSM-Azure: VM in Azure VNet

  3. Cloud-specific platforms
     - AWS IAM platform (for IAM users, roles)
     - Azure AD platform (for Azure users)
     - AWS EC2 platform (for Linux/Windows EC2)
     - Azure VM platform (for Azure VMs)

  4. Network connectivity
     - VPN or Direct Connect (AWS)
     - Express Route (Azure)
     - Firewall rules for port 1858

  5. Account discovery
     - AWS: Use IAM API to discover users
     - Azure: Use Graph API to discover users
```

---

## Quick Reference Tables

### Port Reference Table

| Component | Port | Direction | Purpose |
|-----------|------|-----------|---------|
| Vault | 1858 | Inbound | Primary Vault communication |
| Vault DR | 18923 | Inbound | DR replication |
| PVWA | 443 | Inbound | HTTPS web interface |
| PVWA | 1858 | Outbound | PVWA → Vault |
| CPM | 1858 | Outbound | CPM → Vault |
| PSM | 1858 | Outbound | PSM → Vault |
| PSM | 3389 | Outbound | PSM → Windows targets (RDP) |
| PSM | 22 | Outbound | PSM → Unix targets (SSH) |
| PSM | 1433 | Outbound | PSM → SQL Server |
| PSM | 1521 | Outbound | PSM → Oracle |
| PrivateArk Client | 1858 | Outbound | Admin client → Vault |
| SIEM Integration | 514/6514 | Outbound | Vault → Syslog server |

---

### Safe Permissions Quick Reference

| Permission | Abbr | Description | End User | Power User | Admin |
|-----------|------|-------------|----------|------------|-------|
| Use Accounts | UA | Connect via PSM without seeing password | ✓ | ✓ | ✓ |
| Retrieve Accounts | RA | View/copy password | | ✓ | ✓ |
| List Accounts | LA | See accounts in Safe (required with Retrieve) | | ✓ | ✓ |
| Add Accounts | AA | Onboard new accounts | | | ✓ |
| Update Account Content | UAC | Modify account password/properties | | | ✓ |
| Update Account Properties | UAP | Change metadata | | | ✓ |
| Initiate CPM Management | ICM | Enable auto password management | | | ✓ |
| Specify Next Account Content | SNAC | Set next password value | | | ✓ |
| Rename Accounts | RN | Change account name | | | ✓ |
| Delete Accounts | DA | Remove accounts | | | ✓ |
| Unlock Accounts | ULA | Unlock locked accounts | | | ✓ |
| Manage Safe | MS | Change Safe properties | | | ✓ |
| Manage Safe Members | MSM | Add/remove Safe members | | | ✓ |
| Backup Safe | BS | Export Safe data | | | ✓ |
| View Audit Log | VAL | See Safe audit trail | | ✓ | ✓ |
| View Safe Members | VSM | See who has access | | ✓ | ✓ |
| Access Without Confirmation | AWC | Skip approval workflow | | ✓ | ✓ |
| Create Folders | CF | Organize accounts in folders | | | ✓ |
| Delete Folders | DF | Remove folders | | | ✓ |
| Move Accounts/Folders | MAF | Reorganize structure | | | ✓ |

---

### CPM Operations Decision Tree

```
Is it time to perform an operation?
│
├─ YES: Password Change Scheduled?
│   │
│   ├─ YES: Execute CHANGE operation
│   │   │
│   │   ├─ SUCCESS → Update Vault password
│   │   │           → Schedule next Change
│   │   │
│   │   └─ FAILURE → Log error
│   │              → Retry (based on policy)
│   │              → Alert if repeated failures
│   │
│   └─ NO: Is Verify Scheduled?
│       │
│       ├─ YES: Execute VERIFY operation
│       │   │
│       │   ├─ SUCCESS → Schedule next Verify
│       │   │
│       │   └─ FAILURE → Execute RECONCILE operation
│       │       │
│       │       ├─ SUCCESS → Update Vault password
│       │       │           → Schedule next Verify
│       │       │
│       │       └─ FAILURE → Log critical error
│       │                  → Alert administrator
│       │                  → Manual intervention required
│       │
│       └─ NO: Wait for next scheduled operation
│
└─ NO: Idle (check again in 1 minute)
```

---

### Authentication Methods Priority

| Priority | Method | Use Case | Security Level |
|----------|--------|----------|----------------|
| 1 | **PKI (Certificate)** | High security, smart cards | ⭐⭐⭐⭐⭐ |
| 2 | **RADIUS (MFA)** | Two-factor authentication | ⭐⭐⭐⭐⭐ |
| 3 | **LDAP** | Active Directory integration | ⭐⭐⭐⭐ |
| 4 | **SAML** | SSO, modern deployments | ⭐⭐⭐⭐ |
| 5 | **Vault (Internal)** | Small deployments, service accounts | ⭐⭐⭐ |
| 6 | **Windows (Deprecated)** | Legacy, not recommended | ⭐⭐ |

---

### Platform Types Quick Reference

| Platform Type | Change Method | Verify Method | Common Ports | Use For |
|---------------|---------------|---------------|--------------|---------|
| **WinDomain** | PowerShell Set-ADAccountPassword | PowerShell Test-ADAuthentication | 445 (SMB), 389 (LDAP) | AD domain accounts |
| **WinServerLocal** | NET USER command | Login test | 445 (SMB) | Windows local accounts |
| **UnixSSH** | passwd command via SSH | SSH login test | 22 (SSH) | Linux/Unix accounts |
| **UnixSSHKey** | SSH key rotation | Key-based auth test | 22 (SSH) | SSH key-based accounts |
| **OracleDB** | ALTER USER SQL | SQL login test | 1521 (Oracle Net) | Oracle database users |
| **MySQL** | ALTER USER SQL | SQL login test | 3306 (MySQL) | MySQL database users |
| **SQLServer** | ALTER LOGIN SQL | SQL login test | 1433 (TDS) | SQL Server logins |
| **AWS** | AWS IAM API | IAM login test | 443 (HTTPS) | AWS IAM users |
| **Azure** | Azure AD Graph API | Azure AD auth test | 443 (HTTPS) | Azure AD users |

---

## Troubleshooting Quick Reference

### Top 10 Issues and Fast Fixes

**Issue 1: "Cannot connect to Vault" from PVWA/CPM/PSM**
```
Fast Checks:
  1. ping vault.domain.com (DNS resolution?)
  2. telnet vault.domain.com 1858 (port open?)
  3. Check Vault service running (PrivateArk Server service)
  4. Review Vault.ini / DBParm.ini configuration
  5. Check firewall rules (port 1858 allowed?)

Solution:
  - Fix network connectivity
  - Correct Vault.ini configuration
  - Start Vault service if stopped
```

**Issue 2: "CPM password change failed"**
```
Fast Checks:
  1. Check pm_error.log (last 10 lines)
  2. Verify platform configuration (Connection Test)
  3. Test network connectivity from CPM to target
  4. Verify account credentials (manually login)
  5. Check reconcile account (if configured)

Common Errors:
  - "Target system unreachable" → Network/firewall
  - "Authentication failed" → Wrong reconcile password
  - "Password complexity not met" → Platform policy mismatch
  - "Account locked" → Unlock on target system

Solution:
  - Fix network connectivity
  - Update reconcile account password
  - Align password policy with target system requirements
```

**Issue 3: "User cannot see accounts in Safe"**
```
Fast Checks:
  1. Verify user has "List Accounts" permission
  2. Check Safe membership (is user added?)
  3. Verify LDAP group mapping (if LDAP user)
  4. Check account filters in PVWA

Solution:
  - Add "List Accounts" permission
  - Add user to Safe
  - Verify LDAP group membership
```

**Issue 4: "PSM session won't launch"**
```
Fast Checks:
  1. Check PSMConsole.log (last 20 lines)
  2. Verify connection component exists
  3. Test RDP/SSH from PSM server to target manually
  4. Check user has "Use Accounts" permission
  5. Verify PSM service running

Common Errors:
  - "Connection component not found" → Create connection component
  - "Target unreachable" → Network/firewall
  - "Authentication failed" → Account password wrong

Solution:
  - Configure connection component
  - Fix network connectivity
  - Update account password in Vault
```

**Issue 5: "Approval workflow not working"**
```
Fast Checks:
  1. Verify user does NOT have "Access Without Confirmation"
  2. Check Safe requires authorization (Safe properties)
  3. Verify Authorizer users configured
  4. Check Authorizer has "Authorize Password Requests" permission
  5. Test approval flow end-to-end

Solution:
  - Remove "Access Without Confirmation" from user
  - Enable authorization requirement in Safe
  - Add Authorizers with correct permissions
```

**Issue 6: "LDAP authentication fails"**
```
Fast Checks:
  1. Test LDAP connectivity (PVWA → Admin → LDAP → Test)
  2. Verify LDAP bind credentials correct
  3. Check Base DN configuration (DC=domain,DC=com)
  4. Test LDAP query filter
  5. Review PVWA logs for LDAP errors

Solution:
  - Update LDAP bind credentials
  - Correct Base DN
  - Fix LDAP query filter (e.g., objectClass=user)
```

**Issue 7: "Session recording not visible"**
```
Fast Checks:
  1. Wait 5-10 minutes (recordings process async)
  2. Check PSM → Vault connectivity
  3. Verify recording upload completed (PSM logs)
  4. Check Vault storage space (disk full?)
  5. Search by correct criteria (user, target, date)

Solution:
  - Wait for recording to process
  - Fix PSM → Vault connectivity
  - Free up Vault disk space
```

**Issue 8: "High CPM queue, slow password changes"**
```
Fast Checks:
  1. Check CPM performance (CPU, RAM, network)
  2. Review pm.log for errors/slow operations
  3. Check number of managed accounts
  4. Verify change frequency settings realistic
  5. Check target system performance

Solution:
  - Add more CPM instances (load distribution)
  - Increase CPM resources (CPU, RAM)
  - Adjust change frequencies (stagger schedules)
  - Optimize platform scripts
```

**Issue 9: "Vault DR replication not working"**
```
Fast Checks:
  1. Check port 18923 open from Primary to DR
  2. Verify DR Vault service running
  3. Review Vault logs on both sides
  4. Check DR configuration (padr.ini)
  5. Test manual failover

Solution:
  - Fix network connectivity (port 18923)
  - Correct DR configuration
  - Re-initialize DR if needed
```

**Issue 10: "Performance degradation (slow PVWA)"**
```
Fast Checks:
  1. Check IIS application pool status
  2. Review PVWA server resources (CPU, RAM, disk)
  3. Check Vault response time (PVWA → Vault latency)
  4. Review IIS logs for errors/slow requests
  5. Check concurrent user count

Solution:
  - Restart IIS application pool
  - Add more PVWA instances (load balance)
  - Tune PVWA configuration (web.config, IIS)
  - Optimize Vault performance
```

---

## Exam Day Quick Cards

### Card 1: Defender Exam Essentials

**Exam Format:**
- 60 questions, 90 minutes
- Passing score: 70%
- Multiple choice, multiple select

**Top 5 Topics (50%+ of exam):**
1. Account Management (25%) - Platforms, onboarding, CPM operations
2. Architecture (20%) - Components, deployment, ports
3. Safe Management (20%) - Permissions, policies
4. User Management (15%) - Authentication, groups
5. Monitoring (10%) - Logs, SIEM, recordings

**Must-Know for Exam:**
```
□ Vault port: 1858
□ Safe name max: 28 characters
□ CPM operations: Change, Verify, Reconcile
□ CPM logic: Change scheduled → Change; Verify scheduled → Verify; Verify fails → Reconcile
□ Safe permissions: Use Accounts, Retrieve Accounts, List Accounts
□ SIEM format: CEF
□ Log files: italog.log (Vault), pm.log (CPM), PSMConsole.log (PSM)
```

**Time Management:**
- First pass: 60 minutes (answer all known questions)
- Second pass: 20 minutes (review marked questions)
- Final review: 10 minutes (check all answers)

---

### Card 2: Sentry Exam Essentials

**Exam Format:**
- 75 questions, 120 minutes
- Passing score: 75%
- Scenario-based questions

**Top 5 Topics (60%+ of exam):**
1. Implementation (25%) - Installation, configuration
2. Advanced Account Mgmt (20%) - Custom platforms, reconciliation
3. Architecture (15%) - HA/DR, clustering
4. Integration (15%) - LDAP, API, SIEM
5. PSM Configuration (15%) - Connection components, recording

**Must-Know for Exam:**
```
□ Installation order: Vault → Client → PVWA → CPM → PSM
□ HA vs DR: HA=same datacenter, DR=different datacenter
□ Reconcile account: Used when Verify fails, has admin rights
□ Custom platforms: XML-based, define change/verify scripts
□ REST API: Logon → Get Token → Use Token → Logoff
□ LDAP mapping: AD groups → Vault roles
□ PSM components: Connection component, session recording, isolation
```

**Common Scenario Types:**
- Installation troubleshooting
- HA/DR design questions
- Platform configuration issues
- Integration challenges

---

### Card 3: Guardian Exam Essentials

**Exam Format:**
- 50 questions (complex scenarios), 150 minutes
- Passing score: 80%
- Case studies, design questions

**Top 5 Topics (70%+ of exam):**
1. Architecture & Design (30%) - Enterprise sizing, network design
2. Advanced Implementation (25%) - Complex deployments, migrations
3. Performance (15%) - Tuning, optimization
4. Security Architecture (15%) - Zero trust, compliance
5. Migration (15%) - Strategy, legacy retirement

**Must-Know for Exam:**
```
□ Sizing formulas: RAM, CPU, Disk calculations
□ Network architecture: Security zones, firewall rules
□ HA configurations: Active/Active clustering, load balancing
□ Migration strategies: Phased vs Big Bang
□ Compliance: PCI-DSS, HIPAA requirements
□ Performance tuning: Vault.ini, DBPARM.ini settings
□ Zero trust principles: Never trust, least privilege, assume breach
```

**Case Study Approach:**
1. Read scenario twice
2. Identify requirements (users, accounts, compliance)
3. Design architecture (components, network, sizing)
4. Consider constraints (budget, timeline, risk)
5. Choose BEST answer (not just correct)

---

### Card 4: Common Exam Traps

**Trap 1: "All of the above" or "None of the above"**
- Usually NOT the answer on CyberArk exams
- Eliminate first, then choose specific option

**Trap 2: Over-complicated solutions**
- CyberArk favors simple, standard approaches
- Don't choose exotic configurations unless required

**Trap 3: Ignoring keywords**
- "BEST" → Multiple correct, choose best
- "FIRST" → What to do first (not only action)
- "PRIMARY" → Main reason/concern
- "LEAST" → Opposite of most

**Trap 4: Assuming defaults**
- Read question carefully
- Don't assume default settings unless stated

**Trap 5: Real-world vs Exam-world**
- Exam may not match your production experience
- Follow official CyberArk documentation
- Best practices > company-specific shortcuts

---

**Last Updated**: 2025-12-01
**Version**: 1.0
**Use**: Study aid for CyberArk certifications (Defender, Sentry, Guardian)

**GOOD LUCK ON YOUR EXAM!** 🚀🔒
