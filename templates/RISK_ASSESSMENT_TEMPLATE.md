# Risk Assessment Template

> Comprehensive risk assessment framework for PAM/Conjur implementation projects

---

## Document Control

| Version | Date | Author | Reviewer | Status |
|---------|------|--------|----------|--------|
| 1.0 | YYYY-MM-DD | [Name] | [Name] | Draft |

---

## 1. Executive Summary

### 1.1 Project Information
| Field | Value |
|-------|-------|
| Project Name | [Name] |
| Project Manager | [Name] |
| Risk Assessment Date | [Date] |
| Assessment Period | [Start Date] to [End Date] |
| Next Review Date | [Date] |

### 1.2 Risk Summary Dashboard
| Risk Level | Count | Trend |
|------------|-------|-------|
| Critical (Red) | [X] | [Up/Down/Stable] |
| High (Orange) | [X] | [Up/Down/Stable] |
| Medium (Yellow) | [X] | [Up/Down/Stable] |
| Low (Green) | [X] | [Up/Down/Stable] |
| **Total Active Risks** | **[X]** | |

### 1.3 Top 5 Risks
| Rank | Risk ID | Description | Score | Owner |
|------|---------|-------------|-------|-------|
| 1 | R-XXX | [Description] | [X] | [Name] |
| 2 | R-XXX | [Description] | [X] | [Name] |
| 3 | R-XXX | [Description] | [X] | [Name] |
| 4 | R-XXX | [Description] | [X] | [Name] |
| 5 | R-XXX | [Description] | [X] | [Name] |

---

## 2. Risk Assessment Methodology

### 2.1 Risk Scoring Matrix
```
                          IMPACT
                 Low(1)  Medium(2)  High(3)  Critical(4)
              ┌────────┬─────────┬────────┬───────────┐
    Critical  │   4    │    8    │   12   │    16     │
      (4)     │  Low   │  Medium │  High  │  Critical │
              ├────────┼─────────┼────────┼───────────┤
L     High    │   3    │    6    │    9   │    12     │
I     (3)     │  Low   │  Medium │  High  │   High    │
K             ├────────┼─────────┼────────┼───────────┤
E    Medium   │   2    │    4    │    6   │    8      │
L     (2)     │  Low   │   Low   │ Medium │  Medium   │
I             ├────────┼─────────┼────────┼───────────┤
H     Low     │   1    │    2    │    3   │    4      │
O     (1)     │  Low   │   Low   │  Low   │   Low     │
O             └────────┴─────────┴────────┴───────────┘
D
```

### 2.2 Likelihood Definitions
| Level | Score | Description | Probability |
|-------|-------|-------------|-------------|
| Critical | 4 | Almost certain to occur | > 80% |
| High | 3 | Likely to occur | 50-80% |
| Medium | 2 | Possible to occur | 20-50% |
| Low | 1 | Unlikely to occur | < 20% |

### 2.3 Impact Definitions
| Level | Score | Schedule | Budget | Scope | Security |
|-------|-------|----------|--------|-------|----------|
| Critical | 4 | > 4 weeks delay | > 25% overrun | Critical features missing | Data breach |
| High | 3 | 2-4 weeks delay | 15-25% overrun | Major features impacted | Vulnerability |
| Medium | 2 | 1-2 weeks delay | 5-15% overrun | Minor features impacted | Compliance gap |
| Low | 1 | < 1 week delay | < 5% overrun | Minimal impact | Minor finding |

### 2.4 Risk Response Strategies
| Strategy | Definition | When to Use |
|----------|------------|-------------|
| **Avoid** | Eliminate the risk source | High impact, can be avoided |
| **Mitigate** | Reduce likelihood or impact | Common approach for most risks |
| **Transfer** | Shift to third party | Insurance, contracts, outsourcing |
| **Accept** | Acknowledge and monitor | Low risks, cost of mitigation > benefit |
| **Escalate** | Push to higher authority | Outside project control |

---

## 3. Risk Categories

### 3.1 Technical Risks
| ID | Risk | Likelihood | Impact | Score | Status |
|----|------|------------|--------|-------|--------|
| T-001 | Integration with legacy systems fails | | | | |
| T-002 | Performance does not meet requirements | | | | |
| T-003 | Security vulnerabilities discovered | | | | |
| T-004 | Data migration issues | | | | |
| T-005 | HA/DR configuration problems | | | | |
| T-006 | Network connectivity issues | | | | |
| T-007 | Certificate/encryption problems | | | | |
| T-008 | Database scalability issues | | | | |

