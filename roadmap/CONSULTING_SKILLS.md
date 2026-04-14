# Consulting Skills Development: 18-Month Business Readiness Plan

**Objective**: Develop professional consulting skills to launch an independent PAM + Pentesting consulting practice

**Starting Point**: Technical expert (sysadmin) with no consulting experience
**Target State**: Consulting-ready professional able to win clients, deliver projects, and charge $175-350/hour
**Method**: Progressive skill development integrated with technical learning — presentations, templates, client simulation

---

## Overview

This plan runs **integrated** with your technical roadmap. You build business skills while building technical expertise, so you arrive at Month 18 with both the credentials and the professional materials needed to start consulting.

**Core principle**: Technical expertise alone does not guarantee consulting success. You also need to be able to run a discovery call, write a proposal, price a project, and deliver a finding that a CISO will act on.

---

## Three-Phase Progression

### Phase 1: Presentation Foundation (Months 1-6)

**Goal**: Develop confidence presenting technical topics to an audience

**Month 1-2 — Observation**:
- Watch professional security presentations (RSA Conference, KubeCon, OffSec Live)
- Study slide structure: problem → solution → evidence → recommendation
- Prepare first presentation (PAM Fundamentals); record yourself; watch it back

**Month 3 — First Delivery**:
- Deliver first presentation: PAM Fundamentals (30 min)
- Audience: colleague, family member, or solo recording — the point is to say it out loud
- Get feedback on clarity, not on content (content is secondary at this stage)

**Months 4-6 — Regular Practice**:
- Month 4: PAM Architecture (30 min)
- Month 5: Sentry certification study journey (30 min)
- Month 6: AD attack paths and what CyberArk blocks (30 min — first dual-track presentation)

**Skills developed**: public speaking basics, slide structure, technical explanations, handling nerves, Q&A

**Deliverables by Month 6**:
- [ ] 4 presentations delivered
- [ ] Comfortable presenting PAM topics without reading from slides

---

### Phase 2: Professional Materials (Months 7-12)

**Goal**: Create reusable consulting templates and build the portfolio

**Month 7 — Longer Formats**:
- Month 7 presentation: Guardian architecture (45 min — longer format, professional delivery)
- Practice handling hostile Q&A (prepare 3 hard questions; ask a colleague to use them)

**Months 8-9 — Proposal and RFP Templates**:
- Study 3-5 real RFP responses online (government procurement, enterprise security)
- Draft a PAM implementation proposal using the structure in the Client Interaction Framework below
- Create a reusable RFP response template covering: executive summary, technical approach, project plan, pricing, about you

**Months 10-11 — SOW Templates**:
- Study professional SOW examples; understand deliverables, milestones, and payment terms
- Create a reusable PAM SOW template (use [templates/SOW_TEMPLATE.md](../templates/SOW_TEMPLATE.md) as baseline)
- Create a reusable Pentest SOW template (use [templates/PENTEST_SOW_TEMPLATE.md](../templates/PENTEST_SOW_TEMPLATE.md))
- Define project phases: discovery → design → implementation → knowledge transfer → hypercare

**Months 7-12 — Portfolio Building**:
- Portfolio Project 1 (PAM Lab) should be fully documented by M4
- Portfolio Project 2 (Guardian Architecture) by M9
- Each project: README, architecture diagram, challenge/solution narrative, lessons learned

**Skills developed**: proposal writing, RFP responses, SOW creation, service definition, business writing

**Deliverables by Month 12**:
- [ ] Reusable RFP response template
- [ ] PAM SOW template (reusable)
- [ ] Pentest SOW template (reusable)
- [ ] Sample proposal (PAM implementation, fully drafted)
- [ ] Service offerings defined (at least PAM implementation + internal network pentest)
- [ ] Portfolio Projects 1 and 2 published with professional documentation
- [ ] 8 presentations delivered

---

### Phase 3: Case Studies, Client Simulation, and Launch (Months 13-18)

**Goal**: Build consulting narratives, practice client interactions, and launch

**Months 13-15 — Case Studies**:

- **Month 13 — Case Study 1**: PAM Lab Build + Conjur Docker integration
  - Problem: hardcoded credentials in CI/CD pipeline
  - Solution: Conjur secrets injection with policy-as-code
  - Result: zero hardcoded credentials, full audit trail

