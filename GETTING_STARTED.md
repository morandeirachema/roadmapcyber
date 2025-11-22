# Getting Started

Complete onboarding guide for new users of the 27-Month Cybersecurity Roadmap.

---

## Welcome!

You're about to embark on a 27-month journey to become an expert PAM/Conjur consultant. This guide will help you set up everything you need to succeed.

---

## Is This Roadmap Right for You?

### ✅ You're a Good Fit If:
- [ ] You have 5+ years systems administration experience (17+ years ideal)
- [ ] You can commit 10-12 hours/week consistently for 27 months
- [ ] You're currently employed and want to transition to consulting
- [ ] You want a sustainable, family-friendly learning pace
- [ ] You're willing to learn/improve English for consulting
- [ ] You have $2,150-4,100 budget for certifications and labs
- [ ] You want to work with healthcare, banking, or enterprise clients

### ⚠️ Consider Adjustments If:
- **Less experience** (<5 years): Add 6-12 months to timeline
- **Limited time** (<10 hrs/week): Extend proportionally (8 hrs/week = 34 months)
- **Budget constrained**: Prioritize CyberArk certs, defer optional certifications
- **English not fluent**: Add 6 months focused English study before starting
- **Already K8s expert**: Accelerate timeline by 3-6 months

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

**Note**: CKA is a prerequisite for CKS certification (Month 9-10)

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

Total investment: **$2,150-4,100** over 27 months (~$80-152/month)

**Breakdown**:
- Certifications: $1,350-2,100
- Study materials: $300-600
- Lab infrastructure: $200-500 (cloud costs)
- Optional: $300-900 (training subscriptions)

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
- [ ] Create 2-3 Linux VMs (Ubuntu 22.04 recommended)
- [ ] Deploy first Kubernetes cluster with Minikube
- [ ] Test Docker installation (run `docker run hello-world`)
- [ ] Create GitHub repository for notes/projects

### Day 6-7: Begin Month 1 Activities
- [ ] Start reading CyberArk PAM documentation (in English)
- [ ] Watch first CyberArk Campus intro video
- [ ] Take your first notes in English
- [ ] Begin Kubernetes basics tutorial
- [ ] Log first week hours in 27MONTH_PROGRESS_TRACKER.csv

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
- Bookmark for reference throughout 27 months

**Step 3**: [README.md](README.md)
- Get big picture overview
- Understand 3-phase structure
- See what's achievable by Month 27

**Step 4**: [roadmap/OVERVIEW.md](roadmap/OVERVIEW.md)
- Detailed understanding of full 27-month plan
- Success metrics for each phase
- Timeline visualization

**Step 5**: [roadmap/PHASE1_MONTHS_1-11.md](roadmap/PHASE1_MONTHS_1-11.md)
- Deep dive into your first 11 months
- Understand Defender/Sentry/Guardian certifications
- Learn about Kubernetes hands-on focus

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
   - Update 27MONTH_PROGRESS_TRACKER.csv
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

### Recovery Months (Months 12, 18, 27)

**Reduce to 8 hours/week**:
- Light review and consolidation
- Personal time, family, vacation
- No high-pressure activities or exams
- Catch up if behind on anything

---

## Weekly Review Process (30 minutes, every Sunday)

Use the **Weekly Checklist** from [QUICKSTART.md](QUICKSTART.md):

### Study Progress
- [ ] Completed 10-12 hours this week (or 8 hrs if recovery month)
- [ ] Maintained 70% hands-on labs, 30% study/reading
- [ ] Updated 27MONTH_PROGRESS_TRACKER.csv with actual hours
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

### Certification Prep (if certification month: M5, M8, M11, M27)
- [ ] Completed course modules on schedule
- [ ] Practice tests score 80%+ (aim for 90%+ before exam)
- [ ] Reviewed weak areas from practice tests
- [ ] Scheduled exam (if ready at 90%+)

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

**End of Phase 1 (Month 11)**:
- [ ] All 3 CyberArk certifications obtained (Defender, Sentry, Guardian)
- [ ] Kubernetes hands-on mastery achieved (production-ready)
- [ ] 3-4 portfolio projects published on GitHub
- [ ] English: Comfortable reading/writing technical content
- [ ] First consulting presentations delivered

**End of Phase 2 (Month 18)**:
- [ ] Conjur mastery complete (Docker, K8s, multi-cloud basics)
- [ ] DevSecOps expertise (CI/CD + secrets management)
- [ ] 5-6 total portfolio projects published
- [ ] English: Professional communication skills
- [ ] Consulting skills progressing (RFP/SOW templates)

**End of Phase 3 (Month 27)**:
- [ ] CCSP certification achieved
- [ ] AWS + Azure security architecture expertise
- [ ] Cloud compliance mastery (HIPAA, PCI-DSS, SOC2, GDPR)
- [ ] 7-8 total portfolio projects published
- [ ] English: Consulting presentation skills
- [ ] **CONSULTING PRACTICE LAUNCHED** 🚀

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
   - Start from Day 1 or you won't be ready by Month 27

4. **Scheduling exams before 90%+ practice test scores**
   - High failure risk
   - Wastes money and time

5. **Skipping recovery months** to "speed up"
   - Burnout will cost you more time than 3 light months
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

✅ Completed prerequisites checklist
✅ Set up hardware, software, and accounts
✅ Understand 27-month commitment
✅ Budget confirmed
✅ Read orientation documents

**→ Begin Month 1 activities** from [roadmap/PHASE1_MONTHS_1-11.md](roadmap/PHASE1_MONTHS_1-11.md)

**→ Bookmark [QUICKSTART.md](QUICKSTART.md)** for daily reference

**→ Set up weekly Sunday review** in your calendar

---

### If You Need More Information:

**Questions** → [FAQ.md](FAQ.md)
**Budget concerns** → [BUDGET.md](BUDGET.md)
**English details** → [roadmap/ENGLISH_LEARNING.md](roadmap/ENGLISH_LEARNING.md)
**Timeline questions** → [roadmap/OVERVIEW.md](roadmap/OVERVIEW.md)
**Certification details** → [roadmap/PHASE1_MONTHS_1-11.md](roadmap/PHASE1_MONTHS_1-11.md)

---

## Good Luck!

You're about to embark on a transformative 27-month journey. Stay consistent, use the recovery months, engage with communities, and remember:

**Consistency beats intensity. 10-12 hours/week for 27 months > 20 hours/week for 12 months (with burnout)**

Welcome to the roadmap! 🚀

---

**Last Updated**: 2025-11-21
**Version**: 1.0
