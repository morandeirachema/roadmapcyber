# Hands-On Labs: Phase 3 - Cloud Security + CCSP Mastery

Practical lab exercises with actual commands for Months 19-27. These labs complement CCSP certification study with hands-on AWS and Azure security implementations.

**Prerequisites**:
- Phase 1 and Phase 2 completed
- AWS account (free tier acceptable for most labs)
- Azure account (free tier acceptable for most labs)
- AWS CLI and Azure CLI installed
- Terraform installed (for IaC labs)
- kubectl configured

**Lab Environment**: Builds on Phase 1-2 infrastructure with cloud provider additions.

---

## Table of Contents

1. [AWS IAM Deep Dive](#aws-iam-deep-dive)
2. [AWS Security Services](#aws-security-services)
3. [AWS Compliance and Auditing](#aws-compliance-and-auditing)
4. [Azure AD / Entra ID](#azure-ad--entra-id)
5. [Azure Security Services](#azure-security-services)
6. [Azure Compliance](#azure-compliance)
7. [Multi-Cloud Security Architecture](#multi-cloud-security-architecture)
8. [CCSP Domain Labs](#ccsp-domain-labs)
9. [Compliance Framework Implementation](#compliance-framework-implementation)
10. [Capstone Integration Labs](#capstone-integration-labs)
11. [Troubleshooting Commands](#troubleshooting-commands)

---

## AWS IAM Deep Dive

### Lab 1.1: IAM Users, Groups, and Policies (Month 19, Week 73)

```bash
# Configure AWS CLI
aws configure
# Enter: Access Key ID, Secret Access Key, Region (us-east-1), Output (json)

# Create IAM group for developers
aws iam create-group --group-name Developers

# Create IAM group for operations
aws iam create-group --group-name Operations

# Create custom policy for developers (limited EC2 access)
cat <<'EOF' > developer-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EC2ReadOnly",
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:Get*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3LimitedAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::dev-*",
                "arn:aws:s3:::dev-*/*"
            ]
        },
        {
            "Sid": "CloudWatchLogs",
            "Effect": "Allow",
            "Action": [
                "logs:GetLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        }
    ]
}
EOF

# Create the policy
aws iam create-policy \
    --policy-name DeveloperPolicy \
    --policy-document file://developer-policy.json

# Get your account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Attach policy to group
aws iam attach-group-policy \
    --group-name Developers \
    --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/DeveloperPolicy

# Create IAM user
aws iam create-user --user-name dev-user-01

# Add user to group
aws iam add-user-to-group \
    --user-name dev-user-01 \
    --group-name Developers

# Create login profile (console access)
aws iam create-login-profile \
    --user-name dev-user-01 \
    --password 'TempP@ss123!' \
    --password-reset-required

# Create access keys (programmatic access)
aws iam create-access-key --user-name dev-user-01

# List user's effective permissions
aws iam list-attached-group-policies --group-name Developers
aws iam list-group-policies --group-name Developers
```

### Lab 1.2: IAM Roles and STS (Month 19, Week 74-75)

```bash
# Create trust policy for EC2 to assume role
cat <<'EOF' > ec2-trust-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

# Create role for EC2 instances
aws iam create-role \
    --role-name EC2-S3-Access-Role \
    --assume-role-policy-document file://ec2-trust-policy.json

# Create policy for S3 access
cat <<'EOF' > s3-access-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::my-app-bucket",
                "arn:aws:s3:::my-app-bucket/*"
            ]
        }
    ]
}
EOF

aws iam create-policy \
    --policy-name S3AppAccessPolicy \
    --policy-document file://s3-access-policy.json

# Attach policy to role
aws iam attach-role-policy \
    --role-name EC2-S3-Access-Role \
    --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/S3AppAccessPolicy

# Create instance profile
aws iam create-instance-profile \
    --instance-profile-name EC2-S3-Access-Profile

# Add role to instance profile
aws iam add-role-to-instance-profile \
    --instance-profile-name EC2-S3-Access-Profile \
    --role-name EC2-S3-Access-Role

# Create cross-account role (for multi-account setups)
cat <<'EOF' > cross-account-trust.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::TARGET_ACCOUNT_ID:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "unique-external-id-12345"
                }
            }
        }
    ]
}
EOF

# Test STS assume role
aws sts assume-role \
    --role-arn arn:aws:iam::${ACCOUNT_ID}:role/EC2-S3-Access-Role \
    --role-session-name test-session \
    --duration-seconds 3600

# Get temporary credentials
CREDS=$(aws sts assume-role \
    --role-arn arn:aws:iam::${ACCOUNT_ID}:role/EC2-S3-Access-Role \
    --role-session-name test-session \
    --query 'Credentials')

echo $CREDS | jq
```

### Lab 1.3: IAM Policy Conditions and Boundaries

```bash
# Create policy with conditions
cat <<'EOF' > conditional-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowEC2ActionsInRegion",
            "Effect": "Allow",
            "Action": [
                "ec2:RunInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": ["us-east-1", "us-west-2"]
                }
            }
        },
        {
            "Sid": "AllowOnlyTaggedResources",
            "Effect": "Allow",
            "Action": [
                "ec2:StopInstances",
                "ec2:StartInstances"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/Environment": "Development"
                }
            }
        },
        {
            "Sid": "EnforceMFA",
            "Effect": "Deny",
            "Action": [
                "ec2:TerminateInstances",
                "iam:*"
            ],
            "Resource": "*",
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            }
        },
        {
            "Sid": "RestrictByIP",
            "Effect": "Deny",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": ["203.0.113.0/24", "198.51.100.0/24"]
                }
            }
        }
    ]
}
EOF

# Create permission boundary
cat <<'EOF' > permission-boundary.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowedServices",
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "s3:*",
                "rds:*",
                "lambda:*",
                "cloudwatch:*",
                "logs:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "DenyIAMAdminExceptPassRole",
            "Effect": "Deny",
            "Action": [
                "iam:CreateUser",
                "iam:DeleteUser",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:AttachUserPolicy",
                "iam:AttachRolePolicy",
                "iam:PutUserPermissionsBoundary",
                "iam:PutRolePermissionsBoundary"
            ],
            "Resource": "*"
        },
        {
            "Sid": "DenyOrganizationChanges",
            "Effect": "Deny",
            "Action": "organizations:*",
            "Resource": "*"
        }
    ]
}
EOF

aws iam create-policy \
    --policy-name DeveloperPermissionBoundary \
    --policy-document file://permission-boundary.json

# Apply permission boundary to user
aws iam put-user-permissions-boundary \
    --user-name dev-user-01 \
    --permissions-boundary arn:aws:iam::${ACCOUNT_ID}:policy/DeveloperPermissionBoundary
```

---

## AWS Security Services

### Lab 2.1: AWS KMS - Key Management Service (Month 20, Week 77)

```bash
# Create a customer managed key (CMK)
aws kms create-key \
    --description "Application encryption key" \
    --key-usage ENCRYPT_DECRYPT \
    --origin AWS_KMS \
    --tags TagKey=Environment,TagValue=Production

# Get the Key ID from output and store it
KEY_ID="your-key-id-here"

# Create an alias for the key
aws kms create-alias \
    --alias-name alias/app-encryption-key \
    --target-key-id $KEY_ID

# Create key policy
cat <<'EOF' > key-policy.json
{
    "Version": "2012-10-17",
    "Id": "app-key-policy",
    "Statement": [
        {
            "Sid": "Enable IAM policies",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::ACCOUNT_ID:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow key administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::ACCOUNT_ID:role/KeyAdministrators"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::ACCOUNT_ID:role/EC2-S3-Access-Role"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::ACCOUNT_ID:role/EC2-S3-Access-Role"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
EOF

# Encrypt data
echo "Sensitive data to encrypt" > plaintext.txt
aws kms encrypt \
    --key-id alias/app-encryption-key \
    --plaintext fileb://plaintext.txt \
    --output text \
    --query CiphertextBlob > encrypted.b64

# Decrypt data
aws kms decrypt \
    --ciphertext-blob fileb://<(base64 -d encrypted.b64) \
    --output text \
    --query Plaintext | base64 -d

# Generate data key for envelope encryption
aws kms generate-data-key \
    --key-id alias/app-encryption-key \
    --key-spec AES_256

# Enable automatic key rotation
aws kms enable-key-rotation --key-id $KEY_ID

# Check rotation status
aws kms get-key-rotation-status --key-id $KEY_ID
```

### Lab 2.2: AWS Secrets Manager (Month 20, Week 78)

```bash
# Create a secret
aws secretsmanager create-secret \
    --name prod/myapp/database \
    --description "Production database credentials" \
    --secret-string '{"username":"admin","password":"SuperS3cr3t!","host":"db.example.com","port":"5432"}'

# Create secret with KMS encryption
aws secretsmanager create-secret \
    --name prod/myapp/api-keys \
    --kms-key-id alias/app-encryption-key \
    --secret-string '{"api_key":"ak_prod_12345","api_secret":"as_prod_67890"}'

# Retrieve secret
aws secretsmanager get-secret-value \
    --secret-id prod/myapp/database \
    --query SecretString \
    --output text | jq

# Enable automatic rotation
cat <<'EOF' > rotation-lambda.py
import boto3
import json
import string
import secrets

def lambda_handler(event, context):
    secret_id = event['SecretId']
    token = event['ClientRequestToken']
    step = event['Step']

    client = boto3.client('secretsmanager')

    if step == "createSecret":
        # Generate new password
        alphabet = string.ascii_letters + string.digits + "!@#$%^&*"
        new_password = ''.join(secrets.choice(alphabet) for i in range(24))

        # Get current secret
        current = client.get_secret_value(SecretId=secret_id)
        secret_dict = json.loads(current['SecretString'])
        secret_dict['password'] = new_password

        # Store pending secret
        client.put_secret_value(
            SecretId=secret_id,
            ClientRequestToken=token,
            SecretString=json.dumps(secret_dict),
            VersionStages=['AWSPENDING']
        )

    elif step == "setSecret":
        # Update the database password here
        pass

    elif step == "testSecret":
        # Test the new credentials
        pass

    elif step == "finishSecret":
        # Finalize rotation
        client.update_secret_version_stage(
            SecretId=secret_id,
            VersionStage='AWSCURRENT',
            MoveToVersionId=token,
            RemoveFromVersionId=client.get_secret_value(
                SecretId=secret_id,
                VersionStage='AWSCURRENT'
            )['VersionId']
        )

    return {"statusCode": 200}
EOF

# Configure rotation schedule (30 days)
aws secretsmanager rotate-secret \
    --secret-id prod/myapp/database \
    --rotation-lambda-arn arn:aws:lambda:us-east-1:${ACCOUNT_ID}:function:SecretsRotation \
    --rotation-rules '{"AutomaticallyAfterDays": 30}'

# Compare with Conjur - retrieve secret for application
# Python example
python3 << 'PYTHON'
import boto3
import json

def get_db_credentials():
    client = boto3.client('secretsmanager', region_name='us-east-1')
    response = client.get_secret_value(SecretId='prod/myapp/database')
    secret = json.loads(response['SecretString'])
    return secret

creds = get_db_credentials()
print(f"Host: {creds['host']}")
print(f"User: {creds['username']}")
PYTHON
```

### Lab 2.3: AWS VPC Security (Month 20, Week 79)

```bash
# Create VPC
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=SecureVPC}]' \
    --query 'Vpc.VpcId' \
    --output text)

# Enable DNS hostnames
aws ec2 modify-vpc-attribute \
    --vpc-id $VPC_ID \
    --enable-dns-hostnames

# Create public subnet
PUBLIC_SUBNET=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.1.0/24 \
    --availability-zone us-east-1a \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=PublicSubnet}]' \
    --query 'Subnet.SubnetId' \
    --output text)

# Create private subnet
PRIVATE_SUBNET=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.2.0/24 \
    --availability-zone us-east-1a \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=PrivateSubnet}]' \
    --query 'Subnet.SubnetId' \
    --output text)

# Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway \
    --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=SecureVPC-IGW}]' \
    --query 'InternetGateway.InternetGatewayId' \
    --output text)

aws ec2 attach-internet-gateway \
    --vpc-id $VPC_ID \
    --internet-gateway-id $IGW_ID

# Create NAT Gateway for private subnet
ELASTIC_IP=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)

NAT_GW=$(aws ec2 create-nat-gateway \
    --subnet-id $PUBLIC_SUBNET \
    --allocation-id $ELASTIC_IP \
    --tag-specifications 'ResourceType=natgateway,Tags=[{Key=Name,Value=SecureVPC-NAT}]' \
    --query 'NatGateway.NatGatewayId' \
    --output text)

# Create Security Groups
# Web tier SG
WEB_SG=$(aws ec2 create-security-group \
    --group-name web-tier-sg \
    --description "Security group for web tier" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id $WEB_SG \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id $WEB_SG \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# App tier SG (only allows traffic from web tier)
APP_SG=$(aws ec2 create-security-group \
    --group-name app-tier-sg \
    --description "Security group for application tier" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id $APP_SG \
    --protocol tcp \
    --port 8080 \
    --source-group $WEB_SG

# Database tier SG (only allows traffic from app tier)
DB_SG=$(aws ec2 create-security-group \
    --group-name db-tier-sg \
    --description "Security group for database tier" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id $DB_SG \
    --protocol tcp \
    --port 5432 \
    --source-group $APP_SG

# Create Network ACLs
NACL_ID=$(aws ec2 create-network-acl \
    --vpc-id $VPC_ID \
    --tag-specifications 'ResourceType=network-acl,Tags=[{Key=Name,Value=PrivateSubnet-NACL}]' \
    --query 'NetworkAcl.NetworkAclId' \
    --output text)

# Allow inbound from VPC CIDR
aws ec2 create-network-acl-entry \
    --network-acl-id $NACL_ID \
    --rule-number 100 \
    --protocol -1 \
    --rule-action allow \
    --ingress \
    --cidr-block 10.0.0.0/16

# Deny all other inbound
aws ec2 create-network-acl-entry \
    --network-acl-id $NACL_ID \
    --rule-number 200 \
    --protocol -1 \
    --rule-action deny \
    --ingress \
    --cidr-block 0.0.0.0/0

# Allow outbound to VPC and HTTPS to internet
aws ec2 create-network-acl-entry \
    --network-acl-id $NACL_ID \
    --rule-number 100 \
    --protocol -1 \
    --rule-action allow \
    --egress \
    --cidr-block 10.0.0.0/16

aws ec2 create-network-acl-entry \
    --network-acl-id $NACL_ID \
    --rule-number 110 \
    --protocol tcp \
    --port-range From=443,To=443 \
    --rule-action allow \
    --egress \
    --cidr-block 0.0.0.0/0

# Enable VPC Flow Logs
aws ec2 create-flow-logs \
    --resource-type VPC \
    --resource-ids $VPC_ID \
    --traffic-type ALL \
    --log-destination-type cloud-watch-logs \
    --log-group-name /aws/vpc/flow-logs \
    --deliver-logs-permission-arn arn:aws:iam::${ACCOUNT_ID}:role/FlowLogsRole
```

---

## AWS Compliance and Auditing

### Lab 3.1: AWS CloudTrail (Month 21, Week 81)

```bash
# Create S3 bucket for CloudTrail logs
aws s3api create-bucket \
    --bucket my-cloudtrail-logs-${ACCOUNT_ID} \
    --region us-east-1

# Create bucket policy for CloudTrail
cat <<EOF > cloudtrail-bucket-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::my-cloudtrail-logs-${ACCOUNT_ID}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::my-cloudtrail-logs-${ACCOUNT_ID}/AWSLogs/${ACCOUNT_ID}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF

aws s3api put-bucket-policy \
    --bucket my-cloudtrail-logs-${ACCOUNT_ID} \
    --policy file://cloudtrail-bucket-policy.json

# Create CloudTrail
aws cloudtrail create-trail \
    --name management-events-trail \
    --s3-bucket-name my-cloudtrail-logs-${ACCOUNT_ID} \
    --is-multi-region-trail \
    --enable-log-file-validation \
    --include-global-service-events \
    --kms-key-id alias/app-encryption-key

# Start logging
aws cloudtrail start-logging --name management-events-trail

# Create CloudWatch Log Group for CloudTrail
aws logs create-log-group --log-group-name /aws/cloudtrail/management-events

# Configure CloudTrail to send to CloudWatch
aws cloudtrail update-trail \
    --name management-events-trail \
    --cloud-watch-logs-log-group-arn arn:aws:logs:us-east-1:${ACCOUNT_ID}:log-group:/aws/cloudtrail/management-events \
    --cloud-watch-logs-role-arn arn:aws:iam::${ACCOUNT_ID}:role/CloudTrailCloudWatchRole

# Create data events trail for S3
aws cloudtrail put-event-selectors \
    --trail-name management-events-trail \
    --event-selectors '[
        {
            "ReadWriteType": "All",
            "IncludeManagementEvents": true,
            "DataResources": [
                {
                    "Type": "AWS::S3::Object",
                    "Values": ["arn:aws:s3:::my-sensitive-bucket/"]
                }
            ]
        }
    ]'

# Query CloudTrail events
aws cloudtrail lookup-events \
    --lookup-attributes AttributeKey=EventName,AttributeValue=ConsoleLogin \
    --start-time 2024-01-01T00:00:00Z \
    --end-time 2024-12-31T23:59:59Z \
    --query 'Events[].{Time:EventTime,User:Username,Event:EventName}' \
    --output table
```

### Lab 3.2: AWS Config (Month 21, Week 82)

```bash
# Enable AWS Config
aws configservice put-configuration-recorder \
    --configuration-recorder name=default,roleARN=arn:aws:iam::${ACCOUNT_ID}:role/AWSConfigRole \
    --recording-group allSupported=true,includeGlobalResourceTypes=true

# Create S3 bucket for Config
aws s3api create-bucket \
    --bucket my-aws-config-${ACCOUNT_ID} \
    --region us-east-1

# Configure delivery channel
aws configservice put-delivery-channel \
    --delivery-channel name=default,s3BucketName=my-aws-config-${ACCOUNT_ID},configSnapshotDeliveryProperties={deliveryFrequency=One_Hour}

# Start configuration recorder
aws configservice start-configuration-recorder --configuration-recorder-name default

# Add Config rules

# Rule: Ensure S3 buckets have encryption enabled
aws configservice put-config-rule \
    --config-rule '{
        "ConfigRuleName": "s3-bucket-server-side-encryption-enabled",
        "Description": "Checks that S3 buckets have server-side encryption enabled",
        "Source": {
            "Owner": "AWS",
            "SourceIdentifier": "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
        },
        "MaximumExecutionFrequency": "TwentyFour_Hours"
    }'

# Rule: Ensure IAM users have MFA enabled
aws configservice put-config-rule \
    --config-rule '{
        "ConfigRuleName": "iam-user-mfa-enabled",
        "Description": "Checks that IAM users have MFA enabled",
        "Source": {
            "Owner": "AWS",
            "SourceIdentifier": "IAM_USER_MFA_ENABLED"
        }
    }'

# Rule: Ensure root account has MFA enabled
aws configservice put-config-rule \
    --config-rule '{
        "ConfigRuleName": "root-account-mfa-enabled",
        "Description": "Checks that root account has MFA enabled",
        "Source": {
            "Owner": "AWS",
            "SourceIdentifier": "ROOT_ACCOUNT_MFA_ENABLED"
        }
    }'

# Rule: Ensure EBS volumes are encrypted
aws configservice put-config-rule \
    --config-rule '{
        "ConfigRuleName": "encrypted-volumes",
        "Description": "Checks that EBS volumes are encrypted",
        "Source": {
            "Owner": "AWS",
            "SourceIdentifier": "ENCRYPTED_VOLUMES"
        }
    }'

# Rule: Ensure RDS instances are encrypted
aws configservice put-config-rule \
    --config-rule '{
        "ConfigRuleName": "rds-storage-encrypted",
        "Description": "Checks that RDS instances have storage encryption enabled",
        "Source": {
            "Owner": "AWS",
            "SourceIdentifier": "RDS_STORAGE_ENCRYPTED"
        }
    }'

# Check compliance status
aws configservice describe-compliance-by-config-rule \
    --query 'ComplianceByConfigRules[].{Rule:ConfigRuleName,Compliance:Compliance.ComplianceType}' \
    --output table

# Get non-compliant resources
aws configservice get-compliance-details-by-config-rule \
    --config-rule-name s3-bucket-server-side-encryption-enabled \
    --compliance-types NON_COMPLIANT \
    --query 'EvaluationResults[].{Resource:EvaluationResultIdentifier.EvaluationResultQualifier.ResourceId,Type:EvaluationResultIdentifier.EvaluationResultQualifier.ResourceType}'
```

### Lab 3.3: AWS Security Hub (Month 21, Week 83)

```bash
# Enable Security Hub
aws securityhub enable-security-hub \
    --enable-default-standards

# Enable specific standards
aws securityhub batch-enable-standards \
    --standards-subscription-requests '[
        {"StandardsArn": "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.4.0"},
        {"StandardsArn": "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"},
        {"StandardsArn": "arn:aws:securityhub:us-east-1::standards/pci-dss/v/3.2.1"}
    ]'

# Get findings summary
aws securityhub get-findings \
    --filters '{"SeverityLabel": [{"Value": "CRITICAL", "Comparison": "EQUALS"}]}' \
    --max-items 10 \
    --query 'Findings[].{Title:Title,Severity:Severity.Label,Resource:Resources[0].Id}'

# Get compliance summary
aws securityhub get-enabled-standards \
    --query 'StandardsSubscriptions[].{Standard:StandardsArn,Status:StandardsStatus}'

# Create custom insight
aws securityhub create-insight \
    --name "Critical IAM Findings" \
    --filters '{
        "SeverityLabel": [{"Value": "CRITICAL", "Comparison": "EQUALS"}],
        "ResourceType": [{"Value": "AwsIamUser", "Comparison": "EQUALS"}]
    }' \
    --group-by-attribute ResourceId

# Export findings to S3 (for compliance reporting)
aws securityhub get-findings \
    --filters '{"RecordState": [{"Value": "ACTIVE", "Comparison": "EQUALS"}]}' \
    --output json > security-hub-findings.json
```

---

## Azure AD / Entra ID

### Lab 4.1: Azure AD User and Group Management (Month 22, Week 85)

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "Your-Subscription-Name"

# Create user
az ad user create \
    --display-name "Test Developer" \
    --user-principal-name testdev@yourdomain.onmicrosoft.com \
    --password "TempP@ss123!" \
    --force-change-password-next-sign-in true

# Create security group
az ad group create \
    --display-name "Developers" \
    --mail-nickname "developers"

# Get group ID
DEV_GROUP_ID=$(az ad group show --group "Developers" --query id -o tsv)

# Add user to group
az ad group member add \
    --group $DEV_GROUP_ID \
    --member-id $(az ad user show --id testdev@yourdomain.onmicrosoft.com --query id -o tsv)

# Create app registration
az ad app create \
    --display-name "MySecureApp" \
    --sign-in-audience AzureADMyOrg

# Get app ID
APP_ID=$(az ad app list --display-name "MySecureApp" --query "[0].appId" -o tsv)

# Create service principal for the app
az ad sp create --id $APP_ID

# Create client secret
az ad app credential reset \
    --id $APP_ID \
    --append \
    --display-name "Production Secret" \
    --years 1

# Assign Azure RBAC role to group
az role assignment create \
    --assignee $DEV_GROUP_ID \
    --role "Reader" \
    --scope /subscriptions/$(az account show --query id -o tsv)
```

### Lab 4.2: Conditional Access Policies (Month 22, Week 86)

```bash
# Note: Conditional Access requires Azure AD Premium P1/P2
# These commands use Microsoft Graph API via az rest

# Get tenant ID
TENANT_ID=$(az account show --query tenantId -o tsv)

# Create Conditional Access policy - Require MFA for admins
az rest --method POST \
    --uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" \
    --headers "Content-Type=application/json" \
    --body '{
        "displayName": "Require MFA for Administrators",
        "state": "enabled",
        "conditions": {
            "users": {
                "includeRoles": [
                    "62e90394-69f5-4237-9190-012177145e10",
                    "194ae4cb-b126-40b2-bd5b-6091b380977d"
                ]
            },
            "applications": {
                "includeApplications": ["All"]
            }
        },
        "grantControls": {
            "operator": "OR",
            "builtInControls": ["mfa"]
        }
    }'

# Create policy - Block legacy authentication
az rest --method POST \
    --uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" \
    --headers "Content-Type=application/json" \
    --body '{
        "displayName": "Block Legacy Authentication",
        "state": "enabled",
        "conditions": {
            "users": {
                "includeUsers": ["All"]
            },
            "applications": {
                "includeApplications": ["All"]
            },
            "clientAppTypes": [
                "exchangeActiveSync",
                "other"
            ]
        },
        "grantControls": {
            "operator": "OR",
            "builtInControls": ["block"]
        }
    }'

# Create policy - Require compliant device for sensitive apps
az rest --method POST \
    --uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" \
    --headers "Content-Type=application/json" \
    --body '{
        "displayName": "Require Compliant Device for Sensitive Apps",
        "state": "enabled",
        "conditions": {
            "users": {
                "includeUsers": ["All"]
            },
            "applications": {
                "includeApplications": ["sensitive-app-id-here"]
            }
        },
        "grantControls": {
            "operator": "OR",
            "builtInControls": ["compliantDevice"]
        }
    }'

# List all Conditional Access policies
az rest --method GET \
    --uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" \
    --query "value[].{Name:displayName,State:state}"
```

### Lab 4.3: Azure RBAC (Month 22, Week 87)

```bash
# List built-in roles
az role definition list --query "[].{Name:roleName,Description:description}" --output table

# Create custom role
cat <<'EOF' > custom-role.json
{
    "Name": "PAM Operator",
    "Description": "Can manage Key Vault secrets and monitor security resources",
    "Actions": [
        "Microsoft.KeyVault/vaults/secrets/read",
        "Microsoft.KeyVault/vaults/secrets/write",
        "Microsoft.KeyVault/vaults/secrets/delete",
        "Microsoft.Security/*/read",
        "Microsoft.Resources/subscriptions/resourceGroups/read",
        "Microsoft.Support/*"
    ],
    "NotActions": [],
    "DataActions": [
        "Microsoft.KeyVault/vaults/secrets/getSecret/action",
        "Microsoft.KeyVault/vaults/secrets/setSecret/action"
    ],
    "NotDataActions": [],
    "AssignableScopes": [
        "/subscriptions/YOUR-SUBSCRIPTION-ID"
    ]
}
EOF

az role definition create --role-definition custom-role.json

# Assign custom role to group
az role assignment create \
    --assignee $DEV_GROUP_ID \
    --role "PAM Operator" \
    --scope /subscriptions/$(az account show --query id -o tsv)/resourceGroups/my-rg

# Create role assignment with condition (ABAC)
az role assignment create \
    --assignee $DEV_GROUP_ID \
    --role "Storage Blob Data Reader" \
    --scope /subscriptions/$(az account show --query id -o tsv)/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mystorageaccount \
    --condition "@Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringEquals 'dev-container'" \
    --condition-version "2.0"

# List role assignments
az role assignment list \
    --assignee $DEV_GROUP_ID \
    --query "[].{Role:roleDefinitionName,Scope:scope}" \
    --output table
```

---

## Azure Security Services

### Lab 5.1: Azure Key Vault (Month 23, Week 89)

```bash
# Create resource group
az group create --name keyvault-rg --location eastus

# Create Key Vault
az keyvault create \
    --name myapp-keyvault-$(date +%s) \
    --resource-group keyvault-rg \
    --location eastus \
    --enable-rbac-authorization true \
    --enable-soft-delete true \
    --retention-days 90 \
    --enable-purge-protection true

# Store the Key Vault name
KV_NAME="myapp-keyvault-TIMESTAMP"

# Assign yourself Key Vault Administrator role
az role assignment create \
    --assignee $(az ad signed-in-user show --query id -o tsv) \
    --role "Key Vault Administrator" \
    --scope $(az keyvault show --name $KV_NAME --query id -o tsv)

# Create secrets
az keyvault secret set \
    --vault-name $KV_NAME \
    --name "database-password" \
    --value "SuperSecr3tDbP@ss!"

az keyvault secret set \
    --vault-name $KV_NAME \
    --name "api-key" \
    --value "ak_prod_azure_12345"

# Create key for encryption
az keyvault key create \
    --vault-name $KV_NAME \
    --name "app-encryption-key" \
    --kty RSA \
    --size 2048 \
    --ops encrypt decrypt sign verify

# Create certificate
az keyvault certificate create \
    --vault-name $KV_NAME \
    --name "app-ssl-cert" \
    --policy "$(az keyvault certificate get-default-policy)"

# Enable diagnostic logging
az monitor diagnostic-settings create \
    --name "keyvault-diagnostics" \
    --resource $(az keyvault show --name $KV_NAME --query id -o tsv) \
    --logs '[{"category": "AuditEvent", "enabled": true, "retentionPolicy": {"enabled": true, "days": 90}}]' \
    --workspace $(az monitor log-analytics workspace show --resource-group keyvault-rg --workspace-name my-workspace --query id -o tsv)

# Retrieve secret
az keyvault secret show \
    --vault-name $KV_NAME \
    --name "database-password" \
    --query value -o tsv

# Enable secret rotation notification
az keyvault secret set-attributes \
    --vault-name $KV_NAME \
    --name "database-password" \
    --expires $(date -d "+90 days" +%Y-%m-%dT%H:%M:%SZ)

# Compare with Conjur - retrieve secret from application
python3 << 'PYTHON'
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

credential = DefaultAzureCredential()
client = SecretClient(vault_url="https://myapp-keyvault.vault.azure.net/", credential=credential)

secret = client.get_secret("database-password")
print(f"Secret value: {secret.value}")
PYTHON
```

### Lab 5.2: Azure Defender for Cloud (Month 23, Week 90)

```bash
# Enable Defender for Cloud (Standard tier)
az security pricing create \
    --name VirtualMachines \
    --tier Standard

az security pricing create \
    --name SqlServers \
    --tier Standard

az security pricing create \
    --name StorageAccounts \
    --tier Standard

az security pricing create \
    --name KeyVaults \
    --tier Standard

# Get security score
az security secure-score-controls list \
    --query "[].{Control:displayName,Score:current,Max:max}" \
    --output table

# Get security recommendations
az security assessment list \
    --query "[?status.code=='Unhealthy'].{Name:displayName,Status:status.code,Severity:metadata.severity}" \
    --output table

# Configure auto-provisioning
az security auto-provisioning-setting update \
    --name default \
    --auto-provision On

# Configure security contact
az security contact create \
    --name default \
    --email security@example.com \
    --alert-notifications On \
    --alerts-to-admins On

# Get alerts
az security alert list \
    --query "[].{Name:alertDisplayName,Severity:severity,Status:status}" \
    --output table

# Create custom security policy
cat <<'EOF' > custom-policy.json
{
    "properties": {
        "displayName": "Require encryption for storage accounts",
        "policyType": "Custom",
        "mode": "All",
        "parameters": {},
        "policyRule": {
            "if": {
                "allOf": [
                    {
                        "field": "type",
                        "equals": "Microsoft.Storage/storageAccounts"
                    },
                    {
                        "field": "Microsoft.Storage/storageAccounts/encryption.services.blob.enabled",
                        "notEquals": true
                    }
                ]
            },
            "then": {
                "effect": "deny"
            }
        }
    }
}
EOF

az policy definition create \
    --name "require-storage-encryption" \
    --rules custom-policy.json \
    --mode All

# Assign policy
az policy assignment create \
    --name "require-storage-encryption-assignment" \
    --policy "require-storage-encryption" \
    --scope /subscriptions/$(az account show --query id -o tsv)
```

### Lab 5.3: Azure Network Security (Month 23, Week 91)

```bash
# Create Virtual Network
az network vnet create \
    --name SecureVNet \
    --resource-group keyvault-rg \
    --address-prefix 10.0.0.0/16 \
    --subnet-name WebSubnet \
    --subnet-prefix 10.0.1.0/24

# Create additional subnets
az network vnet subnet create \
    --vnet-name SecureVNet \
    --resource-group keyvault-rg \
    --name AppSubnet \
    --address-prefix 10.0.2.0/24

az network vnet subnet create \
    --vnet-name SecureVNet \
    --resource-group keyvault-rg \
    --name DbSubnet \
    --address-prefix 10.0.3.0/24

# Create Network Security Groups
az network nsg create \
    --name web-nsg \
    --resource-group keyvault-rg

az network nsg create \
    --name app-nsg \
    --resource-group keyvault-rg

az network nsg create \
    --name db-nsg \
    --resource-group keyvault-rg

# Add NSG rules for Web tier
az network nsg rule create \
    --nsg-name web-nsg \
    --resource-group keyvault-rg \
    --name AllowHTTPS \
    --priority 100 \
    --access Allow \
    --protocol Tcp \
    --direction Inbound \
    --source-address-prefixes '*' \
    --source-port-ranges '*' \
    --destination-address-prefixes '*' \
    --destination-port-ranges 443

# Add NSG rules for App tier (only from web subnet)
az network nsg rule create \
    --nsg-name app-nsg \
    --resource-group keyvault-rg \
    --name AllowFromWeb \
    --priority 100 \
    --access Allow \
    --protocol Tcp \
    --direction Inbound \
    --source-address-prefixes 10.0.1.0/24 \
    --source-port-ranges '*' \
    --destination-address-prefixes '*' \
    --destination-port-ranges 8080

# Add NSG rules for DB tier (only from app subnet)
az network nsg rule create \
    --nsg-name db-nsg \
    --resource-group keyvault-rg \
    --name AllowFromApp \
    --priority 100 \
    --access Allow \
    --protocol Tcp \
    --direction Inbound \
    --source-address-prefixes 10.0.2.0/24 \
    --source-port-ranges '*' \
    --destination-address-prefixes '*' \
    --destination-port-ranges 5432

# Associate NSGs with subnets
az network vnet subnet update \
    --vnet-name SecureVNet \
    --resource-group keyvault-rg \
    --name WebSubnet \
    --network-security-group web-nsg

az network vnet subnet update \
    --vnet-name SecureVNet \
    --resource-group keyvault-rg \
    --name AppSubnet \
    --network-security-group app-nsg

az network vnet subnet update \
    --vnet-name SecureVNet \
    --resource-group keyvault-rg \
    --name DbSubnet \
    --network-security-group db-nsg

# Create Azure Firewall
az network firewall create \
    --name SecureFirewall \
    --resource-group keyvault-rg \
    --location eastus

# Create firewall policy
az network firewall policy create \
    --name SecureFirewallPolicy \
    --resource-group keyvault-rg

# Add application rule collection
az network firewall policy rule-collection-group create \
    --name DefaultRuleCollectionGroup \
    --policy-name SecureFirewallPolicy \
    --resource-group keyvault-rg \
    --priority 100

# Enable Network Watcher flow logs
az network watcher flow-log create \
    --name web-nsg-flow-log \
    --nsg web-nsg \
    --resource-group keyvault-rg \
    --storage-account mystorageaccount \
    --enabled true \
    --retention 90 \
    --traffic-analytics true \
    --workspace my-workspace
```

---

## Azure Compliance

### Lab 6.1: Azure Compliance Manager (Month 24, Week 93)

```bash
# Note: Compliance Manager is primarily accessed via the Azure portal
# These commands configure related compliance features

# Get compliance status for policies
az policy state summarize \
    --query "results.{TotalPolicies:totalPolicies,CompliantPolicies:compliantPolicies,NonCompliantPolicies:nonCompliantPolicies}"

# List non-compliant resources
az policy state list \
    --filter "complianceState eq 'NonCompliant'" \
    --query "[].{Resource:resourceId,Policy:policyDefinitionName}" \
    --output table

# Create initiative (policy set) for compliance
cat <<'EOF' > compliance-initiative.json
{
    "properties": {
        "displayName": "HIPAA Compliance Initiative",
        "description": "Policy set for HIPAA compliance requirements",
        "policyDefinitions": [
            {
                "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d",
                "policyDefinitionReferenceId": "StorageAccountSecureTransfer"
            },
            {
                "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9",
                "policyDefinitionReferenceId": "SQLEncryption"
            },
            {
                "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d",
                "policyDefinitionReferenceId": "KeyVaultSoftDelete"
            }
        ]
    }
}
EOF

az policy set-definition create \
    --name "hipaa-compliance" \
    --definitions compliance-initiative.json

# Assign compliance initiative
az policy assignment create \
    --name "hipaa-compliance-assignment" \
    --policy-set-definition "hipaa-compliance" \
    --scope /subscriptions/$(az account show --query id -o tsv) \
    --enforcement-mode Default

# Export compliance report
az policy state list \
    --output json > compliance-report.json
```

---

## Multi-Cloud Security Architecture

### Lab 7.1: Multi-Cloud Identity Federation (Month 24, Week 95)

```bash
# AWS: Create OIDC identity provider for Azure AD
aws iam create-open-id-connect-provider \
    --url https://login.microsoftonline.com/YOUR_TENANT_ID/v2.0 \
    --client-id-list YOUR_AZURE_APP_ID \
    --thumbprint-list YOUR_THUMBPRINT

# AWS: Create role that trusts Azure AD
cat <<'EOF' > azure-ad-trust.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/login.microsoftonline.com/TENANT_ID/v2.0"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "login.microsoftonline.com/TENANT_ID/v2.0:aud": "YOUR_AZURE_APP_ID"
                }
            }
        }
    ]
}
EOF

aws iam create-role \
    --role-name AzureAD-CrossCloud-Role \
    --assume-role-policy-document file://azure-ad-trust.json

# Azure: Configure AWS as external identity provider
# This is typically done via portal or ARM templates

# Terraform for multi-cloud identity federation
cat <<'EOF' > multicloud-identity.tf
# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Azure Provider
provider "azurerm" {
  features {}
}

# AWS OIDC Provider for Azure AD
resource "aws_iam_openid_connect_provider" "azure_ad" {
  url             = "https://login.microsoftonline.com/${var.azure_tenant_id}/v2.0"
  client_id_list  = [var.azure_app_id]
  thumbprint_list = [var.azure_thumbprint]
}

# AWS Role trusting Azure AD
resource "aws_iam_role" "cross_cloud_role" {
  name = "AzureAD-CrossCloud-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.azure_ad.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${aws_iam_openid_connect_provider.azure_ad.url}:aud" = var.azure_app_id
          }
        }
      }
    ]
  })
}
EOF
```

### Lab 7.2: Centralized Secrets Management Across Clouds

```bash
# Deploy Conjur as centralized secrets manager
# See HANDS_ON_LABS_PHASE2.md for Conjur deployment

