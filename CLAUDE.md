# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

An 18-month professional learning and consulting launch program for experienced sysadmins transitioning to PAM + DevSecOps + Pentesting consulting. It is a **documentation-only** repository — 60+ Markdown files covering certifications, hands-on labs, templates, and examples. No application code.

**Program**: May 4, 2026 → October 2027 | 12-15 hrs/week | 5 certifications | 6 portfolio projects

## Validation

The only "build" step is the style validation script:

```bash
./scripts/validate_style.sh          # Check for style violations
./scripts/validate_style.sh --fix    # Auto-fix common issues
```

This validates: footer presence, terminology capitalization, internal link integrity, header hierarchy, code block language identifiers, date formats, and file naming conventions. Exit code 0 with warnings is acceptable; exit code 1 (errors) must be fixed before committing.

**Errors** (exit 1 — must fix): missing `Last Updated` footer, wrong date format in footer, use of banned month terms (`light`/`break`) instead of `recovery month`.
**Warnings** (exit 0 — acceptable): file naming deviations, wrong product capitalization (e.g. lowercase vendor names), broken internal links, multiple H1 headers, code blocks missing language identifiers.

Files under `docs/archive/` are excluded from all validation checks.

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
| OSCP, eJPT, OffSec | oscp, ejpt, offsec |
| Kali Linux | kali linux, Kali |
| Metasploit, Burp Suite | metasploit, burp suite |
| TryHackMe, HackTheBox | tryhackme, hackthebox |
| BloodHound, Impacket | bloodhound, impacket |
| AWS, Azure, GCP | aws, azure, gcp |
| Month 4 / M4 (tables) | month 4, m4 |
| Phase 1 (prose) / PHASE 1 (headers) | phase 1, Phase One |

### Formatting Rules

- Unordered lists: `-` (hyphen), 2-space indent for nesting
- Dates: `YYYY-MM-DD` only — never `April 7, 2026` or `04/07/2026`
- Code blocks must always specify the language identifier (` ```bash `, ` ```yaml `, etc.)
- One `#` H1 per document
- Internal links use relative paths, not absolute paths (e.g., `../docs/FILENAME.md`)

## Repository Architecture

Content is organized in an **18-month progressive learning path** across two parallel tracks: PAM/Conjur mastery and penetration testing.

```text
README.md / GETTING_STARTED.md  ←  entry points
QUICKSTART.md                   ←  daily reference (18-month table)

roadmap/          Phase timelines and week-by-week schedule
docs/             Technical guides: certifications, labs, pentesting, architecture
templates/        Consulting templates (SOW, pentest SOW, project charter, risk assessment)
examples/         Portfolio project examples (PAM, Conjur, AWS, DevSecOps, pentest)
scripts/          validate_style.sh — style enforcement automation
docs/archive/     Archived docs (CKS, CCSP — no longer in primary cert path)
```

**Three phases** and their milestones:

| Phase | Months | Calendar | Certs |
|-------|--------|----------|-------|
| 1 – Security Foundations + PAM Mastery | 1–6 | May–Oct 2026 | Defender (M4), Sentry (M6) |
| 2 – Pentesting Foundations + Advanced PAM | 7–12 | Nov 2026–Apr 2027 | Guardian (M8), eJPT (M12) |
| 3 – Cloud Security + Advanced Pentesting + Launch | 13–18 | May–Oct 2027 | OSCP (M17), Launch (M18) |

**Key phase files**:
- `roadmap/PHASE1_MONTHS_1-6.md`
- `roadmap/PHASE2_MONTHS_7-12.md`
- `roadmap/PHASE3_MONTHS_13-18.md`

`18MONTH_PROGRESS_TRACKER.csv` is the canonical progress tracker. It has one row per week (72 weeks total) plus monthly summary rows. Update `Study_Hours_Actual`, `Lab_Hours_Actual`, `Status`, and `Notes` columns as work is completed. `Status` values used: `Pending`, `In Progress`, `Complete`.

## Adding or Updating Documents

1. Follow the file naming convention (`CAPS_WITH_UNDERSCORES.md`).
2. Start with a single `# Title` and a 1–2 sentence description, then `---`.
3. Use Title Case for `##` and `###` headers.
4. Add the footer (`**Last Updated** / **Version**`) at the end.
5. Run `./scripts/validate_style.sh` and resolve all errors before committing.
