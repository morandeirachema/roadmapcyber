# Getting Started

Complete onboarding guide for new users of the 18-Month Cybersecurity Roadmap (PAM + DevSecOps + Pentesting).

---

## Welcome!

You're about to embark on an 18-month journey to become a dual-track PAM + pentesting consultant. This guide will help you set up everything you need to succeed.

**Program Start Date**: May 4, 2026 | **Program End**: ~October 2027

### What You'll Achieve

By the end of Month 18 (October 2027) you will have earned:

1. **CyberArk Defender** — Month 4 (Aug 2026)
2. **CyberArk Sentry** — Month 6 (Oct 2026)
3. **CyberArk Guardian** — Month 8 (Dec 2026)
4. **eJPT** (eLearnSecurity Junior Penetration Tester) — Month 12 (Apr 2027)
5. **OSCP** (Offensive Security Certified Professional) — Month 17 (Sep 2027)

Plus 6 portfolio projects, Conjur mastery in Docker/Kubernetes/multi-cloud, cloud pentesting skills, and a launched consulting practice targeting $175-350/hour.

---

## Is This Roadmap Right for You?

### You're a Good Fit If:

- [ ] You have 5+ years systems administration experience
- [ ] You hold a valid CKA (Certified Kubernetes Administrator)
- [ ] You can commit 12-15 hours/week consistently for 18 months
- [ ] You're currently employed and want to transition to consulting
- [ ] You want a sustainable, family-friendly learning pace
- [ ] You're willing to learn/improve English for consulting
- [ ] You have $3,400-4,500 budget for certifications and labs
- [ ] You want to combine PAM implementation with pentesting assessment work

### Consider Adjustments If:

- **Less experience** (<5 years): Add 3-6 months to timeline
- **Limited time** (<12 hrs/week): Extend proportionally (8 hrs/week = ~27 months)
- **Budget constrained**: Prioritize CyberArk + OSCP, defer optional certifications
- **English not fluent**: Add 6 months focused English study before starting
- **No prior offensive experience**: Expect the pentesting track to feel harder — budget extra TryHackMe time in M1-4

**Still unsure?** → See [FAQ.md](FAQ.md) for more details

---

## Before You Begin: Prerequisites

### Skills Prerequisites Verification

This roadmap assumes you have foundational IT/systems administration skills. Complete this self-assessment before beginning:

#### Networking Fundamentals ✅
- [ ] Can you explain the OSI model and common protocols (TCP/IP, HTTP/HTTPS, DNS, SSH)?
- [ ] Do you understand subnetting, CIDR notation, and IP addressing?
- [ ] Can you configure firewall rules and understand VLANs?
- [ ] Have you worked with load balancers and reverse proxies?

**If 3+ boxes unchecked**: Study networking basics (1-2 months) before starting roadmap

#### Linux/Windows Administration ✅
- [ ] Comfortable with Linux CLI (bash, common commands, file permissions)?
- [ ] Can you manage Linux services (systemd, cron, logging)?
- [ ] Familiar with Windows Server administration (AD, GPO, services)?
- [ ] Experience with SSH, remote administration, and troubleshooting?

**If 3+ boxes unchecked**: Gain 6-12 months sysadmin experience before starting

#### Cloud Computing Basics ✅
- [ ] Do you understand VMs, virtual networking, and storage concepts?
- [ ] Familiar with basic IAM concepts (users, roles, permissions)?
- [ ] Have you worked with AWS, Azure, or GCP (even basic experience)?
- [ ] Comfortable with API concepts and REST basics?

**If 3+ boxes unchecked**: Take cloud fundamentals course (AWS Cloud Practitioner or Azure Fundamentals)

#### Kubernetes Foundation ✅
- [ ] **Do you have a valid CKA (Certified Kubernetes Administrator) certification?**
- [ ] OR: Can you deploy and manage a Kubernetes cluster?
- [ ] OR: Comfortable with pods, services, deployments, namespaces?

**If all boxes unchecked**: Obtain CKA certification first (add 3-6 months before starting this roadmap)

**Note**: CKA knowledge is used throughout Phase 2 and Phase 3 for Conjur on Kubernetes and cloud-native secrets work.

---

✅ **If you checked most boxes above**: You're ready to start the roadmap!