### 3.2 Project Management Risks
| ID | Risk | Likelihood | Impact | Score | Status |
|----|------|------------|--------|-------|--------|
| P-001 | Scope creep | | | | |
| P-002 | Resource availability | | | | |
| P-003 | Schedule slippage | | | | |
| P-004 | Budget overrun | | | | |
| P-005 | Key personnel departure | | | | |
| P-006 | Vendor dependency | | | | |
| P-007 | Requirements volatility | | | | |
| P-008 | Communication breakdown | | | | |

### 3.3 Organizational Risks
| ID | Risk | Likelihood | Impact | Score | Status |
|----|------|------------|--------|-------|--------|
| O-001 | User resistance to change | | | | |
| O-002 | Insufficient executive support | | | | |
| O-003 | Competing priorities | | | | |
| O-004 | Organizational restructuring | | | | |
| O-005 | Training inadequacy | | | | |
| O-006 | Process adoption failure | | | | |

### 3.4 External Risks
| ID | Risk | Likelihood | Impact | Score | Status |
|----|------|------------|--------|-------|--------|
| E-001 | Regulatory changes | | | | |
| E-002 | Vendor product changes | | | | |
| E-003 | Third-party integration changes | | | | |
| E-004 | Security threat landscape changes | | | | |
| E-005 | Economic conditions | | | | |

---

## 4. Detailed Risk Register

### 4.1 Risk Register Entry Template

---

#### Risk ID: R-XXX
**Risk Title:** [Brief descriptive title]

**Category:** [ ] Technical [ ] Project [ ] Organizational [ ] External

**Description:**
[Detailed description of the risk, its causes, and potential consequences]

**Risk Assessment:**
| Factor | Rating | Justification |
|--------|--------|---------------|
| Likelihood | [1-4] | [Explanation] |
| Impact | [1-4] | [Explanation] |
| **Risk Score** | **[1-16]** | **[Level]** |

**Affected Areas:**
- [ ] Schedule
- [ ] Budget
- [ ] Scope
- [ ] Quality
- [ ] Security

**Early Warning Indicators:**
- [Indicator 1]
- [Indicator 2]

**Response Strategy:** [ ] Avoid [ ] Mitigate [ ] Transfer [ ] Accept

**Mitigation Actions:**
| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| [Action 1] | [Name] | [Date] | [Status] |
| [Action 2] | [Name] | [Date] | [Status] |

**Contingency Plan:**
[What will be done if the risk materializes]

**Risk Owner:** [Name]
**Status:** [ ] Open [ ] In Mitigation [ ] Closed [ ] Occurred

---

### 4.2 Sample Risk Entries

#### Risk ID: R-001
**Risk Title:** Integration Failure with Active Directory

**Category:** [X] Technical

**Description:**
The PAM solution may fail to integrate properly with the organization's Active Directory infrastructure due to complex nested group structures, schema limitations, or network connectivity issues between domains.

**Risk Assessment:**
| Factor | Rating | Justification |
|--------|--------|---------------|
| Likelihood | 3 | Complex multi-forest AD environment |
| Impact | 4 | Would block user authentication and provisioning |
| **Risk Score** | **12** | **High** |

**Early Warning Indicators:**
- Failed AD connectivity tests during environment setup
- Slow user synchronization times
- LDAP query timeouts

**Response Strategy:** [X] Mitigate

**Mitigation Actions:**
| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Conduct AD assessment | AD Admin | Week 1 | Complete |
| Document all trust relationships | AD Admin | Week 2 | In Progress |
| Create test integration environment | Engineer | Week 3 | Planned |
| Develop fallback authentication | Architect | Week 4 | Planned |

**Contingency Plan:**
Implement local CyberArk authentication as backup while AD issues are resolved.

**Risk Owner:** [Technical Lead]
**Status:** [X] Open

---

#### Risk ID: R-002
**Risk Title:** Insufficient Resources for Training

**Category:** [X] Organizational

**Description:**
Team members may not have adequate time allocated for training due to ongoing operational responsibilities, leading to poor adoption and increased support burden post-implementation.

**Risk Assessment:**
| Factor | Rating | Justification |
|--------|--------|---------------|
| Likelihood | 3 | Historical pattern of training deprioritization |
| Impact | 3 | Would impact adoption and increase support costs |
| **Risk Score** | **9** | **High** |

**Response Strategy:** [X] Mitigate

**Mitigation Actions:**
| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Secure training time commitment | PM | Week 1 | Complete |
| Schedule training during low-demand periods | PM | Week 2 | In Progress |
| Develop self-paced modules | Training | Week 4 | Planned |
| Implement training completion tracking | PM | Week 4 | Planned |

