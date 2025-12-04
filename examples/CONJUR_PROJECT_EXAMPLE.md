# Conjur Implementation Project Example

> Real-world example of a CyberArk Conjur secrets management implementation

---

## Project Overview

### Client Profile
| Field | Details |
|-------|---------|
| **Industry** | Financial Services |
| **Company Size** | 5,000 employees |
| **Environment** | Hybrid cloud (AWS + on-premises) |
| **Project Duration** | 16 weeks |
| **Budget** | $350,000 |

### Business Drivers
- DevOps teams hardcoding secrets in CI/CD pipelines
- Multiple secret sprawl across 200+ repositories
- Audit findings for credential management
- AWS security assessment recommendations
- Kubernetes adoption requiring secrets management

---

## Project Scope

### In Scope
- Conjur Enterprise deployment (HA configuration)
- Integration with 5 Jenkins instances
- Integration with GitLab CI (50 projects)
- Kubernetes secrets injection (3 clusters)
- AWS IAM integration
- Migration of 2,000+ secrets

### Out of Scope
- CyberArk PAM (separate project)
- Azure integration (Phase 2)
- Custom application integrations (Phase 2)

---

## Architecture

### Solution Architecture
```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Conjur Enterprise Architecture                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                    ┌──────────────────┐                                │
│                    │   Load Balancer  │                                │
│                    │  (F5 BigIP VIP)  │                                │
│                    └────────┬─────────┘                                │
│                             │                                           │
│              ┌──────────────┴──────────────┐                           │
│              │                             │                            │
│              ▼                             ▼                            │
│     ┌─────────────────┐         ┌─────────────────┐                   │
│     │ Conjur Leader   │         │ Conjur Standby  │                   │
│     │ (Primary DC)    │◄───────►│ (Secondary DC)  │                   │
│     │ conjur-ldr-01   │ Sync    │ conjur-stby-01  │                   │
│     └────────┬────────┘         └────────┬────────┘                   │
│              │                           │                              │
│              │         ┌─────────────────┘                             │
│              │         │                                                │
│              ▼         ▼                                                │
│     ┌─────────────────────────────────────┐                           │
│     │         PostgreSQL HA               │                           │
│     │   (Patroni + Consul cluster)        │                           │
│     │ pg-01 ◄──► pg-02 ◄──► pg-03        │                           │
│     └─────────────────────────────────────┘                           │
│                                                                         │
│  Followers (Read replicas):                                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐                      │
│  │ follower-01 │ │ follower-02 │ │ follower-03 │                      │
│  │ (Jenkins)   │ │ (GitLab)    │ │ (K8s EKS)   │                      │
│  └─────────────┘ └─────────────┘ └─────────────┘                      │
│                                                                         │
│  Consumers:                                                             │
│  ├── Jenkins (5 instances, 200 pipelines)                             │
│  ├── GitLab CI (50 projects)                                          │
│  ├── EKS Clusters (3 clusters, 150 pods)                              │
│  └── AWS Lambda (25 functions)                                        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Network Architecture
| Zone | Components | CIDR |
|------|------------|------|
| Management | Conjur Leader/Standby | 10.100.1.0/24 |
| Database | PostgreSQL cluster | 10.100.2.0/24 |
| Application | Followers | 10.100.10.0/24 |
| CI/CD | Jenkins, GitLab | 10.200.0.0/16 |
| Kubernetes | EKS clusters | 10.50.0.0/16 |

---

## Implementation Timeline

### Phase 1: Foundation (Weeks 1-4)
```
Week 1: Project Kickoff
├── Kickoff meeting
├── Requirements finalization
├── Architecture review
└── Environment planning

Week 2: Infrastructure Setup
├── VM provisioning
├── Network configuration
├── SSL certificate generation
└── PostgreSQL cluster deployment

Week 3: Conjur Deployment
├── Leader installation
├── Standby configuration
├── Follower deployment
└── HA validation

Week 4: Base Configuration
├── Policy structure design
├── Admin authentication
├── Logging configuration
└── Backup procedures
```

### Phase 2: Integration (Weeks 5-10)
```
Week 5-6: Jenkins Integration
├── Jenkins plugin installation
├── Conjur credential setup
├── Pilot pipeline migration
└── Team training

Week 7-8: GitLab CI Integration
├── JWT authenticator setup
├── .gitlab-ci.yml templates
├── Project migration
└── Documentation