⚠️ **If you have significant gaps**: Address them first to ensure success. See [roadmap.sh/cyber-security](https://roadmap.sh/cyber-security) for foundational cybersecurity learning paths.

---

### Hardware Requirements

**Minimum**:
- 16GB RAM
- 4-core CPU (Intel i5 or equivalent)
- 500GB SSD
- Reliable internet connection

**Recommended**:
- 32GB RAM
- 8-core CPU (Intel i7 or equivalent)
- 1TB SSD
- 50+ Mbps internet

**Alternative**: Use cloud VMs if local hardware insufficient (adds $10-30/month)

### Software to Install

**Virtualization** (choose one):
- [ ] VirtualBox (free) - [virtualbox.org](https://www.virtualbox.org)
- [ ] VMware Workstation Player (free for personal use)

**Containers & Kubernetes**:
- [ ] Docker Desktop (free) - [docker.com](https://www.docker.com)
- [ ] Minikube or Kind (free) for local Kubernetes

**Development Tools**:
- [ ] VS Code or preferred text editor (free)
- [ ] Git (free) - [git-scm.com](https://git-scm.com)
- [ ] Terminal/SSH client (built-in on Linux/Mac, PuTTY for Windows)

**Optional but Helpful**:
- [ ] Postman (free) - API testing
- [ ] Draw.io (free) - Architecture diagrams
- [ ] Grammarly (free tier) - English writing assistance

### Accounts to Create

**Essential** (all have free tiers):
- [ ] **CyberArk Campus** - [cyberark.com/services-support/cyberark-campus](https://www.cyberark.com) - Free training and labs
- [ ] **GitHub** - [github.com](https://github.com) - Portfolio hosting
- [ ] **AWS Account** - [aws.amazon.com](https://aws.amazon.com) - Free tier for 12 months
- [ ] **Azure Account** - [azure.microsoft.com](https://azure.microsoft.com) - $200 free credits
- [ ] **LinkedIn** - Professional networking and article publishing

**Helpful** (optional):
- [ ] Reddit account - For /r/cybersecurity, /r/sysadmin communities
- [ ] Slack - For Kubernetes and security community channels
- [ ] Pluralsight or A Cloud Guru - Video training (paid, $200-400/year)

### Budget Confirmation

Total investment: **$3,400-4,500** over 18 months (~$189-250/month average)

**Breakdown**:

- CyberArk certifications: $750-1,500
- Pentesting certifications (eJPT + OSCP): $1,698-2,047
- Study materials and practice platforms: $387-659
- Lab infrastructure: $105-330

**See [BUDGET.md](BUDGET.md) for detailed breakdown and cost-saving strategies**

Can you afford this? _____ (Yes / Need to adjust)

---

## First Week: Quick Wins

Your first week should feel productive and set up success. Here's what to accomplish:

### Day 1-2: Environment Setup
- [ ] Install VirtualBox/VMware
- [ ] Install Docker Desktop
- [ ] Install Git and VS Code
- [ ] Create GitHub account
- [ ] Create CyberArk Campus account
- [ ] Verify hardware meets requirements

### Day 3-4: Orientation
- [ ] Read this file (you are here!)
- [ ] Skim [GLOSSARY.md](GLOSSARY.md) - familiarize yourself with terms
- [ ] Read [README.md](README.md) - big picture overview
- [ ] Read [roadmap/OVERVIEW.md](roadmap/OVERVIEW.md) - understand 3 phases
- [ ] Bookmark [QUICKSTART.md](QUICKSTART.md) for daily use

### Day 5: Lab Environment
- [ ] Create 2-3 Linux VMs (Ubuntu 24.04 recommended)
- [ ] Deploy first Kubernetes cluster with Minikube
- [ ] Test Docker installation (run `docker run hello-world`)
- [ ] Create GitHub repository for notes/projects

### Day 6-7: Begin Month 1 Activities
- [ ] Start reading CyberArk PAM documentation (in English)
- [ ] Watch first CyberArk Campus intro video
- [ ] Take your first notes in English
- [ ] Begin Kubernetes basics tutorial
- [ ] Log first week hours in your progress tracker

**Celebrate!** You've completed your first week! 🎉

---

## Documentation Reading Order

### First-Time User Journey:

**Step 1**: [GETTING_STARTED.md](GETTING_STARTED.md) ← You are here
- Understand if roadmap is right for you
- Complete prerequisites checklist
- Set up environment and accounts

**Step 2**: [GLOSSARY.md](GLOSSARY.md)
- Learn all terminology used in roadmap
- Bookmark for reference throughout the 18 months

**Step 3**: [README.md](README.md)
- Get big picture overview
- Understand 3-phase structure
- See what's achievable by Month 18

**Step 4**: [roadmap/OVERVIEW.md](roadmap/OVERVIEW.md)
- Detailed understanding of the full 18-month plan
- Success metrics for each phase
- Timeline visualization

**Step 5**: [roadmap/PHASE1_MONTHS_1-6.md](roadmap/PHASE1_MONTHS_1-6.md)
- Deep dive into your first 6 months
- Understand CyberArk Defender and Sentry preparation
- Learn about Linux security and web app fundamentals

**Step 6**: [QUICKSTART.md](QUICKSTART.md) - **Bookmark this**
- Your daily/weekly reference
- Consult this every day during roadmap

**Step 7**: [roadmap/MONTH_BY_MONTH_SCHEDULE.md](roadmap/MONTH_BY_MONTH_SCHEDULE.md)
- Week-by-week detailed breakdown
- Reference as needed for current month

### Reference Documents (Use as needed):

- **[FAQ.md](FAQ.md)** - When you have questions
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - When you're stuck
- **[BUDGET.md](BUDGET.md)** - Budget planning and tracking
- **[roadmap/ENGLISH_LEARNING.md](roadmap/ENGLISH_LEARNING.md)** - English study details
- **[roadmap/CONSULTING_SKILLS.md](roadmap/CONSULTING_SKILLS.md)** - Consulting preparation

---

## Daily Workflow (Once Started)

### Weekday Routine (1.5-2 hours/day, Mon-Fri)

**Morning or Evening Block**:
1. **30 minutes**: English practice
   - Read technical documentation in English
   - Watch training video in English (or review notes)

2. **60-90 minutes**: Technical learning
   - **Option A**: Study/reading (theory, documentation, video courses)
   - **Option B**: Hands-on labs (building, configuring, troubleshooting)
   - Aim for 70% hands-on / 30% study overall

3. **5 minutes**: Log hours
   - Update your progress tracker
   - Mark completed tasks

### Weekend Routine (2.5-3 hours total, Sat-Sun)

**Saturday** (1.5-2 hours):
- Deep-focus hands-on lab work
- Build projects, practice configurations
- Most intensive technical work of the week

**Sunday** (1 hour):
- Review week's learning (spaced repetition)
- Update progress tracker with actual vs. planned hours
- Plan next week's priorities
- Check if on track for month's deliverables

### Recovery Months (Months 6, 12, 18)

**Reduce to 8 hours/week**:
- Light review and consolidation
- Personal time, family, vacation
- No high-pressure activities or exams
- Catch up if behind on anything

---

## Weekly Review Process (30 minutes, every Sunday)

Use the **Weekly Checklist** from [QUICKSTART.md](QUICKSTART.md):

### Study Progress
- [ ] Completed 12-15 hours this week (or 8 hrs if recovery month)
- [ ] Maintained 70% hands-on labs, 30% study/reading
- [ ] Updated your progress tracker with actual hours
- [ ] Took notes in English daily

### Lab Work
- [ ] Completed this week's hands-on labs
- [ ] Documented lab work (screenshots, notes, GitHub)
- [ ] Troubleshot issues independently before seeking help

### English Practice
- [ ] Read technical documentation in English daily (30 min)
- [ ] Watched training videos in English
- [ ] Took all notes in English
- [ ] (If Month 7+) Wrote technical content in English

### Certification Prep (if certification month: M4, M6, M8, M12, M17)
- [ ] Completed course modules on schedule
- [ ] Practice tests score 80%+ (aim for 90%+ before exam)
- [ ] Reviewed weak areas from practice tests
- [ ] Scheduled exam (if ready at 90%+)

---

## Progress Tracker Guide

A CSV progress tracker is your primary tool for tracking hours, deliverables, and certifications throughout the 18-month journey. Here's how to use it:

### CSV Structure

| Column | Description | How to Fill |
|--------|-------------|-------------|
| `Month` | Month number (1-18) | Pre-filled |
| `Week` | Week number or range | Pre-filled |
| `Phase` | Phase 1, 2, or 3 | Pre-filled |
| `Focus_Area` | Current focus topic | Pre-filled |
| `Study_Hours_Planned` | Target study hours | Pre-filled (use as reference) |
| `Lab_Hours_Planned` | Target lab hours | Pre-filled (use as reference) |
| `Total_Hours` | Total weekly hours | Pre-filled |
| `Study_Hours_Actual` | **Your actual study hours** | Update weekly |
| `Lab_Hours_Actual` | **Your actual lab hours** | Update weekly |
| `Deliverable` | Expected deliverable | Pre-filled |
| `Status` | Pending/In Progress/Complete | Update as you progress |
| `Notes` | Personal notes, issues, wins | Add your notes |
| `English_Milestone` | English learning checkpoint | Pre-filled with goals |
| `Consulting_Skill` | Consulting skill focus | Pre-filled |
| `Certification` | Certification targets | Pre-filled |
| `Portfolio_Projects` | Project milestones | Pre-filled |

### How to Use the Tracker

**Daily** (5 minutes):
1. Open your progress tracker CSV in any spreadsheet app (Excel, Google Sheets, LibreOffice)
2. Find your current week's row
3. Update `Study_Hours_Actual` and `Lab_Hours_Actual` columns
4. Add any notes to the `Notes` column

**Weekly** (Sunday review):
1. Calculate total actual hours for the week
2. Compare `*_Actual` vs `*_Planned` columns
3. Update `Status` column (Pending → In Progress → Complete)
4. Review next week's planned focus

**Example Row Update**:
```text
Before: Week 9, Status: Pending, Study_Actual: (empty), Lab_Actual: (empty)
After:  Week 9, Status: In Progress, Study_Actual: 5.5, Lab_Actual: 4, Notes: "Defender practice tests started"
```

### Tips for Effective Tracking

- **Be honest**: Track actual hours, not ideal hours
- **Keep it simple**: Don't overthink entries - quick updates work best
- **Review trends**: Compare actual vs. planned to identify patterns
- **Adjust pace**: If consistently under, adjust schedule; if over, ensure sustainability
- **Celebrate wins**: Mark completions and celebrate milestones

---

## Monthly Checkpoint Process (1-2 hours, last Sunday of month)

### Review Monthly Deliverables
- Check current month's deliverables in roadmap docs
- Assess completion: 100% / 75% / 50% / <50%
- If <90% complete: Identify why and adjust next month

### Assess Learning
- Can you explain this month's concepts without notes?
- Practice teaching concepts out loud (rubber duck method)
- If struggling: Plan extra review time next month

### Update Portfolio
- Document completed projects
- Take screenshots of lab work
- Update GitHub repositories
- Draft notes for future blog posts

### Check English Progress
- Compare against monthly English milestones
- Are you progressing as expected?
- If behind: Add extra English practice time

### Plan Next Month
- Review next month's focus in roadmap docs
- Identify potential challenges
- Plan time allocation
- Update CSV tracker projections

---

## Quarterly Deep Review (2-3 hours, end of each phase)

### Phase Completion Assessment

**End of Phase 1 (Month 6)**:

- [ ] CyberArk Defender and Sentry certifications obtained
- [ ] PAM lab fully operational and documented
- [ ] Linux security + web app security (DVWA, Burp Suite) foundations in place
- [ ] DevSecOps pipeline running with security scanners
- [ ] Portfolio Project 1 (PAM Lab Documentation) published

**End of Phase 2 (Month 12)**:

- [ ] CyberArk Guardian certification obtained
- [ ] eJPT certification obtained
- [ ] Conjur deployed in Docker and Kubernetes
- [ ] Comfortable pentesting networks, web apps, and Active Directory
- [ ] Portfolio Project 2 (CyberArk Guardian Enterprise Architecture) published

**End of Phase 3 (Month 18)**:

- [ ] OSCP certification obtained
- [ ] Cloud pentesting skills (CloudGoat AWS, Azure AD attacks)
- [ ] Multi-cloud secrets architecture designed and deployed
- [ ] DevSecOps security audit methodology applied
- [ ] Portfolio Projects 3-6 published (Conjur + CI/CD, Multi-Cloud Secrets, DevSecOps Audit, Enterprise Capstone)
- [ ] **Consulting practice launched**

### Update Professional Materials
- **Resume/CV**: Add new certifications, skills, projects
- **LinkedIn**: Update headline, about section, experience
- **Portfolio**: Polish GitHub repos, add READMEs
- **Articles**: Publish blog post or LinkedIn article summarizing phase learnings

---

## Getting Help & Support

### When You're Stuck

**Follow this order**:

1. **Search first** (< 30 minutes):
   - Google the exact error message
   - Check CyberArk Community forums
   - Search Stack Overflow for K8s issues
   - Review [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

2. **Review documentation** (< 1 hour):
   - Re-read relevant section in roadmap docs
   - Check official product documentation
   - Watch tutorial videos explaining the concept

3. **Ask for help** (if stuck > 2 hours):
   - CyberArk Community forums (very active and helpful)
   - Reddit: /r/cybersecurity, /r/sysadmin, /r/kubernetes
   - Discord: DevOps and security communities
   - Include: exact error, what you've tried, your environment

### Community Resources

**Official**:
- CyberArk Community: [community.cyberark.com](https://community.cyberark.com)
- CyberArk Campus: Free training, labs, forums
- Kubernetes Slack: [slack.kubernetes.io](http://slack.kubernetes.io)

**Unofficial**:
- Reddit: /r/cybersecurity, /r/sysadmin, /r/kubernetes
- Discord: Search for "cybersecurity," "DevSecOps," "PAM" servers
- LinkedIn groups: CyberArk Users, Cloud Security Professionals

**English Practice**:
- Language exchange: Tandem app, HelloTalk
- Tutoring: italki.com, Preply, Cambly
- Forums: Practice writing in CyberArk Community

---

## Common Pitfalls to Avoid

### ❌ Don't Do This:

1. **Rushing through material** to "save time"
   - Leads to weak foundations and exam failures
   - Rushing = more time wasted later

2. **Skipping hands-on labs** to focus only on reading
   - 70% hands-on is mandatory for consulting readiness
   - Theory without practice = cannot do the job

3. **Ignoring English** until Month 20
   - English takes time to develop (can't cram it)
   - Start from Day 1 or you won't be ready by Month 18

4. **Scheduling exams before 90%+ practice test scores**
   - High failure risk
   - Wastes money and time

5. **Skipping recovery months** to "speed up"
   - Burnout will cost you more time than 3 recovery months
   - Recovery months are strategic, not optional

6. **Not tracking progress** in CSV
   - You can't manage what you don't measure
   - Weekly tracking = early problem detection

7. **Working in isolation** (not engaging community)
   - Networking is essential for consulting
   - Community = help when stuck + future clients

### ✅ Do This Instead:

1. **Follow the timeline** as designed
2. **Maintain 70/30 labs/study ratio**
3. **Practice English daily** from Day 1
4. **Never schedule exam <90%** practice score
5. **Use recovery months** fully
6. **Track hours weekly** without fail
7. **Engage communities** throughout journey

---

## Next Steps

### If You're Ready to Start:

- Completed prerequisites checklist
- Set up hardware, software, and accounts
- Understand 18-month commitment
- Budget confirmed
- Read orientation documents

**→ Begin Month 1 activities** from [roadmap/PHASE1_MONTHS_1-6.md](roadmap/PHASE1_MONTHS_1-6.md)

**→ Bookmark [QUICKSTART.md](QUICKSTART.md)** for daily reference

**→ Set up weekly Sunday review** in your calendar

---

### If You Need More Information:

**Questions** → [FAQ.md](FAQ.md)
**Budget concerns** → [BUDGET.md](BUDGET.md)
**English details** → [roadmap/ENGLISH_LEARNING.md](roadmap/ENGLISH_LEARNING.md)
**Timeline questions** → [roadmap/OVERVIEW.md](roadmap/OVERVIEW.md)
**Certification details** → [roadmap/PHASE1_MONTHS_1-6.md](roadmap/PHASE1_MONTHS_1-6.md)

---

## Good Luck!

You're about to embark on a transformative 18-month journey. Stay consistent, use the recovery months, engage with communities, and remember:

**Consistency beats intensity. 12-15 hours/week for 18 months beats 25 hours/week for 9 months (with burnout).**

Welcome to the roadmap.

---

**Last Updated**: 2026-04-14
**Version**: 3.0