- **Month 14 — Case Study 2**: Conjur on Kubernetes (HA deployment + CI/CD)
  - Multi-tenant scenario, secrets rotation, developer workflow impact
  - Quantify: N credentials migrated, rotation time reduced from manual to automated

- **Month 15 — Case Study 3**: Multi-Cloud Secrets Architecture (AWS + Azure + Conjur)
  - Compliance scenario (SOC 2 / PCI-DSS)
  - Cross-cloud secret lifecycle management

- **Month 16 — Case Study 4**: Internal Pentest → PAM Remediation (the flagship dual-track case study)
  - Pentest finding: Kerberoastable service account with PVWA access → lateral movement to Vault
  - Remediation: PAM architectural changes that close the specific attack paths found
  - This is the unique consulting narrative no pure PAM firm or pure pentest firm can write

**Months 16-17 — Client Simulation**:
- Practice discovery calls with a language partner, colleague, or in front of a recording
- Run the full discovery call framework (below) with yourself as both client and consultant
- Prepare a 5-minute capability pitch: who you are, what you do, what makes you different, one case study
- Draft and refine your 30-second elevator pitch

**Month 17-18 — Launch Preparation**:
- Define service packages (use the rate card below)
- Finalize all 4 case studies; polish all 6 portfolio projects on GitHub
- Finalize consulting narrative: your journey (sysadmin → dual-track consultant), your value proposition
- Announce practice on LinkedIn the week after OSCP result is confirmed

**Skills developed**: case study writing, business storytelling, value proposition, client discovery, service packaging, pricing, go-to-market

**Deliverables by Month 18**:
- [ ] 4 case studies written and published
- [ ] All 6 portfolio projects on GitHub with professional documentation
- [ ] Discovery call framework practiced (10+ dry runs)
- [ ] 5-minute capability pitch ready
- [ ] Service packages and rate card finalized
- [ ] Consulting narrative defined
- [ ] 16 presentations delivered
- [ ] **Consulting practice launched**

---

## Monthly Presentation Schedule

Presentations are the most direct route to developing client communication skills. Start Month 3, deliver one per month.

| Month | Topic | Duration | Audience |
|:-----:|-------|:--------:|---------|
| M3 | PAM Fundamentals | 30 min | Self / recording |
| M4 | PAM Architecture | 30 min | Self / colleague |
| M5 | Sentry Certification Journey | 30 min | Colleague |
| M6 | AD Attack Paths → CyberArk Controls | 30 min | Colleague |
| M7 | Guardian Architecture | 45 min | Colleague |
| M8 | Conjur Docker Overview | 45 min | Colleague |
| M9 | BloodHound Attack Paths: What I Found | 45 min | Colleague |
| M10 | Conjur + Kubernetes Integration | 45 min | Colleague |
| M11 | eJPT Preparation Lessons Learned | 45 min | Colleague / LinkedIn |
| M12 | Phase 1-2 Retrospective | 45 min | BSides or online |
| M13 | Conjur in CI/CD Pipelines | 45 min | LinkedIn / community |
| M14 | Cloud Pentesting with CloudGoat | 45 min | Colleague |
| M15 | Multi-Cloud Secrets Architecture | 45 min | CyberArk Commons |
| M16 | DevSecOps Security Audit Methodology | 45 min | Colleague |
| M17 | OSCP Preparation: What Worked | 45 min | BSides or online |
| M18 | **Consulting Launch Presentation** | 60 min | Network / LinkedIn Live |

**Total**: 16 presentations across 18 months

Month 12 and M17 are ideal BSides talk candidates — a retrospective with real lab data and OSCP lessons are topics the community actively wants to hear.

---

## Consulting Materials Checklist

### Templates (Completed by Month 12)
- [ ] RFP Response Template (PAM implementation)
- [ ] PAM SOW Template — see [templates/SOW_TEMPLATE.md](../templates/SOW_TEMPLATE.md)
- [ ] Pentest SOW Template — see [templates/PENTEST_SOW_TEMPLATE.md](../templates/PENTEST_SOW_TEMPLATE.md)
- [ ] Client Needs Assessment Template
- [ ] Project Proposal Template