Week 9-10: Kubernetes Integration
├── K8s authenticator config
├── Secrets Provider deployment
├── Application testing
└── Production readiness
```

### Phase 3: Migration (Weeks 11-14)
```
Week 11-12: Secret Migration
├── Secret inventory
├── Migration scripting
├── Batch migration
├── Validation

Week 13-14: AWS Integration
├── IAM authenticator
├── Lambda integration
├── EC2 integration
└── Testing
```

### Phase 4: Stabilization (Weeks 15-16)
```
Week 15: Production Cutover
├── Final validation
├── Cutover execution
├── Monitoring setup
└── Hypercare start

Week 16: Project Closure
├── Documentation finalization
├── Knowledge transfer
├── Lessons learned
└── Sign-off
```

---

## Technical Implementation

### Policy Structure
```yaml
# root.yml - Top-level policy structure
- !policy
  id: infrastructure
  body:
    - !policy databases
    - !policy messaging
    - !policy certificates

- !policy
  id: applications
  body:
    - !policy frontend
    - !policy backend
    - !policy mobile-api

- !policy
  id: ci-cd
  body:
    - !policy jenkins
    - !policy gitlab
    - !policy github-actions

- !policy
  id: kubernetes
  body:
    - !policy eks-prod
    - !policy eks-staging
    - !policy eks-dev

- !policy
  id: cloud
  body:
    - !policy aws
    - !policy azure  # Future
```

### Jenkins Integration Policy
```yaml
# policies/ci-cd/jenkins.yml
- !policy
  id: jenkins
  body:
    # Host identities for Jenkins nodes
    - !layer jenkins-nodes

    # Host factory for dynamic node registration
    - !host-factory
      id: jenkins-factory
      layers:
        - !layer jenkins-nodes

    # Specific Jenkins hosts
    - !host jenkins-master
    - !host jenkins-agent-01
    - !host jenkins-agent-02
    - !host jenkins-agent-03
    - !host jenkins-agent-04

    - !grant
      role: !layer jenkins-nodes
      members:
        - !host jenkins-master
        - !host jenkins-agent-01
        - !host jenkins-agent-02
        - !host jenkins-agent-03
        - !host jenkins-agent-04

    # Secrets accessible to Jenkins
    - &jenkins-secrets
      - !variable artifactory/username
      - !variable artifactory/password
      - !variable sonarqube/token
      - !variable docker-registry/username
      - !variable docker-registry/password
      - !variable npm-registry/token
      - !variable aws/deploy-access-key
      - !variable aws/deploy-secret-key

    - !permit
      role: !layer jenkins-nodes
      privileges: [read, execute]
      resources: *jenkins-secrets
```

### GitLab CI Integration
```yaml
# .gitlab-ci.yml template with Conjur
variables:
  CONJUR_ACCOUNT: "finservices"
  CONJUR_AUTHN_URL: "https://conjur.finservices.com/authn-jwt/gitlab"