# Create multi-cloud policy in Conjur
cat <<'EOF' > multicloud-policy.yml
# Multi-Cloud Unified Secrets Management
- !policy
  id: cloud-secrets
  body:
    # AWS secrets
    - !policy
      id: aws
      body:
        - !variable us-east-1/rds/admin-password
        - !variable us-east-1/s3/encryption-key
        - !variable us-west-2/elasticache/auth-token

    # Azure secrets
    - !policy
      id: azure
      body:
        - !variable eastus/sql/admin-password
        - !variable eastus/storage/account-key
        - !variable westus/cosmosdb/primary-key

    # Shared secrets (cloud-agnostic)
    - !policy
      id: shared
      body:
        - !variable encryption/master-key
        - !variable api/gateway-secret
        - !variable monitoring/datadog-api-key

    # Application layers
    - !layer aws-apps
    - !layer azure-apps
    - !layer multicloud-apps

    # Grant permissions
    - !permit
      role: !layer aws-apps
      privileges: [read, execute]
      resources:
        - !variable aws/us-east-1/rds/admin-password
        - !variable aws/us-east-1/s3/encryption-key
        - !variable shared/encryption/master-key

    - !permit
      role: !layer azure-apps
      privileges: [read, execute]
      resources:
        - !variable azure/eastus/sql/admin-password
        - !variable azure/eastus/storage/account-key
        - !variable shared/encryption/master-key

    - !permit
      role: !layer multicloud-apps
      privileges: [read, execute]
      resources:
        - !variable aws/us-east-1/rds/admin-password
        - !variable azure/eastus/sql/admin-password
        - !variable shared/encryption/master-key
        - !variable shared/api/gateway-secret
