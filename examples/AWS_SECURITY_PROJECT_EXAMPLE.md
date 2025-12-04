# AWS Security Implementation Project Example

> Real-world example of AWS security services implementation with CyberArk integration

---

## Project Overview

### Client Profile
| Field | Details |
|-------|---------|
| **Industry** | Healthcare Technology |
| **Company Size** | 2,500 employees |
| **AWS Footprint** | 3 accounts, 150+ EC2 instances |
| **Project Duration** | 12 weeks |
| **Budget** | $180,000 |

### Business Drivers
- HIPAA compliance requirements
- AWS security assessment findings
- Need for centralized IAM management
- Secrets sprawl in AWS Secrets Manager
- No visibility into privileged access

---

## Project Scope

### In Scope
- AWS IAM hardening and centralization
- AWS Secrets Manager integration with Conjur
- CyberArk PAM for AWS console access
- AWS CloudTrail and Config setup
- Security Hub enablement
- GuardDuty threat detection
- KMS key management standardization

### Architecture Overview
```
┌─────────────────────────────────────────────────────────────────────────┐
│                    AWS Security Architecture                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  AWS Organization                                                       │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                                                                   │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │   │
│  │  │ Security    │  │ Production  │  │ Development │              │   │
│  │  │ Account     │  │ Account     │  │ Account     │              │   │
│  │  │             │  │             │  │             │              │   │
│  │  │ • Security  │  │ • EC2       │  │ • EC2       │              │   │
│  │  │   Hub       │  │ • RDS       │  │ • RDS       │              │   │
│  │  │ • GuardDuty │  │ • EKS       │  │ • S3        │              │   │
│  │  │ • Config    │  │ • Lambda    │  │ • Lambda    │              │   │
│  │  │ • CloudTrail│  │ • S3        │  │             │              │   │
│  │  │ • KMS       │  │             │  │             │              │   │
│  │  │   (Central) │  │             │  │             │              │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘              │   │
│  │         │                │                │                       │   │
│  │         └────────────────┼────────────────┘                       │   │
│  │                          │                                         │   │
│  └──────────────────────────┼─────────────────────────────────────────┘   │
│                             │                                             │
│                   ┌─────────▼─────────┐                                  │
│                   │   On-Premises      │                                  │
│                   ├───────────────────┤                                  │
│                   │ • CyberArk Vault  │                                  │
│                   │ • Conjur Leader   │                                  │
│                   │ • PVWA/PSM        │                                  │
│                   │ • SIEM (Splunk)   │                                  │
│                   └───────────────────┘                                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Implementation Details

### Phase 1: IAM Hardening (Weeks 1-3)

#### IAM Assessment Results
| Finding | Severity | Count | Resolution |
|---------|----------|-------|------------|
| Root account MFA missing | Critical | 2 | MFA enabled |
| Unused IAM users | High | 45 | Removed |
| Overly permissive policies | High | 28 | Least privilege applied |
| Access keys > 90 days | Medium | 67 | Rotated |
| No password policy | Medium | 3 | Policy enforced |

#### IAM Structure Implementation
```hcl
# terraform/iam/main.tf

# Create organizational units
resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.main.roots[0].id
}

# Service Control Policy - Deny root account usage
resource "aws_organizations_policy" "deny_root" {
  name        = "DenyRootAccountUsage"
  description = "Deny all actions for root account"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyRootUser"
        Effect    = "Deny"
        Action    = "*"
        Resource  = "*"
        Condition = {
          StringLike = {
            "aws:PrincipalArn" = "arn:aws:iam::*:root"
          }
        }
      }
    ]
  })
}

# IAM Identity Center (SSO) configuration
resource "aws_ssoadmin_permission_set" "admin" {
  name             = "AdministratorAccess"
  instance_arn     = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  session_duration = "PT4H"

  tags = {
    ManagedBy = "Terraform"
  }
}

# Custom managed policy for developers
resource "aws_iam_policy" "developer_policy" {
  name        = "DeveloperAccess"
  description = "Standard developer access policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2ReadOnly"
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:Get*"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3LimitedAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.dev_bucket}",
          "arn:aws:s3:::${var.dev_bucket}/*"
        ]
      },
      {
        Sid    = "DenyHighPrivilege"
        Effect = "Deny"
        Action = [
          "iam:*",
          "organizations:*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion"
        ]
        Resource = "*"
      }
    ]
  })
}
```

### Phase 2: CyberArk AWS Integration (Weeks 4-6)

#### AWS IAM Keys in CyberArk
```powershell
# Add-AWSCredentialsToCyberArk.ps1

