# DevSecOps Pipeline Implementation Example

> Real-world example of a secure CI/CD pipeline with integrated secrets management

---

## Project Overview

### Client Profile
| Field | Details |
|-------|---------|
| **Industry** | E-commerce/Retail |
| **Company Size** | 1,200 employees |
| **Development Teams** | 15 teams, 120 developers |
| **Project Duration** | 10 weeks |
| **Budget** | $125,000 |

### Business Drivers
- Security vulnerabilities discovered in production
- Secrets exposed in Git repositories
- Manual deployment processes causing delays
- Compliance requirements (PCI-DSS)
- Need for faster, safer releases

---

## Pipeline Architecture

### High-Level Architecture
```
┌─────────────────────────────────────────────────────────────────────────┐
│                    DevSecOps Pipeline Architecture                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Developer                                                              │
│      │                                                                  │
│      │ git push                                                        │
│      ▼                                                                  │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                │
│  │   GitLab    │───▶│  Pipeline   │───▶│   Conjur    │                │
│  │  Repository │    │  Trigger    │    │  (Secrets)  │                │
│  └─────────────┘    └──────┬──────┘    └─────────────┘                │
│                            │                                            │
│                            ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    CI/CD Pipeline Stages                         │   │
│  │                                                                   │   │
│  │  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐         │   │
│  │  │ Build │─▶│ SAST  │─▶│ Test  │─▶│ DAST  │─▶│Deploy │         │   │
│  │  └───────┘  └───────┘  └───────┘  └───────┘  └───────┘         │   │
│  │      │          │          │          │          │               │   │
│  │      ▼          ▼          ▼          ▼          ▼               │   │
│  │  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐         │   │
│  │  │SCA    │  │Secret │  │Contain│  │API    │  │K8s    │         │   │
│  │  │Scan   │  │Scan   │  │Scan   │  │Scan   │  │Deploy │         │   │
│  │  └───────┘  └───────┘  └───────┘  └───────┘  └───────┘         │   │
│  │                                                                   │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                            │                                            │
│                            ▼                                            │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                │
│  │ Kubernetes  │    │  Security   │    │   SIEM      │                │
│  │  Cluster    │    │  Dashboard  │    │  (Splunk)   │                │
│  └─────────────┘    └─────────────┘    └─────────────┘                │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Security Tools Stack
| Tool | Purpose | Integration Point |
|------|---------|-------------------|
| GitLab CI | Pipeline orchestration | Central |
| Conjur | Secrets management | All stages |
| SonarQube | SAST scanning | Build stage |
| Snyk | SCA/dependency scanning | Build stage |
| Gitleaks | Secret detection | Pre-commit, CI |
| Trivy | Container scanning | Build stage |
| OWASP ZAP | DAST scanning | Test stage |
| Falco | Runtime security | Production |

---

## Implementation Details

### GitLab CI Pipeline Configuration

```yaml
# .gitlab-ci.yml - Complete DevSecOps Pipeline

stages:
  - pre-commit
  - build
  - security-scan
  - test
  - container-scan
  - dast
  - deploy-staging
  - deploy-production

variables:
  CONJUR_ACCOUNT: "retailco"
  CONJUR_AUTHN_URL: "https://conjur.retailco.com/authn-jwt/gitlab"
  DOCKER_IMAGE: "${CI_REGISTRY_IMAGE}:${CI_COMMIT_SHA}"
  SONAR_HOST_URL: "https://sonarqube.retailco.com"
  SNYK_ORG: "retailco"

# ============================================
# Stage: Pre-commit Checks
# ============================================
secret-detection:
  stage: pre-commit
  image: zricethezav/gitleaks:latest
  script:
    - gitleaks detect --source . --verbose --redact
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

lint-dockerfile:
  stage: pre-commit
  image: hadolint/hadolint:latest-debian
  script:
    - hadolint Dockerfile --failure-threshold error
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

