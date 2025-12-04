# DevSecOps CI/CD Integration Guide

Comprehensive guide for integrating secrets management into CI/CD pipelines. Covers Jenkins, GitLab CI, GitHub Actions, and Azure DevOps with CyberArk Conjur and native cloud secrets.

---

## Table of Contents

1. [DevSecOps Overview](#devsecops-overview)
2. [Secrets Management Principles](#secrets-management-principles)
3. [Jenkins Integration](#jenkins-integration)
4. [GitLab CI Integration](#gitlab-ci-integration)
5. [GitHub Actions Integration](#github-actions-integration)
6. [Azure DevOps Integration](#azure-devops-integration)
7. [Conjur CI/CD Patterns](#conjur-cicd-patterns)
8. [Cloud Native Secrets](#cloud-native-secrets)
9. [Security Best Practices](#security-best-practices)
10. [Troubleshooting](#troubleshooting)

---

## DevSecOps Overview

### What is DevSecOps?

DevSecOps integrates security practices into every phase of the software development lifecycle, making security a shared responsibility rather than a gatekeeping function.

```
┌─────────────────────────────────────────────────────────────────┐
│                    DevSecOps Pipeline                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Plan → Code → Build → Test → Release → Deploy → Operate        │
│    │      │      │       │       │         │         │          │
│    ▼      ▼      ▼       ▼       ▼         ▼         ▼          │
│  Threat  SAST   SCA    DAST   Secrets   Secrets    Runtime      │
│  Model   Scan   Scan   Scan   Injection Rotation   Protection   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Secrets in CI/CD Pipelines

**Common secrets in CI/CD**:
- Docker registry credentials
- Cloud provider credentials (AWS, Azure, GCP)
- Database connection strings
- API keys and tokens
- SSH keys for deployment
- Code signing certificates
- SonarQube/scanning tool tokens

**Problems with hardcoded secrets**:
- Exposed in version control history
- Visible in build logs
- Shared across environments
- Difficult to rotate
- No audit trail

---

## Secrets Management Principles

### The Five Principles of CI/CD Secrets

**1. Never Store Secrets in Code**
```yaml
# BAD - hardcoded secret
environment:
  DATABASE_PASSWORD: "mysecretpassword"

# GOOD - reference to secret manager
environment:
  DATABASE_PASSWORD: ${CONJUR_SECRET_apps/myapp/db/password}
```

**2. Use Short-Lived Credentials**
```bash
# Get temporary credentials, not permanent keys
aws sts assume-role --role-arn arn:aws:iam::123456789:role/deploy-role \
  --role-session-name pipeline-session \
  --duration-seconds 3600
```

**3. Principle of Least Privilege**
```yaml
# Grant only necessary permissions
- !permit
  role: !host ci-cd/jenkins/build-job
  privileges: [ read ]  # Not write/delete
  resources:
    - !variable apps/myapp/docker/registry-password
```

**4. Audit Everything**
```bash
# Every secret access should be logged
# Conjur automatically logs all access
conjur audit resources -k variable -l 100
```

**5. Rotate Regularly**
```yaml
# Automate rotation
rotation:
  schedule: "0 0 * * 0"  # Weekly
  notify: security-team@example.com
```

### Secrets Injection Patterns

**Pattern 1: Environment Variable Injection**
```bash
# Secrets injected as environment variables at runtime
export DATABASE_PASSWORD=$(conjur variable get -i apps/myapp/db/password)
./run-app.sh
```

**Pattern 2: File-Based Injection**
```bash
# Secrets written to file, read by application
conjur variable get -i apps/myapp/db/password > /run/secrets/db-password
chmod 400 /run/secrets/db-password
```

**Pattern 3: API-Based Retrieval**
```python
# Application retrieves secrets via API
import conjur
client = conjur.Client()
password = client.get_secret("apps/myapp/db/password")
```

**Pattern 4: Sidecar/Init Container**
```yaml
# Kubernetes sidecar pattern
initContainers:
- name: secrets-init
  image: cyberark/secrets-provider
  # Fetches secrets before app starts
```

---

## Jenkins Integration

### Jenkins Credential Management

**Native Jenkins Credentials**:
```groovy
// Using Jenkins credentials binding
pipeline {
    agent any
    environment {
        DOCKER_CREDS = credentials('docker-registry-creds')
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW registry.example.com'
            }
        }
    }
}
```

### Jenkins + Conjur Integration

**Install Conjur Credentials Plugin**:
1. Navigate to Manage Jenkins → Manage Plugins
2. Search for "Conjur Secrets"
3. Install and restart Jenkins

**Configure Conjur Connection**:
```groovy
// Jenkinsfile with Conjur
pipeline {
    agent any

    environment {
        // Conjur configuration
        CONJUR_APPLIANCE_URL = 'https://conjur.example.com'
        CONJUR_ACCOUNT = 'myorg'
        CONJUR_AUTHN_LOGIN = 'host/ci-cd/jenkins/build-job'
    }

    stages {
        stage('Authenticate') {
            steps {
                script {
                    // Authenticate to Conjur
                    withCredentials([string(credentialsId: 'conjur-api-key', variable: 'CONJUR_AUTHN_API_KEY')]) {
                        env.CONJUR_TOKEN = sh(
                            script: '''
                                curl -s -X POST \
                                    "${CONJUR_APPLIANCE_URL}/authn/${CONJUR_ACCOUNT}/${CONJUR_AUTHN_LOGIN}/authenticate" \
                                    -H "Content-Type: text/plain" \
                                    -d "${CONJUR_AUTHN_API_KEY}" | base64 | tr -d '\\n'
                            ''',
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }

        stage('Get Secrets') {
            steps {
                script {
                    // Retrieve secrets from Conjur
                    env.DOCKER_USER = sh(
                        script: '''
                            curl -s -H "Authorization: Token token=\\"${CONJUR_TOKEN}\\"" \
                                "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fjenkins%2Fdocker%2Fusername"
                        ''',
                        returnStdout: true
                    ).trim()

                    env.DOCKER_PASS = sh(
                        script: '''
                            curl -s -H "Authorization: Token token=\\"${CONJUR_TOKEN}\\"" \
                                "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fjenkins%2Fdocker%2Fpassword"
                        ''',
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Build & Push') {
            steps {
                sh '''
                    echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin registry.example.com
                    docker build -t registry.example.com/myapp:${BUILD_NUMBER} .
                    docker push registry.example.com/myapp:${BUILD_NUMBER}
                    docker logout registry.example.com
                '''
            }
        }
    }

    post {
        always {
            // Clean up
            sh 'docker logout registry.example.com || true'
        }
    }
}
```

### Jenkins Shared Library for Secrets

**vars/conjurSecret.groovy**:
```groovy
def call(String secretPath) {
    def conjurUrl = env.CONJUR_APPLIANCE_URL
    def conjurAccount = env.CONJUR_ACCOUNT
    def conjurToken = env.CONJUR_TOKEN

    def encodedPath = java.net.URLEncoder.encode(secretPath, "UTF-8")

    def secret = sh(
        script: """
            curl -s -H "Authorization: Token token=\\"${conjurToken}\\"" \
                "${conjurUrl}/secrets/${conjurAccount}/variable/${encodedPath}"
        """,
        returnStdout: true
    ).trim()

    return secret
}
```

**Usage in Jenkinsfile**:
```groovy
@Library('my-shared-library') _

pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                script {
                    def dbPassword = conjurSecret('apps/myapp/database/password')
                    // Use dbPassword
                }
            }
        }
    }
}
```

---

## GitLab CI Integration

### GitLab CI/CD Variables

**Built-in Variables**:
```yaml
# .gitlab-ci.yml
variables:
  # GitLab CI/CD variables (set in project settings)
  DOCKER_REGISTRY: $CI_REGISTRY
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE

build:
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $DOCKER_IMAGE:$CI_COMMIT_SHA .
    - docker push $DOCKER_IMAGE:$CI_COMMIT_SHA
```

### GitLab CI + Conjur Integration

```yaml
# .gitlab-ci.yml
variables:
  CONJUR_APPLIANCE_URL: "https://conjur.example.com"
  CONJUR_ACCOUNT: "myorg"
  CONJUR_AUTHN_LOGIN: "host/ci-cd/gitlab/${CI_PROJECT_PATH}"

stages:
  - authenticate
  - build
  - test
  - deploy

.conjur_auth: &conjur_auth
  before_script:
    - |
      # Authenticate to Conjur
      export CONJUR_TOKEN=$(curl -s -X POST \
        "${CONJUR_APPLIANCE_URL}/authn/${CONJUR_ACCOUNT}/${CONJUR_AUTHN_LOGIN}/authenticate" \
        -H "Content-Type: text/plain" \
        -d "${CONJUR_AUTHN_API_KEY}" | base64 | tr -d '\n')

      # Helper function to get secrets
      get_secret() {
        local secret_id=$1
        local encoded_id=$(echo -n "$secret_id" | jq -sRr @uri)
        curl -s -H "Authorization: Token token=\"${CONJUR_TOKEN}\"" \
          "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/${encoded_id}"
      }

build:
  stage: build
  <<: *conjur_auth
  script:
    - |
      # Get Docker credentials
      DOCKER_USER=$(get_secret "ci-cd/gitlab/docker/username")
      DOCKER_PASS=$(get_secret "ci-cd/gitlab/docker/password")

      # Build and push
      echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin $CI_REGISTRY
      docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
      docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

test:
  stage: test
  <<: *conjur_auth
  script:
    - |
      # Get test database credentials
      export DATABASE_URL="postgres://testuser:$(get_secret 'ci-cd/gitlab/test-db/password')@testdb:5432/testdb"
      npm test

deploy_staging:
  stage: deploy
  <<: *conjur_auth
  environment:
    name: staging
  script:
    - |
      # Get Kubernetes credentials
      get_secret "ci-cd/gitlab/k8s/staging-kubeconfig" | base64 -d > /tmp/kubeconfig
      export KUBECONFIG=/tmp/kubeconfig

      kubectl set image deployment/myapp myapp=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n staging
  only:
    - develop
  after_script:
    - rm -f /tmp/kubeconfig

deploy_production:
  stage: deploy
  <<: *conjur_auth
  environment:
    name: production
  script:
    - |
      get_secret "ci-cd/gitlab/k8s/prod-kubeconfig" | base64 -d > /tmp/kubeconfig
      export KUBECONFIG=/tmp/kubeconfig

      kubectl set image deployment/myapp myapp=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n production
  only:
    - main
  when: manual
  after_script:
    - rm -f /tmp/kubeconfig
```

### GitLab Vault Integration (Alternative)

```yaml
# Using GitLab's native HashiCorp Vault integration
production:
  stage: deploy
  secrets:
    DATABASE_PASSWORD:
      vault: production/database/password@secrets
      file: false
    API_KEY:
      vault: production/api/key@secrets
  script:
    - echo "Database password available as $DATABASE_PASSWORD"
    - ./deploy.sh
```

---

## GitHub Actions Integration

### GitHub Secrets

**Repository Secrets**:
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Login to Docker Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
```

### GitHub Actions + Conjur Integration

```yaml
# .github/workflows/ci-conjur.yml
name: CI/CD with Conjur

on:
  push:
    branches: [main]

env:
  CONJUR_APPLIANCE_URL: ${{ secrets.CONJUR_URL }}
  CONJUR_ACCOUNT: myorg

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Authenticate to Conjur
        id: conjur-auth
        run: |
          TOKEN=$(curl -s -X POST \
            "${CONJUR_APPLIANCE_URL}/authn/${CONJUR_ACCOUNT}/host%2Fci-cd%2Fgithub%2F${{ github.repository }}/authenticate" \
            -H "Content-Type: text/plain" \
            -d "${{ secrets.CONJUR_API_KEY }}" | base64 | tr -d '\n')
          echo "token=${TOKEN}" >> $GITHUB_OUTPUT

      - name: Get Docker Credentials
        id: docker-creds
        run: |
          DOCKER_USER=$(curl -s \
            -H "Authorization: Token token=\"${{ steps.conjur-auth.outputs.token }}\"" \
            "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgithub%2Fdocker%2Fusername")

          DOCKER_PASS=$(curl -s \
            -H "Authorization: Token token=\"${{ steps.conjur-auth.outputs.token }}\"" \
            "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgithub%2Fdocker%2Fpassword")

          # Mask the password in logs
          echo "::add-mask::${DOCKER_PASS}"

          echo "username=${DOCKER_USER}" >> $GITHUB_OUTPUT
          echo "password=${DOCKER_PASS}" >> $GITHUB_OUTPUT

      - name: Login to Docker Registry
        uses: docker/login-action@v3
        with:
          registry: registry.example.com
          username: ${{ steps.docker-creds.outputs.username }}
          password: ${{ steps.docker-creds.outputs.password }}

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: registry.example.com/myapp:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Authenticate to Conjur
        id: conjur-auth
        run: |
          TOKEN=$(curl -s -X POST \
            "${CONJUR_APPLIANCE_URL}/authn/${CONJUR_ACCOUNT}/host%2Fci-cd%2Fgithub%2F${{ github.repository }}/authenticate" \
            -H "Content-Type: text/plain" \
            -d "${{ secrets.CONJUR_API_KEY }}" | base64 | tr -d '\n')
          echo "token=${TOKEN}" >> $GITHUB_OUTPUT

      - name: Get Kubernetes Credentials
        run: |
          curl -s \
            -H "Authorization: Token token=\"${{ steps.conjur-auth.outputs.token }}\"" \
            "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgithub%2Fk8s%2Fkubeconfig" \
            | base64 -d > /tmp/kubeconfig

      - name: Deploy to Kubernetes
        run: |
          export KUBECONFIG=/tmp/kubeconfig
          kubectl set image deployment/myapp myapp=registry.example.com/myapp:${{ github.sha }} -n production

      - name: Cleanup
        if: always()
        run: rm -f /tmp/kubeconfig
```

### CyberArk Conjur GitHub Action

```yaml
# Using official CyberArk GitHub Action
name: Deploy with Conjur Action

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Retrieve Secrets from Conjur
        uses: cyberark/conjur-action@v2
        with:
          url: ${{ secrets.CONJUR_URL }}
          account: myorg
          host_id: host/ci-cd/github/${{ github.repository }}
          api_key: ${{ secrets.CONJUR_API_KEY }}
          secrets: |
            ci-cd/github/docker/username | DOCKER_USERNAME
            ci-cd/github/docker/password | DOCKER_PASSWORD
            ci-cd/github/aws/access-key-id | AWS_ACCESS_KEY_ID
            ci-cd/github/aws/secret-access-key | AWS_SECRET_ACCESS_KEY

      - name: Use Retrieved Secrets
        run: |
          echo "Docker User: ${{ env.DOCKER_USERNAME }}"
          # AWS credentials automatically available
          aws s3 ls
```

### GitHub OIDC with Cloud Providers

```yaml
# Using GitHub OIDC for AWS (no long-lived credentials)
name: Deploy to AWS

on:
  push:
    branches: [main]

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Deploy
        run: |
          # AWS credentials automatically configured
          aws s3 sync ./dist s3://my-bucket/
```

---

## Azure DevOps Integration

### Azure DevOps Service Connections

```yaml
# azure-pipelines.yml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

stages:
  - stage: Build
    jobs:
      - job: Build
        steps:
          - task: Docker@2
            inputs:
              containerRegistry: 'myDockerServiceConnection'
              repository: 'myapp'
              command: 'buildAndPush'
              Dockerfile: '**/Dockerfile'
              tags: '$(Build.BuildId)'

  - stage: Deploy
    jobs:
      - deployment: DeployToAKS
        environment: 'production'
        strategy:
          runOnce:
            deploy:
              steps:
                - task: KubernetesManifest@0
                  inputs:
                    action: 'deploy'
                    kubernetesServiceConnection: 'myAKSConnection'
                    manifests: '$(Pipeline.Workspace)/manifests/*.yaml'
```

### Azure DevOps + Conjur Integration

```yaml
# azure-pipelines.yml with Conjur
trigger:
  - main

variables:
  - group: conjur-settings  # Variable group with CONJUR_URL, CONJUR_ACCOUNT

pool:
  vmImage: 'ubuntu-latest'

stages:
  - stage: Build
    jobs:
      - job: Build
        steps:
          - task: Bash@3
            displayName: 'Authenticate to Conjur'
            inputs:
              targetType: 'inline'
              script: |
                CONJUR_TOKEN=$(curl -s -X POST \
                  "$(CONJUR_URL)/authn/$(CONJUR_ACCOUNT)/host%2Fci-cd%2Fazure%2F$(System.TeamProject)/authenticate" \
                  -H "Content-Type: text/plain" \
                  -d "$(CONJUR_API_KEY)" | base64 | tr -d '\n')
                echo "##vso[task.setvariable variable=CONJUR_TOKEN;issecret=true]$CONJUR_TOKEN"

          - task: Bash@3
            displayName: 'Get Docker Credentials'
            inputs:
              targetType: 'inline'
              script: |
                DOCKER_USER=$(curl -s \
                  -H "Authorization: Token token=\"$(CONJUR_TOKEN)\"" \
                  "$(CONJUR_URL)/secrets/$(CONJUR_ACCOUNT)/variable/ci-cd%2Fazure%2Fdocker%2Fusername")
                DOCKER_PASS=$(curl -s \
                  -H "Authorization: Token token=\"$(CONJUR_TOKEN)\"" \
                  "$(CONJUR_URL)/secrets/$(CONJUR_ACCOUNT)/variable/ci-cd%2Fazure%2Fdocker%2Fpassword")
                echo "##vso[task.setvariable variable=DOCKER_USER]$DOCKER_USER"
                echo "##vso[task.setvariable variable=DOCKER_PASS;issecret=true]$DOCKER_PASS"

          - task: Docker@2
            displayName: 'Build and Push'
            inputs:
              containerRegistry: 'dockerServiceConnection'
              repository: 'myapp'
              command: 'buildAndPush'
              tags: '$(Build.BuildId)'
```

### Azure Key Vault Integration

```yaml
# Using Azure Key Vault directly
stages:
  - stage: Deploy
    jobs:
      - job: Deploy
        steps:
          - task: AzureKeyVault@2
            inputs:
              azureSubscription: 'myAzureSubscription'
              KeyVaultName: 'myKeyVault'
              SecretsFilter: 'database-password,api-key'
              RunAsPreJob: true

          - task: Bash@3
            displayName: 'Use Secrets'
            inputs:
              targetType: 'inline'
              script: |
                echo "Database password available as $(database-password)"
                ./deploy.sh
```

---

## Conjur CI/CD Patterns

### Conjur Policy for CI/CD

```yaml
# ci-cd-policy.yml
# Root CI/CD Policy
- !policy
  id: ci-cd
  body:
    # CI/CD platforms as sub-policies
    - !policy
      id: jenkins
      body:
        - !layer
        - !host master
        - !host build-agent-01
        - !host build-agent-02

        - !grant
          role: !layer
          members:
            - !host master
            - !host build-agent-01
            - !host build-agent-02

        # Jenkins-specific secrets
        - !variable docker/username
        - !variable docker/password
        - !variable sonarqube/token
        - !variable artifactory/api-key

        - !permit
          role: !layer
          privileges: [read, execute]
          resources:
            - !variable docker/username
            - !variable docker/password
            - !variable sonarqube/token
            - !variable artifactory/api-key

    - !policy
      id: gitlab
      body:
        - !layer
        - !host runner-01
        - !host runner-02

        - !grant
          role: !layer
          members:
            - !host runner-01
            - !host runner-02

        - !variable docker/username
        - !variable docker/password
        - !variable k8s/staging-kubeconfig
        - !variable k8s/prod-kubeconfig

        - !permit
          role: !layer
          privileges: [read, execute]
          resources:
            - !variable docker/username
            - !variable docker/password
            - !variable k8s/staging-kubeconfig
            - !variable k8s/prod-kubeconfig

    - !policy
      id: github
      body:
        - !layer
        # GitHub repos as hosts
        - !host myorg/repo1
        - !host myorg/repo2

        - !grant
          role: !layer
          members:
            - !host myorg/repo1
            - !host myorg/repo2

        - !variable docker/username
        - !variable docker/password
        - !variable aws/access-key-id
        - !variable aws/secret-access-key

        - !permit
          role: !layer
          privileges: [read, execute]
          resources:
            - !variable docker/username
            - !variable docker/password
            - !variable aws/access-key-id
            - !variable aws/secret-access-key

    # Shared CI/CD secrets
    - !policy
      id: shared
      body:
        - !variable encryption/signing-key
        - !variable monitoring/datadog-api-key
        - !variable slack/webhook-url

        # All CI/CD layers can access shared secrets
        - !permit
          role: !layer /ci-cd/jenkins
          privileges: [read, execute]
          resources:
            - !variable encryption/signing-key
            - !variable monitoring/datadog-api-key

        - !permit
          role: !layer /ci-cd/gitlab
          privileges: [read, execute]
          resources:
            - !variable encryption/signing-key
            - !variable monitoring/datadog-api-key

        - !permit
          role: !layer /ci-cd/github
          privileges: [read, execute]
          resources:
            - !variable encryption/signing-key
            - !variable monitoring/datadog-api-key
```

### Environment-Specific Secrets

```yaml
# environment-secrets-policy.yml
- !policy
  id: environments
  body:
    - !policy
      id: development
      body:
        - !variable database/host
        - !variable database/password
        - !variable api/endpoint

    - !policy
      id: staging
      body:
        - !variable database/host
        - !variable database/password
        - !variable api/endpoint

    - !policy
      id: production
      body:
        - !variable database/host
        - !variable database/password
        - !variable api/endpoint

    # Deployment hosts
    - !host deploy-dev
    - !host deploy-staging
    - !host deploy-prod

    # Dev can access development
    - !permit
      role: !host deploy-dev
      privileges: [read, execute]
      resources:
        - !variable development/database/host
        - !variable development/database/password
        - !variable development/api/endpoint

    # Staging can access staging
    - !permit
      role: !host deploy-staging
      privileges: [read, execute]
      resources:
        - !variable staging/database/host
        - !variable staging/database/password
        - !variable staging/api/endpoint

    # Production requires additional approval (separate host)
    - !permit
      role: !host deploy-prod
      privileges: [read, execute]
      resources:
        - !variable production/database/host
        - !variable production/database/password
        - !variable production/api/endpoint
```

---

## Cloud Native Secrets

### AWS Secrets Manager in CI/CD

```yaml
# GitHub Actions with AWS Secrets Manager
name: Deploy with AWS Secrets

on:
  push:
    branches: [main]

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Get Secrets
        uses: aws-actions/aws-secretsmanager-get-secrets@v1
        with:
          secret-ids: |
            DB_PASSWORD,prod/myapp/database
            API_KEY,prod/myapp/api-key

      - name: Deploy
        run: |
          echo "Database password: ${{ env.DB_PASSWORD }}"
          ./deploy.sh
```

### Azure Key Vault in CI/CD

```yaml
# GitHub Actions with Azure Key Vault
name: Deploy with Azure Key Vault

on:
  push:
    branches: [main]

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Azure Login
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Get Key Vault Secrets
        uses: azure/get-keyvault-secrets@v1
        with:
          keyvault: "myKeyVault"
          secrets: 'database-password, api-key'
        id: keyvault

      - name: Deploy
        run: |
          echo "Using secrets from Key Vault"
          ./deploy.sh
        env:
          DB_PASSWORD: ${{ steps.keyvault.outputs.database-password }}
          API_KEY: ${{ steps.keyvault.outputs.api-key }}
```

### GCP Secret Manager in CI/CD

```yaml
# GitHub Actions with GCP Secret Manager
name: Deploy with GCP Secrets

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write

    steps:
      - uses: actions/checkout@v4

      - id: auth
        uses: google-github-actions/auth@v1
        with:
          workload_identity_provider: 'projects/123456/locations/global/workloadIdentityPools/github-pool/providers/github-provider'
          service_account: 'github-actions@project.iam.gserviceaccount.com'

      - name: Get Secrets
        id: secrets
        uses: google-github-actions/get-secretmanager-secrets@v1
        with:
          secrets: |-
            db-password:projects/my-project/secrets/database-password
            api-key:projects/my-project/secrets/api-key

      - name: Deploy
        run: |
          ./deploy.sh
        env:
          DB_PASSWORD: '${{ steps.secrets.outputs.db-password }}'
          API_KEY: '${{ steps.secrets.outputs.api-key }}'
```

---

## Security Best Practices

### Pipeline Security Checklist

**Code & Repository**:
- [ ] No secrets in code or configuration files
- [ ] `.gitignore` excludes sensitive files
- [ ] Pre-commit hooks scan for secrets (git-secrets, gitleaks)
- [ ] Branch protection rules enabled
- [ ] Signed commits required

**CI/CD Configuration**:
- [ ] Pipeline configuration files reviewed for security
- [ ] Secrets stored in secure secret manager
- [ ] Secrets masked in logs
- [ ] Minimal permissions for pipeline service accounts
- [ ] Separate credentials per environment

**Build Process**:
- [ ] Base images from trusted registries
- [ ] Images scanned for vulnerabilities
- [ ] Dependencies scanned (SCA)
- [ ] SAST scanning enabled
- [ ] No secrets baked into images

**Deployment**:
- [ ] Secrets injected at runtime, not build time
- [ ] Production deployments require approval
- [ ] Audit logging enabled
- [ ] Rollback procedures documented

### Secret Scanning Tools

**Pre-commit Scanning**:
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks

  - repo: https://github.com/awslabs/git-secrets
    rev: master
    hooks:
      - id: git-secrets
```

**Pipeline Scanning**:
```yaml
# GitHub Actions secret scanning
- name: Scan for secrets
  uses: gitleaks/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Audit and Compliance

**Logging Requirements**:
```bash
# Conjur audit log query
conjur audit resources -k variable --since "24 hours ago"

# AWS CloudTrail for Secrets Manager
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventSource,AttributeValue=secretsmanager.amazonaws.com
```

**Compliance Reporting**:
```python
# Generate secrets access report
import conjur
from datetime import datetime, timedelta

client = conjur.Client()

# Get audit events for last 30 days
events = client.audit(
    resource_type='variable',
    since=datetime.now() - timedelta(days=30)
)

# Generate compliance report
for event in events:
    print(f"{event.timestamp} | {event.action} | {event.resource} | {event.user}")
```

---

## Troubleshooting

### Common Issues

**1. Authentication Failures**

```bash
# Check Conjur connectivity
curl -v https://conjur.example.com/health

# Verify host identity
conjur whoami

# Test authentication
curl -X POST \
  "https://conjur.example.com/authn/myorg/host%2Fci-cd%2Fjenkins%2Fmaster/authenticate" \
  -H "Content-Type: text/plain" \
  -d "YOUR_API_KEY" -v
```

**2. Permission Denied**

```bash
# Check permissions
conjur resource permitted_roles variable:ci-cd/jenkins/docker/password read

# Verify host is in correct layer
conjur role members layer:ci-cd/jenkins
```

**3. Secrets Not Masking in Logs**

```yaml
# GitHub Actions - ensure masking
- name: Get Secret
  run: |
    SECRET=$(get_secret)
    echo "::add-mask::${SECRET}"
    echo "SECRET=${SECRET}" >> $GITHUB_ENV
```

**4. Token Expiration**

```bash
# Conjur tokens expire after 8 minutes by default
# Refresh token in long-running jobs

refresh_token() {
  CONJUR_TOKEN=$(curl -s -X POST \
    "${CONJUR_URL}/authn/${CONJUR_ACCOUNT}/${CONJUR_LOGIN}/authenticate" \
    -d "${CONJUR_API_KEY}" | base64 | tr -d '\n')
}

# Call periodically in long jobs
```

### Debug Mode

```yaml
# Jenkins - enable debug
pipeline {
    options {
        timestamps()
    }
    stages {
        stage('Debug') {
            steps {
                sh 'set -x'  # Enable bash debug
                sh 'curl -v ...'  # Verbose curl
            }
        }
    }
}
```

```yaml
# GitHub Actions - enable debug
env:
  ACTIONS_STEP_DEBUG: true
```

---

## Related Documents

- **Phase 2 Labs**: [HANDS_ON_LABS_PHASE2.md](HANDS_ON_LABS_PHASE2.md)
- **Multi-Cloud Patterns**: [MULTICLOUD_PATTERNS.md](MULTICLOUD_PATTERNS.md)
- **Security Best Practices**: [CKS_CHEAT_SHEETS.md](CKS_CHEAT_SHEETS.md)
- **Conjur Documentation**: [HANDS_ON_LABS_PHASE2.md#conjur-docker-deployment](HANDS_ON_LABS_PHASE2.md#conjur-docker-deployment)

---

## External References

- [Jenkins Credentials Plugin](https://plugins.jenkins.io/credentials/)
- [GitLab CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Azure DevOps Variable Groups](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups)
- [CyberArk Conjur Documentation](https://docs.conjur.org/)
- [OWASP CI/CD Security](https://owasp.org/www-project-devsecops-guideline/)

---

**Last Updated**: 2025-12-04
**Version**: 1.0