$vaultConfig = @{
    PVWAURL = "https://pvwa.healthtech.com"
    SafeName = "AWS_IAM_Keys"
    PlatformID = "AWSAccessKeys"
}

# Import AWS credentials
$awsAccounts = @(
    @{
        AccountName = "prod-deploy-user"
        Environment = "Production"
        AccessKeyId = "AKIAIOSFODNN7EXAMPLE"
        Region = "us-east-1"
    },
    @{
        AccountName = "dev-deploy-user"
        Environment = "Development"
        AccessKeyId = "AKIAI44QH8DHBEXAMPLE"
        Region = "us-east-1"
    }
)

foreach ($account in $awsAccounts) {
    $body = @{
        safeName = $vaultConfig.SafeName
        platformId = $vaultConfig.PlatformID
        address = "aws.amazon.com"
        userName = $account.AccessKeyId
        secretType = "password"
        secret = (Get-SecretAccessKey -AccessKeyId $account.AccessKeyId)
        platformAccountProperties = @{
            AWSRegion = $account.Region
            Environment = $account.Environment
        }
    } | ConvertTo-Json

    Invoke-RestMethod -Uri "$($vaultConfig.PVWAURL)/PasswordVault/api/Accounts" `
        -Method POST `
        -Headers $authHeaders `
        -Body $body `
        -ContentType "application/json"

    Write-Host "Added: $($account.AccountName)"
}
```

#### CyberArk AWS Console Access via PSM
```xml
<!-- PSM-AWS-Connector.xml -->
<ConnectionComponent Id="PSM-AWS-Console" Type="WebApp">
  <General>
    <Name>AWS Console via PSM</Name>
    <Description>Secure AWS Console access</Description>
    <WebProtocol>https</WebProtocol>
    <WebPort>443</WebPort>
  </General>

  <Authentication>
    <Mode>SAML</Mode>
    <SAMLProvider>CyberArk</SAMLProvider>
    <RoleARN>{AWSRoleARN}</RoleARN>
    <SessionDuration>3600</SessionDuration>
  </Authentication>

  <Recording>
    <Enabled>true</Enabled>
    <RecordKeystrokes>true</RecordKeystrokes>
    <RecordClicks>true</RecordClicks>
  </Recording>

  <SessionManagement>
    <MaxIdleTime>900</MaxIdleTime>
    <MaxSessionTime>14400</MaxSessionTime>
  </SessionManagement>
</ConnectionComponent>
```

### Phase 3: Security Services (Weeks 7-9)

#### Security Hub Configuration
```hcl
# terraform/security/security_hub.tf

resource "aws_securityhub_account" "main" {}

# Enable CIS AWS Foundations Benchmark
resource "aws_securityhub_standards_subscription" "cis" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

# Enable AWS Foundational Security Best Practices
resource "aws_securityhub_standards_subscription" "aws_best_practices" {
  depends_on    = [aws_securityhub_account.main]
  standards_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# Custom action for CyberArk integration
resource "aws_securityhub_action_target" "cyberark_alert" {
  name        = "SendToCyberArk"
  identifier  = "CyberArkAlert"
  description = "Send finding to CyberArk for privileged access review"
}

# EventBridge rule for critical findings
resource "aws_cloudwatch_event_rule" "critical_findings" {
  name        = "security-hub-critical-findings"
  description = "Route critical Security Hub findings"

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = {
          Label = ["CRITICAL", "HIGH"]
        }
        Workflow = {
          Status = ["NEW"]
        }
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_processor" {
  rule      = aws_cloudwatch_event_rule.critical_findings.name
  target_id = "ProcessSecurityFinding"
  arn       = aws_lambda_function.security_processor.arn
}
```

#### GuardDuty Configuration
```hcl
# terraform/security/guardduty.tf

resource "aws_guardduty_detector" "main" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = true
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }

  finding_publishing_frequency = "FIFTEEN_MINUTES"

  tags = {
    Environment = "Security"
    ManagedBy   = "Terraform"
  }
}

