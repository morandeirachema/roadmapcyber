# Documentation Style Guide

Formatting and terminology standards for 27-Month Cybersecurity Roadmap documentation.

---

## Purpose

This style guide ensures consistency across all documentation files, making the roadmap easier to navigate, maintain, and update.

---

## File Naming Conventions

### Top-Level Files (Root Directory)
**Format**: `CAPS_WITH_UNDERSCORES.md`

**Examples**:
- ✅ `README.md`
- ✅ `GETTING_STARTED.md`
- ✅ `QUICKSTART.md`
- ✅ `GLOSSARY.md`
- ✅ `FAQ.md`
- ✅ `TROUBLESHOOTING.md`
- ✅ `BUDGET.md`
- ❌ `getting-started.md` (wrong - use caps)
- ❌ `GettingStarted.md` (wrong - use underscores)

### Subdirectory Files
**Format**: `Title_Case_With_Underscores.md` OR `CAPS_WITH_UNDERSCORES.md`

**Examples**:
- ✅ `roadmap/OVERVIEW.md`
- ✅ `roadmap/MONTH_BY_MONTH_SCHEDULE.md`
- ✅ `templates/RFP_RESPONSE_TEMPLATE.md`
- ✅ `examples/PORTFOLIO_PROJECT_EXAMPLE.md`

### CSV and Data Files
**Format**: `DESCRIPTIVE_NAME.csv`

**Examples**:
- ✅ `27MONTH_PROGRESS_TRACKER.csv`
- ❌ `tracker.csv` (not descriptive enough)

---

## Markdown Formatting

### Headers

**Use ATX-style headers** (`#` syntax, not underline style):

```markdown
✅ Correct:
# Level 1 Header
## Level 2 Header
### Level 3 Header

❌ Incorrect:
Level 1 Header
===============
```

**Header Capitalization**: Title Case for major headers

```markdown
✅ Correct:
## Getting Started
## Phase 1: PAM + Kubernetes Mastery

❌ Incorrect:
## getting started
## phase 1: pam + kubernetes mastery
```

**No Emojis in Headers** (use in content only):

```markdown
✅ Correct:
## Recovery Months
Content: Recovery months (🏖️ M12, M18, M27) provide rest time.

❌ Incorrect:
## 🏖️ Recovery Months
```

### Lists

**Unordered Lists**: Use `-` (hyphen)

```markdown
✅ Correct:
- Item 1
- Item 2
  - Nested item

❌ Incorrect:
* Item 1
* Item 2
```

**Ordered Lists**: Use `1.` format

```markdown
✅ Correct:
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
✅ Correct:
- Parent item
  - Child item
    - Grandchild item

❌ Incorrect (4 spaces):
- Parent item
    - Child item
```

### Checkboxes

**Task Lists**: Use `- [ ]` for uncompleted, `- [x]` for completed

```markdown
✅ Correct:
- [ ] Incomplete task
- [x] Completed task

❌ Incorrect:
[ ] Incomplete task (missing dash)
-[ ] Incomplete task (missing space)
```

**Visual Emphasis**: Use `✅` emoji for summaries only, not task lists

```markdown
✅ Correct - Summary section:
✅ All 3 CyberArk certifications
✅ K8s mastery achieved

❌ Incorrect - Task lists should use [x]:
✅ Complete this task
✅ Complete that task
```

### Links

**Internal Links**: Use relative paths

```markdown
✅ Correct:
[GETTING_STARTED.md](GETTING_STARTED.md)
[Phase 1 Details](roadmap/PHASE1_MONTHS_1-11.md)
[Back to README](../README.md)

❌ Incorrect (absolute path):
[GETTING_STARTED.md](/home/user/GETTING_STARTED.md)

❌ Incorrect (missing .md):
[GETTING_STARTED](GETTING_STARTED)
```