EOF

# Application code for multi-cloud secret retrieval
python3 << 'PYTHON'
import os
import requests
import base64

class MultiCloudSecretsClient:
    def __init__(self, conjur_url, account, auth_token):
        self.conjur_url = conjur_url
        self.account = account
        self.token = auth_token

    def get_secret(self, secret_path):
        """Retrieve secret from Conjur regardless of cloud provider"""
        encoded_path = requests.utils.quote(secret_path, safe='')
        response = requests.get(
            f"{self.conjur_url}/secrets/{self.account}/variable/{encoded_path}",
            headers={"Authorization": f'Token token="{self.token}"'}
        )
        return response.text

    def get_aws_secret(self, region, service, name):
        return self.get_secret(f"cloud-secrets/aws/{region}/{service}/{name}")

    def get_azure_secret(self, region, service, name):
        return self.get_secret(f"cloud-secrets/azure/{region}/{service}/{name}")

    def get_shared_secret(self, category, name):
        return self.get_secret(f"cloud-secrets/shared/{category}/{name}")

# Usage
client = MultiCloudSecretsClient(
    conjur_url="https://conjur.example.com",
    account="myorg",
    auth_token=os.environ.get("CONJUR_TOKEN")
)

# Get AWS RDS password
aws_db_pass = client.get_aws_secret("us-east-1", "rds", "admin-password")