### Case Studies (Completed by Month 16)
- [ ] Case Study 1: PAM Lab + Conjur Docker Integration
- [ ] Case Study 2: Conjur on Kubernetes (HA + CI/CD)
- [ ] Case Study 3: Multi-Cloud Secrets Architecture
- [ ] Case Study 4: Internal Pentest → PAM Remediation (flagship)

### Service Offerings (Defined by Month 17)
- [ ] PAM Assessment Service
- [ ] PAM Implementation Service
- [ ] Conjur / Secrets Management Implementation
- [ ] Internal Network Penetration Test
- [ ] Active Directory Security Assessment
- [ ] PAM + Pentest Combined Assessment (flagship premium offering)

### Portfolio (Complete by Month 18)
- [ ] 6 portfolio projects published on GitHub
- [ ] Each project: README, architecture diagram, challenge/solution narrative
- [ ] Enterprise Capstone (Project 6): PAM + Conjur + Pentest combined — the anchor piece

### Professional Presence (Complete by Month 18)
- [ ] LinkedIn profile optimized (see [NETWORKING_STRATEGY.md](../docs/NETWORKING_STRATEGY.md))
- [ ] 6+ technical articles published (M11-M18)
- [ ] CyberArk Defender, Sentry, Guardian, eJPT, OSCP all displayed
- [ ] HackTheBox public profile linked (Pro Hacker or above)
- [ ] Professional photo

### Launch Materials (Month 18)
- [ ] Rate card finalized
- [ ] Service packages documented
- [ ] 4 case studies ready to share
- [ ] Elevator pitch (30 seconds)
- [ ] Capability pitch (5 minutes)
- [ ] Discovery call framework practiced
- [ ] **Open for business**

---

## Client Interaction Framework

### Discovery Call Structure (30-45 Minutes)

**Introduction (5 min)**:
- Your background in one sentence: "I'm a sysadmin turned PAM specialist and pentester — I implement CyberArk and can also assess the attack surface that makes PAM necessary."
- Your certifications (Guardian, eJPT, OSCP)
- One relevant case study in two sentences

**Client Needs Assessment (15-20 min)**:
- Current privileged access situation: "How are admin credentials managed today?"
- Pain points: "What compliance requirement is driving this conversation?"
- Environment: "Are you on-prem, cloud, or hybrid? Active Directory?"
- Timeline and urgency: "Is there a specific audit or incident driving the timeline?"
- Budget signal: "Have you budgeted for this project or is this exploratory?"

**Solution Discussion (10-15 min)**:
- High-level approach based on what you just heard
- One case study that closely matches their situation
- Realistic outcome and timeline estimate
- Ballpark investment range (do not dodge this — ranges are fine)

**Next Steps (5 min)**:
- Commit to a proposal delivery date (3-5 business days is professional)
- Agree on what information they will send you (org chart, environment diagram, compliance framework)

### Proposal Structure

**1. Executive Summary** (1 page):
- One paragraph on their situation as you understood it
- One paragraph on the proposed solution
- One sentence on expected business value
- Investment summary (number only, detail in section 4)

**2. Technical Approach** (2-3 pages):
- Current state assessment (what you found or were told)
- Proposed architecture (diagrams preferred over text)
- Implementation phases with durations
- Technology stack and versions

**3. Project Plan** (1-2 pages):
- Week-by-week timeline
- Milestones and exit criteria per phase
- What you need from the client and when
- Assumptions and out-of-scope items

**4. Investment** (1 page):
- Fixed-fee pricing preferred (clients trust it more than T&M for defined scope)
- Payment terms: 33% on contract signing, 33% at midpoint milestone, 34% on final delivery
- Pentest engagements: 25% deposit before testing begins
- Travel at cost, pre-approved

**5. About You** (1 page):
- Certifications listed
- Relevant portfolio project or case study (one paragraph)
- One or two testimonials if available

---

## Rate Card

Rates below reflect the 18-month dual-track positioning. Start at the lower end of each range and increase after 3-5 successful engagements.

### Hourly Rates (Remote)