**Contingency Plan:**
Extend hypercare period and provide additional 1:1 coaching sessions.

**Risk Owner:** [Project Manager]
**Status:** [X] In Mitigation

---

## 5. Risk Monitoring

### 5.1 Risk Review Schedule
| Activity | Frequency | Participants | Deliverable |
|----------|-----------|--------------|-------------|
| Risk identification | Ongoing | All team | New risks logged |
| Risk assessment | Weekly | PM, Tech Lead | Updated scores |
| Risk review meeting | Bi-weekly | Core team | Status update |
| Risk report | Monthly | PM | Risk report |
| Full risk reassessment | Quarterly | All stakeholders | Updated register |

### 5.2 Risk Metrics
| Metric | Current | Previous | Trend |
|--------|---------|----------|-------|
| Total open risks | [X] | [X] | |
| High/Critical risks | [X] | [X] | |
| Risks closed this period | [X] | [X] | |
| Risks materialized | [X] | [X] | |
| Average risk score | [X.X] | [X.X] | |

### 5.3 Risk Burn-Down Chart
```
Risks
  │
16┤ ████
  │ ████ ████
12┤ ████ ████ ████
  │ ████ ████ ████ ████
 8┤ ████ ████ ████ ████ ████
  │ ████ ████ ████ ████ ████ ████
 4┤ ████ ████ ████ ████ ████ ████ ████
  │ ████ ████ ████ ████ ████ ████ ████ ████
 0┼──────────────────────────────────────────
    Wk1  Wk2  Wk3  Wk4  Wk5  Wk6  Wk7  Wk8
```

---

## 6. Risk Response Actions

### 6.1 Active Mitigation Plans
| Risk ID | Action | Owner | Due | Status | Progress |
|---------|--------|-------|-----|--------|----------|
| R-001 | [Action] | [Name] | [Date] | [Status] | [%] |
| R-002 | [Action] | [Name] | [Date] | [Status] | [%] |

### 6.2 Contingency Budget
| Category | Allocated | Used | Remaining |
|----------|-----------|------|-----------|
| Technical contingency | $[X] | $[X] | $[X] |
| Schedule buffer | [X] days | [X] days | [X] days |
| Resource backup | [X] FTE | [X] FTE | [X] FTE |

### 6.3 Escalation Thresholds
| Trigger | Escalation Level | Notification |
|---------|------------------|--------------|
| Risk score > 12 | Project Sponsor | Within 24 hours |
| Multiple risks materialize | Steering Committee | Immediate |
| Contingency budget > 50% used | Project Sponsor | Within 48 hours |
| Critical path impacted | Steering Committee | Immediate |

---

## 7. Realized Risks (Issues)

### 7.1 Issue Log
| Issue ID | Original Risk | Date Occurred | Impact | Resolution |
|----------|---------------|---------------|--------|------------|
| I-001 | R-XXX | [Date] | [Description] | [Resolution] |

### 7.2 Lessons Learned
| Risk/Issue | What Happened | Lesson | Future Prevention |
|------------|---------------|--------|-------------------|
| [Risk] | [Description] | [Learning] | [Prevention] |

---

## 8. Appendices

### Appendix A: Risk Assessment Checklist
**Technical Risks:**
- [ ] Hardware compatibility verified
- [ ] Software dependencies documented
- [ ] Integration points identified
- [ ] Performance requirements defined
- [ ] Security requirements validated
- [ ] DR/HA requirements understood

**Project Risks:**
- [ ] Scope clearly defined
- [ ] Resources confirmed
- [ ] Schedule realistic
- [ ] Dependencies mapped
- [ ] Stakeholders identified
- [ ] Communication plan in place

**Organizational Risks:**
- [ ] Executive sponsorship confirmed
- [ ] Change readiness assessed
- [ ] Training plan developed
- [ ] Support model defined

### Appendix B: Risk Categories Reference
| Category | Subcategories |
|----------|---------------|
| Technical | Architecture, Integration, Performance, Security, Data |
| Project | Scope, Schedule, Budget, Resources, Quality |
| Organizational | People, Process, Culture, Change |
| External | Regulatory, Market, Vendor, Technology |

### Appendix C: Related Documents
- [PROJECT_CHARTER_TEMPLATE.md](PROJECT_CHARTER_TEMPLATE.md)
- [CHANGE_MANAGEMENT_TEMPLATE.md](CHANGE_MANAGEMENT_TEMPLATE.md)
- [TESTING_PLAN_TEMPLATE.md](TESTING_PLAN_TEMPLATE.md)

---

*Last Updated: 2025-12-04*
*Version: 1.0*