# Get Azure SQL password
azure_db_pass = client.get_azure_secret("eastus", "sql", "admin-password")

# Get shared encryption key
encryption_key = client.get_shared_secret("encryption", "master-key")
PYTHON
```

---

## CCSP Domain Labs

### Lab 8.1: Domain 1 - Cloud Architecture Security (Month 25)

```bash
# Lab: Evaluate cloud service models security
# Create comparison matrix for IaaS vs PaaS vs SaaS security responsibilities

cat <<'EOF' > cloud-shared-responsibility.md
# Cloud Shared Responsibility Matrix

| Security Control | IaaS | PaaS | SaaS |
|-----------------|------|------|------|
| Physical Security | Provider | Provider | Provider |
| Network Security | Shared | Provider | Provider |
| Hypervisor | Provider | Provider | Provider |
| OS Patching | Customer | Provider | Provider |
| Application Security | Customer | Customer | Provider |
| Data Classification | Customer | Customer | Customer |
| Identity Management | Customer | Customer | Shared |
| Access Control | Customer | Customer | Customer |
| Encryption (at rest) | Customer | Shared | Provider |
| Encryption (in transit) | Customer | Shared | Provider |

## Key Takeaways for CCSP:
1. Data classification is ALWAYS customer responsibility
2. Identity management requires customer attention in all models
3. Provider responsibilities increase from IaaS → PaaS → SaaS
4. Encryption key management varies by model
EOF
```

### Lab 8.2: Domain 2 - Data Security Lab (Month 25)

```bash
# Lab: Implement data classification and protection