.conjur_auth: &conjur_auth
  id_tokens:
    CONJUR_TOKEN:
      aud: https://conjur.finservices.com
  before_script:
    - |
      # Authenticate to Conjur
      CONJUR_ACCESS_TOKEN=$(curl -s -X POST \
        "${CONJUR_AUTHN_URL}/${CONJUR_ACCOUNT}/authenticate" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Accept-Encoding: base64" \
        --data-urlencode "jwt=${CONJUR_TOKEN}")

      # Retrieve secrets
      export DB_PASSWORD=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.finservices.com/secrets/${CONJUR_ACCOUNT}/variable/applications%2F${CI_PROJECT_NAME}%2Fdb%2Fpassword")

build:
  <<: *conjur_auth
  stage: build
  script:
    - echo "Building with secure credentials"
    - docker build --build-arg DB_PASSWORD="${DB_PASSWORD}" -t app:${CI_COMMIT_SHA} .

deploy:
  <<: *conjur_auth
  stage: deploy
  script:
    - ./deploy.sh
  environment:
    name: production
```

### Kubernetes Integration
```yaml
# conjur-k8s-authenticator.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: conjur-follower
  namespace: conjur
spec:
  replicas: 2
  selector:
    matchLabels:
      app: conjur-follower
  template:
    metadata:
      labels:
        app: conjur-follower
    spec:
      containers:
        - name: conjur
          image: cyberark/conjur:latest
          env:
            - name: CONJUR_AUTHENTICATORS
              value: "authn,authn-k8s/eks-prod"
            - name: CONJUR_DATA_KEY
              valueFrom:
                secretKeyRef:
                  name: conjur-data-key
                  key: key
          ports:
            - containerPort: 443
          volumeMounts:
            - name: conjur-ssl
              mountPath: /opt/conjur/etc/ssl
      volumes:
        - name: conjur-ssl
          secret:
            secretName: conjur-ssl-cert

---
# Application using Secrets Provider
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
  namespace: production
spec:
  template:
    metadata:
      annotations:
        conjur.org/container-mode: sidecar
        conjur.org/secrets-destination: file
        conjur.org/secrets-refresh-interval: 5m
    spec:
      serviceAccountName: payment-service-sa
      containers:
        - name: payment-service
          image: finservices/payment-service:v2.1
          volumeMounts:
            - name: conjur-secrets
              mountPath: /etc/secrets
              readOnly: true
        - name: conjur-secrets-provider
          image: cyberark/secrets-provider-for-k8s:latest
          env:
            - name: CONJUR_AUTHN_URL
              value: "https://conjur.finservices.com/authn-k8s/eks-prod"
            - name: CONJUR_ACCOUNT
              value: "finservices"
            - name: K8S_SECRETS
              value: |
                - db-password: applications/payment-service/db/password
                - api-key: applications/payment-service/api/key
          volumeMounts:
            - name: conjur-secrets
              mountPath: /conjur/secrets
      volumes:
        - name: conjur-secrets
          emptyDir:
            medium: Memory
```

### AWS IAM Integration
```yaml
# aws-iam-authenticator-policy.yml
- !policy
  id: authn-iam
  body:
    - !webservice aws

    - !variable aws-account-id

    # Groups for AWS roles
    - !group lambda-functions
    - !group ec2-instances
    - !group ecs-tasks

    - !permit
      role: !group lambda-functions
      privileges: [read, authenticate]
      resource: !webservice aws

    - !permit
      role: !group ec2-instances
      privileges: [read, authenticate]
      resource: !webservice aws

# Define specific AWS identities
- !host
  id: aws/arn:aws:iam::123456789012:role/lambda-payment-processor
  annotations:
    authn-iam/aws: true

- !grant
  role: !group authn-iam/aws/lambda-functions
  member: !host aws/arn:aws:iam::123456789012:role/lambda-payment-processor

# Grant access to secrets
- !permit
  role: !host aws/arn:aws:iam::123456789012:role/lambda-payment-processor
  privileges: [read, execute]
  resources:
    - !variable applications/payment-processor/db/connection-string
    - !variable applications/payment-processor/encryption/key
```

---

## Migration Results

### Secret Migration Summary
| Category | Count | Status |
|----------|-------|--------|
| Database credentials | 450 | Migrated |
| API keys | 380 | Migrated |
| Service accounts | 290 | Migrated |
| SSL certificates | 85 | Migrated |
| Encryption keys | 120 | Migrated |
| AWS credentials | 175 | Migrated |
| Other secrets | 500 | Migrated |
| **Total** | **2,000** | **Complete** |

### Pipeline Migration
| Platform | Total | Migrated | Success Rate |
|----------|-------|----------|--------------|
| Jenkins | 200 | 195 | 97.5% |
| GitLab CI | 50 | 50 | 100% |
| Lambda | 25 | 25 | 100% |
| **Total** | **275** | **270** | **98.2%** |

### Performance Metrics
| Metric | Target | Achieved |
|--------|--------|----------|
| Secret retrieval latency (p95) | < 100ms | 45ms |
| Authentication latency (p95) | < 200ms | 85ms |
| Availability | 99.9% | 99.95% |
| Secrets retrieved/day | 50,000 | 75,000 |

---

## Challenges and Solutions

### Challenge 1: Legacy Jenkins Plugins
**Problem:** Some Jenkins jobs used deprecated credential plugins that didn't support Conjur.

**Solution:**
- Created wrapper scripts to fetch secrets via CLI
- Migrated jobs to use Jenkins Conjur plugin
- Documented migration patterns for teams

```groovy
// Legacy pattern (deprecated)
withCredentials([string(credentialsId: 'db-password', variable: 'DB_PASS')]) {
    sh 'deploy.sh'
}

// New pattern with Conjur
withConjur(url: 'https://conjur.finservices.com',
           account: 'finservices') {
    def dbPassword = conjurSecret('applications/myapp/db/password')
    sh "DB_PASS=${dbPassword} deploy.sh"
}
```

### Challenge 2: Kubernetes RBAC Complexity
**Problem:** Complex RBAC requirements across multiple namespaces and clusters.

**Solution:**
- Implemented namespace-based policy hierarchy
- Created service account mapping automation
- Developed namespace onboarding script

```bash
#!/bin/bash
# onboard_namespace.sh - Automate Conjur policy for new namespaces

NAMESPACE=$1
CLUSTER=$2
POLICY_BRANCH="kubernetes/${CLUSTER}"

cat << EOF | conjur policy load -b "$POLICY_BRANCH" -f -
- !host
  id: ${NAMESPACE}/*
  annotations:
    authn-k8s/${CLUSTER}/namespace: ${NAMESPACE}

- !grant
  role: !layer ${POLICY_BRANCH}/${NAMESPACE}
  member: !host ${NAMESPACE}/*
EOF
```

### Challenge 3: Secret Rotation Coordination
**Problem:** Rotating database credentials required coordinating with multiple applications.

**Solution:**
- Implemented graceful rotation with dual-credential support
- Created rotation runbook with application notification
- Deployed connection pool with automatic refresh

---

## Lessons Learned

### What Worked Well
1. **Early pilot with Jenkins team** - Built confidence and advocates
2. **Policy-as-Code approach** - Enabled version control and review process
3. **Comprehensive documentation** - Reduced support burden
4. **Follower per integration type** - Simplified troubleshooting

### What Could Be Improved
1. **Earlier stakeholder engagement** - Some teams felt surprised
2. **More thorough secret inventory** - Discovered additional secrets during migration
3. **Better testing automation** - Manual testing slowed progress

### Recommendations for Future Projects
1. Start with comprehensive secret discovery
2. Engage application teams early in planning
3. Develop self-service onboarding tools
4. Implement policy CI/CD from day one
5. Plan for secret rotation from the start

---

## Project Metrics

### Budget Performance
| Category | Budget | Actual | Variance |
|----------|--------|--------|----------|
| Software licenses | $150,000 | $150,000 | 0% |
| Professional services | $150,000 | $140,000 | -7% |
| Infrastructure | $30,000 | $35,000 | +17% |
| Training | $20,000 | $15,000 | -25% |
| **Total** | **$350,000** | **$340,000** | **-3%** |

### Schedule Performance
| Milestone | Planned | Actual | Variance |
|-----------|---------|--------|----------|
| Infrastructure complete | Week 4 | Week 4 | On time |
| Jenkins integration | Week 6 | Week 6 | On time |
| GitLab integration | Week 8 | Week 9 | +1 week |
| Migration complete | Week 14 | Week 14 | On time |
| Go-live | Week 15 | Week 15 | On time |

### Business Outcomes
| Outcome | Before | After | Improvement |
|---------|--------|-------|-------------|
| Hardcoded secrets | 2,000+ | 0 | 100% |
| Secret audit findings | 12 | 0 | 100% |
| Secret rotation (manual) | 40 hrs/month | 0 | 100% |
| Secret access provisioning | 2 days | 15 min | 99% |

---

## Handoff Documentation

### Operations Runbook
- [Conjur Daily Operations](../docs/runbooks/conjur-daily-ops.md)
- [Secret Rotation Procedures](../docs/runbooks/secret-rotation.md)
- [Follower Management](../docs/runbooks/follower-management.md)
- [Disaster Recovery](../docs/runbooks/conjur-dr.md)

### Support Escalation
| Level | Contact | Response Time |
|-------|---------|---------------|
| L1 | Help Desk | 4 hours |
| L2 | PAM Team | 8 hours |
| L3 | CyberArk Support | 24 hours |

### Monitoring Dashboards
- [Conjur Health Dashboard](https://grafana.finservices.com/d/conjur-health)
- [Secret Usage Metrics](https://grafana.finservices.com/d/secret-usage)
- [Authentication Metrics](https://grafana.finservices.com/d/conjur-auth)

---

## Related Documents
- [DEVOPS_CI_CD_GUIDE.md](../docs/DEVOPS_CI_CD_GUIDE.md) - CI/CD integration patterns
- [KUBERNETES_MULTICLUSTER_GUIDE.md](../docs/KUBERNETES_MULTICLUSTER_GUIDE.md) - K8s integration
- [PERFORMANCE_TUNING_GUIDE.md](../docs/PERFORMANCE_TUNING_GUIDE.md) - Performance optimization

---

*Last Updated: 2025-12-04*
*Version: 1.0*
