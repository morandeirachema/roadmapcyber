# Statement of Work (SOW) Template

Template for creating detailed Statements of Work for PAM/Conjur consulting engagements.

---

## STATEMENT OF WORK

**Project**: [Project Name - e.g., "Enterprise PAM Implementation"]

**Effective Date**: [Start Date]

**Between**:
- **Client**: [Client Company Name], [Address]
- **Consultant**: [Your Name/Company], [Address]

---

## 1. Project Overview

### 1.1 Background
[Brief description of client's current state and why this project is needed]

### 1.2 Objectives
The objectives of this engagement are to:
1. [Objective 1 - e.g., Deploy CyberArk PAM solution for privileged access management]
2. [Objective 2 - e.g., Achieve HIPAA compliance for healthcare data access controls]
3. [Objective 3 - e.g., Train internal team on PAM administration]

### 1.3 Scope Summary
This SOW covers the design, implementation, and deployment of [brief scope description].

---

## 2. Scope of Work

### 2.1 In-Scope Activities

**Phase 1: Discovery & Design** (Weeks 1-[X])
- Conduct requirements gathering workshops ([X] sessions)
- Document current state architecture
- Design target state PAM architecture
- Identify integration points
- Create Technical Design Document (TDD)
- Risk assessment and mitigation planning

**Phase 2: Lab Environment & Proof of Concept** (Weeks [X]-[X])
- Build lab environment
- Deploy POC with [X] test accounts
- Validate workflows and integrations
- Test compliance controls
- Demonstrate to stakeholders
- Document POC findings and recommendations

**Phase 3: Production Implementation** (Weeks [X]-[X])
- Deploy production infrastructure
  - Password Vault (HA configuration)
  - Central Policy Manager (CPM)
  - Privileged Session Manager (PSM)
  - PVWA web interface
- Configure integrations:
  - Active Directory/LDAP
  - [Cloud provider: AWS/Azure]
  - [SIEM: Splunk/ELK/etc.]
  - [Ticketing: ServiceNow/Jira]
- Onboard privileged accounts:
  - [X] Windows accounts
  - [X] Linux accounts
  - [X] Database accounts
  - [X] Cloud service accounts
- Implement compliance controls
- Configure monitoring and alerting
- Conduct security validation

**Phase 4: Documentation & Training** (Weeks [X]-[X])
- Create comprehensive documentation:
  - Administrator runbooks
  - User guides
  - Troubleshooting procedures
  - Disaster recovery procedures
  - Compliance documentation
- Deliver training:
  - Administrator training ([X] hours, [X] attendees)
  - End-user training materials
  - Train-the-trainer session
  - Recorded video tutorials
- Knowledge transfer sessions

**Phase 5: Hypercare Support** (Weeks [X]-[X])
- [X] weeks of post-launch support
- Issue resolution and troubleshooting
- Performance optimization
- Process refinement
- Final documentation updates
- Project closeout report

### 2.2 Out-of-Scope Activities

The following are explicitly out of scope for this SOW:
- [ ] CyberArk software licensing costs (client responsibility)
- [ ] Cloud infrastructure costs (AWS/Azure - client responsibility)
- [ ] Hardware procurement
- [ ] Network infrastructure changes
- [ ] Integration with systems not listed in Section 2.1
- [ ] Post-hypercare ongoing support (available separately)
- [ ] Additional training beyond specified sessions
- [ ] [Other specific exclusions]

Any work beyond the defined scope will require a change order with separate pricing.

---

## 3. Deliverables

| Deliverable | Description | Due Date | Format |
|-------------|-------------|----------|--------|
| **Technical Design Document** | Complete architecture design, 30-50 pages | Week [X] | PDF + Visio/Draw.io |
| **POC Validation Report** | POC findings and recommendations, 10-15 pages | Week [X] | PDF |
| **Production Environment** | Fully configured PAM solution | Week [X] | Operational system |
| **Administrator Runbooks** | Step-by-step operational procedures, 40-60 pages | Week [X] | PDF + Word |
| **User Documentation** | End-user guides and quick reference, 15-20 pages | Week [X] | PDF |
| **Training Materials** | Slides, videos, hands-on exercises | Week [X] | PowerPoint + Video |
| **Compliance Documentation** | HIPAA/PCI-DSS/SOC2 control mappings, 20-30 pages | Week [X] | PDF + Excel |
| **Hypercare Report** | Post-launch performance and recommendations, 10-15 pages | Week [X] | PDF |

---

## 4. Timeline & Milestones

### 4.1 Project Schedule

| Phase | Start Date | End Date | Duration | Key Milestone |
|-------|-----------|----------|----------|---------------|
| Phase 1: Discovery | [Date] | [Date] | [X] weeks | TDD Approved |
| Phase 2: POC | [Date] | [Date] | [X] weeks | POC Validated |
| Phase 3: Production | [Date] | [Date] | [X] weeks | Go-Live |
| Phase 4: Documentation | [Date] | [Date] | [X] weeks | Training Complete |
| Phase 5: Hypercare | [Date] | [Date] | [X] weeks | Project Closed |
| **Total Duration** | [Start] | [End] | **[X] weeks** | |

### 4.2 Project Milestones

- **Kickoff Meeting**: Week 1, Day 1
- **TDD Review**: Week [X]
- **TDD Approval**: Week [X]
- **POC Demonstration**: Week [X]
- **POC Sign-off**: Week [X]
- **Production Go-Live**: Week [X]
- **Training Completion**: Week [X]
- **Project Closeout**: Week [X]

---

## 5. Roles & Responsibilities

### 5.1 Consultant Responsibilities
- Lead all phases of the project
- Provide expert guidance on PAM best practices
- Design and implement PAM solution
- Create all deliverables listed in Section 3
- Provide training to client team
- Document all configurations and procedures
- Deliver hypercare support

### 5.2 Client Responsibilities
- Provide timely access to systems and documentation
- Assign dedicated project sponsor and stakeholders
- Provide SMEs for requirements and integration discussions
- Provision necessary infrastructure (servers, network, cloud accounts)
- Procure CyberArk software licenses
- Attend scheduled meetings and training sessions
- Review and approve deliverables in timely manner
- Provide test accounts and validation support

### 5.3 Key Contacts

**Client Side**:
- Project Sponsor: [Name, Title, Email, Phone]
- Technical Lead: [Name, Title, Email, Phone]
- Security Lead: [Name, Title, Email, Phone]

**Consultant Side**:
- Lead Consultant: [Your Name, Email, Phone]

---

## 6. Assumptions & Dependencies

### 6.1 Assumptions
1. Client has existing Active Directory infrastructure
2. AWS/Azure cloud accounts are provisioned and accessible
3. Network connectivity between all systems is in place
4. Client will provide necessary system access within 1 business day of request
5. All required software licenses will be available by project start
6. Client stakeholders will be available for scheduled meetings
7. [Add project-specific assumptions]

### 6.2 Dependencies
1. CyberArk software licenses procured by client
2. Infrastructure (servers, VMs, cloud resources) provisioned
3. Network firewall rules configured for component communication
4. DNS entries created for PAM components
5. SSL certificates obtained for PVWA
6. Test accounts and credentials available for validation
7. [Add project-specific dependencies]

### 6.3 Risks & Mitigation
| Risk | Impact | Mitigation Strategy |
|------|--------|---------------------|
| License delays | Project delay | Client to procure licenses 2 weeks before project start |
| Integration complexity | Scope creep | Detailed discovery phase to identify all requirements |
| Resource availability | Timeline slip | Define backup SMEs, maintain communication |
| [Other risks] | [Impact] | [Mitigation] |

---

## 7. Fees & Payment Terms

### 7.1 Professional Services Fees

**Consulting Rate**: $[XXX]/hour

**Estimated Effort by Phase**:

| Phase | Estimated Hours | Rate | Total Cost |
|-------|----------------|------|------------|
| Phase 1: Discovery & Design | [XX] hrs | $[XXX]/hr | $[X,XXX] |
| Phase 2: Lab & POC | [XX] hrs | $[XXX]/hr | $[X,XXX] |
| Phase 3: Production | [XXX] hrs | $[XXX]/hr | $[XX,XXX] |
| Phase 4: Documentation & Training | [XX] hrs | $[XXX]/hr | $[X,XXX] |
| Phase 5: Hypercare | [XX] hrs | $[XXX]/hr | $[X,XXX] |
| **Total Professional Services** | **[XXX] hrs** | | **$[XX,XXX]** |

**Note**: This is a time & materials engagement. Actual hours may vary based on project complexity. Client will be notified if estimated hours are expected to exceed 10% variance.

### 7.2 Expenses
- Travel expenses (if on-site required): Actual costs, pre-approved
- Lodging and meals (if on-site required): Per company policy, pre-approved

### 7.3 Payment Schedule
- **Invoice 1 (25%)**: Upon contract execution - $[X,XXX]
- **Invoice 2 (25%)**: Upon Phase 2 completion (POC validated) - $[X,XXX]
- **Invoice 3 (25%)**: Upon Phase 3 completion (Go-Live) - $[X,XXX]
- **Invoice 4 (25%)**: Upon Phase 5 completion (Project closeout) - $[X,XXX]

**Payment Terms**: Net 30 days from invoice date

### 7.4 Change Management
- Changes to scope will be documented via Change Request process
- Change Requests will include impact analysis (cost, schedule, resources)
- Changes require written approval from both parties before proceeding
- Change Request template provided in Appendix

---

## 8. Acceptance Criteria

### 8.1 Phase Acceptance
Each phase will be considered complete upon:
1. All deliverables for the phase submitted
2. Client review completed (within 5 business days)
3. Any issues or deficiencies resolved
4. Formal acceptance signed by client project sponsor

### 8.2 Project Acceptance
The project will be considered complete upon:
- All phases completed and accepted
- All deliverables submitted and approved
- Training completed
- Hypercare period concluded
- Final project closeout report accepted
- Formal project sign-off by client

---

## 9. Terms & Conditions

### 9.1 Term & Termination
- This SOW is effective from [Start Date] and continues until project completion
- Either party may terminate with 30 days written notice
- Upon termination, client will pay for all services rendered to date
- All deliverables completed to date will be provided to client

### 9.2 Confidentiality
- Both parties agree to maintain confidentiality of all proprietary information
- Consultant will not disclose client information to third parties
- Confidentiality obligations survive termination of this SOW

### 9.3 Intellectual Property
- Client retains ownership of all configurations, documentation, and custom work products
- Consultant retains ownership of methodologies, templates, and reusable tools
- No proprietary client information will be used in public materials without permission

### 9.4 Warranty
- Consultant warrants all work will be performed in professional manner
- Issues related to implementation will be resolved at no additional cost during hypercare
- Post-hypercare support available at standard consulting rates

### 9.5 Limitation of Liability
- Consultant liability limited to fees paid under this SOW
- Consultant not liable for indirect, consequential, or incidental damages
- Client responsible for backup and disaster recovery of production systems

---

## 10. Signatures

By signing below, both parties agree to the terms and conditions outlined in this Statement of Work.

**CLIENT**:

Signature: ___________________________

Print Name: ___________________________

Title: ___________________________

Date: ___________________________


**CONSULTANT**:

Signature: ___________________________

Print Name: ___________________________

Title: ___________________________

Date: ___________________________

---

## Appendix A: Change Request Template

**Change Request #**: [CR-XXX]

**Requested By**: [Name, Date]

**Description of Change**: [Detailed description]

**Justification**: [Why is this change needed?]

**Impact Analysis**:
- **Schedule Impact**: [Additional weeks/days]
- **Cost Impact**: [Additional hours × rate = $X,XXX]
- **Resource Impact**: [Additional resources needed]
- **Risk Impact**: [Any new risks introduced]

**Approval**:
- Client Approval: ___________________ Date: _________
- Consultant Approval: ___________________ Date: _________

---

## Appendix B: Weekly Status Report Template

**Project**: [Project Name]
**Week Ending**: [Date]
**Prepared By**: [Consultant Name]

**Accomplishments This Week**:
- [Task 1 completed]
- [Task 2 completed]

**Planned for Next Week**:
- [Task 1]
- [Task 2]

**Issues & Risks**:
- [Issue/Risk 1 - Status: Open/Resolved]

**Decisions Needed**:
- [Decision point 1]

**Overall Status**: 🟢 Green / 🟡 Yellow / 🔴 Red

---

**Document Version**: 1.0
**Last Updated**: [Date]