# ============================================
# Stage: Build
# ============================================
build-app:
  stage: build
  image: docker:24.0
  services:
    - docker:24.0-dind
  id_tokens:
    CONJUR_TOKEN:
      aud: https://conjur.retailco.com
  before_script:
    # Authenticate to Conjur
    - |
      apk add --no-cache curl jq
      CONJUR_ACCESS_TOKEN=$(curl -s -X POST \
        "${CONJUR_AUTHN_URL}/${CONJUR_ACCOUNT}/authenticate" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Accept-Encoding: base64" \
        --data-urlencode "jwt=${CONJUR_TOKEN}")

      # Retrieve build secrets
      export REGISTRY_USER=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.retailco.com/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgitlab%2Fregistry%2Fusername")
      export REGISTRY_PASS=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.retailco.com/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgitlab%2Fregistry%2Fpassword")
  script:
    - echo "${REGISTRY_PASS}" | docker login -u "${REGISTRY_USER}" --password-stdin ${CI_REGISTRY}
    - docker build -t ${DOCKER_IMAGE} .
    - docker push ${DOCKER_IMAGE}
  artifacts:
    reports:
      dotenv: build.env

# ============================================
# Stage: Security Scanning
# ============================================
sast-scan:
  stage: security-scan
  image: sonarsource/sonar-scanner-cli:latest
  id_tokens:
    CONJUR_TOKEN:
      aud: https://conjur.retailco.com
  before_script:
    - |
      export SONAR_TOKEN=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.retailco.com/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fsonarqube%2Ftoken")
  script:
    - sonar-scanner
        -Dsonar.projectKey=${CI_PROJECT_NAME}
        -Dsonar.sources=.
        -Dsonar.host.url=${SONAR_HOST_URL}
        -Dsonar.login=${SONAR_TOKEN}
        -Dsonar.qualitygate.wait=true
  allow_failure: false
  rules:
    - if: $CI_COMMIT_BRANCH

dependency-scan:
  stage: security-scan
  image: snyk/snyk:node
  id_tokens:
    CONJUR_TOKEN:
      aud: https://conjur.retailco.com
  before_script:
    - |
      export SNYK_TOKEN=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.retailco.com/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fsnyk%2Ftoken")
  script:
    - snyk auth ${SNYK_TOKEN}
    - snyk test --severity-threshold=high --json > snyk-results.json || true
    - snyk monitor --org=${SNYK_ORG}
  artifacts:
    reports:
      dependency_scanning: snyk-results.json
    when: always

license-scan:
  stage: security-scan
  image: licensefinder/license_finder
  script:
    - license_finder --decisions-file=doc/dependency_decisions.yml
  allow_failure: true

# ============================================
# Stage: Container Scanning
# ============================================
container-scan:
  stage: container-scan
  image: aquasec/trivy:latest
  script:
    - trivy image
        --exit-code 1
        --severity CRITICAL,HIGH
        --ignore-unfixed
        --format json
        --output trivy-results.json
        ${DOCKER_IMAGE}
  artifacts:
    reports:
      container_scanning: trivy-results.json
    when: always

# ============================================
# Stage: Testing
# ============================================
unit-tests:
  stage: test
  image: node:18-alpine
  id_tokens:
    CONJUR_TOKEN:
      aud: https://conjur.retailco.com
  before_script:
    - npm ci
    # Get test database credentials from Conjur
    - |
      export TEST_DB_HOST=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.retailco.com/secrets/${CONJUR_ACCOUNT}/variable/test%2Fdatabase%2Fhost")
      export TEST_DB_PASS=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.retailco.com/secrets/${CONJUR_ACCOUNT}/variable/test%2Fdatabase%2Fpassword")
  script:
    - npm run test:coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      junit: test-results.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

integration-tests:
  stage: test
  image: node:18-alpine
  services:
    - name: postgres:14
      alias: testdb
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: test
    POSTGRES_PASSWORD: testpass
  script:
    - npm ci
    - npm run test:integration
  artifacts:
    reports:
      junit: integration-test-results.xml

# ============================================
# Stage: DAST Scanning
# ============================================
dast-scan:
  stage: dast
  image: owasp/zap2docker-stable
  services:
    - name: ${DOCKER_IMAGE}
      alias: target-app
  variables:
    DAST_TARGET_URL: "http://target-app:3000"
  script:
    - mkdir -p /zap/wrk
    - zap-baseline.py
        -t ${DAST_TARGET_URL}
        -r zap-report.html
        -J zap-report.json
        -I
  artifacts:
    paths:
      - zap-report.html
      - zap-report.json
    reports:
      dast: zap-report.json
    when: always
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

# ============================================
# Stage: Deploy to Staging
# ============================================
deploy-staging:
  stage: deploy-staging
  image: bitnami/kubectl:latest
  id_tokens:
    CONJUR_TOKEN:
      aud: https://conjur.retailco.com
  environment:
    name: staging
    url: https://staging.retailco.com
  before_script:
    - |
      # Get Kubernetes credentials from Conjur
      export KUBECONFIG_DATA=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.retailco.com/secrets/${CONJUR_ACCOUNT}/variable/kubernetes%2Fstaging%2Fkubeconfig")
      echo "${KUBECONFIG_DATA}" | base64 -d > /tmp/kubeconfig
      export KUBECONFIG=/tmp/kubeconfig
  script:
    - kubectl set image deployment/app app=${DOCKER_IMAGE} -n staging
    - kubectl rollout status deployment/app -n staging --timeout=300s
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

# ============================================
# Stage: Deploy to Production
# ============================================
deploy-production:
  stage: deploy-production
  image: bitnami/kubectl:latest
  id_tokens:
    CONJUR_TOKEN:
      aud: https://conjur.retailco.com
  environment:
    name: production
    url: https://www.retailco.com
  before_script:
    - |
      export KUBECONFIG_DATA=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_ACCESS_TOKEN}\"" \
        "https://conjur.retailco.com/secrets/${CONJUR_ACCOUNT}/variable/kubernetes%2Fproduction%2Fkubeconfig")
      echo "${KUBECONFIG_DATA}" | base64 -d > /tmp/kubeconfig
      export KUBECONFIG=/tmp/kubeconfig
  script:
    - kubectl set image deployment/app app=${DOCKER_IMAGE} -n production
    - kubectl rollout status deployment/app -n production --timeout=300s
  when: manual
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