# AWS: Enable S3 bucket data classification with Macie
aws macie2 enable-macie
aws macie2 create-classification-job \
    --name "PII-Discovery-Job" \
    --job-type ONE_TIME \
    --s3-job-definition '{
        "bucketDefinitions": [
            {
                "accountId": "'$ACCOUNT_ID'",
                "buckets": ["my-data-bucket"]
            }
        ]
    }'

# Azure: Enable Purview for data classification
az purview account create \
    --name my-purview-account \
    --resource-group data-governance-rg \
    --location eastus

# Implement data masking
python3 << 'PYTHON'
import re
import hashlib

def mask_pii(data):
    """Mask PII data for non-production environments"""
    # Mask SSN
    data = re.sub(r'\d{3}-\d{2}-\d{4}', 'XXX-XX-XXXX', data)

    # Mask credit cards
    data = re.sub(r'\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}', 'XXXX-XXXX-XXXX-XXXX', data)

    # Mask email addresses
    data = re.sub(r'[\w\.-]+@[\w\.-]+\.\w+', 'masked@email.com', data)

    return data

def tokenize_sensitive_data(value, salt="my-secret-salt"):
    """Tokenize sensitive data for secure storage"""
    return hashlib.sha256(f"{value}{salt}".encode()).hexdigest()

