# PAM Incident Response Playbook

Security incident response procedures for Privileged Access Management environments. Covers detection, containment, investigation, and recovery for PAM-related security incidents.

---

## Table of Contents

1. [Incident Response Framework](#incident-response-framework)
2. [Incident Classification](#incident-classification)
3. [Detection and Alerting](#detection-and-alerting)
4. [Response Playbooks](#response-playbooks)
5. [Investigation Procedures](#investigation-procedures)
6. [Containment Actions](#containment-actions)
7. [Recovery Procedures](#recovery-procedures)
8. [Post-Incident Activities](#post-incident-activities)
9. [Communication Templates](#communication-templates)
10. [Tools and Resources](#tools-and-resources)

---

## Incident Response Framework

### NIST Incident Response Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                 Incident Response Lifecycle                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐     │
│   │ 1. Preparation│───►│ 2. Detection │───►│ 3. Contain-  │     │
│   │              │    │ & Analysis   │    │    ment      │     │
│   └──────────────┘    └──────────────┘    └──────────────┘     │
│          ▲                                        │             │
│          │                                        ▼             │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐     │
│   │ 6. Lessons   │◄───│ 5. Recovery  │◄───│ 4. Eradica-  │     │
│   │   Learned    │    │              │    │    tion      │     │
│   └──────────────┘    └──────────────┘    └──────────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Incident Response Team

| Role | Responsibilities | Contact |
|------|-----------------|---------|
| **Incident Commander** | Overall coordination, decisions | [Name] - [Phone] |
| **PAM Administrator** | Technical investigation, containment | [Name] - [Phone] |
| **Security Analyst** | Log analysis, threat intelligence | [Name] - [Phone] |
| **System Administrator** | Infrastructure support | [Name] - [Phone] |
| **Communications Lead** | Stakeholder updates | [Name] - [Phone] |
| **Legal/Compliance** | Regulatory requirements | [Name] - [Phone] |

### Escalation Matrix

```
┌─────────────────────────────────────────────────────────────────┐
│                    Escalation Matrix                             │
├────────────┬────────────────────────────────────────────────────┤
│ Severity   │ Escalation Path                                    │
├────────────┼────────────────────────────────────────────────────┤
│ Critical   │ Immediate: CISO → CEO → Board                      │
│ (P1)       │ Time: Within 15 minutes                            │
├────────────┼────────────────────────────────────────────────────┤
│ High       │ Security Manager → CISO                            │
│ (P2)       │ Time: Within 1 hour                                │
├────────────┼────────────────────────────────────────────────────┤
│ Medium     │ Security Analyst → Security Manager                │
│ (P3)       │ Time: Within 4 hours                               │
├────────────┼────────────────────────────────────────────────────┤
│ Low        │ Security Analyst                                   │
│ (P4)       │ Time: Next business day                            │
└────────────┴────────────────────────────────────────────────────┘
```

---

## Incident Classification

### PAM-Specific Incident Types

| Incident Type | Severity | Description |
|--------------|----------|-------------|
| **Compromised Master Credential** | Critical (P1) | Vault master key or admin credentials compromised |
| **Unauthorized Vault Access** | Critical (P1) | Unauthorized access to Password Vault |
| **Credential Theft** | High (P2) | Privileged credentials stolen or exposed |
| **Session Hijacking** | High (P2) | PSM session compromised or hijacked |
| **Failed Authentication Spike** | Medium (P3) | Unusual failed login attempts |
| **Policy Violation** | Medium (P3) | User violating PAM policies |
| **Service Degradation** | Medium (P3) | PAM components experiencing issues |
| **Suspicious Activity** | Low (P4) | Anomalous but unconfirmed behavior |

### Severity Definitions

**Critical (P1)**:
- Active breach of PAM infrastructure
- Compromised vault or master credentials
- Data exfiltration in progress
- **Response Time**: Immediate (< 15 minutes)

**High (P2)**:
- Successful unauthorized access
- Credential exposure confirmed
- Significant policy violations
- **Response Time**: < 1 hour

**Medium (P3)**:
- Attempted unauthorized access
- Suspicious patterns detected
- Minor policy violations
- **Response Time**: < 4 hours

**Low (P4)**:
- Anomalies requiring investigation
- Minor configuration issues
- Information requests
- **Response Time**: Next business day

---

## Detection and Alerting

### Key Indicators of Compromise (IOCs)

```yaml
# IOCs for PAM Environments
iocs:
  authentication:
    - Multiple failed logins from same IP
    - Successful login after multiple failures
    - Login from unusual location/time
    - Login from blacklisted IP
    - Concurrent sessions from different locations

  vault_access:
    - Access to high-privilege safes outside business hours
    - Bulk credential retrieval
    - Access from unauthorized application
    - Changes to vault configuration
    - Master key access attempts

  session_activity:
    - Commands executed without session recording
    - Unusual commands (rm -rf, drop database)
    - Data exfiltration patterns
    - Session from unexpected source
    - Disabled recording attempts

  infrastructure:
    - Unauthorized service account creation
    - Policy changes without change control
    - Certificate modifications
    - Network configuration changes
    - Backup file access
```

### SIEM Detection Rules

```yaml
# Splunk Detection Rules for PAM
# Rule 1: Brute Force Attack Detection
[Brute_Force_PAM]
search = index=cyberark sourcetype=cyberark:vault "Failed to verify password"
| stats count by src_ip, user
| where count > 5
alert.severity = high
alert.track = true
cron_schedule = */5 * * * *

# Rule 2: Off-Hours Privileged Access
[OffHours_Privileged_Access]
search = index=cyberark sourcetype=cyberark:vault action=Retrieve
| eval hour=strftime(_time, "%H")
| where hour < 6 OR hour > 22
| stats count by user, safe, account
alert.severity = medium

# Rule 3: Bulk Credential Access
[Bulk_Credential_Access]
search = index=cyberark sourcetype=cyberark:vault action=Retrieve
| stats dc(account) as accounts_accessed by user, src_ip
| where accounts_accessed > 10
alert.severity = high

# Rule 4: Vault Configuration Change
[Vault_Config_Change]
search = index=cyberark sourcetype=cyberark:vault
  (action=UpdateSafe OR action=DeleteSafe OR action=AddMember)
| table _time, user, action, safe, details
alert.severity = critical
```

### Alert Configuration

```yaml
# PagerDuty Alert Configuration
alerts:
  - name: "PAM Critical - Vault Breach"
    condition: "vault_breach_detected"
    severity: critical
    notification:
      - pagerduty: security-oncall
      - slack: "#security-alerts"
      - email: security-team@example.com
    escalation:
      - after: 5m
        to: security-manager
      - after: 15m
        to: ciso

  - name: "PAM High - Unauthorized Access"
    condition: "unauthorized_access"
    severity: high
    notification:
      - slack: "#security-alerts"
      - email: pam-admins@example.com
    escalation:
      - after: 30m
        to: security-manager

  - name: "PAM Medium - Suspicious Activity"
    condition: "suspicious_activity"
    severity: medium
    notification:
      - slack: "#pam-alerts"
    escalation:
      - after: 4h
        to: pam-admin
```

---

## Response Playbooks

### Playbook 1: Compromised Privileged Credential

```markdown
# Playbook: Compromised Privileged Credential

## Trigger
- Credential found in data breach
- Credential used from unknown source
- User reports credential compromise

## Immediate Actions (0-15 minutes)

### 1. Verify the Incident
```bash
# Check recent access for the compromised account
conjur audit -r variable:accounts/<account_name> --since "24 hours ago"

# Check CyberArk vault logs
Search: index=cyberark account=<account_name> action=Retrieve
```

### 2. Contain the Threat
```bash
# Immediately rotate the compromised credential
curl -X POST "https://pvwa.example.com/PasswordVault/api/Accounts/<AccountID>/Change" \
  -H "Authorization: $SESSION_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"ChangeEntireGroup": false}'

# Lock the account in CyberArk
curl -X POST "https://pvwa.example.com/PasswordVault/api/Accounts/<AccountID>/Lock" \
  -H "Authorization: $SESSION_TOKEN"
```

### 3. Notify Stakeholders
- Alert security team
- Notify account owner
- Inform IT operations

## Short-Term Actions (15-60 minutes)

### 4. Investigate Scope
- Identify all systems where credential was used
- Check for lateral movement
- Review session recordings if available

### 5. Expand Containment
- Rotate related credentials
- Review and rotate secrets on affected systems
- Block suspicious IPs at firewall

### 6. Document Evidence
- Export vault logs
- Capture session recordings
- Document timeline

## Recovery Actions (1-4 hours)

### 7. Verify Credential Rotation
- Confirm new credential is active
- Test application connectivity
- Verify no unauthorized access

### 8. Resume Operations
- Unlock account (if appropriate)
- Monitor for suspicious activity
- Keep enhanced logging enabled

## Post-Incident

### 9. Root Cause Analysis
- How was credential compromised?
- What detection gaps existed?
- What controls failed?

### 10. Improvements
- Update detection rules
- Enhance access controls
- Improve credential hygiene
```

### Playbook 2: Unauthorized Vault Access

```markdown
# Playbook: Unauthorized Vault Access

## Trigger
- Access from unauthorized IP/location
- Access outside of approved hours
- Access by terminated/suspended user
- Access without proper approval workflow

## Immediate Actions (0-15 minutes)

### 1. Verify the Incident
```bash
# Query vault access logs
Search: index=cyberark src_ip=<suspicious_ip> OR user=<suspicious_user>
| table _time, user, src_ip, action, safe, account
```

### 2. Disable Access
```bash
# Disable user in CyberArk
curl -X DELETE "https://pvwa.example.com/PasswordVault/api/Users/<UserID>/Activate" \
  -H "Authorization: $SESSION_TOKEN"

# If using AD authentication, disable AD account
Set-ADUser -Identity <username> -Enabled $false
```

### 3. Block Source
```bash
# Block IP at firewall
aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxxx \
  --protocol all \
  --cidr <suspicious_ip>/32 \
  --deny

# Or add to WAF blocklist
```

## Investigation (15-60 minutes)

### 4. Determine Access Scope
- What safes were accessed?
- What credentials were retrieved?
- Were any credentials used on target systems?

### 5. Check for Data Exfiltration
- Review session recordings
- Check for bulk downloads
- Analyze network traffic

### 6. Identify Attack Vector
- How did attacker gain access?
- Compromised credentials?
- Session hijacking?
- Insider threat?

## Containment (1-4 hours)

### 7. Rotate Accessed Credentials
```bash
# Rotate all credentials accessed during incident
for account_id in $ACCESSED_ACCOUNTS; do
  curl -X POST "https://pvwa.example.com/PasswordVault/api/Accounts/${account_id}/Change" \
    -H "Authorization: $SESSION_TOKEN"
done
```

### 8. Review Permissions
- Audit safe memberships
- Review approval workflows
- Check for unauthorized policy changes

## Recovery

### 9. Restore Secure State
- Verify all compromised credentials rotated
- Confirm no persistent access
- Re-enable legitimate users

### 10. Enhanced Monitoring
- Increase logging verbosity
- Add detection rules for similar patterns
- Monitor for returning attacker
```

### Playbook 3: PSM Session Compromise

```markdown
# Playbook: PSM Session Compromise

## Trigger
- Suspicious commands in session recording
- Session from unexpected source
- Disabled/bypassed recording detected
- User reports hijacked session

## Immediate Actions (0-15 minutes)

### 1. Terminate Active Session
```bash
# Get active sessions
curl -X GET "https://pvwa.example.com/PasswordVault/api/LiveSessions" \
  -H "Authorization: $SESSION_TOKEN" | jq '.LiveSessions[] | select(.User=="<username>")'

# Terminate suspicious session
curl -X POST "https://pvwa.example.com/PasswordVault/api/LiveSessions/<SessionID>/Terminate" \
  -H "Authorization: $SESSION_TOKEN"
```

### 2. Isolate Affected Systems
```bash
# Quarantine target system
# Option 1: Network isolation
aws ec2 modify-instance-attribute --instance-id <instance-id> \
  --groups sg-quarantine

# Option 2: Disable network interface
ssh target-server "sudo ip link set eth0 down"
```

### 3. Preserve Evidence
```bash
# Export session recording
curl -X GET "https://pvwa.example.com/PasswordVault/api/Recordings/<SessionID>" \
  -H "Authorization: $SESSION_TOKEN" \
  -o session_recording.avi

# Capture system state
ssh target-server "sudo tar czf /tmp/forensics.tar.gz /var/log /etc"
```

## Investigation (15-60 minutes)

### 4. Review Session Recording
- Identify all commands executed
- Look for data exfiltration
- Check for persistence mechanisms
- Note IOCs (files, processes, connections)

### 5. Analyze Target System
```bash
# Check for unauthorized processes
ps auxf | grep -E "(nc|netcat|curl|wget|python|perl|bash)"

# Check for unauthorized network connections
netstat -tulpn | grep ESTABLISHED

# Check for modified files
find / -mmin -60 -type f 2>/dev/null

# Check for new users
grep -E ":0:|:1[0-9]{3}:" /etc/passwd

# Check crontabs
for user in $(cut -f1 -d: /etc/passwd); do crontab -l -u $user 2>/dev/null; done
```

### 6. Check for Lateral Movement
- Review network logs for connections from target
- Check other systems accessed with same credentials
- Analyze authentication logs

## Containment (1-4 hours)

### 7. Clean Target System
```bash
# Remove identified malware/backdoors
# Kill malicious processes
# Remove unauthorized users
# Clear malicious cron entries
```

### 8. Rotate Credentials
- Rotate credential used in compromised session
- Rotate any credentials accessed during session
- Consider rotating all credentials on target system

## Recovery

### 9. Restore System
- If significant compromise: rebuild from known-good image
- If minor: patch and harden
- Verify no persistence mechanisms remain

### 10. Resume Monitoring
- Re-enable PSM access with enhanced monitoring
- Add specific detection rules for observed TTPs
```

---

## Investigation Procedures

### Evidence Collection

```bash
#!/bin/bash
# evidence-collection.sh
# Collect forensic evidence for PAM incident

INCIDENT_ID=$1
EVIDENCE_DIR="/forensics/${INCIDENT_ID}"
mkdir -p "${EVIDENCE_DIR}"

echo "=== PAM Incident Evidence Collection ==="
echo "Incident ID: ${INCIDENT_ID}"
echo "Collection Time: $(date -u)"

# 1. CyberArk Vault Logs
echo "Collecting CyberArk logs..."
scp vault@vault-server:/var/log/cyberark/* "${EVIDENCE_DIR}/vault_logs/"

# 2. PVWA Logs
echo "Collecting PVWA logs..."
scp pvwa@pvwa-server:C:/inetpub/logs/LogFiles/* "${EVIDENCE_DIR}/pvwa_logs/"

# 3. PSM Session Recordings
echo "Collecting PSM recordings..."
# Export from PVWA API or direct copy
curl -X GET "https://pvwa.example.com/PasswordVault/api/Recordings?Limit=100" \
  -H "Authorization: ${SESSION_TOKEN}" > "${EVIDENCE_DIR}/recordings_list.json"

# 4. Conjur Audit Logs
echo "Collecting Conjur audit logs..."
kubectl logs -n conjur-system -l app=conjur --since=24h > "${EVIDENCE_DIR}/conjur_logs.txt"

# 5. Network Traffic (if available)
echo "Collecting network captures..."
# tcpdump or PCAP from security tools

# 6. System Logs from Affected Hosts
echo "Collecting system logs..."
for host in ${AFFECTED_HOSTS}; do
  mkdir -p "${EVIDENCE_DIR}/hosts/${host}"
  ssh ${host} "sudo tar czf - /var/log" > "${EVIDENCE_DIR}/hosts/${host}/logs.tar.gz"
done

# 7. Calculate Hashes
echo "Calculating evidence hashes..."
find "${EVIDENCE_DIR}" -type f -exec sha256sum {} \; > "${EVIDENCE_DIR}/evidence_hashes.txt"

# 8. Create Evidence Manifest
cat > "${EVIDENCE_DIR}/manifest.json" << EOF
{
  "incident_id": "${INCIDENT_ID}",
  "collection_time": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "collector": "$(whoami)",
  "evidence_items": $(find "${EVIDENCE_DIR}" -type f | wc -l),
  "total_size": "$(du -sh ${EVIDENCE_DIR} | cut -f1)"
}
EOF

echo "Evidence collection complete. Location: ${EVIDENCE_DIR}"
```

### Log Analysis Queries

```sql
-- Query 1: Failed Authentication Timeline
SELECT
  timestamp,
  user,
  source_ip,
  action,
  result,
  details
FROM vault_audit_logs
WHERE result = 'Failed'
  AND timestamp BETWEEN @incident_start AND @incident_end
ORDER BY timestamp;

-- Query 2: Credential Access During Incident
SELECT
  timestamp,
  user,
  source_ip,
  safe,
  account_name,
  action
FROM vault_audit_logs
WHERE action IN ('Retrieve', 'Copy', 'Connect')
  AND timestamp BETWEEN @incident_start AND @incident_end
ORDER BY timestamp;

-- Query 3: Configuration Changes
SELECT
  timestamp,
  user,
  action,
  target_type,
  target_name,
  old_value,
  new_value
FROM vault_audit_logs
WHERE action IN ('Update', 'Delete', 'Create', 'AddMember', 'RemoveMember')
  AND timestamp BETWEEN @incident_start AND @incident_end
ORDER BY timestamp;
```

### Timeline Construction

```markdown
# Incident Timeline Template

## Incident: [INCIDENT_ID]
## Date: [DATE]

### Timeline

| Time (UTC) | Source | Event | Actor | Details |
|------------|--------|-------|-------|---------|
| HH:MM:SS | Vault | Failed login | attacker@bad.com | IP: x.x.x.x |
| HH:MM:SS | Vault | Successful login | attacker@bad.com | After 5 failures |
| HH:MM:SS | Vault | Credential retrieve | attacker | Safe: Production |
| HH:MM:SS | PSM | Session start | attacker | Target: db-server |
| HH:MM:SS | PSM | Command executed | attacker | SELECT * FROM users |
| HH:MM:SS | SIEM | Alert triggered | System | Bulk access detected |
| HH:MM:SS | IR Team | Incident declared | Analyst | Severity: High |
| HH:MM:SS | IR Team | Session terminated | Admin | Manual intervention |
| HH:MM:SS | IR Team | Account disabled | Admin | Containment |

### Key Findings
1. [Finding 1]
2. [Finding 2]
3. [Finding 3]

### Attack Vector
[Description of how the attack was carried out]

### Impact Assessment
- Systems affected: [List]
- Credentials compromised: [List]
- Data accessed: [List]
```

---

## Containment Actions

### Immediate Containment Options

```bash
#!/bin/bash
# containment-actions.sh

# Option 1: Disable User Account
disable_user() {
  local username=$1
  echo "Disabling user: ${username}"

  # CyberArk
  curl -X PUT "https://pvwa.example.com/PasswordVault/api/Users/${username}" \
    -H "Authorization: ${SESSION_TOKEN}" \
    -d '{"enableUser": false}'

  # Active Directory
  Set-ADUser -Identity ${username} -Enabled $false

  # Conjur
  conjur user rotate-api-key -u ${username}
}

# Option 2: Lock Safe
lock_safe() {
  local safe_name=$1
  echo "Locking safe: ${safe_name}"

  # Remove all member access temporarily
  curl -X DELETE "https://pvwa.example.com/PasswordVault/api/Safes/${safe_name}/Members/*" \
    -H "Authorization: ${SESSION_TOKEN}"
}

# Option 3: Rotate Credential
rotate_credential() {
  local account_id=$1
  echo "Rotating credential: ${account_id}"

  curl -X POST "https://pvwa.example.com/PasswordVault/api/Accounts/${account_id}/Change" \
    -H "Authorization: ${SESSION_TOKEN}" \
    -d '{"ChangeEntireGroup": false}'
}

# Option 4: Block IP Address
block_ip() {
  local ip_address=$1
  echo "Blocking IP: ${ip_address}"

  # AWS Security Group
  aws ec2 revoke-security-group-ingress \
    --group-id sg-pam-access \
    --protocol all \
    --cidr ${ip_address}/32

  # Add to WAF blocklist
  aws wafv2 update-ip-set \
    --name blocked-ips \
    --scope REGIONAL \
    --id $IP_SET_ID \
    --addresses ${ip_address}/32 \
    --lock-token $LOCK_TOKEN
}

# Option 5: Isolate System
isolate_system() {
  local instance_id=$1
  echo "Isolating system: ${instance_id}"

  # Move to quarantine security group
  aws ec2 modify-instance-attribute \
    --instance-id ${instance_id} \
    --groups sg-quarantine
}

# Option 6: Terminate All Sessions
terminate_sessions() {
  local username=$1
  echo "Terminating sessions for: ${username}"

  # Get all active sessions
  sessions=$(curl -s "https://pvwa.example.com/PasswordVault/api/LiveSessions" \
    -H "Authorization: ${SESSION_TOKEN}" | jq -r ".LiveSessions[] | select(.User==\"${username}\") | .SessionID")

  for session in $sessions; do
    curl -X POST "https://pvwa.example.com/PasswordVault/api/LiveSessions/${session}/Terminate" \
      -H "Authorization: ${SESSION_TOKEN}"
  done
}
```

### Containment Decision Matrix

| Scenario | Action | Impact | Reversible |
|----------|--------|--------|------------|
| Compromised user | Disable account | User loses access | Yes |
| Compromised credential | Rotate password | Application may break | Yes |
| Suspicious IP | Block at firewall | Legitimate users from IP blocked | Yes |
| Active attack | Terminate sessions | Ongoing work lost | No |
| System compromise | Network isolation | System offline | Yes |
| Vault breach | Enable lockdown mode | All access blocked | Yes |

---

## Recovery Procedures

### Recovery Checklist

```markdown
# Recovery Checklist

## Pre-Recovery Verification
- [ ] Threat has been fully contained
- [ ] Root cause identified
- [ ] Evidence preserved
- [ ] Stakeholders informed

## Credential Recovery
- [ ] All compromised credentials rotated
- [ ] Rotation verified on target systems
- [ ] Applications tested with new credentials
- [ ] Dependent systems updated

## Account Recovery
- [ ] Legitimate users re-enabled
- [ ] Access permissions reviewed
- [ ] MFA re-enrolled if needed
- [ ] Users notified

## System Recovery
- [ ] Affected systems cleaned/rebuilt
- [ ] Security patches applied
- [ ] Configurations hardened
- [ ] Monitoring enhanced

## Service Recovery
- [ ] PAM services restored
- [ ] Integrations verified
- [ ] Load testing completed
- [ ] Users can access normally

## Post-Recovery Monitoring
- [ ] Enhanced logging enabled
- [ ] Additional alerts configured
- [ ] Manual review scheduled
- [ ] Incident watch period defined
```

### Service Restoration Order

```
1. Core Infrastructure
   └── Password Vault Primary
       └── Verify data integrity
       └── Enable replication

2. Management Services
   └── PVWA (Web Access)
       └── Verify connectivity
       └── Test authentication

3. Operational Components
   └── CPM (Password Rotation)
       └── Verify rotation capability
   └── PSM (Session Management)
       └── Test session recording

4. Integrations
   └── Application connections
   └── CI/CD pipelines
   └── Monitoring systems

5. User Access
   └── Re-enable user accounts
   └── Verify access permissions
   └── Communicate restoration
```

---

## Post-Incident Activities

### Incident Report Template

```markdown
# Incident Report

## Executive Summary
- **Incident ID**: [ID]
- **Date/Time**: [Start] - [End]
- **Duration**: [Hours]
- **Severity**: [Critical/High/Medium/Low]
- **Status**: [Resolved/Ongoing]

## Incident Description
[Brief description of what happened]

## Timeline
[Key events with timestamps]

## Impact Assessment
- **Systems Affected**: [List]
- **Users Affected**: [Count]
- **Data Compromised**: [Yes/No - Details]
- **Business Impact**: [Description]
- **Financial Impact**: [Estimate if known]

## Root Cause Analysis
### What Happened
[Detailed technical description]

### Why It Happened
[Contributing factors]

### Detection Gap
[How long before detection, why]

## Response Summary
### Actions Taken
1. [Action 1]
2. [Action 2]
3. [Action 3]

### Response Timeline
- Time to Detect: [X minutes]
- Time to Contain: [X minutes]
- Time to Resolve: [X hours]

## Lessons Learned
### What Worked Well
1. [Positive 1]
2. [Positive 2]

### What Needs Improvement
1. [Improvement 1]
2. [Improvement 2]

## Recommendations
### Immediate (0-30 days)
- [ ] [Recommendation 1]
- [ ] [Recommendation 2]

### Short-term (30-90 days)
- [ ] [Recommendation 1]
- [ ] [Recommendation 2]

### Long-term (90+ days)
- [ ] [Recommendation 1]
- [ ] [Recommendation 2]

## Appendices
- A: Evidence Inventory
- B: Detailed Timeline
- C: Technical Findings
- D: Communication Log
```

### Lessons Learned Meeting Agenda

```markdown
# Post-Incident Review Meeting

## Meeting Details
- **Date**: [Date]
- **Duration**: 60-90 minutes
- **Attendees**: IR Team, PAM Admins, Security Leadership

## Agenda

### 1. Incident Overview (10 min)
- Timeline recap
- Impact summary
- Current status

### 2. What Happened (15 min)
- Technical walkthrough
- Attack vector analysis
- Root cause discussion

### 3. Response Evaluation (20 min)
- What worked well?
- What could be improved?
- Were playbooks followed?
- Tool effectiveness

### 4. Gap Analysis (15 min)
- Detection gaps
- Response gaps
- Communication gaps
- Tool/process gaps

### 5. Recommendations (15 min)
- Prioritized improvements
- Resource requirements
- Timeline for implementation

### 6. Action Items (10 min)
- Assign owners
- Set deadlines
- Schedule follow-up

## Ground Rules
- Blameless discussion
- Focus on process, not people
- Constructive recommendations
- Document everything
```

---

## Communication Templates

### Initial Notification

```
Subject: [SEVERITY] PAM Security Incident - [INCIDENT_ID]

Incident Summary:
A security incident affecting the Privileged Access Management system has been detected.

Severity: [Critical/High/Medium]
Status: Under Investigation
Detection Time: [TIMESTAMP]

Current Impact:
- [Brief description of impact]
- [Affected systems/users]

Actions in Progress:
- Incident response team engaged
- Containment measures being implemented
- Investigation ongoing

Next Update: [TIME]

For questions, contact: [CONTACT]
```

### Status Update

```
Subject: UPDATE - PAM Security Incident - [INCIDENT_ID]

Current Status: [Contained/Under Investigation/Resolved]

Update Summary:
[Brief description of what has changed since last update]

Actions Completed:
- [Action 1]
- [Action 2]

Actions In Progress:
- [Action 1]
- [Action 2]

Impact Update:
- [Current impact assessment]
- [Any changes to scope]

Next Steps:
- [Planned action 1]
- [Planned action 2]

Estimated Resolution: [TIME/DATE]
Next Update: [TIME]
```

### Resolution Notification

```
Subject: RESOLVED - PAM Security Incident - [INCIDENT_ID]

The security incident has been resolved.

Resolution Summary:
[Brief description of how incident was resolved]

Root Cause:
[High-level root cause]

Actions Taken:
- [Action 1]
- [Action 2]
- [Action 3]

Preventive Measures:
- [Measure 1]
- [Measure 2]

Remaining Activities:
- Post-incident review scheduled: [DATE]
- Full incident report: [DATE]

If you experience any issues, contact: [CONTACT]
```

---

## Tools and Resources

### Incident Response Toolkit

```yaml
tools:
  detection:
    - Splunk (SIEM)
    - CyberArk Vault Audit
    - Conjur Audit Logs
    - AWS CloudTrail
    - Azure Activity Log

  analysis:
    - Wireshark (network analysis)
    - Volatility (memory forensics)
    - Autopsy (disk forensics)
    - YARA (malware detection)
    - Log Parser Lizard

  containment:
    - CyberArk PVWA (account management)
    - AWS Security Groups
    - Azure NSGs
    - Firewall management tools

  communication:
    - PagerDuty (alerting)
    - Slack (team communication)
    - StatusPage (status updates)
    - Jira (ticket tracking)

  documentation:
    - Confluence (knowledge base)
    - GitHub (runbooks)
    - DrawIO (diagrams)
```

### Quick Reference Commands

```bash
# CyberArk Quick Commands
# List all safes
curl -X GET "https://pvwa/PasswordVault/api/Safes" -H "Authorization: $TOKEN"

# Get safe members
curl -X GET "https://pvwa/PasswordVault/api/Safes/<SafeName>/Members" -H "Authorization: $TOKEN"

# Disable user
curl -X PUT "https://pvwa/PasswordVault/api/Users/<UserID>" -H "Authorization: $TOKEN" -d '{"enableUser":false}'

# Rotate password
curl -X POST "https://pvwa/PasswordVault/api/Accounts/<AccountID>/Change" -H "Authorization: $TOKEN"

# Terminate session
curl -X POST "https://pvwa/PasswordVault/api/LiveSessions/<SessionID>/Terminate" -H "Authorization: $TOKEN"

# Conjur Quick Commands
# Check authentication
conjur whoami

# View audit log
conjur audit -r variable:apps/myapp --since "1 hour ago"

# Rotate host API key
conjur host rotate-api-key -i apps/myhost

# List resources
conjur list -k variable
```

---

## Related Documents

- **HA/DR Architecture**: [HA_DR_ARCHITECTURE.md](HA_DR_ARCHITECTURE.md)
- **CyberArk Cheat Sheets**: [CYBERARK_CHEAT_SHEETS.md](CYBERARK_CHEAT_SHEETS.md)
- **Compliance Frameworks**: [COMPLIANCE_FRAMEWORKS_GUIDE.md](COMPLIANCE_FRAMEWORKS_GUIDE.md)
- **Consulting Skills**: [CONSULTING_SKILLS.md](../roadmap/CONSULTING_SKILLS.md)

---

## External References

- [NIST Incident Response Guide (SP 800-61)](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final)
- [SANS Incident Handler's Handbook](https://www.sans.org/white-papers/33901/)
- [CyberArk Security Bulletins](https://www.cyberark.com/resources/security-center)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)

---

**Last Updated**: 2025-12-04
**Version**: 1.0
