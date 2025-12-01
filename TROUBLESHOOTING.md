# Troubleshooting Guide

Solutions for common problems encountered during the 27-Month Cybersecurity Roadmap.

---

## Certification Exam Issues

### Failed a Certification Exam

**Symptoms**: Did not pass certification exam on first attempt

**Impact**:
- Timeline delay of 3-4 weeks minimum
- Additional exam cost ($250-750 depending on certification)
- Potential confidence impact

**Immediate Actions**:

1. **Review your score report** (usually provided within 24-48 hours)
   - Identify which domains/topics you scored lowest
   - Note specific areas marked as "needs improvement"
   - Don't just look at pass/fail - understand WHERE you struggled

2. **Take 24-48 hours to process** before jumping back into study
   - Avoid emotional reactions
   - Failed exam ≠ failure in career
   - Many successful consultants failed exams on first attempt

3. **Create a recovery study plan** (3-4 weeks):
   ```
   Week 1: Deep dive on weakest domain(s) from score report
   Week 2: Hands-on labs for weak areas + review of all domains
   Week 3: Practice tests (targeting 90%+)
   Week 4: Final review + exam retake
   ```

4. **Update your timeline**:
   - Add 4 weeks to current phase
   - Adjust subsequent milestones
   - Update 27MONTH_PROGRESS_TRACKER.csv