# Test
sample_data = "Customer SSN: 123-45-6789, Email: john@example.com"
print(f"Original: {sample_data}")
print(f"Masked: {mask_pii(sample_data)}")
print(f"Token: {tokenize_sensitive_data('123-45-6789')}")
PYTHON
```

### Lab 8.3: Domain 5 - Security Operations Lab (Month 27)

```bash
# Lab: Implement cloud security operations

# Create CloudWatch alarm for security events
aws cloudwatch put-metric-alarm \
    --alarm-name "UnauthorizedAPICall" \
    --alarm-description "Alert on unauthorized API calls" \
    --namespace "CloudTrailMetrics" \
    --metric-name "UnauthorizedAttemptCount" \
    --statistic Sum \
    --period 300 \
    --threshold 1 \
    --comparison-operator GreaterThanOrEqualToThreshold \
    --evaluation-periods 1 \
    --alarm-actions arn:aws:sns:us-east-1:${ACCOUNT_ID}:security-alerts

# Create metric filter for unauthorized API calls
aws logs put-metric-filter \
    --log-group-name /aws/cloudtrail/management-events \
    --filter-name "UnauthorizedAPICallFilter" \
    --filter-pattern '{ ($.errorCode = "*UnauthorizedAccess*") || ($.errorCode = "AccessDenied*") }' \
    --metric-transformations \
        metricName=UnauthorizedAttemptCount,metricNamespace=CloudTrailMetrics,metricValue=1