| Service Line | Entry Rate | Established Rate |
|---|---|---|
| Penetration Testing | $175/hr | $225/hr |
| PAM Implementation | $200/hr | $275/hr |
| PAM + Pentest Combined | $250/hr | $350/hr |
| On-site premium | +25% | +25% |

### Fixed-Fee Project Ranges

| Service | Typical Range | Duration |
|---|---|---|
| PAM Assessment | $11,000 – $27,500 | 2-4 weeks |
| PAM Implementation | $55,000 – $110,000 | 8-16 weeks |
| Conjur Implementation | $27,500 – $82,000 | 4-10 weeks |
| Internal Network Pentest | $12,000 – $25,000 | 5-10 days |
| AD Security Assessment | $8,000 – $14,000 | 5-7 days |
| Web App Pentest | $10,000 – $22,000 | 5-10 days |
| PAM + Pentest Combined | $22,000 – $48,000 | 3-4 weeks |

### Pricing Tips

- **Start with fixed-fee wherever possible** — clients prefer predictable spend and it rewards your efficiency
- **Never anchor on hourly rate in a sales call** — lead with project outcomes and fixed-fee ranges
- **Increase rates after Year 1** by 15-20%; demand in the PAM niche supports this
- **The PAM + Pentest combined offering** is where the premium is — no pure PAM firm can offer it, no pure pentest firm can offer the remediation side

---

## Target Client Profile

**Industries with highest PAM + pentest demand**:
- Financial services (PCI-DSS, SOX — strong regulatory driver)
- Healthcare (HIPAA — privileged access to EHR systems)
- Critical infrastructure (NERC CIP, operational technology PAM)
- Mid-market technology companies (fast cloud growth, secrets sprawl)

**Size and structure**:
- 500-10,000 employees
- Has Active Directory (essentially universal in these industries)
- Has or is considering CyberArk (or competitive PAM product)

**Buying signals**:
- Recent audit finding on privileged access
- Recent breach or near-miss involving privileged credentials
- Compliance deadline (SOC 2 Type II, PCI-DSS assessment)
- DevOps team scaling rapidly and creating secrets sprawl

**Decision makers**:
- CISO or VP of Security (economic buyer)
- Security Architect or Director (technical buyer / champion)
- Compliance Officer (urgency driver in regulated industries)

---

## Outreach and Client Acquisition

The full networking and pipeline strategy — month-by-month from M1 through M18 — is in [docs/NETWORKING_STRATEGY.md](../docs/NETWORKING_STRATEGY.md).

The short version: first clients almost always come from former employers and warm introductions. Cold outreach and content marketing (LinkedIn articles, CyberArk Commons) take 6-12 months to produce results, which is why both start in Month 1 of this roadmap, not Month 18.

For the M8 employment fork decision (working at a CyberArk partner vs. continuing as sole proprietor), see [FAQ.md](../FAQ.md) under Career & Consulting.

---

## Related Documents

- [OVERVIEW.md](OVERVIEW.md) — 18-month program structure and Key Decision Points
- [PHASE1_MONTHS_1-6.md](PHASE1_MONTHS_1-6.md) — Phase 1 consulting activities
- [PHASE2_MONTHS_7-12.md](PHASE2_MONTHS_7-12.md) — Phase 2 consulting development
- [PHASE3_MONTHS_13-18.md](PHASE3_MONTHS_13-18.md) — Phase 3 launch preparation
- [ENGLISH_LEARNING.md](ENGLISH_LEARNING.md) — English fluency plan
- [docs/NETWORKING_STRATEGY.md](../docs/NETWORKING_STRATEGY.md) — Client pipeline strategy
- [templates/SOW_TEMPLATE.md](../templates/SOW_TEMPLATE.md) — PAM SOW template
- [templates/PENTEST_SOW_TEMPLATE.md](../templates/PENTEST_SOW_TEMPLATE.md) — Pentest SOW template
- [templates/RFP_RESPONSE_TEMPLATE.md](../templates/RFP_RESPONSE_TEMPLATE.md) — RFP template
- [docs/CONSULTING_LAUNCH_CHECKLIST.md](../docs/CONSULTING_LAUNCH_CHECKLIST.md) — Launch checklist

---

**Last Updated**: 2026-04-14
**Version**: 2.0