# GuardDuty member accounts
resource "aws_guardduty_member" "production" {
  account_id         = var.production_account_id
  detector_id        = aws_guardduty_detector.main.id
  email              = "security@healthtech.com"
  invite             = true
  invitation_message = "GuardDuty monitoring invitation"
}

# Threat intelligence feed
resource "aws_guardduty_threatintelset" "custom" {
  activate    = true
  detector_id = aws_guardduty_detector.main.id
  format      = "TXT"
  location    = "s3://${aws_s3_bucket.security.bucket}/threat-intel/malicious-ips.txt"
  name        = "CustomThreatIntel"
}

# SNS for alerting
resource "aws_sns_topic" "guardduty_alerts" {
  name = "guardduty-alerts"
}

resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  name        = "guardduty-high-severity"
  description = "GuardDuty high severity findings"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
    detail = {
      severity = [{ numeric = [">=", 7] }]
    }
  })
}
```

#### CloudTrail Configuration
```hcl
# terraform/security/cloudtrail.tf

resource "aws_cloudtrail" "organization" {
  name                          = "healthtech-org-trail"
  s3_bucket_name               = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail        = true
  is_organization_trail        = true
  enable_log_file_validation   = true
  kms_key_id                   = aws_kms_key.cloudtrail.arn

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  insight_selector {
    insight_type = "ApiCallRateInsight"
  }

  insight_selector {
    insight_type = "ApiErrorRateInsight"
  }

  tags = {
    Environment = "Security"
    Compliance  = "HIPAA"
  }
}