# Azure: Create alert rule for security events
az monitor metrics alert create \
    --name "FailedLoginAttempts" \
    --resource-group keyvault-rg \
    --scopes /subscriptions/$(az account show --query id -o tsv) \
    --condition "total FailedLoginCount > 10" \
    --window-size 5m \
    --evaluation-frequency 1m \
    --action-group security-team-ag
```

---

## Compliance Framework Implementation

### Lab 9.1: HIPAA Compliance Controls (Month 26, Week 104)

```bash
# Create HIPAA compliance checklist implementation

# 1. Access Control (164.312(a)(1))
# AWS: Enable IAM Access Analyzer
aws accessanalyzer create-analyzer \
    --analyzer-name hipaa-access-analyzer \
    --type ACCOUNT

# 2. Audit Controls (164.312(b))
# Ensure CloudTrail is enabled (already done in Lab 3.1)

# 3. Integrity Controls (164.312(c)(1))
# Enable S3 versioning and MFA delete
aws s3api put-bucket-versioning \
    --bucket hipaa-data-bucket \
    --versioning-configuration Status=Enabled,MFADelete=Enabled

# 4. Transmission Security (164.312(e)(1))
# Enforce HTTPS only on S3 bucket
cat <<'EOF' > https-only-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EnforceHTTPS",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::hipaa-data-bucket",
                "arn:aws:s3:::hipaa-data-bucket/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
EOF

aws s3api put-bucket-policy \
    --bucket hipaa-data-bucket \
    --policy file://https-only-policy.json