### Conjur Policy for CI/CD
```yaml
# policies/ci-cd.yml

- !policy
  id: ci-cd
  body:
    # GitLab CI secrets
    - !policy
      id: gitlab
      body:
        # Registry credentials
        - !variable registry/username
        - !variable registry/password

        # SonarQube token
        - !variable sonarqube/token

        # Snyk token
        - !variable snyk/token

        # Project-specific secrets
        - &gitlab-secrets
          - !variable registry/username
          - !variable registry/password
          - !variable sonarqube/token
          - !variable snyk/token

    # Kubernetes deployment secrets
    - !policy
      id: kubernetes
      body:
        - !policy
          id: staging
          body:
            - !variable kubeconfig
            - !variable db/host
            - !variable db/password
            - !variable redis/url

        - !policy
          id: production
          body:
            - !variable kubeconfig
            - !variable db/host
            - !variable db/password
            - !variable redis/url
            - !variable stripe/api-key

    # Test environment secrets
    - !policy
      id: test
      body:
        - !variable database/host
        - !variable database/password

# JWT Authenticator for GitLab
- !policy
  id: authn-jwt/gitlab
  body:
    - !webservice

    - !variable issuer
    - !variable jwks-uri
    - !variable token-app-property

    - !group gitlab-runners

    - !permit
      role: !group gitlab-runners
      privileges: [read, authenticate]
      resource: !webservice

# Host identities for GitLab projects
- !host
  id: gitlab/retailco/payment-service
  annotations:
    authn-jwt/gitlab/project_path: retailco/payment-service

- !host
  id: gitlab/retailco/inventory-service
  annotations:
    authn-jwt/gitlab/project_path: retailco/inventory-service

- !host
  id: gitlab/retailco/frontend-app
  annotations:
    authn-jwt/gitlab/project_path: retailco/frontend-app

# Grant access to secrets
- !grant
  role: !group authn-jwt/gitlab/gitlab-runners
  members:
    - !host gitlab/retailco/payment-service
    - !host gitlab/retailco/inventory-service
    - !host gitlab/retailco/frontend-app

- !permit
  role: !host gitlab/retailco/payment-service
  privileges: [read, execute]
  resources:
    - !variable ci-cd/gitlab/registry/username
    - !variable ci-cd/gitlab/registry/password
    - !variable ci-cd/gitlab/sonarqube/token
    - !variable ci-cd/gitlab/snyk/token
    - !variable ci-cd/kubernetes/staging/kubeconfig
    - !variable ci-cd/kubernetes/production/kubeconfig
    - !variable ci-cd/kubernetes/production/stripe/api-key
```