**External Links**: Include protocol (https://)

```markdown
✅ Correct:
[CyberArk Documentation](https://docs.cyberark.com)

❌ Incorrect:
[CyberArk Documentation](docs.cyberark.com)
```

**Link Text**: Descriptive, not "click here"

```markdown
✅ Correct:
See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for solutions.

❌ Incorrect:
Click [here](TROUBLESHOOTING.md) for troubleshooting.
```

### Tables

**Always Include Header Row**:

```markdown
✅ Correct:
| Column 1 | Column 2 |
|----------|----------|
| Data 1   | Data 2   |

❌ Incorrect (no header):
| Data 1   | Data 2   |
```

**Alignment**: Use colons for alignment

```markdown
| Left Aligned | Center Aligned | Right Aligned |
|:-------------|:--------------:|--------------:|
| Content      | Content        | Content       |
```

**Keep Consistent Width** (for readability in source):

```markdown
✅ Correct (aligned):
| Month  | Focus          | Deliverable      |
|--------|----------------|------------------|
| M1-2   | PAM basics     | Lab ready        |
| M3-5   | Defender cert  | Defender cert ✅ |

❌ Acceptable but less readable:
| Month | Focus | Deliverable |
|---|---|---|
| M1-2 | PAM basics | Lab ready |
```

---

## Terminology Standards

### Month References

**Standard Form**: `Month [number]`

```markdown
✅ Correct: Month 1, Month 12, Month 27

❌ Incorrect: month 1, M. 1, month-1
```

**Abbreviation** (use only in tables/charts): `M[number]`

```markdown
✅ Correct in tables:
| M1 | M5 | M12 |

✅ Correct in text when space-constrained:
Recovery months: M12, M18, M27

❌ Incorrect in regular prose:
You'll complete M5 certification...
(Should be: You'll complete Month 5 certification...)
```

**Full Form** (when including weeks): `Month [number] (Weeks X-Y)`

```markdown
✅ Correct:
Month 12 (Weeks 45-48) is a recovery month.
```

### Phase References

**Standard Format**: `Phase [number]` or `Phase [number]: [Name]`

```markdown
✅ Correct:
Phase 1
Phase 2: Conjur + DevSecOps

❌ Incorrect:
phase 1, PHASE ONE, Phase-1
```

**Header Format**: `PHASE [number]: [Name] (Months X-Y)`

```markdown
✅ Correct:
## PHASE 1: PAM + Kubernetes Mastery (Months 1-11)

❌ Incorrect:
## Phase 1 - PAM + Kubernetes Mastery - Months 1-11
```

### Certification Names

**First Mention**: Full name

```markdown
✅ Correct:
CyberArk Defender (first mention)

Then in same document:
Defender (subsequent mentions)
```

**Standard Names**:
- CyberArk Defender ✅ (not Defender Certification, Defender Cert)
- CyberArk Sentry ✅ (not Sentry Certification)
- CyberArk Guardian ✅ (not Guardian Cert)
- CCSP ✅ or Certified Cloud Security Professional
- CISSP ✅ or Certified Information Systems Security Professional
- CKA ✅ or Certified Kubernetes Administrator

### Technology Names

**Consistent Capitalization**:
- CyberArk PAM ✅ (not Cyberark, cyberArk)
- CyberArk Conjur ✅ (not conjur, CONJUR)
- Kubernetes ✅ (not kubernetes)
- K8s ✅ (acceptable abbreviation)
- Active Directory ✅ (not active directory, AD only in tables)
- AWS ✅, Azure ✅, GCP ✅

### Recovery Month vs. Light Month

**Standard Term**: "Recovery month"

```markdown
✅ Correct:
Month 12 is a recovery month.
Recovery months: M12, M18, M27

❌ Incorrect (use "recovery month" only):
Month 12 is a light month.
Month 12 is a break month.
Month 12 is an easy month.
```

**When describing workload**: "8 hrs/week" or "light workload"

```markdown
✅ Correct:
Recovery months have 8 hrs/week (light workload).
```

### Portfolio Projects

**Standard Term**: "Portfolio project"

```markdown
✅ Correct:
Portfolio project 1: PAM Lab Implementation

❌ Incorrect:
Project 1 (too vague - project for what?)
Portfolio item 1
```

### Compliance Frameworks

**Standard Names** (use acronyms after first mention):
- HIPAA ✅ (Health Insurance Portability and Accountability Act)
- PCI-DSS ✅ (Payment Card Industry Data Security Standard)
- SOC2 ✅ (Service Organization Control 2)
- GDPR ✅ (General Data Protection Regulation)

---

## Formatting Patterns

### Time Commitments

**Standard Format**: `X-Y hours/week`

```markdown
✅ Correct:
10-12 hours/week
8 hrs/week (recovery months)

❌ Incorrect:
10-12 hrs per week
10 to 12 hours weekly
```

### Date References

**Standard Format**: `YYYY-MM-DD` or `Month DD, YYYY`

```markdown
✅ Correct:
2025-11-21
November 21, 2025

❌ Incorrect:
11/21/2025 (ambiguous in international contexts)
21-Nov-2025
```

**Version/Last Updated**: At bottom of files

```markdown
✅ Correct:
---

**Last Updated**: 2025-11-21
**Version**: 1.0
```

### Emphasis

**Bold**: Use `**text**` for important terms, headings in lists

```markdown
✅ Correct:
The **recovery months** (M12, M18, M27) are critical.
**Phase 1**: PAM + Kubernetes Mastery
```

**Italic**: Use `*text*` for emphasis (sparingly)

```markdown
✅ Correct:
This is *very* important.
```

**Code**: Use backticks for technical terms, commands, file names

```markdown
✅ Correct:
Edit the `27MONTH_PROGRESS_TRACKER.csv` file.
Run the `kubectl get pods` command.
Configure `RBAC` policies.
```

---

## Content Organization

### File Structure

**Every file should have**:
1. H1 Title (# Title)
2. Brief description (1-2 sentences)
3. Horizontal rule (`---`)
4. Table of contents (if >200 lines)
5. Sections with H2 headers
6. Related documents section (if applicable)
7. Footer with version/date

**Example**:
```markdown
# File Title

Brief description of what this file contains.

---

## Section 1

Content...

## Section 2

Content...

---

## Related Documents

- [Link to related file](path/to/file.md)

---

**Last Updated**: 2025-11-21
**Version**: 1.0
```

### Section Ordering

**Standard Order** (when applicable):
1. Overview / Introduction
2. Prerequisites (if needed)
3. Main content sections
4. Examples (if applicable)
5. Related documents / Next steps
6. Version footer

---

## Common Mistakes to Avoid

### ❌ Don't Do This:

1. **Mixing terminology**:
   ```markdown
   ❌ Month 12 is a light month, M18 is recovery, Month 27 is a break
   ✅ Recovery months: M12, M18, M27
   ```

2. **Inconsistent formatting**:
   ```markdown
   ❌
   - Item 1
   * Item 2
   - Item 3

   ✅
   - Item 1
   - Item 2
   - Item 3
   ```

3. **Vague links**:
   ```markdown
   ❌ Click [here](link.md) for more info.
   ✅ See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for solutions.
   ```

4. **Missing headers in tables**:
   ```markdown
   ❌
   | Data 1 | Data 2 |

   ✅
   | Column 1 | Column 2 |
   |----------|----------|
   | Data 1   | Data 2   |
   ```

5. **Emojis in inappropriate places**:
   ```markdown
   ❌ ## 🚀 Getting Started (header)
   ✅ ## Getting Started
      🚀 Let's begin! (content)
   ```

---

## Enforcing Standards

### Before Committing Changes:

- [ ] File names follow naming conventions
- [ ] Headers use ATX style (# ##)
- [ ] Lists use consistent format (- for unordered, 1. for ordered)
- [ ] Links use relative paths
- [ ] Tables have header rows
- [ ] Terminology is standard (Month X, Phase X, recovery month)
- [ ] Footer with version/date included
- [ ] All links tested and working

### Tools for Consistency:

**Find/Replace Patterns** (for standardization):
```
Find: "month (\d+)" → Replace: "Month $1"
Find: "M\. (\d+)" → Replace: "M$1"
Find: "light month" → Replace: "recovery month"
```

**Markdown Linters** (optional):
- `markdownlint` - Checks markdown syntax
- `remark-lint` - Enforces consistent style

---

## Questions About Style?

If you encounter a situation not covered in this guide:

1. **Check existing files** - See how similar content is formatted
2. **Choose clarity over cleverness** - When in doubt, be explicit
3. **Be consistent** - Match the style of the file you're editing
4. **Document your choice** - If you establish a new pattern, add it to this guide

---

**Style Guide Version**: 1.0
**Last Updated**: 2025-11-21
**Maintained By**: Documentation Team