# CloudWatch Metric Filters for security events
resource "aws_cloudwatch_log_metric_filter" "root_login" {
  name           = "RootAccountLogin"
  pattern        = "{ $.userIdentity.type = Root && $.userIdentity.invokedBy NOT EXISTS && $.eventType != AwsServiceEvent }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name

  metric_transformation {
    name          = "RootLoginCount"
    namespace     = "SecurityMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "unauthorized_api" {
  name           = "UnauthorizedAPICalls"
  pattern        = "{ ($.errorCode = *UnauthorizedAccess*) || ($.errorCode = AccessDenied*) }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name

  metric_transformation {
    name          = "UnauthorizedAPICount"
    namespace     = "SecurityMetrics"
    value         = "1"
    default_value = "0"
  }
}

# Alarm for root account usage
resource "aws_cloudwatch_metric_alarm" "root_usage" {
  alarm_name          = "RootAccountUsage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RootLoginCount"
  namespace           = "SecurityMetrics"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Root account was used"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}
```

### Phase 4: Secrets Integration (Weeks 10-12)

#### Conjur AWS IAM Authenticator
```yaml
# conjur-aws-authn-policy.yml
- !policy
  id: authn-iam
  body:
    - !webservice aws

    - !variable aws-account-id

    - !group ec2-instances
    - !group lambda-functions
    - !group ecs-tasks

    - !permit
      role: !group ec2-instances
      privileges: [read, authenticate]
      resource: !webservice aws

    - !permit
      role: !group lambda-functions
      privileges: [read, authenticate]
      resource: !webservice aws

    - !permit
      role: !group ecs-tasks
      privileges: [read, authenticate]
      resource: !webservice aws

# Define AWS identities
- !host
  id: aws/arn:aws:iam::111111111111:role/production-app-role
  annotations:
    authn-iam/aws: true

- !host
  id: aws/arn:aws:iam::111111111111:role/lambda-processor-role
  annotations:
    authn-iam/aws: true

# Grant membership
- !grant
  role: !group authn-iam/aws/ec2-instances
  member: !host aws/arn:aws:iam::111111111111:role/production-app-role

- !grant
  role: !group authn-iam/aws/lambda-functions
  member: !host aws/arn:aws:iam::111111111111:role/lambda-processor-role
```

#### Lambda Function with Conjur
```python
# lambda_function.py - Lambda with Conjur secrets retrieval

import json
import boto3
import requests
from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest
import base64

CONJUR_URL = "https://conjur.healthtech.com"
CONJUR_ACCOUNT = "healthtech"

def get_conjur_token():
    """Authenticate to Conjur using AWS IAM"""
    session = boto3.Session()
    credentials = session.get_credentials()
    region = session.region_name

    # Build STS GetCallerIdentity request for Conjur
    sts_endpoint = f"https://sts.{region}.amazonaws.com"
    request = AWSRequest(
        method='POST',
        url=sts_endpoint,
        data='Action=GetCallerIdentity&Version=2011-06-15',
        headers={
            'Content-Type': 'application/x-www-form-urlencoded',
            'Host': f'sts.{region}.amazonaws.com'
        }
    )

    SigV4Auth(credentials, 'sts', region).add_auth(request)

    # Exchange with Conjur
    conjur_auth_url = f"{CONJUR_URL}/authn-iam/aws/{CONJUR_ACCOUNT}/authenticate"

    response = requests.post(
        conjur_auth_url,
        headers=dict(request.headers),
        data=request.data,
        verify=True
    )

    if response.status_code == 200:
        return base64.b64encode(response.content).decode('utf-8')
    else:
        raise Exception(f"Conjur auth failed: {response.text}")

def get_secret(token, variable_id):
    """Retrieve secret from Conjur"""
    encoded_id = requests.utils.quote(variable_id, safe='')
    url = f"{CONJUR_URL}/secrets/{CONJUR_ACCOUNT}/variable/{encoded_id}"

    response = requests.get(
        url,
        headers={'Authorization': f'Token token="{token}"'},
        verify=True
    )

    if response.status_code == 200:
        return response.text
    else:
        raise Exception(f"Secret retrieval failed: {response.status_code}")

def lambda_handler(event, context):
    """Main Lambda handler"""
    try:
        # Get Conjur token
        token = get_conjur_token()

        # Retrieve database credentials
        db_host = get_secret(token, "infrastructure/databases/prod/host")
        db_user = get_secret(token, "infrastructure/databases/prod/username")
        db_pass = get_secret(token, "infrastructure/databases/prod/password")

        # Process event with credentials
        # ... business logic ...

        return {
            'statusCode': 200,
            'body': json.dumps({'status': 'success'})
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
```

---

## Compliance Mapping

### HIPAA Security Rule Mapping
| Control | AWS Implementation | Status |
|---------|-------------------|--------|
| Access Control (164.312a1) | IAM policies, MFA | Compliant |
| Audit Controls (164.312b) | CloudTrail, CloudWatch | Compliant |
| Integrity (164.312c1) | KMS encryption | Compliant |
| Transmission Security (164.312e1) | TLS, VPC endpoints | Compliant |
| Automatic Logoff (164.312a2iii) | Session timeouts | Compliant |
| Encryption (164.312a2iv) | KMS, S3 SSE | Compliant |

### CIS AWS Benchmark Results
| Section | Controls | Passed | Failed | Score |
|---------|----------|--------|--------|-------|
| IAM | 22 | 21 | 1 | 95% |
| Logging | 11 | 11 | 0 | 100% |
| Monitoring | 14 | 13 | 1 | 93% |
| Networking | 5 | 5 | 0 | 100% |
| **Total** | **52** | **50** | **2** | **96%** |

---

## Project Outcomes

### Security Improvements
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Security Hub score | 45% | 96% | +51% |
| IAM findings | 142 | 8 | 94% reduction |
| Unrotated keys | 67 | 0 | 100% |
| MFA coverage | 40% | 100% | +60% |
| Secrets in code | 23 | 0 | 100% |

### Cost Impact
| Category | Monthly Cost | Notes |
|----------|--------------|-------|
| Security Hub | $150 | Per account |
| GuardDuty | $450 | Based on event volume |
| CloudTrail | $200 | Multi-region |
| Config | $180 | Rule evaluations |
| KMS | $50 | Key usage |
| **Total** | **$1,030/month** | |

### ROI Analysis
- Estimated breach cost avoided: $4.5M (healthcare average)
- Annual security service cost: $12,360
- Compliance audit savings: $50,000/year
- Operational efficiency: $30,000/year
- **Net annual benefit: $67,640+**

---

## Related Documents
- [HANDS_ON_LABS_PHASE3.md](../docs/HANDS_ON_LABS_PHASE3.md) - AWS security labs
- [MULTICLOUD_PATTERNS.md](../docs/MULTICLOUD_PATTERNS.md) - Multi-cloud security
- [DEVOPS_CI_CD_GUIDE.md](../docs/DEVOPS_CI_CD_GUIDE.md) - CI/CD integration

---

*Last Updated: 2025-12-04*
*Version: 1.0*
