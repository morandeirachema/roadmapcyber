# Portfolio Project Example: Enterprise PAM Lab Implementation

Complete example of a well-documented portfolio project demonstrating PAM expertise.

---

## Project Overview

**Project Name**: Enterprise CyberArk PAM Lab Implementation

**Duration**: 4 weeks (60 hours)

**Objective**: Design and implement a complete CyberArk Privileged Access Management (PAM) lab environment demonstrating enterprise-level architecture, integrations, and compliance controls.

**Technologies Used**:
- CyberArk PAM (Password Vault, CPM, PSM, PVWA)
- Active Directory (Windows Server 2022)
- Linux (Ubuntu 22.04, RHEL 9)
- VMware ESXi / VirtualBox
- Network segmentation (VLANs)

**GitHub Repository**: [https://github.com/yourname/cyberark-pam-lab](https://github.com/yourname/cyberark-pam-lab)

---

## Business Problem

Organizations struggle to secure privileged accounts across hybrid environments (Windows, Linux, databases, cloud). Without proper privileged access management:
- Passwords are shared and stored insecurely
- No session recording or audit trail for privileged actions
- Compliance requirements (HIPAA, PCI-DSS) cannot be met
- Insider threats and compromised credentials pose significant risk

**Solution**: Implement enterprise-grade PAM solution providing vaulting, automated rotation, session recording, and compliance reporting.

---

## Architecture

### High-Level Design

```
┌─────────────────────────────────────────────────────────────┐
│                    Management Network (VLAN 10)              │
│                                                               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │ Password     │    │ Central      │    │ Privileged   │  │
│  │ Vault (HA)   │◄──►│ Policy       │    │ Session      │  │
│  │              │    │ Manager      │    │ Manager      │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│         ▲                                        ▲           │
│         │                                        │           │
│         │            ┌──────────────┐           │           │
│         └───────────►│ PVWA         │───────────┘           │
│                      │ (Web UI)     │                       │
│                      └──────────────┘                       │
│                             ▲                                │
└─────────────────────────────┼────────────────────────────────┘
                              │
                              │ HTTPS (Port 443)
                              │
┌─────────────────────────────┼────────────────────────────────┐
│                    User Network (VLAN 20)                     │
│                             │                                 │
│                      ┌──────────────┐                        │
│                      │ End Users    │                        │
│                      └──────────────┘                        │
└───────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                 Target Systems (VLAN 30)                      │
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Windows  │  │  Linux   │  │ Database │  │  Active  │   │
│  │ Servers  │  │ Servers  │  │ Servers  │  │ Directory│   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└───────────────────────────────────────────────────────────────┘
```

### Component Details

**Password Vault** (Primary + DR replica):
- Stores all privileged credentials encrypted at rest
- High Availability configuration
- Disaster Recovery replica in separate datacenter

**Central Policy Manager (CPM)**:
- Automated password rotation (daily, weekly, on-demand)
- Verification of successful password changes
- Alerting on rotation failures

**Privileged Session Manager (PSM)**:
- Proxies all privileged sessions
- Records sessions for audit and compliance
- Isolates endpoints from direct target access

**Password Vault Web Access (PVWA)**:
- Web-based user interface
- Self-service password checkout
- Approval workflows for sensitive accounts

---

## Implementation Details

### Phase 1: Infrastructure Setup (Week 1)

**Lab Environment Specifications**:
- **Virtualization**: VMware ESXi 7.0 (or VirtualBox for local)
- **Network**: 3 VLANs (Management, User, Target)
- **Storage**: 500GB allocated across VMs

**Virtual Machines Created**:
| VM Name | OS | vCPU | RAM | Disk | Role |
|---------|-----|------|-----|------|------|
| VAULT01 | Windows Server 2022 | 4 | 8GB | 100GB | Password Vault (Primary) |
| VAULT02 | Windows Server 2022 | 4 | 8GB | 100GB | Password Vault (DR) |
| CPM01 | Windows Server 2022 | 2 | 4GB | 60GB | Central Policy Manager |
| PSM01 | Windows Server 2022 | 4 | 8GB | 60GB | Privileged Session Manager |
| PVWA01 | Windows Server 2022 | 2 | 4GB | 60GB | Web Access |
| DC01 | Windows Server 2022 | 2 | 4GB | 60GB | Active Directory |
| WIN-TARGET01 | Windows Server 2022 | 2 | 4GB | 40GB | Target Windows Server |
| LINUX-TARGET01 | Ubuntu 22.04 | 2 | 2GB | 40GB | Target Linux Server |
| DB01 | Windows Server 2022 + SQL Server | 4 | 8GB | 100GB | Database Server |

**Network Configuration**:
- VLAN 10 (Management): 10.10.10.0/24
- VLAN 20 (User): 10.10.20.0/24
- VLAN 30 (Target): 10.10.30.0/24
- Firewall rules: Vault accessible only from management network

### Phase 2: CyberArk Component Installation (Week 2)

**Installation Order** (following CyberArk best practices):
1. **Password Vault** (VAULT01):
   - Installed CyberArk Digital Vault v13.0
   - Configured Master User
   - Enabled TLS 1.2+ only
   - Configured automatic backup to separate storage

2. **Disaster Recovery Vault** (VAULT02):
   - Installed as replica of VAULT01
   - Configured replication (every 4 hours)
   - Tested failover procedures

3. **PVWA** (PVWA01):
   - Installed IIS with required features
   - Installed CyberArk Password Vault Web Access
   - Configured HTTPS with self-signed certificate (production would use CA-signed)
   - Integrated with Vault

4. **CPM** (CPM01):
   - Installed Central Policy Manager
   - Registered with Vault
   - Installed platform packs (Windows, Unix, Oracle, SQL Server)

5. **PSM** (PSM01):
   - Installed Privileged Session Manager
   - Registered with Vault
   - Configured session recording
   - Integrated with PSM for HTML5 gateway

**Challenges Encountered**:
- Issue: PVWA couldn't connect to Vault initially
- Cause: Windows Firewall blocking port 1858
- Resolution: Created firewall rule allowing TCP 1858 from PVWA IP
- Lesson: Always verify firewall rules before troubleshooting application issues

### Phase 3: Integration & Configuration (Week 3)

**Active Directory Integration**:
- Created service account (`svc_cyberark`) with appropriate permissions
- Configured LDAP integration for user authentication
- Mapped AD groups to CyberArk roles (Vault Admins, Users, Auditors)
- Result: Single sign-on experience for AD-authenticated users

**Safe Creation** (organized by system type):
- `Windows-Servers`: Local admin accounts for Windows servers
- `Linux-Servers`: Root and sudo accounts for Linux servers
- `Databases`: SA and admin accounts for SQL Server, Oracle
- `Active-Directory`: Domain admin and service accounts
- `Network-Devices`: Router and switch accounts (future expansion)

**Account Onboarding**:
| Account Type | Count | Rotation Policy |
|-------------|-------|-----------------|
| Windows Local Admin | 5 | Daily |
| Linux Root | 3 | Weekly |
| Linux Sudo Users | 4 | Weekly |
| SQL Server SA | 2 | Weekly |
| Domain Admin | 2 | Manual (on-demand) |
| Service Accounts | 3 | Manual (change control required) |

**Total Privileged Accounts Managed**: 19

**Automated Password Rotation**:
- Configured CPM to rotate passwords based on policy
- Tested rotation for each platform (Windows, Linux, SQL Server)
- Verified old password no longer works after rotation
- Validated new password stored correctly in Vault

**Session Recording**:
- All PSM sessions recorded automatically
- Recording stored in Vault with 90-day retention
- Tested playback of RDP and SSH sessions
- Configured alerts for suspicious keywords (e.g., "rm -rf", "drop database")

### Phase 4: Compliance & Documentation (Week 4)

**Compliance Controls Implemented**:

**HIPAA Requirements**:
- ✅ Access Control (164.312(a)(1)): Role-based access via Safes
- ✅ Audit Controls (164.312(b)): Session recording and activity logs
- ✅ Person/Entity Authentication (164.312(d)): AD integration + MFA ready
- ✅ Transmission Security (164.312(e)(1)): TLS 1.2+ enforced

**PCI-DSS Requirements**:
- ✅ Requirement 7: Restrict access to cardholder data (Safe permissions)
- ✅ Requirement 8: Unique credentials for each user (no shared passwords)
- ✅ Requirement 10: Track and monitor all access (audit logs + session recording)

**Compliance Reporting**:
- Created report showing all privileged access in last 30 days
- Report includes: User, Account accessed, Timestamp, Duration, Actions performed
- Exported to CSV for compliance team review

---

## Testing & Validation

### Test Scenarios Executed

**Test 1: Password Checkout & Rotation**
- ✅ User checks out Windows admin password from PVWA
- ✅ User logs into target system using checked-out password
- ✅ CPM rotates password after 24 hours
- ✅ Old password no longer works on target
- ✅ New password stored in Vault

**Test 2: Session Recording**
- ✅ User launches PSM session via PVWA (RDP to Windows target)
- ✅ Session is proxied through PSM
- ✅ All actions recorded (keystrokes, mouse clicks)
- ✅ Recording available for playback in PVWA
- ✅ Alert triggered when "dangerous" command detected

**Test 3: Dual Control Workflow**
- ✅ Configured Domain Admin accounts to require approval
- ✅ User requests access to Domain Admin account
- ✅ Approval request sent to manager
- ✅ Manager approves via PVWA
- ✅ User gains time-limited access (4 hours)
- ✅ Access automatically revoked after 4 hours

**Test 4: Disaster Recovery Failover**
- ✅ Simulated primary Vault failure
- ✅ Promoted DR Vault to primary
- ✅ All components reconnected to new primary
- ✅ No data loss
- ✅ Users could continue working without interruption

---

## Results & Outcomes

### Quantitative Results
- **19 privileged accounts** secured and managed
- **100% password rotation** success rate after tuning
- **50+ PSM sessions** recorded during testing
- **0 unencrypted passwords** stored on systems
- **HIPAA & PCI-DSS** compliance requirements met

### Qualitative Outcomes
- Eliminated shared privileged credentials
- Established audit trail for all privileged actions
- Demonstrated dual control for sensitive accounts
- Proved viability of HA/DR architecture
- Created reusable documentation and runbooks

### Business Value
- **Security**: Significantly reduced risk of credential theft and misuse
- **Compliance**: Provided evidence for auditors (HIPAA, PCI-DSS)
- **Accountability**: Clear audit trail of who accessed what and when
- **Efficiency**: Automated password rotation eliminated manual process

---

## Documentation Deliverables

All documentation available in GitHub repository:

1. **Architecture Diagrams** (Visio + Draw.io)
   - High-level architecture
   - Network topology
   - Component interaction diagrams

2. **Installation Runbooks** (40 pages)
   - Step-by-step installation procedures
   - Screenshots for each critical step
   - Troubleshooting common issues

3. **Configuration Guides** (25 pages)
   - Safe creation and permission templates
   - Account onboarding procedures
   - Platform configuration

4. **Administrator Guide** (30 pages)
   - Daily operations procedures
   - Password rotation management
   - Session recording review
   - User management
   - Troubleshooting common issues

5. **Compliance Documentation** (15 pages)
   - HIPAA control mappings
   - PCI-DSS requirement mappings
   - Sample audit reports
   - Evidence of controls

---

## Lessons Learned

### What Went Well
✅ Systematic approach to component installation prevented issues
✅ Network segmentation simplified troubleshooting
✅ Documentation-first approach made configuration repeatable
✅ Testing scenarios caught configuration issues before "production"

### What Could Be Improved
⚠️ Initial firewall configuration caused delays - should verify networking first
⚠️ Password rotation policies needed tuning - started too aggressive
⚠️ Session recordings consumed significant storage - needs capacity planning

### Best Practices Identified
1. **Always follow CyberArk recommended installation order** (Vault → PVWA → CPM → PSM)
2. **Network connectivity is critical** - verify firewall rules before installing components
3. **Start with conservative password rotation** (weekly), then increase frequency
4. **Test DR failover regularly** - don't wait for real disaster
5. **Document everything as you go** - much harder to recreate later

---

## Skills Demonstrated

This project demonstrates proficiency in:
- ✅ CyberArk PAM architecture and design
- ✅ Component installation and configuration
- ✅ Active Directory integration
- ✅ Automated password rotation
- ✅ Session recording and monitoring
- ✅ Compliance framework implementation (HIPAA, PCI-DSS)
- ✅ High Availability and Disaster Recovery
- ✅ Technical documentation and runbook creation
- ✅ Troubleshooting and problem resolution

---

## Future Enhancements

Potential expansions of this lab:
- [ ] Add cloud integration (AWS IAM, Azure AD)
- [ ] Implement CyberArk Conjur for application secrets
- [ ] Add MFA (RSA, Duo) for additional security
- [ ] Integrate with SIEM (Splunk) for centralized logging
- [ ] Add network device management (Cisco, Juniper)
- [ ] Implement Alero (remote access) for third-party vendors
- [ ] Add EPM (Endpoint Privilege Manager) for workstation privilege elevation

---

## References & Resources

- **CyberArk Documentation**: [docs.cyberark.com](https://docs.cyberark.com)
- **CyberArk Community**: [cyberark.force.com](https://cyberark.force.com)
- **HIPAA Security Rule**: [HHS.gov](https://www.hhs.gov/hipaa)
- **PCI-DSS Standards**: [pcisecuritystandards.org](https://pcisecuritystandards.org)

---

## Contact & Portfolio

**Author**: [Your Name]
**Certifications**: CyberArk Defender, Sentry, Guardian | CCSP | CKA
**GitHub**: [github.com/yourname](https://github.com/yourname)
**LinkedIn**: [linkedin.com/in/yourname](https://linkedin.com/in/yourname)
**Email**: [your.email@example.com](mailto:your.email@example.com)

---

**Project Completed**: [Date]
**Last Updated**: [Date]
**Version**: 1.0