**Prevention for Next Time**:
- [ ] Never schedule exam unless scoring 90%+ on practice tests consistently
- [ ] Complete ALL hands-on labs before exam (theory alone isn't enough)
- [ ] Allow 2-4 weeks of pure study before exam (no new topics)
- [ ] Take multiple practice tests from different sources

**Cost Management**:
- Check if exam provider offers discounted retake bundles
- CyberArk Campus may offer voucher discounts
- Budget $500-1000 for potential exam retakes in BUDGET.md

**When to Reconsider**:
- If you fail same exam 3 times: Reassess if you need more foundational knowledge
- Consider if certification is appropriate for your current skill level
- May need to extend timeline significantly or seek formal training

---

### Practice Test Scores Below 80%

**Symptoms**: Consistently scoring below 80% on practice exams

**Impact**: Not ready for real exam - high failure risk if you proceed

**Root Causes**:
- Insufficient study time (rushed through material)
- Weak foundational knowledge
- Poor test-taking skills
- Not completing hands-on labs (theory without practice)
- Language barriers (if exam is in English)

**Solutions**:

1. **Do NOT schedule exam yet**
   - 80% = not ready
   - Target: 90%+ consistently before scheduling

2. **Analyze your weak areas**:
   - Which domains are you scoring lowest?
   - Are you weak on concepts or application?
   - Is it knowledge gap or test-taking skills?

3. **Extend study period by 2-4 weeks**:
   ```
   Week 1-2: Focus exclusively on weak domains
   Week 3: Take full practice test again
   If still <85%: Add another 2 weeks
   If 85-90%: One more week of weak area review
   If 90%+: Schedule exam for 1-2 weeks out
   ```

4. **Hands-on labs are mandatory**:
   - Each certification requires practical experience
   - Theory + Practice = exam success
   - If you skipped labs to save time, go back and complete them

5. **Consider study method changes**:
   - Active learning (labs, flashcards, teaching others) > passive reading
   - Study groups or forums for discussion
   - Alternate study resources (different author's explanations)

**English Language Considerations**:
- If struggling with English in exams, allocate extra time to:
  - Read questions carefully (highlight keywords)
  - Build technical English vocabulary
  - Practice reading comprehension
  - Consider taking English exam prep course

---

## Lab & Technical Issues

### Cannot Complete Hands-On Labs

**Symptoms**: Stuck on lab exercises, can't get environment working, configurations failing

**Common Causes**:

**1. Insufficient hardware resources**:
- Labs need 16GB+ RAM, 4+ cores
- Running out of disk space
- VMs competing for resources

**Solutions**:
- Close unnecessary applications
- Allocate more resources to VMs in settings
- Consider using cloud VMs (AWS/Azure) instead of local
- Simplify lab: fewer VMs, lighter-weight setup

**2. Missing prerequisites or dependencies**:
- Skipped setup steps
- Missing software components
- Network/firewall blocking connections

**Solutions**:
- Re-read lab instructions from beginning
- Check all prerequisites are installed
- Verify network connectivity
- Check firewall rules (local and cloud)

**3. Following outdated documentation**:
- CyberArk versions change
- Kubernetes versions change
- Cloud platforms update frequently

**Solutions**:
- Check documentation date vs. current date
- Look for version-specific notes
- Search for "[technology] [version] [specific error]" on Google
- Check if newer lab guides exist on CyberArk Campus

**4. Knowledge gaps**:
- Fundamental concepts not understood
- Moving too fast through material
- Skipping foundational topics

**Solutions**:
- **Stop and learn the fundamentals**
- Don't skip ahead when confused
- Watch tutorial videos explaining concepts
- Ask "Why does this work?" not just "How do I make it work?"

**Getting Help**:

1. **Search first** (90% of lab issues already solved online):
   - Google exact error message
   - Check CyberArk Community forums
   - Search Stack Overflow for K8s issues

2. **Ask for help** (when stuck >2 hours):
   - CyberArk Community forums (very active)
   - Kubernetes Slack channels
   - Reddit: /r/cybersecurity, /r/kubernetes
   - Discord: DevOps/Security communities

3. **How to ask for help effectively**:
   ```
   ❌ "CyberArk not working, help!"
   ✅ "CyberArk CPM v12.6 failing to rotate password for Linux account.
       Error: [exact error message]
       Environment: [Ubuntu 22.04, CPM connected to Vault successfully]
       What I've tried: [list troubleshooting steps]
   ```

**When to Simplify vs. Persist**:
- **Persist**: Core technologies (PAM, Conjur, K8s) - you MUST learn these
- **Simplify**: Optional integrations, complex scenarios - come back later
- **Skip temporarily**: Bleeding-edge features, undocumented setups

---

### Running Out of Cloud Credits / Budget

**Symptoms**: AWS/Azure costs exceeding budget, free tier exhausted

**Impact**: Cannot complete cloud labs, budget overrun

**Immediate Solutions**:

1. **Stop all running resources**:
   - AWS: EC2 instances, RDS databases, ELB load balancers
   - Azure: VMs, databases, storage accounts
   - Check for "orphaned" resources (created but forgotten)

2. **Delete unused resources**:
   - Old snapshots
   - Unattached volumes
   - Test environments left running
   - Log files in S3/Blob storage

3. **Use cost calculators**:
   - AWS Cost Explorer (shows what's costing money)
   - Azure Cost Management
   - Set up billing alerts (<$10, <$25, <$50)

**Cost Optimization Strategies**:

1. **Maximize free tiers**:
   - AWS: 750 hours/month EC2 t2.micro (run one instance 24/7)
   - Azure: $200 credit first month + 12 months free services
   - Use free tier services exclusively for first 6 months

2. **Time-box cloud usage**:
   - Only spin up resources when actively doing labs
   - Shut down everything when done (daily)
   - Use instance schedulers (auto-start/stop)

3. **Use local labs instead**:
   - PAM: Run entirely on local VMs (no cloud needed)
   - Conjur: Docker locally (no cloud needed)
   - K8s: Minikube/Kind locally (no cloud needed)
   - **Only use cloud for**: AWS/Azure specific services (M19-27)

4. **Smaller instance sizes**:
   - Use t2.micro instead of t2.medium (AWS)
   - Use B1S instead of B2S (Azure)
   - Performance slower but functional for learning

5. **Clean up regularly**:
   ```
   Weekly: Delete all test resources
   Monthly: Review bill, identify unexpected costs
   ```

**Budget Allocation**:
- Months 1-18: $0-5/month (local labs)
- Months 19-27: $20-50/month (AWS + Azure practice)
- Emergency buffer: $200 for unexpected costs

**If Budget Truly Constrained**:
- Complete Months 1-18 entirely on local infrastructure
- Save cloud practice for Months 19-27 only
- Consider extending timeline to spread cloud costs
- Look for AWS/Azure credits (student programs, startup programs)

---

## Schedule & Progress Issues

### Consistently Missing Weekly Study Hours

**Symptoms**: Logging only 6-8 hours/week instead of 10-12 hours/week for 3+ consecutive weeks

**Impact**: Falling behind timeline, won't complete monthly deliverables

**Root Cause Analysis**:

**Ask yourself honestly**:

1. **Is 10-12 hrs/week realistic for my life?**
   - Work demands changed?
   - Family commitments increased?
   - Health issues?
   - **If life changed significantly**: Adjust timeline expectations

2. **Am I inefficient with study time?**
   - Distractions during study (social media, interruptions)?
   - Choosing easy tasks over hard ones?
   - Spending too long on unimportant details?
   - **If yes**: Improve study discipline and focus

3. **Am I avoiding specific topics?**
   - Stuck on something and procrastinating?
   - Topic seems too hard?
   - Losing motivation?
   - **If yes**: Seek help, break down into smaller tasks

**Solutions by Root Cause**:

**If life circumstances changed**:
1. **Accept reality and adjust timeline**
   - 8 hrs/week realistic? Extend to 34 months
   - 6 hrs/week realistic? Extend to 45 months
   - <6 hrs/week? Pause roadmap until life stabilizes

2. **Update your plan**:
   - Recalculate timeline in CSV tracker
   - Adjust monthly milestones
   - Communicate to anyone supporting you

**If inefficiency is the issue**:
1. **Time-box activities**:
   - Pomodoro technique (25-min focus blocks)
   - Turn off phone/notifications during study
   - Dedicated study space (not couch/bed)

2. **Track where time actually goes**:
   - Log daily: "Actually studied 1.5 hrs" vs. "Planned 2 hrs"
   - Identify time leaks (setup time, distractions, breaks)

3. **Front-load your week**:
   - Don't leave all 12 hrs for weekend
   - Monday-Wednesday: knock out 6 hrs
   - Relieves weekend pressure

**If avoiding difficult topics**:
1. **Break down the scary task**:
   - "Learn Conjur" → "Read first 3 pages of Conjur docs"
   - Small wins build momentum

2. **Seek help early**:
   - Don't stay stuck for weeks
   - Ask in forums, communities
   - Find a study buddy

3. **Revisit motivation**:
   - Remember why you started ($250-400/hr consulting!)
   - Visualize Month 27 success
   - Review success stories

**Prevention**:
- Weekly Sunday review (30 mins) to assess if on track
- Monthly reassessment of time commitment
- Quarterly deep reflection on progress and motivation

---

### Feeling Burned Out

**Symptoms**:
- Dreading study time
- Difficulty concentrating
- Skipping study sessions
- Losing interest in topics you previously enjoyed
- Irritability, fatigue, lack of motivation

**Impact**:
- Significantly increased risk of abandoning roadmap
- Poor learning retention
- Potential health impacts

**Immediate Actions** (Take seriously - burnout is real):

1. **Take an immediate 1-week break**:
   - No studying, no labs
   - Rest and recharge
   - Spend time on hobbies, family, exercise
   - This is NOT failure - this is smart management

2. **Assess burnout severity**:

   **Mild burnout** (caught early):
   - Reduce to 8 hrs/week for 2 weeks
   - Focus on easier, more enjoyable activities
   - Skip ahead to next recovery month

   **Moderate burnout** (chronic stress):
   - Take 2-week complete break
   - Reduce to 6 hrs/week for 4 weeks
   - Extend timeline by 2-3 months
   - Focus only on high-value activities

   **Severe burnout** (considering quitting):
   - Take 1-month complete break
   - Reassess if roadmap is right for you
   - Consider pausing roadmap for 3-6 months
   - Seek support (mentor, community, therapist if needed)

3. **Prevent recurrence**:
   - **Use recovery months** - M12, M18, M27 are designed to prevent this
   - Don't skip recovery months to "save time"
   - Reduce weekly hours permanently if needed
   - Better to finish in 30 months than burn out at Month 15

**Burnout Prevention Strategies**:

1. **Maintain work-life balance**:
   - Exercise 3x/week minimum
   - Sleep 7-8 hours nightly
   - Social connections maintained
   - Hobbies outside of tech

2. **Variety in study activities**:
   - Mix hands-on labs (active) with reading (passive)
   - Alternate hard topics with easier ones
   - Celebrate small wins

3. **Community engagement**:
   - Share progress on LinkedIn
   - Help others in forums
   - Find study buddy or accountability partner
   - Remind yourself you're not alone

**Red Flags to Stop Immediately**:
- Suicidal thoughts or severe depression
- Physical health deteriorating
- Relationships seriously damaged
- Work performance significantly impacted

**Your health and well-being > this roadmap**. Extend, pause, or modify as needed.

---

## English Learning Issues

### English Not Improving as Expected

**Symptoms**:
- At Month 12 but can't write clear technical docs
- At Month 18 but struggle to understand training videos
- At Month 24 but not ready for client communication

**Root Causes**:

**1. Not actually practicing daily** (just reading passively)

**Solution**:
- **Active practice required**: Write daily, speak daily, not just read
- English in: Read docs → English out: Write summary
- Set up language exchange partner (30 mins/week speaking practice)

**2. Avoiding English (using translations)**

**Solution**:
- Stop using Spanish translations of docs
- Force yourself to struggle through English versions
- Write all notes in English from Day 1
- Change phone/computer interface to English

**3. No feedback loop** (don't know if you're improving)

**Solution**:
- Post in English forums (get corrections)
- Use Grammarly or LanguageTool (free) for writing feedback
- Record yourself speaking, listen back
- Ask native speaker to review your writing

**4. Learning general English, not technical English**

**Solution**:
- Focus on cybersecurity-specific vocabulary
- Read CyberArk docs, not novels
- Watch tech presentations, not TV shows
- Write technical blogs, not creative writing

**Specific Remediation by Phase**:

**If behind at Month 6**:
- Add 30 mins/day English-only technical reading
- Use children's tech books (simpler English, same concepts)
- Flashcards for technical vocabulary
- Extend Phase 1 by 2 months if needed

**If behind at Month 12**:
- Start publishing SHORT blog posts (300 words) weekly
- Join English-speaking online communities
- Watch YouTube tech videos with English subtitles, then without
- Consider online tutor (italki.com, $10-20/hr)

**If behind at Month 18**:
- Critical: You need professional English for consulting
- Consider intensive English course (2-4 weeks)
- Daily 1-hour English practice (in addition to roadmap)
- May need to extend timeline by 6 months for English catch-up

**If behind at Month 24**:
- **Stop and reassess**: Consulting requires fluent English
- Options:
  1. Extend timeline by 6-12 months, focus heavily on English
  2. Target local market only (if non-English speaking)
  3. Partner with English-speaking consultant for client-facing work

**Resources for Accelerated English Learning**:
- **italki.com**: 1-on-1 tutors, $10-30/hr, 3x/week = significant improvement
- **Preply**: Similar to italki
- **Cambly**: Conversation practice with native speakers
- **Coursera**: "English for IT Professionals" free audit
- **YouTube**: "English Speeches" channel for executive communication practice

**Minimum English Levels by Phase**:
- **Month 6**: CEFR B1 (Intermediate) - read technical docs
- **Month 12**: CEFR B2 (Upper Intermediate) - write clear docs
- **Month 18**: CEFR C1 (Advanced) - professional communication
- **Month 24-27**: CEFR C1-C2 - consulting-level fluency

---

## Still Stuck?

**If your issue isn't listed here**:

1. **Check other resources**:
   - [FAQ.md](FAQ.md) - Common questions and answers
   - [GLOSSARY.md](GLOSSARY.md) - Terminology definitions
   - [GETTING_STARTED.md](GETTING_STARTED.md) - Setup and onboarding

2. **Search online communities**:
   - CyberArk Community forums (official, very active)
   - Reddit: /r/cybersecurity, /r/sysadmin
   - Discord: Search for cybersecurity/PAM communities

3. **Ask for help** (be specific):
   - Describe exact problem
   - Include error messages
   - Explain what you've tried
   - Provide context (which month, which lab, etc.)

4. **Document your issue and solution**:
   - When you solve it, write it down
   - Helps others who encounter same issue
   - Reinforces your learning

---

## CyberArk PAM Troubleshooting

Technology-specific issues for CyberArk Privileged Access Manager.

### Vault Connection Issues

**Symptoms**: PVWA, CPM, or PSM cannot connect to Vault

**Common Causes & Solutions**:

**1. Vault Service Not Running**:
```bash
# Check Vault service status (on Vault server)
sc query PrivateArk

# Start if stopped
net start PrivateArk
```

**2. Firewall Blocking Port 1858**:
```bash
# Test connectivity from component server
Test-NetConnection -ComputerName vault.company.com -Port 1858

# If blocked, add firewall rule (Windows)
New-NetFirewallRule -DisplayName "CyberArk Vault" -Direction Inbound -Port 1858 -Protocol TCP -Action Allow
```

**3. Credential Manager Service Issues**:
```bash
# Check CredFile location
Get-Content "C:\Program Files (x86)\CyberArk\Password Vault Web Access\CredFiles\appuser.ini"

# Recreate CredFile if corrupted
CreateCredFile.exe appuser.ini Password /Username <username> /Password <password> /AppType "AppPrv" /Hostname <vault>
```

**4. SSL/TLS Certificate Issues**:
- Verify certificate not expired
- Ensure certificate chain is complete
- Check certificate hostname matches Vault FQDN

---

### CPM (Central Policy Manager) Issues

**Symptoms**: Passwords not rotating, CPM service errors

**Issue 1: CPM Cannot Reconcile Account**

**Diagnostic Steps**:
```text
1. Check CPM log: C:\Program Files (x86)\CyberArk\Password Manager\Logs\PMConsole.log
2. Look for error codes:
   - ITATS033E: Account locked on target
   - ITATS034E: Insufficient permissions
   - ITATS049E: Connection timeout
```

**Common Fixes**:
- **Account locked**: Unlock on target system, verify reconcile account has unlock permissions
- **Permission issue**: Verify reconcile account has password reset rights
- **Connection timeout**: Check network path, firewall rules, DNS resolution

**Issue 2: CPM High CPU Usage**

**Cause**: Too many concurrent tasks or stuck processes

**Solution**:
```text
1. Reduce MaxConcurrentConnections in PMConfigure.xml
2. Check for hung CPM scanner processes
3. Verify target system responsiveness
4. Review pending password changes in queue
```

---

### PSM (Privileged Session Manager) Issues

**Symptoms**: Session recording failures, connection errors

**Issue 1: RDP Connections Failing**

**Diagnostic Steps**:
```powershell
# Check PSM service
Get-Service PSMConnector

# Verify RDP listener on PSM
netstat -an | Select-String ":3389"

# Test target connectivity from PSM
Test-NetConnection -ComputerName target.company.com -Port 3389
```

**Common Fixes**:
- Ensure PSM has valid certificate for RDP
- Check PSM license allocation
- Verify PSM account has "Log on locally" rights
- Restart PSM services:
  ```powershell
  Restart-Service PSMConnector
  Restart-Service CyberArkScheduledTasks
  ```

**Issue 2: Session Recording Not Working**

**Cause**: Storage issues, recording server problems

**Diagnostic**:
```text
1. Check recording path exists and has write permissions
2. Verify disk space on recording destination
3. Check Windows Media Foundation installed (required for recording)
4. Review PSMRecording.log for errors
```

---

### PVWA (Password Vault Web Access) Issues

**Symptoms**: Web interface errors, login failures

**Issue 1: "Cannot Connect to Vault" Error**

**Solutions**:
```text
1. Verify IIS Application Pool running
2. Check Vault connectivity from PVWA server
3. Review Application Event Log for .NET errors
4. Verify PVWA application user credentials in Vault
5. Clear browser cache and retry
```

**Issue 2: LDAP Authentication Failing**

**Diagnostic**:
```powershell
# Test LDAP connectivity
$ldap = [ADSI]"LDAP://dc.company.com:389"
$ldap.Name

# Check PVWA LDAP configuration
# AdminTools > Configuration > LDAP Integration
```

**Common Fixes**:
- Verify LDAP bind account not locked
- Check LDAP URL format (ldap://dc.company.com:389 or ldaps://dc.company.com:636)
- Ensure Base DN correct
- Test LDAP filter syntax

---

## Kubernetes Security Troubleshooting

Common Kubernetes security issues and solutions.

### RBAC Permission Errors

**Symptoms**: "User cannot get/list/create resource" errors

**Diagnostic Commands**:
```bash
# Check what a user can do
kubectl auth can-i --list --as=user@company.com

# Check specific permission
kubectl auth can-i create pods --as=system:serviceaccount:default:my-sa -n production

# View effective RBAC for service account
kubectl get rolebindings,clusterrolebindings -A -o wide | grep my-sa

# Debug RBAC with impersonation
kubectl get pods -n production --as=system:serviceaccount:default:my-sa
```

**Common Fixes**:

**1. Create Missing RoleBinding**:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: production
subjects:
- kind: ServiceAccount
  name: my-sa
  namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

**2. Service Account Missing Token**:
```bash
# For K8s 1.24+, tokens are not auto-created
# Create token manually
kubectl create token my-sa -n default

# Or create legacy secret
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: my-sa-token
  namespace: default
  annotations:
    kubernetes.io/service-account.name: my-sa
type: kubernetes.io/service-account-token
EOF
```

---

### Network Policy Issues

**Symptoms**: Pods cannot communicate, services unreachable

**Diagnostic Commands**:
```bash
# List network policies affecting a pod
kubectl get networkpolicy -n <namespace>

# Test connectivity from inside pod
kubectl exec -it <pod> -- curl <target-service>:port
kubectl exec -it <pod> -- nc -zv <target-ip> <port>

# Check if CNI supports NetworkPolicy
kubectl get pods -n kube-system | grep -E 'calico|cilium|weave'
```

**Common Issues**:

**1. Default Deny Blocking Traffic**:
```yaml
# This policy denies ALL traffic to pods with app=backend
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  - Egress
```

**Fix - Add Allow Rule**:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
```

**2. CNI Doesn't Support Network Policies**:
- **Flannel**: Does NOT support NetworkPolicy
- **Calico, Cilium, Weave**: Support NetworkPolicy
- Solution: Install Calico alongside Flannel or migrate CNI

---

### Pod Security Issues

**Symptoms**: Pods stuck in "CreateContainerConfigError" or "Forbidden"

**Diagnostic Commands**:
```bash
# Check events for pod
kubectl describe pod <pod-name> -n <namespace>

# Check if PodSecurityAdmission is blocking
kubectl get events -n <namespace> --field-selector reason=FailedCreate

# View namespace PSA labels
kubectl get namespace <namespace> -o yaml | grep pod-security
```

**Common Fixes**:

**1. Pod Blocked by Pod Security Standards**:
```text
Error: "violates PodSecurity 'restricted:latest'"
```

**Fix - Modify pod to comply**:
```yaml
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
      readOnlyRootFilesystem: true
```

**2. Namespace PSA Too Restrictive**:
```bash
# Check current enforcement
kubectl get ns production -o jsonpath='{.metadata.labels}'

# Lower enforcement for testing (not production!)
kubectl label namespace production pod-security.kubernetes.io/enforce=baseline --overwrite
```

---

### Secrets Management Issues

**Symptoms**: Secrets not mounting, cannot access secret data

**Diagnostic Commands**:
```bash
# Verify secret exists
kubectl get secret <secret-name> -n <namespace>

# Check secret content (base64 encoded)
kubectl get secret <secret-name> -o jsonpath='{.data}'

# Check pod can access secret
kubectl describe pod <pod-name> | grep -A5 Volumes

# Check service account permissions
kubectl auth can-i get secrets --as=system:serviceaccount:<namespace>:<sa-name>
```

**Common Fixes**:

**1. Secret in Wrong Namespace**:
```bash
# Secrets are namespace-scoped
# Pod in namespace A cannot access secret in namespace B
# Solution: Copy secret to same namespace or use External Secrets

kubectl get secret my-secret -n source-namespace -o yaml | \
  sed 's/namespace: source-namespace/namespace: target-namespace/' | \
  kubectl apply -f -
```

**2. Using Conjur with Kubernetes**:
```yaml
# If Conjur authenticator failing, check:
# 1. Conjur authenticator enabled in Conjur
# 2. Service account authorized in Conjur policy
# 3. Conjur URL and certificate correct

# Debug Conjur sidecar
kubectl logs <pod-name> -c authenticator -n <namespace>
```

---

## Conjur Troubleshooting

CyberArk Conjur secrets management issues.

### Conjur Authentication Failures

**Symptoms**: Applications cannot authenticate to Conjur

**Issue 1: Kubernetes Authenticator Not Working**

**Diagnostic Steps**:
```bash
# Check Conjur server logs
docker logs conjur-server 2>&1 | grep authn-k8s

# Verify authenticator enabled
conjur list -k authenticator

# Check service account has Conjur identity
kubectl get serviceaccount <sa-name> -o yaml | grep conjur
```

**Common Causes**:
1. **Authenticator not enabled**: Enable in Conjur config
2. **Service account not authorized**: Add to Conjur policy
3. **Certificate mismatch**: Regenerate Conjur certificate

**Fix - Add Service Account to Conjur Policy**:
```yaml
# In Conjur policy file
- !host
  id: myapp
  annotations:
    authn-k8s/namespace: production
    authn-k8s/service-account: my-service-account
    authn-k8s/authentication-container-name: authenticator

- !grant
  role: !group consumers/myapp-group
  member: !host myapp
```

---

### Secret Retrieval Failures

**Symptoms**: Application cannot retrieve secrets after authentication

**Diagnostic Commands**:
```bash
# Test secret retrieval manually
conjur variable get -i secrets/production/db/password

# Check variable exists
conjur list -k variable | grep db/password

# Verify permissions
conjur resource permitted_roles variable:secrets/production/db/password execute
```

**Common Fixes**:

**1. Variable Path Incorrect**:
```text
Common mistake: secrets/db/password
Correct path: myorg/secrets/production/db/password

# Check full variable path
conjur list -k variable
```

**2. Missing Execute Permission**:
```yaml
# Conjur policy - grant execute permission
- !permit
  resource: !variable secrets/production/db/password
  privileges: [read, execute]
  roles: !group consumers/myapp-group
```

---

## Cloud Security Troubleshooting

AWS, Azure, and GCP common security issues.

### AWS IAM Issues

**Symptoms**: Access denied errors, unable to assume roles

**Diagnostic Commands**:
```bash
# Check current identity
aws sts get-caller-identity

# Test specific permission
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:user/myuser \
  --action-names s3:GetObject \
  --resource-arns arn:aws:s3:::mybucket/*

# Check role trust policy
aws iam get-role --role-name MyRole --query 'Role.AssumeRolePolicyDocument'
```

**Common Fixes**:

**1. Cross-Account Role Assumption Failing**:
```json
// Trust policy must allow the source account
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "AWS": "arn:aws:iam::SOURCE_ACCOUNT_ID:root"
    },
    "Action": "sts:AssumeRole",
    "Condition": {
      "StringEquals": {
        "sts:ExternalId": "unique-external-id"
      }
    }
  }]
}
```

**2. SCP (Service Control Policy) Blocking**:
```bash
# Check organization SCPs
aws organizations list-policies --filter SERVICE_CONTROL_POLICY

# Get SCP content
aws organizations describe-policy --policy-id p-xxxxx
```

---

### Azure RBAC Issues

**Symptoms**: "AuthorizationFailed" errors

**Diagnostic Commands**:
```bash
# Check current user
az account show

# List role assignments for user
az role assignment list --assignee user@company.com --output table

# Check specific permission
az role assignment list --scope /subscriptions/<sub-id>/resourceGroups/<rg> --output table
```

**Common Fixes**:

**1. Missing Role Assignment**:
```bash
# Assign Contributor role at resource group scope
az role assignment create \
  --assignee user@company.com \
  --role "Contributor" \
  --scope /subscriptions/<sub-id>/resourceGroups/<rg>
```

**2. Managed Identity Not Working**:
```bash
# Check managed identity status
az vm identity show --name myvm --resource-group myrg

# Verify identity can access Key Vault
az keyvault secret list --vault-name myvault
# If fails, add access policy:
az keyvault set-policy --name myvault \
  --object-id <managed-identity-object-id> \
  --secret-permissions get list
```

---

### GCP IAM Issues

**Symptoms**: "Permission denied" errors

**Diagnostic Commands**:
```bash
# Check current identity
gcloud auth list

# Test IAM permissions
gcloud projects get-iam-policy PROJECT_ID --flatten="bindings[].members" \
  --filter="bindings.members:user@company.com"

# Check service account permissions
gcloud projects get-iam-policy PROJECT_ID --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:SA@PROJECT.iam.gserviceaccount.com"
```

**Common Fixes**:

**1. Add IAM Binding**:
```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:user@company.com" \
  --role="roles/storage.objectViewer"
```

**2. Workload Identity Not Working**:
```bash
# Check Workload Identity annotation on service account
kubectl get serviceaccount KSA_NAME -o yaml | grep workload

# Bind KSA to GSA
gcloud iam service-accounts add-iam-policy-binding GSA@PROJECT.iam.gserviceaccount.com \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:PROJECT.svc.id.goog[NAMESPACE/KSA_NAME]"
```

---

## DevSecOps Pipeline Troubleshooting

CI/CD security scanning issues.

### Security Scan Failures

**Symptoms**: Pipeline blocked by security scanners

**Issue 1: Trivy Blocking on Vulnerabilities**

**Diagnostic**:
```bash
# Run Trivy manually with verbose output
trivy image --severity HIGH,CRITICAL myimage:latest

# Check specific CVE
trivy image --vuln-type os --ignore-unfixed myimage:latest
```

**Fixes**:
```bash
# Option 1: Ignore specific CVE (with justification)
trivy image --ignorefile .trivyignore myimage:latest

# .trivyignore contents:
# CVE-2021-12345  # Accepted risk: not exploitable in our context

# Option 2: Upgrade base image
# Change Dockerfile FROM
FROM alpine:3.18  # Instead of alpine:3.17
```

**Issue 2: SAST Tool False Positives**

**Solutions**:
```yaml
# For SonarQube - suppress with comment
# NOSONAR: False positive, input is already sanitized
validate_input(user_input)  // NOSONAR

# For Semgrep - nosemgrep comment
# nosemgrep: security-audit
os.system(safe_command)
```

---

### Secrets Detection Blocking Pipeline

**Symptoms**: Pipeline fails on "secrets detected"

**Issue**: Legitimate test data flagged as secrets

**Solutions**:

**1. GitLeaks Allowlist**:
```toml
# .gitleaks.toml
[allowlist]
  paths = [
    "test/fixtures/",
    "docs/examples/"
  ]
  regexes = [
    "EXAMPLE_API_KEY",
    "test-secret-do-not-use"
  ]
```

**2. Pre-commit Hook Bypass (Emergency Only)**:
```bash
# Skip pre-commit hooks (document why!)
git commit --no-verify -m "Emergency fix: documented false positive"
```

---

**Remember**: Everyone encounters obstacles. Persistence + seeking help = success.

---

**Last Updated**: 2025-12-01
**Version**: 2.0