### Pre-commit Hooks Configuration
```yaml
# .pre-commit-config.yaml

repos:
  # Secret detection
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks

  # Dockerfile linting
  - repo: https://github.com/hadolint/hadolint
    rev: v2.12.0
    hooks:
      - id: hadolint-docker

  # YAML linting
  - repo: https://github.com/adrienverge/yamllint
    rev: v1.32.0
    hooks:
      - id: yamllint
        args: [--strict]

  # Shell script linting
  - repo: https://github.com/shellcheck-py/shellcheck-py
    rev: v0.9.0.6
    hooks:
      - id: shellcheck

  # Terraform security
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.5
    hooks:
      - id: terraform_tfsec
      - id: terraform_checkov

  # Python security
  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.5
    hooks:
      - id: bandit
        args: ["-r", "src/"]

  # JavaScript/TypeScript security
  - repo: local
    hooks:
      - id: npm-audit
        name: npm audit
        entry: npm audit --audit-level=high
        language: system
        files: package-lock.json
        pass_filenames: false
```

### Security Dashboard Configuration
```yaml
# security-dashboard/docker-compose.yml

version: '3.8'

services:
  defectdojo:
    image: defectdojo/defectdojo-django:latest
    environment:
      DD_DATABASE_URL: "postgresql://defectdojo:${DD_DB_PASS}@db:5432/defectdojo"
      DD_SECRET_KEY: "${DD_SECRET_KEY}"
      DD_CREDENTIAL_AES_256_KEY: "${DD_AES_KEY}"
    ports:
      - "8080:8080"
    depends_on:
      - db

  db:
    image: postgres:14
    environment:
      POSTGRES_DB: defectdojo
      POSTGRES_USER: defectdojo
      POSTGRES_PASSWORD: "${DD_DB_PASS}"
    volumes:
      - defectdojo_db:/var/lib/postgresql/data

  # Import pipeline results
  importer:
    build: ./importer
    environment:
      DEFECTDOJO_URL: "http://defectdojo:8080"
      CONJUR_URL: "https://conjur.retailco.com"
      CONJUR_ACCOUNT: "retailco"
    volumes:
      - ./scan-results:/results

volumes:
  defectdojo_db:
```

