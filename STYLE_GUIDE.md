# Documentation Style Guide

Comprehensive formatting and terminology standards for the 27-Month Cybersecurity Roadmap. This guide ensures consistency, readability, and professionalism across all documentation.

**Target Audience**: Contributors, editors, and maintainers of roadmap documentation

**Grade**: A+ (Professional technical documentation standards)

---

## Table of Contents

1. [Quick Reference Card](#quick-reference-card)
2. [File Naming Conventions](#file-naming-conventions)
3. [Markdown Formatting](#markdown-formatting)
4. [Terminology Standards](#terminology-standards)
5. [Formatting Patterns](#formatting-patterns)
6. [Content Organization](#content-organization)
7. [Advanced Formatting](#advanced-formatting)
8. [Quality Checklist](#quality-checklist)
9. [Common Mistakes](#common-mistakes)
10. [Automation & Tools](#automation--tools)

---

## Quick Reference Card

### Most Common Patterns

```markdown
# Months
✅ Month 5, Month 12, Month 27 (in prose)
✅ M5, M8, M11 (in tables/charts)

# Phases
✅ Phase 1: PAM + Kubernetes Mastery (Months 1-11)
✅ PHASE 1: PAM + Kubernetes Mastery (Months 1-11) [headers only]

# Time
✅ 10-12 hours/week
✅ 8 hrs/week (recovery months)

# Certifications
✅ CyberArk Defender, CyberArk Sentry, CyberArk Guardian
✅ CKS (Certified Kubernetes Security Specialist)
✅ CCSP (Certified Cloud Security Professional)

# Technology
✅ CyberArk PAM, CyberArk Conjur, Kubernetes, K8s
✅ AWS, Azure, GCP

# Lists
✅ Use - (hyphen) for unordered
✅ Use 1. for ordered
✅ Use 2-space indentation for nesting

# Links
✅ [File Name](relative/path/to/file.md)
✅ [Descriptive Text](https://example.com)

# Emphasis
✅ **Bold** for important terms
✅ *Italic* for emphasis (sparingly)
✅ `Code` for technical terms, commands, files
```

### File Header Template

```markdown
# Document Title

Brief 1-2 sentence description of what this document contains.

---

## Section 1

Content...

---

**Last Updated**: YYYY-MM-DD
**Version**: X.X
```

---

## File Naming Conventions

### Top-Level Files (Root Directory)

**Format**: `CAPS_WITH_UNDERSCORES.md`

**Purpose**: Core navigation and reference documents

| ✅ Correct | ❌ Incorrect | Reason |
|-----------|-------------|--------|
| `README.md` | `readme.md` | Not capitalized |
| `GETTING_STARTED.md` | `getting-started.md` | Not caps, uses hyphens |
| `QUICKSTART.md` | `QuickStart.md` | CamelCase not allowed |
| `GLOSSARY.md` | `glossary.txt` | Wrong file extension |
| `FAQ.md` | `faq.md` | Not capitalized |
| `TROUBLESHOOTING.md` | `trouble_shooting.md` | Not caps |
| `BUDGET.md` | `budget-guide.md` | Not caps, uses hyphens |
| `STYLE_GUIDE.md` | `StyleGuide.md` | CamelCase not allowed |

### Subdirectory Files

**Format**: `CAPS_WITH_UNDERSCORES.md` (preferred for roadmap files)

**Subdirectory-Specific Patterns**:

| Directory | Format | Examples |
|-----------|--------|----------|
| `roadmap/` | CAPS_WITH_UNDERSCORES.md | `OVERVIEW.md`, `PHASE1_MONTHS_1-11.md` |
| `docs/` | CAPS_WITH_UNDERSCORES.md | `CYBERARK_CERTIFICATIONS.md`, `CKS_CERTIFICATION_GUIDE.md` |
| `templates/` | CAPS_WITH_UNDERSCORES.md | `RFP_RESPONSE_TEMPLATE.md`, `SOW_TEMPLATE.md` |
| `examples/` | CAPS_WITH_UNDERSCORES.md | `PORTFOLIO_PROJECT_EXAMPLE.md`, `CASE_STUDY_EXAMPLE.md` |

**Examples**:
```
✅ roadmap/OVERVIEW.md
✅ roadmap/MONTH_BY_MONTH_SCHEDULE.md
✅ roadmap/PHASE1_MONTHS_1-11.md
✅ roadmap/PHASE2_MONTHS_12-18.md
✅ roadmap/PHASE3_MONTHS_19-27.md
✅ docs/CYBERARK_CERTIFICATIONS.md
✅ docs/CKS_CERTIFICATION_GUIDE.md
✅ docs/CKS_CHEAT_SHEETS.md
✅ templates/RFP_RESPONSE_TEMPLATE.md
✅ examples/PORTFOLIO_PROJECT_EXAMPLE.md

❌ roadmap/phase1.md (not caps)
❌ docs/CyberArkCertifications.md (CamelCase)
❌ templates/rfp-template.md (not caps, hyphens)
```

### Data Files (CSV, JSON)

**Format**: `DESCRIPTIVE_NAME.csv` or `DESCRIPTIVE_NAME.json`

**Requirements**:
- Descriptive name that explains purpose
- All caps with underscores
- Includes timeframe or version if applicable

**Examples**:
```
✅ 27MONTH_PROGRESS_TRACKER.csv
✅ CERTIFICATION_SCHEDULE.csv
✅ BUDGET_BREAKDOWN.csv

❌ tracker.csv (too vague)
❌ data.csv (not descriptive)
❌ progress-tracker.csv (hyphens not allowed)
```

---

## Markdown Formatting

### Headers

**Use ATX-style headers** (`#` syntax, not underline style):

```markdown
✅ Correct:
# Level 1 Header
## Level 2 Header
### Level 3 Header
#### Level 4 Header

❌ Incorrect (underline style):
Level 1 Header
===============

Level 2 Header
---------------
```

**Header Capitalization**: Title Case for major headers

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `## Getting Started` | `## getting started` |
| `## Phase 1: PAM + Kubernetes Mastery` | `## phase 1: pam + kubernetes mastery` |
| `## Zero Trust Architecture` | `## zero trust architecture` |
| `## Budget Breakdown` | `## BUDGET BREAKDOWN` (all caps in content) |

**Header Hierarchy Rules**:
- Only ONE `#` (H1) per file (the title)
- Use `##` (H2) for main sections
- Use `###` (H3) for subsections
- Use `####` (H4) sparingly (only when deeply nested content)
- NEVER skip levels (`#` → `###` is wrong)

**No Emojis in Headers**:

```markdown
✅ Correct:
## Recovery Months
Content: Recovery months (🏖️ M12, M18, M27) provide rest time.

❌ Incorrect:
## 🏖️ Recovery Months
```

**Rationale**: Headers are used for navigation, table of contents generation, and accessibility. Emojis break these features.

### Lists

**Unordered Lists**: Always use `-` (hyphen), never `*` or `+`

```markdown
✅ Correct:
- Item 1
- Item 2
- Item 3
  - Nested item A
  - Nested item B

❌ Incorrect:
* Item 1
* Item 2

❌ Incorrect:
+ Item 1
+ Item 2
```

**Ordered Lists**: Use `1.` format

```markdown
✅ Correct (explicit numbering):
1. First step
2. Second step
3. Third step

✅ Also acceptable (auto-numbering):
1. First step
1. Second step
1. Third step
```

**Nested Lists**: Use 2-space indentation

```markdown
✅ Correct (2 spaces):
- Parent item
  - Child item level 1
    - Child item level 2
      - Child item level 3

❌ Incorrect (4 spaces):
- Parent item
    - Child item
```

**Complex List Example**:
```markdown
**Month 5 Activities**:
- Study:
  - CyberArk Defender materials (15 hours total)
  - Practice exam 1 (2 hours)
  - Practice exam 2 (2 hours)
- Labs:
  - CPM configuration (4 hours)
  - PSM deployment (4 hours)
  - PVWA customization (3 hours)
- Exam:
  - Schedule Defender exam
  - Take exam (Week 20)
```

### Checkboxes (Task Lists)

**Format**: `- [ ]` for incomplete, `- [x]` for complete

```markdown
✅ Correct:
- [ ] Incomplete task
- [x] Completed task
- [ ] Another incomplete task

❌ Incorrect:
[ ] Missing dash
-[ ] Missing space
- [] Missing space between brackets
```

**Visual Emphasis**: Use `✅` emoji for summaries ONLY, not task lists

```markdown
✅ Correct - Summary section:
**Success Metrics**:
✅ All 3 CyberArk certifications obtained
✅ K8s mastery achieved
✅ 7-8 portfolio projects published

❌ Incorrect - Task lists should use [x], not ✅:
✅ Complete CyberArk Defender
✅ Complete CyberArk Sentry
```

**Rationale**: GitHub renders `- [x]` as interactive checkboxes. Using `✅` breaks this functionality.

### Links

**Internal Links**: Always use relative paths

```markdown
✅ Correct:
[GETTING_STARTED.md](GETTING_STARTED.md)
[Phase 1 Details](roadmap/PHASE1_MONTHS_1-11.md)
[Back to Overview](../roadmap/OVERVIEW.md)
[CKS Guide](docs/CKS_CERTIFICATION_GUIDE.md)

❌ Incorrect (absolute path):
[GETTING_STARTED.md](/home/user/Cyber-Roadmap/GETTING_STARTED.md)
[GETTING_STARTED.md](file:///C:/Users/user/Cyber-Roadmap/GETTING_STARTED.md)

❌ Incorrect (missing .md extension):
[GETTING_STARTED](GETTING_STARTED)
[Phase 1](roadmap/PHASE1_MONTHS_1-11)
```

**External Links**: Always include protocol (https://)

```markdown
✅ Correct:
[CyberArk Documentation](https://docs.cyberark.com)
[Kubernetes Docs](https://kubernetes.io/docs)
[roadmap.sh](https://roadmap.sh/cyber-security)

❌ Incorrect (missing protocol):
[CyberArk Documentation](docs.cyberark.com)
[Kubernetes Docs](kubernetes.io/docs)
```

**Link Text**: Descriptive, never "click here" or "here"

```markdown
✅ Correct:
See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for solutions.
Review the [complete budget breakdown](BUDGET.md).
Check out the [CKS certification guide](docs/CKS_CERTIFICATION_GUIDE.md).

❌ Incorrect:
Click [here](TROUBLESHOOTING.md) for troubleshooting.
For more info, go [here](BUDGET.md).
[This link](docs/CKS_CERTIFICATION_GUIDE.md) has the CKS guide.
```

**Link Format in Lists**:

```markdown
✅ Correct:
**Quick Links**:
- [GETTING_STARTED.md](GETTING_STARTED.md) - Setup and onboarding
- [QUICKSTART.md](QUICKSTART.md) - Daily reference
- [FAQ.md](FAQ.md) - Common questions

❌ Incorrect:
**Quick Links**:
- GETTING_STARTED.md - Setup and onboarding
- [QUICKSTART.md](QUICKSTART.md)
- FAQ.md: [link](FAQ.md)
```

### Tables

**Always Include Header Row**:

```markdown
✅ Correct:
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data 1   | Data 2   | Data 3   |

❌ Incorrect (no header):
| Data 1   | Data 2   | Data 3   |
```

**Alignment**: Use colons for column alignment

```markdown
| Left Aligned | Center Aligned | Right Aligned |
|:-------------|:--------------:|--------------:|
| Content      | Content        | Content       |
| Left         | Center         | Right         |
```

**Keep Consistent Width** (for readability in source):

```markdown
✅ Correct (aligned columns):
| Month  | Focus                | Deliverable           |
|--------|----------------------|-----------------------|
| M1-2   | PAM basics           | Lab environment ready |
| M3-5   | Defender preparation | Defender cert ✅      |
| M6-8   | Sentry preparation   | Sentry cert ✅        |

❌ Acceptable but less readable in source:
| Month | Focus | Deliverable |
|---|---|---|
| M1-2 | PAM basics | Lab environment ready |
| M3-5 | Defender preparation | Defender cert ✅ |
```

**Complex Table Example**:

```markdown
| Certification | Month | Cost | Prerequisite | Difficulty |
|:--------------|:-----:|-----:|:-------------|:----------:|
| CyberArk Defender | M5 | $250-500 | None | ⭐⭐ |
| CyberArk Sentry | M8 | $250-500 | Defender | ⭐⭐⭐ |
| CKS | M9-10 | $395 | Valid CKA | ⭐⭐⭐⭐ |
| CyberArk Guardian | M11 | $250-500 | Sentry | ⭐⭐⭐⭐⭐ |
| CCSP | M27 | $599 | 5 years exp | ⭐⭐⭐⭐ |
```

### Code Blocks

**Inline Code**: Use single backticks for short code, commands, filenames

```markdown
✅ Correct:
Edit the `27MONTH_PROGRESS_TRACKER.csv` file.
Run the `kubectl get pods` command.
Configure `RBAC` policies in `auth-config.yaml`.
The `runAsNonRoot` security context is required.

❌ Incorrect (missing backticks):
Edit the 27MONTH_PROGRESS_TRACKER.csv file.
Run the kubectl get pods command.
```

**Code Blocks**: Use triple backticks with language identifier

````markdown
✅ Correct:
```bash
kubectl apply -f deployment.yaml
kubectl get pods -n production
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsNonRoot: true
```

```python
def check_credentials():
    return vault.get_secret("api_key")
```

❌ Incorrect (no language identifier):
```
kubectl apply -f deployment.yaml
```

❌ Incorrect (indentation instead of code block):
    kubectl apply -f deployment.yaml
````

**Supported Language Identifiers**:
- `bash` - Shell commands
- `yaml` - Kubernetes manifests, config files
- `json` - JSON data, API responses
- `python` - Python code
- `markdown` - Markdown examples
- `sql` - SQL queries
- `dockerfile` - Dockerfile content

---

## Terminology Standards

### Month References

**Standard Form in Prose**: `Month [number]`

```markdown
✅ Correct:
Month 1, Month 5, Month 12, Month 27
You'll complete Month 5 certification...
During Month 9, you'll prepare for CKS...

❌ Incorrect:
month 1, M. 1, month-1, Month-5
You'll complete M5 certification... (use "Month 5" in prose)
```

**Abbreviation in Tables/Charts**: `M[number]`

```markdown
✅ Correct in tables:
| M1 | M5 | M8 | M9-10 | M11 | M27 |

✅ Correct when space-constrained:
Recovery months: M12, M18, M27
Certifications: M5, M8, M9-10, M11, M27

❌ Incorrect in regular prose:
You'll complete M5 certification... (should be "Month 5")
```

**Month Ranges**:

```markdown
✅ Correct:
Months 1-11 (full range)
Month 9-10 (CKS preparation)
M9-10 (in tables)

❌ Incorrect:
Months 1 to 11
Month 9 through 10
M9 to M10
```

**Full Form with Weeks**: `Month [number] (Weeks X-Y)`

```markdown
✅ Correct:
Month 12 (Weeks 45-48) is a recovery month.
Month 5 (Weeks 17-20) includes Defender exam.
```

### Week References

**Standard Form**: `Week [number]` or `Weeks [range]`

```markdown
✅ Correct:
Week 1, Week 36, Week 108
Weeks 1-4, Weeks 33-40
During Week 40, you'll take the CKS exam.

❌ Incorrect:
week 1, W1, w/1
Weeks 1 to 4
```

### Phase References

**Standard Format in Content**: `Phase [number]` or `Phase [number]: [Name]`

```markdown
✅ Correct:
Phase 1
Phase 2: Conjur + DevSecOps
Phase 1 focuses on PAM mastery.

❌ Incorrect:
phase 1, PHASE ONE, Phase-1, Ph1
```

**Header Format**: `PHASE [NUMBER]: [Name] (Months X-Y)`

```markdown
✅ Correct:
# PHASE 1: PAM + Kubernetes Mastery (Months 1-11)
## PHASE 2: Conjur + DevSecOps (Months 12-18)
### PHASE 3: Cloud Security + CCSP (Months 19-27)

❌ Incorrect:
# Phase 1 - PAM + Kubernetes Mastery - Months 1-11
## Phase Two: Conjur + DevSecOps (M12-18)
```

### Certification Names

**First Mention**: Full official name

**Subsequent Mentions**: Abbreviation or short form acceptable

| Certification | First Mention | Subsequent | Abbreviation |
|--------------|---------------|------------|--------------|
| CyberArk Defender | CyberArk Defender | Defender | N/A |
| CyberArk Sentry | CyberArk Sentry | Sentry | N/A |
| CyberArk Guardian | CyberArk Guardian | Guardian | N/A |
| CyberArk Trustee | CyberArk Trustee | Trustee | N/A |
| Certified Kubernetes Security Specialist | CKS or Certified Kubernetes Security Specialist | CKS | CKS |
| Certified Kubernetes Administrator | CKA or Certified Kubernetes Administrator | CKA | CKA |
| Certified Cloud Security Professional | CCSP or Certified Cloud Security Professional | CCSP | CCSP |
| Certified Information Systems Security Professional | CISSP or Certified Information Systems Security Professional | CISSP | CISSP |

**Examples**:

```markdown
✅ Correct:
The CyberArk Defender (Month 5) is the foundation certification.
After obtaining Defender, you'll prepare for Sentry.

The CKS (Certified Kubernetes Security Specialist) exam requires valid CKA.
After passing CKS, you can leverage your Kubernetes security expertise.

✅ Also correct:
The Certified Kubernetes Security Specialist (CKS) is earned at Month 9-10.
CKS requires valid CKA (Certified Kubernetes Administrator) certification.

❌ Incorrect:
The Defender Certification (wrong - remove "Certification")
CyberArk Defender Cert (wrong - use full name or "Defender")
cyberark defender (wrong - not capitalized)
K8s Security Specialist (wrong - use "CKS" or full name)
```

### Technology Names

**Consistent Capitalization and Official Names**:

| Technology | ✅ Correct | ❌ Incorrect |
|-----------|-----------|-------------|
| CyberArk PAM | CyberArk PAM | Cyberark, cyberArk, CYBERARK PAM |
| CyberArk Conjur | CyberArk Conjur | conjur, CONJUR, Cyberark Conjur |
| Kubernetes | Kubernetes | kubernetes, KUBERNETES |
| K8s | K8s | k8s, K8S (acceptable in headings) |
| Docker | Docker | docker, DOCKER |
| Active Directory | Active Directory | active directory, AD (use full name) |
| AWS | AWS | aws, Amazon Web Services (on first mention can use full) |
| Azure | Azure | azure, AZURE, Microsoft Azure (prefer "Azure") |
| GCP | GCP | gcp, Google Cloud Platform (on first mention can use full) |
| Linux | Linux | linux, LINUX |
| Windows Server | Windows Server | windows server, Windows server |
| Falco | Falco | falco, FALCO |
| Trivy | Trivy | trivy, TRIVY |
| Helm | Helm | helm, HELM |

**Examples**:

```markdown
✅ Correct:
CyberArk Conjur integrates with Kubernetes (K8s) for secrets management.
Deploy Falco for runtime security monitoring.
Use Trivy to scan container images.

❌ Incorrect:
Cyberark's Conjur integrates with kubernetes (k8s).
Deploy falco for runtime security.
Use TRIVY to scan images.
```

### Recovery Month vs Light Month

**Standard Term**: "recovery month" ONLY

```markdown
✅ Correct:
Month 12 is a recovery month.
Recovery months: M12, M18, M27
Recovery months provide rest and consolidation time.

❌ Incorrect (never use these):
Month 12 is a light month.
Month 12 is a break month.
Month 12 is an easy month.
Month 12 is a rest month.
```

**When Describing Workload**: Specify "8 hrs/week"

```markdown
✅ Correct:
Recovery months have reduced workload (8 hrs/week).
Month 12 is a recovery month with 8 hrs/week commitment.

❌ Incorrect:
Recovery months are lighter.
Month 12 has less work.
```

### Portfolio Projects

**Standard Term**: "Portfolio project" or "Project [number]"

```markdown
✅ Correct:
Portfolio project 1: PAM Lab Implementation
Project 4: Conjur Basics
Complete 7-8 portfolio projects by Month 27

❌ Incorrect:
Project 1 (too vague - what kind of project?)
Portfolio item 1
Portfolio piece 1
Lab project 1
```

**Project Naming Convention**:

```markdown
✅ Correct format:
Portfolio project [number]: [Descriptive Name]

Examples:
Portfolio project 1: PAM Lab Implementation
Portfolio project 2: Multi-Tier K8s Application
Portfolio project 3: PAM + K8s Integration
Portfolio project 4: Conjur Basics
```

### Compliance Frameworks

**Standard Names**: Use acronyms, spell out on first mention

```markdown
✅ Correct (first mention):
HIPAA (Health Insurance Portability and Accountability Act)
PCI-DSS (Payment Card Industry Data Security Standard)
SOC2 (Service Organization Control 2)
GDPR (General Data Protection Regulation)

✅ Correct (subsequent mentions):
HIPAA compliance requirements...
PCI-DSS controls...
SOC2 audit...
GDPR data protection...

❌ Incorrect:
Hipaa, hipaa, HIPAA compliance framework (drop "framework")
PCI DSS (missing hyphen)
SOC 2 (wrong spacing)
GDPR regulations (redundant - GDPR already means regulation)
```

### Time References

**Standard Patterns**:

| Context | ✅ Correct | ❌ Incorrect |
|---------|-----------|-------------|
| Weekly commitment | 10-12 hours/week | 10-12 hrs per week, 10 to 12 hours weekly |
| Recovery months | 8 hrs/week | 8 hours per week, 8 hrs/wk |
| Study time | 3 hrs/week | 3 hours weekly, 3hr/wk |
| Total hours | 1,215-1,296 hours | 1215-1296 hrs, ~1200-1300 hours |
| Lab time | 7 hrs/week | 7 hours a week, 7hr/week |

**Examples**:

```markdown
✅ Correct:
Standard months: 10-12 hours/week
Recovery months: 8 hrs/week
Study: 3 hrs/week, Labs: 7 hrs/week

❌ Incorrect:
10-12 hrs per week
8 hours every week
3 hours/wk study, 7 hours/wk labs
```

---

## Formatting Patterns

### Emphasis and Highlighting

**Bold** (`**text**`): Important terms, headings in lists, key concepts

```markdown
✅ Correct:
The **recovery months** (M12, M18, M27) are critical for preventing burnout.
**Phase 1**: PAM + Kubernetes Mastery
**Prerequisite**: Valid CKA certification required

❌ Incorrect (overuse):
The **recovery months** (**M12**, **M18**, **M27**) are **critical**.
```

**Italic** (`*text*`): Emphasis, notes, or subtle highlighting (use sparingly)

```markdown
✅ Correct:
This is *very* important to understand.
*Note*: CKA is a prerequisite for CKS.

❌ Incorrect (overuse):
This is *very* *important* to *understand*.
```

**Code/Technical** (backticks): Commands, filenames, technical terms, constants

```markdown
✅ Correct:
Edit `27MONTH_PROGRESS_TRACKER.csv` to log hours.
Run `kubectl get pods` to verify deployment.
Set `runAsNonRoot: true` in the security context.
Configure `RBAC` policies using `kubectl create role`.

❌ Incorrect (missing backticks):
Edit 27MONTH_PROGRESS_TRACKER.csv to log hours.
Run kubectl get pods to verify deployment.
```

**Combination Example**:

```markdown
**Month 9 Focus**: CKS preparation begins

During Month 9, you'll study for the **CKS** (Certified Kubernetes Security
Specialist) certification. The exam requires a *valid CKA certification* as
a prerequisite. Practice with `kubectl` security commands and review the
[CKS_CERTIFICATION_GUIDE.md](docs/CKS_CERTIFICATION_GUIDE.md).
```

### Date References

**Standard Formats**:

| Format | Use Case | Example |
|--------|----------|---------|
| `YYYY-MM-DD` | Version control, file metadata | 2025-11-22 |
| `Month DD, YYYY` | Document footers, changelog | November 22, 2025 |
| `YYYY-MM` | Month references without day | 2025-11 |

**Examples**:

```markdown
✅ Correct:
**Last Updated**: 2025-11-22
**Version**: 1.0

Changelog:
- November 22, 2025: Added CKS certification guide
- November 21, 2025: Refactored to Grade A+ standards

❌ Incorrect:
**Last Updated**: 11/22/2025 (ambiguous internationally)
**Last Updated**: 22-Nov-2025 (non-standard)
**Last Updated**: Nov 22, 2025 (use full month name)
```

### Version Footer

**Standard Format**: Place at end of every markdown file

```markdown
---

**Last Updated**: YYYY-MM-DD
**Version**: X.X
```

**Example**:

```markdown
---

**Last Updated**: 2025-11-22
**Version**: 1.2
```

**Version Numbering**:
- Major version (X.0): Complete rewrites, major structural changes
- Minor version (X.1, X.2): Additions, enhancements, new sections
- Don't use patch versions (X.X.1) for documentation

---

## Content Organization

### Standard File Structure

**Every documentation file should have**:

1. **H1 Title** (`# Title`)
2. **Brief Description** (1-2 sentences below title)
3. **Horizontal Rule** (`---`)
4. **Table of Contents** (if file >200 lines or >5 sections)
5. **Main Sections** (H2 headers: `##`)
6. **Related Documents Section** (when applicable)
7. **Version Footer** (always at end)

**Example Structure**:

```markdown
# Document Title

Brief 1-2 sentence description explaining the purpose and contents of this document.

---

## Table of Contents

1. [Section 1](#section-1)
2. [Section 2](#section-2)
3. [Section 3](#section-3)

---

## Section 1

Content for section 1...

## Section 2

Content for section 2...

### Subsection 2.1

Subsection content...

## Section 3

Content for section 3...

---

## Related Documents

- [Related File 1](path/to/file1.md) - Description
- [Related File 2](path/to/file2.md) - Description

---

**Last Updated**: YYYY-MM-DD
**Version**: X.X
```

### Section Ordering (Standard)

When applicable, use this order:

1. **Overview / Introduction**
2. **Prerequisites** (if needed)
3. **Main Content Sections** (ordered logically)
4. **Examples** (if applicable)
5. **Practice / Labs** (if applicable)
6. **Troubleshooting** (if applicable)
7. **Related Documents / Next Steps**
8. **Version Footer** (always last)

### Table of Contents

**When to Include**:
- Files >200 lines
- Files with >5 major sections
- Files that users will reference frequently
- Complex guides or certification prep documents

**Format**:

```markdown
## Table of Contents

1. [Section Name](#section-name)
2. [Another Section](#another-section)
   - [Subsection](#subsection)
3. [Final Section](#final-section)

---
```

**Link Format**: Use lowercase with hyphens for anchors

```markdown
✅ Correct:
## Zero Trust Architecture
[Zero Trust Architecture](#zero-trust-architecture)

## CKS Certification Guide
[CKS Certification Guide](#cks-certification-guide)

❌ Incorrect:
[Zero Trust Architecture](#Zero-Trust-Architecture)
[CKS Certification Guide](#cks_certification_guide)
```

---

## Advanced Formatting

### Blockquotes

**Use for Notes, Warnings, Important Information**:

```markdown
> **Note**: CKA is a prerequisite for CKS certification. Obtain CKA before
> starting the CKS preparation in Month 9.

> **Warning**: Do not commit files containing secrets or credentials to Git.

> **Tip**: Use `kubectl explain` to get quick documentation during the exam.
```

**Multi-paragraph Blockquotes**:

```markdown
> **Important Considerations**:
>
> CKS exam requires valid CKA certification. The CKA must not be expired
> at the time you take CKS.
>
> CKS exam is performance-based with 15-20 hands-on tasks. Practice speed
> with `kubectl` commands using aliases and shortcuts.
```

### Horizontal Rules

**Use to Separate Major Sections**:

```markdown
---
```

**When to Use**:
- After title and description
- Between major logical sections
- Before "Related Documents" section
- Before version footer

**When NOT to Use**:
- Between every H2 section (too busy)
- Within lists or tables
- Inside code blocks

### Admonitions (Note, Warning, Tip Boxes)

**Standard Pattern** (using blockquotes + bold):

```markdown
> **Note**: This is a note with important supplementary information.

> **Warning**: This is a warning about something that could go wrong.

> **Tip**: This is a helpful tip to make tasks easier.

> **Important**: This is critical information that must not be missed.
```

**Example in Context**:

```markdown
### CKS Exam Prerequisites

> **Important**: You MUST have a valid CKA certification before scheduling
> the CKS exam. CKA certification is valid for 3 years.

> **Tip**: Schedule your CKS exam 2-3 weeks in advance to ensure your
> preferred date/time is available.
```

### Collapsible Sections (Details/Summary)

**Format**:

```markdown
<details>
<summary>Click to expand: Detailed Explanation</summary>

Detailed content goes here. Can include:
- Lists
- Code blocks
- Tables
- Any markdown content

</details>
```

**Use Cases**:
- Long reference lists
- Detailed examples
- Optional advanced content
- FAQ expandable answers

**Example**:

```markdown
<details>
<summary>Click to expand: Complete CKS Study Resources List</summary>

**Official Documentation**:
- Kubernetes.io Security Documentation
- CNCF CKS Curriculum
- Kubernetes Security Best Practices

**Practice Platforms**:
- Killer.sh (2 practice exams included with CKS purchase)
- KodeKloud CKS Course
- Linux Foundation CKS Course

**Books**:
- "Kubernetes Security" by Liz Rice
- "Container Security" by Liz Rice

</details>
```

### Emoji Usage

**Allowed**:
- ✅ Success indicators in summary sections
- ❌ Error/incorrect indicators in examples
- 🚀 Celebrating milestones (sparingly)
- 🏖️ Recovery month references (sparingly)
- ⭐ Difficulty ratings in tables
- ⚠️ Warning indicators

**NOT Allowed**:
- Headers (breaks navigation)
- File names
- Code blocks
- Technical content (reduces professionalism)

**Example (Correct Usage)**:

```markdown
## Success Metrics (Month 11)

✅ All 3 CyberArk certifications obtained
✅ CKS certification earned
✅ K8s production-ready skills demonstrated
✅ 4 portfolio projects published

Recovery months: 🏖️ M12, M18, M27

**Difficulty**: ⭐⭐⭐⭐ (Advanced)
```

---

## Quality Checklist

### Before Committing Documentation Changes

**File-Level Checks**:
- [ ] File name follows naming conventions (CAPS_WITH_UNDERSCORES.md)
- [ ] H1 title present (only one per file)
- [ ] Brief description below title (1-2 sentences)
- [ ] Horizontal rule after description (`---`)
- [ ] Table of contents included (if file >200 lines)
- [ ] Version footer at end with date and version

**Formatting Checks**:
- [ ] Headers use ATX style (`#`, not underlines)
- [ ] Lists use consistent format (`-` for unordered, `1.` for ordered)
- [ ] 2-space indentation for nested lists
- [ ] Links use relative paths (internal) and include protocol (external)
- [ ] Tables have header rows with alignment
- [ ] Code blocks use triple backticks with language identifier
- [ ] Inline code uses single backticks for technical terms

**Terminology Checks**:
- [ ] Months referenced as "Month X" (prose) or "MX" (tables)
- [ ] Phases referenced as "Phase X" or "PHASE X: Name (Months X-Y)"
- [ ] Certifications use official names (CyberArk Defender, CKS, CCSP)
- [ ] Technology names capitalized correctly (CyberArk, Kubernetes, K8s)
- [ ] "Recovery month" used (not "light month" or "break month")
- [ ] Portfolio projects referenced consistently
- [ ] Time commitments formatted as "X-Y hours/week" or "X hrs/week"

**Content Quality Checks**:
- [ ] All links tested and working
- [ ] Internal links point to correct files
- [ ] External links include https://
- [ ] No broken references or missing files mentioned
- [ ] Examples are accurate and tested
- [ ] Code blocks are syntactically correct
- [ ] No sensitive information (passwords, API keys, personal data)

**Accessibility Checks**:
- [ ] Link text is descriptive (not "click here")
- [ ] Images include alt text (if any images present)
- [ ] Tables are simple and readable
- [ ] Header hierarchy is logical (no skipped levels)
- [ ] No emojis in headers

---

## Common Mistakes

### Top 10 Documentation Errors

#### 1. Mixing Terminology

**❌ Incorrect**:
```markdown
Month 12 is a light month, M18 is recovery, Month 27 is a break month.
```

**✅ Correct**:
```markdown
Recovery months: M12, M18, M27 (8 hrs/week workload)
```

---

#### 2. Inconsistent List Formatting

**❌ Incorrect**:
```markdown
- Item 1
* Item 2
- Item 3
```

**✅ Correct**:
```markdown
- Item 1
- Item 2
- Item 3
```

---

#### 3. Vague Link Text

**❌ Incorrect**:
```markdown
Click [here](TROUBLESHOOTING.md) for troubleshooting help.
For more info, see [this](BUDGET.md).
```

**✅ Correct**:
```markdown
See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.
Review the [complete budget breakdown](BUDGET.md).
```

---

#### 4. Missing Table Headers

**❌ Incorrect**:
```markdown
| Data 1 | Data 2 | Data 3 |
```

**✅ Correct**:
```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data 1   | Data 2   | Data 3   |
```

---

#### 5. Emojis in Headers

**❌ Incorrect**:
```markdown
## 🚀 Getting Started
## 🏖️ Recovery Months
```

**✅ Correct**:
```markdown
## Getting Started
🚀 Let's begin your journey!

## Recovery Months
Recovery months (🏖️ M12, M18, M27) provide rest time.
```

---

#### 6. Absolute File Paths in Links

**❌ Incorrect**:
```markdown
[Getting Started](/home/user/Cyber-Roadmap/GETTING_STARTED.md)
[CKS Guide](C:\Users\user\docs\CKS_CERTIFICATION_GUIDE.md)
```

**✅ Correct**:
```markdown
[Getting Started](GETTING_STARTED.md)
[CKS Guide](docs/CKS_CERTIFICATION_GUIDE.md)
```

---

#### 7. Missing Backticks for Technical Terms

**❌ Incorrect**:
```markdown
Edit the 27MONTH_PROGRESS_TRACKER.csv file.
Run kubectl get pods to check status.
Set runAsNonRoot to true.
```

**✅ Correct**:
```markdown
Edit the `27MONTH_PROGRESS_TRACKER.csv` file.
Run `kubectl get pods` to check status.
Set `runAsNonRoot` to `true`.
```

---

#### 8. Inconsistent Indentation

**❌ Incorrect** (4 spaces):
```markdown
- Parent item
    - Child item
        - Grandchild item
```

**✅ Correct** (2 spaces):
```markdown
- Parent item
  - Child item
    - Grandchild item
```

---

#### 9. Wrong Certification Names

**❌ Incorrect**:
```markdown
Cyberark Defender Certification
CKS Security Specialist
CCSP Cloud Security Professional Certification
```

**✅ Correct**:
```markdown
CyberArk Defender
CKS (Certified Kubernetes Security Specialist)
CCSP (Certified Cloud Security Professional)
```

---

#### 10. Missing Version Footer

**❌ Incorrect**:
```markdown
(end of file with no footer)
```

**✅ Correct**:
```markdown
---

**Last Updated**: 2025-11-22
**Version**: 1.0
```

---

## Automation & Tools

### Find/Replace Patterns (Standardization)

**Month References**:
```regex
Find: "month (\d+)"
Replace: "Month $1"

Find: "M\. (\d+)"
Replace: "M$1"
```

**Recovery Month Terminology**:
```regex
Find: "light month"
Replace: "recovery month"

Find: "break month"
Replace: "recovery month"

Find: "easy month"
Replace: "recovery month"
```

**Certification Names**:
```regex
Find: "Cyberark"
Replace: "CyberArk"

Find: "cyberArk"
Replace: "CyberArk"

Find: "Defender Cert(ification)?"
Replace: "Defender"
```

**Technology Names**:
```regex
Find: "kubernetes"
Replace: "Kubernetes"

Find: "k8s" (in prose, not code)
Replace: "K8s"
```

### Markdown Linters

**Recommended Tools**:

1. **markdownlint** (VS Code Extension)
   - Install: VS Code Extensions → Search "markdownlint"
   - Auto-fixes many formatting issues
   - Enforces consistent style

2. **remark-lint** (Command-line)
   ```bash
   npm install -g remark-cli remark-lint
   remark -u lint documentation.md
   ```

3. **prettier** (Code Formatter)
   ```bash
   npm install -g prettier
   prettier --write "**/*.md"
   ```

### Pre-Commit Hooks

**Example Git Hook** (`.git/hooks/pre-commit`):

```bash
#!/bin/bash

# Check for common style violations
echo "Checking documentation style..."

# Find files with "light month" instead of "recovery month"
if git diff --cached | grep -i "light month"; then
    echo "ERROR: Use 'recovery month' not 'light month'"
    exit 1
fi

# Find missing version footers
for file in $(git diff --cached --name-only | grep "\.md$"); do
    if ! grep -q "Last Updated" "$file"; then
        echo "WARNING: $file missing version footer"
    fi
done

echo "Style checks passed!"
```

### Style Validation Script

**Create**: `scripts/validate_style.sh`

```bash
#!/bin/bash
# Validate documentation style compliance

ERRORS=0

# Check file naming
echo "Checking file naming conventions..."
for file in *.md; do
    if [[ ! "$file" =~ ^[A-Z_]+\.md$ ]] && [[ "$file" != "README.md" ]]; then
        echo "ERROR: $file doesn't follow naming convention"
        ((ERRORS++))
    fi
done

# Check for version footers
echo "Checking version footers..."
for file in *.md **/*.md; do
    if ! grep -q "Last Updated" "$file"; then
        echo "WARNING: $file missing version footer"
    fi
done

# Check for consistent month references
echo "Checking month terminology..."
if grep -r "light month\|break month\|easy month" *.md **/*.md; then
    echo "ERROR: Use 'recovery month' only"
    ((ERRORS++))
fi

if [ $ERRORS -eq 0 ]; then
    echo "✅ All style checks passed!"
    exit 0
else
    echo "❌ $ERRORS style errors found"
    exit 1
fi
```

---

## Questions About Style?

If you encounter a situation not covered in this guide:

1. **Check Existing Files**: See how similar content is formatted in current documentation
2. **Choose Clarity Over Cleverness**: When in doubt, be explicit and straightforward
3. **Be Consistent**: Match the style of the file you're editing
4. **Document Your Choice**: If you establish a new pattern, add it to this guide
5. **Ask for Review**: When making significant style decisions, get feedback

### Contributing to This Guide

If you identify a new pattern or best practice:

1. Test the pattern in a real document
2. Verify it improves readability/consistency
3. Add it to this guide with examples
4. Update the version number and date
5. Submit for review

---

## Document Control

**Style Guide Version**: 2.0
**Last Updated**: 2025-11-22
**Previous Version**: 1.0 (2025-11-21)
**Maintained By**: Documentation Team
**Review Frequency**: Monthly or as needed

**Changelog**:
- **2.0** (2025-11-22): Complete refactor to A+ grade
  - Added Quick Reference Card section
  - Expanded certification names to include CKS
  - Added Advanced Formatting section
  - Added Quality Checklist section
  - Expanded Common Mistakes with 10 detailed examples
  - Added Automation & Tools section
  - Improved examples throughout
  - Enhanced table formats and visual hierarchy
- **1.0** (2025-11-21): Initial version
