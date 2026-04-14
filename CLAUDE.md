# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

A structured 27-month learning and consulting launch program for experienced sysadmins transitioning to PAM/Conjur consulting. It is a **documentation-only** repository — 51 Markdown files covering certifications, hands-on labs, templates, and examples. There is no application code.

## Validation

The only "build" step is the style validation script:

```bash
./scripts/validate_style.sh          # Check for style violations
./scripts/validate_style.sh --fix    # Auto-fix common issues
```

This validates: footer presence, terminology capitalization, internal link integrity, header hierarchy, code block language identifiers, date formats, and file naming conventions. Exit code 1 means errors found. Fix all errors before committing.

## Documentation Standards

### File Naming

All `.md` files use `CAPS_WITH_UNDERSCORES.md` in every directory. Never use CamelCase, hyphens, or lowercase.

### Required Footer

Every `.md` file must end with:

```markdown
**Last Updated**: YYYY-MM-DD
**Version**: X.X
```

Update both fields whenever a document is modified.

### Terminology (strict capitalization)

| Correct | Never write |
|---------|-------------|
| CyberArk PAM | cyberark pam, Cyberark |
| CyberArk Conjur | conjur (standalone) |
| Kubernetes / K8s | lowercase forms not allowed in prose |
| CKS, CCSP | cks, ccsp |
| AWS, Azure, GCP | aws, azure, gcp |
| Month 5 / M5 (tables) | month 5, m5 |
| Phase 1 (prose) / PHASE 1 (headers) | phase 1, Phase One |

### Formatting Rules

- Unordered lists: `-` (hyphen), 2-space indent for nesting
- Dates: `YYYY-MM-DD` only — never `April 7, 2026` or `04/07/2026`
- Code blocks must always specify the language identifier (` ```bash `, ` ```yaml `, etc.)
- One `#` H1 per document
- Internal links use relative paths: `[Text](../docs/FILE.md)`

## Repository Architecture

Content is organized in a **progressive three-phase learning path**:

```
README.md / GETTING_STARTED.md  ←  entry points
QUICKSTART.md                   ←  daily reference

roadmap/          Phase timelines and week-by-week schedule
docs/             Deep technical guides: certifications, labs, architecture, compliance
templates/        Consulting deliverable templates (SOW, project charter, risk assessment)
examples/         Worked portfolio project examples (PAM, Conjur, AWS, DevSecOps)
scripts/          validate_style.sh — style enforcement automation
```

**Three phases** and their milestones:

| Phase | Months | Certs |
|-------|--------|-------|
| 1 – PAM + Kubernetes Mastery | 1–11 | Defender (M5), Sentry (M8), Guardian (M11) |
| 2 – Conjur + DevSecOps | 12–18 | — (recovery M12 = 8 hrs/week) |
| 3 – Cloud Security + CCSP | 19–27 | CCSP (M27), consulting launch |

`27MONTH_PROGRESS_TRACKER.csv` is the canonical progress tracker.

## Adding or Updating Documents

1. Follow the file naming convention (`CAPS_WITH_UNDERSCORES.md`).
2. Start with a single `# Title` and a 1–2 sentence description, then `---`.
3. Use Title Case for `##` and `###` headers.
4. Add the footer (`**Last Updated** / **Version**`) at the end.
5. Run `./scripts/validate_style.sh` and resolve all errors before committing.