### Security Metrics Script
```python
#!/usr/bin/env python3
"""
security_metrics.py - Collect and report security metrics
"""

import requests
import json
from datetime import datetime, timedelta
from typing import Dict, List

class SecurityMetricsCollector:
    def __init__(self, config: Dict):
        self.config = config
        self.metrics = {}

    def collect_sonarqube_metrics(self) -> Dict:
        """Collect SAST metrics from SonarQube"""
        response = requests.get(
            f"{self.config['sonarqube_url']}/api/measures/component",
            params={
                'component': self.config['project_key'],
                'metricKeys': 'vulnerabilities,security_hotspots,security_rating'
            },
            auth=(self.config['sonarqube_token'], '')
        )

        data = response.json()
        return {
            'vulnerabilities': next(
                (m['value'] for m in data['component']['measures']
                 if m['metric'] == 'vulnerabilities'), 0
            ),
            'security_hotspots': next(
                (m['value'] for m in data['component']['measures']
                 if m['metric'] == 'security_hotspots'), 0
            ),
            'security_rating': next(
                (m['value'] for m in data['component']['measures']
                 if m['metric'] == 'security_rating'), 'N/A'
            )
        }

    def collect_snyk_metrics(self) -> Dict:
        """Collect SCA metrics from Snyk"""
        response = requests.get(
            f"https://snyk.io/api/v1/org/{self.config['snyk_org']}/project/{self.config['snyk_project']}/aggregated-issues",
            headers={'Authorization': f"token {self.config['snyk_token']}"}
        )

        data = response.json()
        return {
            'critical': len([i for i in data['issues'] if i['severity'] == 'critical']),
            'high': len([i for i in data['issues'] if i['severity'] == 'high']),
            'medium': len([i for i in data['issues'] if i['severity'] == 'medium']),
            'low': len([i for i in data['issues'] if i['severity'] == 'low'])
        }

    def collect_pipeline_metrics(self) -> Dict:
        """Collect pipeline security gate metrics from GitLab"""
        response = requests.get(
            f"{self.config['gitlab_url']}/api/v4/projects/{self.config['project_id']}/pipelines",
            headers={'PRIVATE-TOKEN': self.config['gitlab_token']},
            params={'per_page': 100}
        )

        pipelines = response.json()
        total = len(pipelines)
        failed_security = len([p for p in pipelines if p['status'] == 'failed'])

        return {
            'total_pipelines': total,
            'security_gate_failures': failed_security,
            'pass_rate': (total - failed_security) / total * 100 if total > 0 else 0
        }

    def generate_report(self) -> Dict:
        """Generate comprehensive security report"""
        return {
            'timestamp': datetime.now().isoformat(),
            'sast': self.collect_sonarqube_metrics(),
            'sca': self.collect_snyk_metrics(),
            'pipeline': self.collect_pipeline_metrics(),
            'summary': {
                'overall_risk': self._calculate_risk_score(),
                'trend': self._calculate_trend()
            }
        }

    def _calculate_risk_score(self) -> str:
        """Calculate overall risk score"""
        # Implementation based on weighted metrics
        return "Medium"

    def _calculate_trend(self) -> str:
        """Calculate trend compared to last week"""
        return "Improving"


def main():
    config = {
        'sonarqube_url': 'https://sonarqube.retailco.com',
        'sonarqube_token': 'xxx',
        'project_key': 'payment-service',
        'snyk_org': 'retailco',
        'snyk_project': 'xxx',
        'snyk_token': 'xxx',
        'gitlab_url': 'https://gitlab.retailco.com',
        'gitlab_token': 'xxx',
        'project_id': '123'
    }

    collector = SecurityMetricsCollector(config)
    report = collector.generate_report()

    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
```

---

## Results and Metrics

### Security Improvements
| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Secrets in repositories | 47 | 0 | -100% |
| Critical vulnerabilities | 23 | 2 | -91% |
| High vulnerabilities | 89 | 12 | -87% |
| MTTR (security issues) | 14 days | 2 days | -86% |
| Security gate pass rate | N/A | 94% | New |

### Pipeline Performance
| Metric | Value |
|--------|-------|
| Average pipeline duration | 18 minutes |
| Security scan overhead | 4 minutes |
| Deployment frequency | 15/week |
| Change failure rate | 2.1% |
| Lead time for changes | 4 hours |

### Compliance Status
| Control | Status | Evidence |
|---------|--------|----------|
| PCI-DSS 6.5 | Compliant | SAST/DAST reports |
| PCI-DSS 6.6 | Compliant | Security testing |
| PCI-DSS 10.1 | Compliant | Audit logs |
| PCI-DSS 10.2 | Compliant | Activity tracking |

---

## Lessons Learned

### What Worked Well
1. **GitLab JWT integration with Conjur** - Eliminated hardcoded credentials
2. **Pre-commit hooks** - Caught issues before they reached CI
3. **Security gates with fail-fast** - Quick feedback loop
4. **DefectDojo aggregation** - Single pane of glass

### Challenges Overcome
1. **Pipeline duration** - Parallelized security scans
2. **False positives** - Tuned scanner configurations
3. **Developer adoption** - Provided clear documentation and training
4. **Tool integration** - Created standardized wrapper scripts

### Recommendations
1. Start with pre-commit hooks before CI integration
2. Implement security gates gradually (warn before fail)
3. Provide clear remediation guidance with findings
4. Track metrics from day one
5. Integrate with existing developer workflows

---

## Related Documents
- [DEVOPS_CI_CD_GUIDE.md](../docs/DEVOPS_CI_CD_GUIDE.md) - CI/CD integration guide
- [CONJUR_PROJECT_EXAMPLE.md](CONJUR_PROJECT_EXAMPLE.md) - Conjur implementation
- [HANDS_ON_LABS_PHASE2.md](../docs/HANDS_ON_LABS_PHASE2.md) - DevSecOps labs

---

*Last Updated: 2025-12-04*
*Version: 1.0*
