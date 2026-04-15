# Case Study Template

Use this structure for every case study you write. Target length: 800-1,200 words. Longer is not better — a client reading between meetings needs to understand the value in 5 minutes.

---

## How to Use This Template

Each case study answers one question for a prospective client: *"Has this consultant solved a problem like mine before?"*

**Before writing**: Identify the single most important result of the engagement. Build everything toward that result. If you cannot name a specific result (not a vague benefit), the case study is not ready to be written yet.

**What to include vs redact**:

| Include | Redact |
|---------|--------|
| Industry and company size | Company name (unless you have written permission) |
| Specific technical problem | Internal project names or system names |
| Technologies used | Internal network details, IPs, hostnames |
| Quantified results | Specific vulnerability details that could harm the client |
| Your role and approach | Individual names, org chart details |
| Timeline | Contract value (unless the client approves) |

---

## Case Study Structure

---

### [CASE STUDY TITLE]

*Format: `[Industry] Company — [Problem Solved]`*
*Example: `Financial Services Firm — CyberArk PAM Implementation for 2,000 Privileged Accounts`*

---

#### Client Context

**Industry**: [e.g., Financial Services / Healthcare / Manufacturing]
**Company size**: [e.g., 2,000 employees, global operations]
**Environment**: [e.g., Hybrid AD, 3 data centers, AWS, regulated by PCI-DSS]

Write 2-3 sentences describing the client context without identifying them. Focus on what made their situation common enough that other prospects will recognize themselves in it.

*Example: "A mid-size financial services firm with 2,000 employees and operations in four countries needed to meet PCI-DSS requirements for privileged account management. They had no existing PAM solution — administrators shared a single domain admin account stored in a spreadsheet."*

---

#### The Problem

What was broken, missing, or at risk before the engagement? Be specific. Vague problems produce vague impressions.

**Good**: "Service accounts used weak, static passwords that had not rotated in 3 years. One account had been flagged in a recent pen test as Kerberoastable — an attacker could crack the password offline in under an hour."

**Weak**: "The client had poor password management practices that created security risks."

Include:
- The technical problem
- The business or compliance driver (why it mattered *now*)
- Any prior attempts to solve it that failed or stalled

---

#### What I Did

Describe your approach in enough technical detail that another professional recognizes the skill involved, but do not write a lab guide. The audience is a CISO or security architect, not a junior engineer.

Structure as phases if the work had multiple stages:

**Phase 1 — Assessment** (e.g., 1 week):
- What you found, how you found it
- Tools or methodology used

**Phase 2 — Design** (e.g., 1 week):
- Key architectural decisions and why
- Trade-offs you evaluated

**Phase 3 — Implementation** (e.g., 3 weeks):
- What you built and configured
- Specific integrations or challenges

**Phase 4 — Handover** (e.g., 1 week):
- Documentation delivered
- Knowledge transfer approach
- Hypercare period

---

#### The Result

This is the most important section. Quantify wherever possible. If you cannot quantify, qualify precisely.

| Metric | Before | After |
|--------|--------|-------|
| Privileged accounts vaulted | 0 | [number] |
| Password rotation | Manual / never | Automated every 30 days |
| Time to provision access | [X days] | [Y hours] |
| Audit findings on privileged access | [N open] | [0 / reduced by %] |
| [Other relevant metric] | | |

Write 2-3 sentences interpreting the results: *"The client passed their PCI-DSS audit three months after go-live with zero findings on privileged access management — the first clean audit in that area in four years."*

---

#### Technologies Used

- [e.g., CyberArk Vault 13.0, CPM, PVWA, PSM]
- [e.g., Windows Server 2022 AD]
- [e.g., FortiAuthenticator RADIUS MFA]
- [e.g., CyberArk Conjur OSS on Kubernetes]

---

#### What Made This Engagement Different

One paragraph on the specific challenge or decision that required expertise beyond a standard installation. This is where you demonstrate depth. Examples:

- "The client's legacy application used a service account that could not rotate passwords due to a hard-coded connection string — we designed a CPM custom platform plugin that rotated the password and automatically updated the application's configuration file via a post-change script."
- "We discovered during the internal pentest that a Kerberoastable service account had direct read access to the PAM vault admin safe — an attack path that would have allowed an attacker to dump all managed credentials. We redesigned the safe ACL hierarchy before the PAM rollout completed."

---

#### Applicability to Your Engagement

End with one sentence explicitly connecting this case study to the type of client you want to attract.

*"If your organization is facing an upcoming PCI-DSS or SOC 2 audit with open findings on privileged access, this engagement is directly applicable."*

---

## How to Use Case Studies in Sales Conversations

**In a discovery call**: After hearing the client describe their problem, say: *"That's very similar to an engagement I did recently for a [industry] company — they had [similar problem]. What I did was [2 sentences]. The result was [quantified outcome]. Would it be helpful if I sent you that case study after this call?"*

**In a proposal**: Include the most relevant case study in the "About You" section (1 paragraph summary + offer to share the full version).

**On LinkedIn**: Publish a condensed version (400-600 words) as an article. Use the structure: problem → approach → result. Never include client details without permission.

**On GitHub**: A sanitized version with all client details removed is a legitimate portfolio piece. Rename companies to "Client A" or "[Industry] Company."

---

## Case Study 0: Your Wallix Deployment (Write This First)

You already have a case study. The Wallix PAM + FortiAuthenticator MFA deployment for a multinational company is a real, complete, enterprise-scale engagement. You did not need to simulate this in a lab — you built it.

Write Case Study 0 before Month 13 using the template above, based on your actual Wallix project (January–November 2026). Sanitize the client name and any identifying details. This becomes your most powerful sales asset immediately — no other candidate building a PAM consulting practice from scratch has a production multinational enterprise deployment they can reference.

**Positioning for Case Study 0**: The framing should be: *"Before specializing in CyberArk, I served as lead architect and implementer for an enterprise PAM deployment using a different vendor. Here is what I learned about what makes PAM succeed at scale — independent of the product."* This positions multi-vendor expertise as a feature, not a gap.

---

**Last Updated**: 2026-04-15
**Version**: 1.0