# 5. Encryption at rest
aws s3api put-bucket-encryption \
    --bucket hipaa-data-bucket \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "aws:kms",
                    "KMSMasterKeyID": "alias/hipaa-encryption-key"
                },
                "BucketKeyEnabled": true
            }
        ]
    }'
```

### Lab 9.2: PCI-DSS Compliance Controls

```bash
# Create PCI-DSS compliance controls

# Requirement 3: Protect stored cardholder data
# Create dedicated KMS key for cardholder data
aws kms create-key \
    --description "PCI-DSS Cardholder Data Encryption Key" \
    --tags TagKey=Compliance,TagValue=PCI-DSS \
    --policy file://pci-key-policy.json

# Requirement 7: Restrict access to cardholder data
# Create restrictive IAM policy
cat <<'EOF' > pci-access-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RestrictCardholderDataAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::pci-cardholder-data/*",
            "Condition": {
                "Bool": {
                    "aws:MultiFactorAuthPresent": "true"
                },
                "IpAddress": {
                    "aws:SourceIp": ["10.0.0.0/8"]
                }
            }
        }
    ]
}
EOF

# Requirement 10: Track and monitor all access
# Create comprehensive logging
aws cloudtrail put-event-selectors \
    --trail-name pci-audit-trail \
    --event-selectors '[
        {
            "ReadWriteType": "All",
            "IncludeManagementEvents": true,
            "DataResources": [
                {
                    "Type": "AWS::S3::Object",
                    "Values": ["arn:aws:s3:::pci-cardholder-data/"]
                }
            ]
        }
    ]'
```

---

## Capstone Integration Labs

### Lab 10.1: Enterprise Architecture Integration (Month 27)

```bash
# Deploy complete enterprise security architecture
# This lab integrates all Phase 1-3 components

# Create Terraform configuration for enterprise deployment
cat <<'EOF' > enterprise-capstone.tf
# Enterprise PAM + Conjur + Multi-Cloud Security Architecture

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# AWS Infrastructure
module "aws_security" {
  source = "./modules/aws"

  vpc_cidr         = "10.0.0.0/16"
  enable_cloudtrail = true
  enable_config    = true
  enable_guardduty = true
  kms_key_alias    = "enterprise-encryption"
}

# Azure Infrastructure
module "azure_security" {
  source = "./modules/azure"

  resource_group_name = "enterprise-security-rg"
  location           = "eastus"
  enable_defender    = true
  enable_sentinel    = true
  keyvault_name      = "enterprise-keyvault"
}

# Kubernetes (EKS + AKS)
module "kubernetes_security" {
  source = "./modules/kubernetes"

  eks_cluster_name = "enterprise-eks"
  aks_cluster_name = "enterprise-aks"
  conjur_namespace = "conjur-system"
}

# Conjur Deployment
module "conjur" {
  source = "./modules/conjur"

  kubernetes_provider = module.kubernetes_security.eks_provider
  conjur_account     = "enterprise"
  conjur_data_key    = var.conjur_data_key

  authenticators = [
    "authn",
    "authn-k8s/eks",
    "authn-k8s/aks",
    "authn-iam/aws",
    "authn-azure/azure"
  ]
}

# Output important values
output "conjur_url" {
  value = module.conjur.conjur_url
}

output "aws_security_hub_arn" {
  value = module.aws_security.security_hub_arn
}

output "azure_defender_id" {
  value = module.azure_security.defender_id
}
EOF
```

---

## Troubleshooting Commands

### AWS Troubleshooting

```bash
# Check IAM permissions
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::${ACCOUNT_ID}:user/dev-user-01 \
    --action-names s3:GetObject \
    --resource-arns arn:aws:s3:::my-bucket/my-object

# Debug STS assume role
aws sts get-caller-identity
aws sts assume-role --role-arn arn:aws:iam::${ACCOUNT_ID}:role/MyRole --role-session-name test --debug

# Check CloudTrail events
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=AssumeRole --max-items 10

# Validate KMS key policy
aws kms get-key-policy --key-id alias/my-key --policy-name default --output text | jq

# Check Security Hub findings
aws securityhub get-findings --filters '{"SeverityLabel":[{"Value":"CRITICAL","Comparison":"EQUALS"}]}' --max-items 5
```

### Azure Troubleshooting

```bash
# Check role assignments
az role assignment list --assignee $(az ad signed-in-user show --query id -o tsv) --output table

# Debug Azure AD token
az account get-access-token --resource https://management.azure.com/ --query accessToken -o tsv | jwt decode -

# Check Key Vault access
az keyvault show --name mykeyvault --query "properties.accessPolicies"

# View activity logs
az monitor activity-log list --start-time $(date -d "-1 hour" +%Y-%m-%dT%H:%M:%SZ) --query "[].{Time:eventTimestamp,Operation:operationName.localizedValue,Status:status.localizedValue}"

# Check Defender recommendations
az security assessment list --query "[?status.code=='Unhealthy']" --output table
```

---

## Cleanup Commands

```bash
# AWS Cleanup
aws cloudtrail delete-trail --name management-events-trail
aws configservice delete-configuration-recorder --configuration-recorder-name default
aws s3 rb s3://my-cloudtrail-logs-${ACCOUNT_ID} --force
aws iam delete-group --group-name Developers
aws ec2 delete-vpc --vpc-id $VPC_ID

# Azure Cleanup
az group delete --name keyvault-rg --yes
az ad app delete --id $APP_ID
az ad user delete --id testdev@yourdomain.onmicrosoft.com
```

---

## Related Documents

- **Phase 3 Overview**: [PHASE3_MONTHS_19-27.md](../roadmap/PHASE3_MONTHS_19-27.md)
- **Phase 1 Labs**: [HANDS_ON_LABS_PHASE1.md](HANDS_ON_LABS_PHASE1.md)
- **Phase 2 Labs**: [HANDS_ON_LABS_PHASE2.md](HANDS_ON_LABS_PHASE2.md)
- **CCSP Certification Guide**: [CCSP_CERTIFICATION_GUIDE.md](CCSP_CERTIFICATION_GUIDE.md)
- **Compliance Frameworks Guide**: [COMPLIANCE_FRAMEWORKS_GUIDE.md](COMPLIANCE_FRAMEWORKS_GUIDE.md)
- **Multi-Cloud Patterns**: [MULTICLOUD_PATTERNS.md](MULTICLOUD_PATTERNS.md)

---

## External References

- [AWS Security Documentation](https://docs.aws.amazon.com/security/)
- [Azure Security Documentation](https://docs.microsoft.com/en-us/azure/security/)
- [CCSP Official Study Guide](https://www.isc2.org/certifications/ccsp)
- [NIST Cloud Computing Security](https://csrc.nist.gov/publications/detail/sp/800-144/final)
- [CSA Cloud Controls Matrix](https://cloudsecurityalliance.org/research/cloud-controls-matrix/)

---

**Last Updated**: 2025-12-04
**Version**: 1.0
