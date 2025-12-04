# Multi-Cloud PAM Architecture Patterns

> Design patterns and best practices for deploying CyberArk PAM and Conjur across AWS, Azure, and GCP

---

## Table of Contents

1. [Multi-Cloud Overview](#multi-cloud-overview)
2. [Architecture Patterns](#architecture-patterns)
3. [AWS Deployment](#aws-deployment)
4. [Azure Deployment](#azure-deployment)
5. [GCP Deployment](#gcp-deployment)
6. [Cross-Cloud Connectivity](#cross-cloud-connectivity)
7. [Identity Federation](#identity-federation)
8. [Secrets Synchronization](#secrets-synchronization)
9. [Unified Management](#unified-management)
10. [Security Considerations](#security-considerations)
11. [Operational Patterns](#operational-patterns)

---

## Multi-Cloud Overview

### Why Multi-Cloud PAM?

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Multi-Cloud PAM Drivers                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Business Drivers:                                                      │
│  ├── Avoid vendor lock-in                                              │
│  ├── Best-of-breed services per cloud                                  │
│  ├── M&A integration (inherited cloud environments)                    │
│  ├── Regional compliance requirements                                  │
│  └── Cost optimization                                                 │
│                                                                         │
│  Technical Drivers:                                                     │
│  ├── Disaster recovery across providers                                │
│  ├── Latency optimization (workloads near users)                       │
│  ├── Service availability (provider-specific features)                 │
│  └── Development flexibility                                           │
│                                                                         │
│  Security Requirements:                                                 │
│  ├── Centralized privileged access control                             │
│  ├── Unified audit and compliance                                      │
│  ├── Consistent secrets management                                     │
│  └── Cross-cloud identity governance                                   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Multi-Cloud Challenges

| Challenge | Description | Solution Approach |
|-----------|-------------|-------------------|
| Identity Sprawl | Different IAM per cloud | Federation + Conjur |
| Network Complexity | Cross-cloud connectivity | Hub-spoke or mesh |
| Secrets Silos | Cloud-native secrets stores | Conjur centralization |
| Compliance | Different audit formats | Unified SIEM integration |
| Latency | Cross-region access | Regional Conjur followers |

---

## Architecture Patterns

### Pattern 1: Centralized Hub

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Centralized Hub Pattern                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                        ┌──────────────────┐                            │
│                        │   On-Premises    │                            │
│                        │   (Primary Hub)  │                            │
│                        ├──────────────────┤                            │
│                        │ CyberArk Vault   │                            │
│                        │ Conjur Leader    │                            │
│                        │ PVWA             │                            │
│                        │ CPM              │                            │
│                        └────────┬─────────┘                            │
│                                 │                                       │
│              ┌──────────────────┼──────────────────┐                   │
│              │                  │                  │                    │
│              ▼                  ▼                  ▼                    │
│    ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐         │
│    │      AWS        │ │     Azure       │ │      GCP        │         │
│    ├─────────────────┤ ├─────────────────┤ ├─────────────────┤         │
│    │ Conjur Follower │ │ Conjur Follower │ │ Conjur Follower │         │
│    │ PSM (optional)  │ │ PSM (optional)  │ │ PSM (optional)  │         │
│    │ Workloads       │ │ Workloads       │ │ Workloads       │         │
│    └─────────────────┘ └─────────────────┘ └─────────────────┘         │
│                                                                         │
│  Characteristics:                                                       │
│  • Single source of truth on-premises                                  │
│  • Followers in each cloud for low latency                             │
│  • Centralized policy management                                       │
│  • Requires reliable connectivity to hub                               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Pattern 2: Primary Cloud with Satellites

```
┌─────────────────────────────────────────────────────────────────────────┐
│                 Primary Cloud with Satellites                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                        ┌──────────────────┐                            │
│                        │   AWS (Primary)  │                            │
│                        ├──────────────────┤                            │
│                        │ CyberArk Vault   │                            │
│                        │ Conjur Leader    │                            │
│                        │ PVWA / CPM / PSM │                            │
│                        │ Primary Workloads│                            │
│                        └────────┬─────────┘                            │
│                                 │                                       │
│                    ┌────────────┴────────────┐                         │
│                    │                         │                          │
│                    ▼                         ▼                          │
│          ┌─────────────────┐       ┌─────────────────┐                 │
│          │     Azure       │       │      GCP        │                 │
│          │   (Satellite)   │       │   (Satellite)   │                 │
│          ├─────────────────┤       ├─────────────────┤                 │
│          │ Conjur Follower │       │ Conjur Follower │                 │
│          │ Standby PSM     │       │ Read-only access│                 │
│          │ Secondary loads │       │ Dev/Test loads  │                 │
│          └─────────────────┘       └─────────────────┘                 │
│                                                                         │
│  Characteristics:                                                       │
│  • Primary infrastructure in one cloud                                 │
│  • Satellites for specific workloads                                   │
│  • Simplified operations                                               │
│  • May not meet all compliance requirements                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Pattern 3: Federated Multi-Primary

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Federated Multi-Primary                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│    ┌─────────────────┐       ┌─────────────────┐                       │
│    │   AWS Region    │◄─────►│   Azure Region  │                       │
│    ├─────────────────┤ Sync  ├─────────────────┤                       │
│    │ Conjur Primary  │◄─────►│ Conjur Primary  │                       │
│    │ CyberArk Vault  │       │ CyberArk Vault  │                       │
│    │ Full PAM Stack  │       │ Full PAM Stack  │                       │
│    └────────┬────────┘       └────────┬────────┘                       │
│             │                         │                                 │
│             │    ┌─────────────────┐  │                                │
│             └───►│  GCP Region     │◄─┘                                │
│                  ├─────────────────┤                                   │
│                  │ Conjur Primary  │                                   │
│                  │ CyberArk Vault  │                                   │
│                  │ Full PAM Stack  │                                   │
│                  └─────────────────┘                                   │
│                                                                         │
│  Characteristics:                                                       │
│  • Independent primary in each cloud                                   │
│  • Cross-cloud synchronization layer                                   │
│  • Regional autonomy                                                   │
│  • Complex to manage and synchronize                                   │
│  • Best for true multi-cloud independence                              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## AWS Deployment

### CyberArk PAM on AWS

```yaml
# aws_pam_infrastructure.yaml
# CloudFormation template for CyberArk PAM components

AWSTemplateFormatVersion: '2010-09-09'
Description: 'CyberArk PAM Multi-Cloud Deployment - AWS'

Parameters:
  Environment:
    Type: String
    AllowedValues: [Production, DR, Development]
  VaultAMI:
    Type: AWS::EC2::Image::Id
    Description: CyberArk Vault AMI ID
  ComponentAMI:
    Type: AWS::EC2::Image::Id
    Description: CyberArk Component AMI ID

Resources:
  # VPC Configuration
  PAMVpc:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.100.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: !Sub 'pam-vpc-${Environment}'

  # Private Subnets for Vault
  VaultSubnetA:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref PAMVpc
      AvailabilityZone: !Select [0, !GetAZs '']
      CidrBlock: 10.100.1.0/24
      MapPublicIpOnLaunch: false
      Tags:
        - Key: Name
          Value: !Sub 'vault-subnet-a-${Environment}'

  VaultSubnetB:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref PAMVpc
      AvailabilityZone: !Select [1, !GetAZs '']
      CidrBlock: 10.100.2.0/24
      MapPublicIpOnLaunch: false
      Tags:
        - Key: Name
          Value: !Sub 'vault-subnet-b-${Environment}'

  # Vault Security Group
  VaultSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: CyberArk Vault Security Group
      VpcId: !Ref PAMVpc
      SecurityGroupIngress:
        # Vault Protocol
        - IpProtocol: tcp
          FromPort: 1858
          ToPort: 1858
          SourceSecurityGroupId: !Ref ComponentSecurityGroup
        # PrivateArk Client
        - IpProtocol: tcp
          FromPort: 443
          ToPort: 443
          SourceSecurityGroupId: !Ref ComponentSecurityGroup
      Tags:
        - Key: Name
          Value: !Sub 'vault-sg-${Environment}'

  # Primary Vault Instance
  VaultPrimary:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: m5.xlarge
      ImageId: !Ref VaultAMI
      SubnetId: !Ref VaultSubnetA
      SecurityGroupIds:
        - !Ref VaultSecurityGroup
      IamInstanceProfile: !Ref VaultInstanceProfile
      BlockDeviceMappings:
        - DeviceName: /dev/sda1
          Ebs:
            VolumeSize: 100
            VolumeType: gp3
            Encrypted: true
            KmsKeyId: !Ref VaultKmsKey
        # Safes Storage
        - DeviceName: /dev/sdf
          Ebs:
            VolumeSize: 500
            VolumeType: gp3
            Encrypted: true
            KmsKeyId: !Ref VaultKmsKey
      Tags:
        - Key: Name
          Value: !Sub 'vault-primary-${Environment}'

  # Component Subnet (PVWA, CPM, PSM)
  ComponentSubnetA:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref PAMVpc
      AvailabilityZone: !Select [0, !GetAZs '']
      CidrBlock: 10.100.10.0/24
      Tags:
        - Key: Name
          Value: !Sub 'component-subnet-a-${Environment}'

  # PVWA Auto Scaling Group
  PVWALaunchTemplate:
    Type: AWS::EC2::LaunchTemplate
    Properties:
      LaunchTemplateData:
        InstanceType: m5.large
        ImageId: !Ref ComponentAMI
        SecurityGroupIds:
          - !Ref ComponentSecurityGroup
        IamInstanceProfile:
          Arn: !GetAtt ComponentInstanceProfile.Arn
        UserData:
          Fn::Base64: !Sub |
            #!/bin/bash
            # Configure PVWA connection to Vault
            /opt/cyberark/configure-pvwa.sh \
              --vault-ip ${VaultPrimary.PrivateIp} \
              --vault-port 1858

  PVWAAutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      LaunchTemplate:
        LaunchTemplateId: !Ref PVWALaunchTemplate
        Version: !GetAtt PVWALaunchTemplate.LatestVersionNumber
      MinSize: 2
      MaxSize: 4
      DesiredCapacity: 2
      VPCZoneIdentifier:
        - !Ref ComponentSubnetA
        - !Ref ComponentSubnetB
      TargetGroupARNs:
        - !Ref PVWATargetGroup
      Tags:
        - Key: Name
          Value: !Sub 'pvwa-asg-${Environment}'
          PropagateAtLaunch: true

  # Application Load Balancer for PVWA
  PVWALoadBalancer:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Name: !Sub 'pvwa-alb-${Environment}'
      Subnets:
        - !Ref PublicSubnetA
        - !Ref PublicSubnetB
      SecurityGroups:
        - !Ref ALBSecurityGroup
      Scheme: internal

  # KMS Key for Encryption
  VaultKmsKey:
    Type: AWS::KMS::Key
    Properties:
      Description: KMS key for CyberArk Vault encryption
      EnableKeyRotation: true
      KeyPolicy:
        Version: '2012-10-17'
        Statement:
          - Sid: Enable IAM User Permissions
            Effect: Allow
            Principal:
              AWS: !Sub 'arn:aws:iam::${AWS::AccountId}:root'
            Action: 'kms:*'
            Resource: '*'
          - Sid: Allow Vault Instance
            Effect: Allow
            Principal:
              AWS: !GetAtt VaultInstanceRole.Arn
            Action:
              - kms:Encrypt
              - kms:Decrypt
              - kms:GenerateDataKey
            Resource: '*'

Outputs:
  VaultPrivateIP:
    Description: Primary Vault Private IP
    Value: !GetAtt VaultPrimary.PrivateIp
    Export:
      Name: !Sub '${Environment}-VaultPrivateIP'

  PVWAEndpoint:
    Description: PVWA Load Balancer DNS
    Value: !GetAtt PVWALoadBalancer.DNSName
    Export:
      Name: !Sub '${Environment}-PVWAEndpoint'
```

### Conjur on AWS EKS

```yaml
# conjur_eks_deployment.yaml
# Conjur deployment for AWS EKS

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: conjur-oss
  namespace: conjur
  labels:
    app: conjur-oss
spec:
  serviceName: conjur
  replicas: 1  # Leader
  selector:
    matchLabels:
      app: conjur-oss
  template:
    metadata:
      labels:
        app: conjur-oss
    spec:
      serviceAccountName: conjur-cluster
      containers:
        - name: conjur-oss
          image: cyberark/conjur:latest
          ports:
            - containerPort: 443
              name: https
            - containerPort: 5432
              name: postgres
          env:
            - name: CONJUR_AUTHENTICATORS
              value: "authn,authn-iam/aws,authn-k8s/eks-cluster"
            - name: CONJUR_DATA_KEY
              valueFrom:
                secretKeyRef:
                  name: conjur-data-key
                  key: key
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: conjur-database-url
                  key: url
          volumeMounts:
            - name: conjur-ssl
              mountPath: /opt/conjur/etc/ssl
              readOnly: true
          resources:
            requests:
              memory: "2Gi"
              cpu: "1000m"
            limits:
              memory: "4Gi"
              cpu: "2000m"
          livenessProbe:
            httpGet:
              path: /health
              port: 443
              scheme: HTTPS
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /health
              port: 443
              scheme: HTTPS
            initialDelaySeconds: 10
            periodSeconds: 5
      volumes:
        - name: conjur-ssl
          secret:
            secretName: conjur-ssl-cert
      nodeSelector:
        node.kubernetes.io/instance-type: m5.large
      tolerations:
        - key: "dedicated"
          operator: "Equal"
          value: "conjur"
          effect: "NoSchedule"

---
# AWS IAM Authenticator Configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: conjur-aws-authn
  namespace: conjur
data:
  policy.yml: |
    - !policy
      id: authn-iam/aws
      body:
        - !webservice

        # AWS Account configuration
        - !variable aws-account-id

        # Permitted AWS roles
        - !group aws-roles

        - !permit
          role: !group aws-roles
          privileges: [read, authenticate]
          resource: !webservice

    # Define AWS roles that can authenticate
    - !host
      id: aws/arn:aws:iam::123456789012:role/app-role
      annotations:
        authn-iam/aws: true

    - !grant
      role: !group authn-iam/aws/aws-roles
      member: !host aws/arn:aws:iam::123456789012:role/app-role

---
# Service for internal cluster access
apiVersion: v1
kind: Service
metadata:
  name: conjur
  namespace: conjur
spec:
  selector:
    app: conjur-oss
  ports:
    - name: https
      port: 443
      targetPort: 443
  type: ClusterIP

---
# Ingress for external access
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: conjur-ingress
  namespace: conjur
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internal
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:123456789012:certificate/xxx
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-2017-01
spec:
  rules:
    - host: conjur.internal.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: conjur
                port:
                  number: 443
```

### AWS Secrets Manager Integration

```python
#!/usr/bin/env python3
"""
aws_conjur_sync.py
Synchronize secrets between AWS Secrets Manager and Conjur
"""

import boto3
import requests
import json
import base64
from typing import Dict, List, Optional
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class AWSConjurSync:
    """Bidirectional sync between AWS Secrets Manager and Conjur"""

    def __init__(self,
                 aws_region: str,
                 conjur_url: str,
                 conjur_account: str):
        self.secrets_client = boto3.client('secretsmanager',
                                           region_name=aws_region)
        self.conjur_url = conjur_url
        self.conjur_account = conjur_account
        self.conjur_token = None

    def authenticate_conjur_iam(self) -> str:
        """Authenticate to Conjur using AWS IAM"""
        # Get AWS credentials
        session = boto3.Session()
        credentials = session.get_credentials()

        # Create signed request for Conjur
        from botocore.auth import SigV4Auth
        from botocore.awsrequest import AWSRequest

        # Build authentication request
        host = self.conjur_url.replace('https://', '')
        endpoint = f"{self.conjur_url}/authn-iam/aws/{self.conjur_account}/authenticate"

        request = AWSRequest(method='POST', url=endpoint)
        SigV4Auth(credentials, 'sts', session.region_name).add_auth(request)

        # Exchange for Conjur token
        response = requests.post(
            endpoint,
            headers=dict(request.headers),
            verify=True
        )

        if response.status_code == 200:
            self.conjur_token = base64.b64encode(
                response.content
            ).decode('utf-8')
            return self.conjur_token
        else:
            raise Exception(f"Conjur IAM auth failed: {response.text}")

    def sync_aws_to_conjur(self,
                           aws_secret_name: str,
                           conjur_variable: str) -> bool:
        """Sync secret from AWS to Conjur"""
        try:
            # Get from AWS
            response = self.secrets_client.get_secret_value(
                SecretId=aws_secret_name
            )
            secret_value = response['SecretString']

            # Set in Conjur
            headers = {
                'Authorization': f'Token token="{self.conjur_token}"'
            }
            encoded_var = requests.utils.quote(conjur_variable, safe='')

            response = requests.post(
                f"{self.conjur_url}/secrets/{self.conjur_account}/variable/{encoded_var}",
                headers=headers,
                data=secret_value
            )

            if response.status_code == 201:
                logger.info(f"Synced {aws_secret_name} -> {conjur_variable}")
                return True
            else:
                logger.error(f"Failed to sync: {response.text}")
                return False

        except Exception as e:
            logger.error(f"Sync error: {e}")
            return False

    def sync_conjur_to_aws(self,
                           conjur_variable: str,
                           aws_secret_name: str) -> bool:
        """Sync secret from Conjur to AWS"""
        try:
            # Get from Conjur
            headers = {
                'Authorization': f'Token token="{self.conjur_token}"'
            }
            encoded_var = requests.utils.quote(conjur_variable, safe='')

            response = requests.get(
                f"{self.conjur_url}/secrets/{self.conjur_account}/variable/{encoded_var}",
                headers=headers
            )

            if response.status_code != 200:
                logger.error(f"Failed to get Conjur secret: {response.text}")
                return False

            secret_value = response.text

            # Update in AWS
            try:
                self.secrets_client.put_secret_value(
                    SecretId=aws_secret_name,
                    SecretString=secret_value
                )
            except self.secrets_client.exceptions.ResourceNotFoundException:
                # Create new secret
                self.secrets_client.create_secret(
                    Name=aws_secret_name,
                    SecretString=secret_value
                )

            logger.info(f"Synced {conjur_variable} -> {aws_secret_name}")
            return True

        except Exception as e:
            logger.error(f"Sync error: {e}")
            return False


def lambda_handler(event, context):
    """AWS Lambda handler for periodic sync"""
    sync = AWSConjurSync(
        aws_region='us-east-1',
        conjur_url='https://conjur.example.com',
        conjur_account='myorg'
    )

    sync.authenticate_conjur_iam()

    # Process sync mappings
    mappings = event.get('mappings', [])
    results = []

    for mapping in mappings:
        if mapping['direction'] == 'aws_to_conjur':
            success = sync.sync_aws_to_conjur(
                mapping['aws_secret'],
                mapping['conjur_variable']
            )
        else:
            success = sync.sync_conjur_to_aws(
                mapping['conjur_variable'],
                mapping['aws_secret']
            )

        results.append({
            'mapping': mapping,
            'success': success
        })

    return {
        'statusCode': 200,
        'body': json.dumps(results)
    }
```

---

## Azure Deployment

### CyberArk PAM on Azure

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": {
      "type": "string",
      "allowedValues": ["Production", "DR", "Development"]
    },
    "vaultVmSize": {
      "type": "string",
      "defaultValue": "Standard_D4s_v3"
    },
    "componentVmSize": {
      "type": "string",
      "defaultValue": "Standard_D2s_v3"
    }
  },
  "variables": {
    "vnetName": "[concat('pam-vnet-', parameters('environment'))]",
    "vnetAddressPrefix": "10.200.0.0/16",
    "vaultSubnetPrefix": "10.200.1.0/24",
    "componentSubnetPrefix": "10.200.10.0/24"
  },
  "resources": [
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2021-02-01",
      "name": "[variables('vnetName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": ["[variables('vnetAddressPrefix')]"]
        },
        "subnets": [
          {
            "name": "vault-subnet",
            "properties": {
              "addressPrefix": "[variables('vaultSubnetPrefix')]",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', 'vault-nsg')]"
              },
              "serviceEndpoints": [
                {"service": "Microsoft.KeyVault"},
                {"service": "Microsoft.Storage"}
              ]
            }
          },
          {
            "name": "component-subnet",
            "properties": {
              "addressPrefix": "[variables('componentSubnetPrefix')]",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', 'component-nsg')]"
              }
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2021-02-01",
      "name": "vault-nsg",
      "location": "[resourceGroup().location]",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-Vault-Protocol",
            "properties": {
              "priority": 100,
              "direction": "Inbound",
              "access": "Allow",
              "protocol": "Tcp",
              "sourceAddressPrefix": "[variables('componentSubnetPrefix')]",
              "sourcePortRange": "*",
              "destinationAddressPrefix": "*",
              "destinationPortRange": "1858"
            }
          },
          {
            "name": "Deny-All-Inbound",
            "properties": {
              "priority": 4096,
              "direction": "Inbound",
              "access": "Deny",
              "protocol": "*",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationAddressPrefix": "*",
              "destinationPortRange": "*"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2021-03-01",
      "name": "[concat('vault-primary-', parameters('environment'))]",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]"
      ],
      "properties": {
        "hardwareProfile": {
          "vmSize": "[parameters('vaultVmSize')]"
        },
        "storageProfile": {
          "osDisk": {
            "createOption": "FromImage",
            "managedDisk": {
              "storageAccountType": "Premium_LRS"
            },
            "diskSizeGB": 128
          },
          "dataDisks": [
            {
              "lun": 0,
              "createOption": "Empty",
              "diskSizeGB": 512,
              "managedDisk": {
                "storageAccountType": "Premium_LRS"
              }
            }
          ]
        },
        "osProfile": {
          "computerName": "[concat('vault-', parameters('environment'))]",
          "adminUsername": "pamadmin"
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', 'vault-nic')]"
            }
          ]
        },
        "securityProfile": {
          "encryptionAtHost": true
        }
      },
      "identity": {
        "type": "SystemAssigned"
      }
    },
    {
      "type": "Microsoft.KeyVault/vaults",
      "apiVersion": "2021-06-01-preview",
      "name": "[concat('pam-kv-', uniqueString(resourceGroup().id))]",
      "location": "[resourceGroup().location]",
      "properties": {
        "tenantId": "[subscription().tenantId]",
        "sku": {
          "family": "A",
          "name": "premium"
        },
        "enabledForDeployment": true,
        "enabledForDiskEncryption": true,
        "enabledForTemplateDeployment": true,
        "enableSoftDelete": true,
        "softDeleteRetentionInDays": 90,
        "enablePurgeProtection": true,
        "networkAcls": {
          "bypass": "AzureServices",
          "defaultAction": "Deny",
          "virtualNetworkRules": [
            {
              "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), 'vault-subnet')]"
            }
          ]
        }
      }
    }
  ]
}
```

### Conjur on Azure AKS

```yaml
# conjur_aks_deployment.yaml
# Conjur deployment for Azure AKS with Azure AD integration

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: conjur-primary
  namespace: conjur
spec:
  serviceName: conjur
  replicas: 1
  selector:
    matchLabels:
      app: conjur
      role: primary
  template:
    metadata:
      labels:
        app: conjur
        role: primary
        azure.workload.identity/use: "true"
    spec:
      serviceAccountName: conjur-workload-identity
      containers:
        - name: conjur
          image: cyberark/conjur:latest
          env:
            - name: CONJUR_AUTHENTICATORS
              value: "authn,authn-azure/azure,authn-k8s/aks-cluster"
            - name: AZURE_TENANT_ID
              valueFrom:
                secretKeyRef:
                  name: azure-config
                  key: tenant-id
          ports:
            - containerPort: 443
          volumeMounts:
            - name: conjur-ssl
              mountPath: /opt/conjur/etc/ssl
            - name: conjur-data
              mountPath: /var/lib/postgresql/data
      volumes:
        - name: conjur-ssl
          secret:
            secretName: conjur-ssl-cert
  volumeClaimTemplates:
    - metadata:
        name: conjur-data
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: managed-premium
        resources:
          requests:
            storage: 100Gi

---
# Azure AD Workload Identity
apiVersion: v1
kind: ServiceAccount
metadata:
  name: conjur-workload-identity
  namespace: conjur
  annotations:
    azure.workload.identity/client-id: "<client-id>"
    azure.workload.identity/tenant-id: "<tenant-id>"

---
# Azure Authenticator Policy
apiVersion: v1
kind: ConfigMap
metadata:
  name: conjur-azure-authn
  namespace: conjur
data:
  policy.yml: |
    - !policy
      id: authn-azure/azure
      body:
        - !webservice

        - !variable provider-uri

        - !group apps

        - !permit
          role: !group apps
          privileges: [read, authenticate]
          resource: !webservice

    # Define Azure identities
    - !host
      id: azure/<subscription-id>/<resource-group>/Microsoft.ManagedIdentity/userAssignedIdentities/<identity-name>
      annotations:
        authn-azure/subscription-id: <subscription-id>
        authn-azure/resource-group: <resource-group>

    - !grant
      role: !group authn-azure/azure/apps
      member: !host azure/<subscription-id>/<resource-group>/Microsoft.ManagedIdentity/userAssignedIdentities/<identity-name>

---
# Azure Application Gateway Ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: conjur-ingress
  namespace: conjur
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
    appgw.ingress.kubernetes.io/ssl-redirect: "true"
    appgw.ingress.kubernetes.io/backend-protocol: "https"
spec:
  tls:
    - hosts:
        - conjur.azure.example.com
      secretName: conjur-tls
  rules:
    - host: conjur.azure.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: conjur
                port:
                  number: 443
```

### Azure Key Vault Integration

```python
#!/usr/bin/env python3
"""
azure_conjur_integration.py
Azure Key Vault and Conjur integration
"""

from azure.identity import ManagedIdentityCredential, DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
import requests
import json
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class AzureConjurIntegration:
    """Integrate Azure Key Vault with Conjur"""

    def __init__(self,
                 key_vault_url: str,
                 conjur_url: str,
                 conjur_account: str,
                 use_managed_identity: bool = True):
        # Azure credentials
        if use_managed_identity:
            credential = ManagedIdentityCredential()
        else:
            credential = DefaultAzureCredential()

        self.kv_client = SecretClient(
            vault_url=key_vault_url,
            credential=credential
        )

        self.conjur_url = conjur_url
        self.conjur_account = conjur_account
        self.credential = credential

    def authenticate_conjur_azure(self) -> str:
        """Authenticate to Conjur using Azure AD"""
        # Get Azure AD token for Conjur
        token = self.credential.get_token(
            f"{self.conjur_url}/.default"
        )

        # Exchange for Conjur token
        response = requests.post(
            f"{self.conjur_url}/authn-azure/azure/{self.conjur_account}/authenticate",
            headers={
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            data={
                'jwt': token.token
            }
        )

        if response.status_code == 200:
            import base64
            self.conjur_token = base64.b64encode(
                response.content
            ).decode('utf-8')
            return self.conjur_token
        else:
            raise Exception(f"Azure auth failed: {response.text}")

    def sync_keyvault_to_conjur(self,
                                 kv_secret_name: str,
                                 conjur_variable: str) -> bool:
        """Sync secret from Key Vault to Conjur"""
        try:
            # Get from Key Vault
            secret = self.kv_client.get_secret(kv_secret_name)

            # Set in Conjur
            headers = {
                'Authorization': f'Token token="{self.conjur_token}"'
            }
            encoded_var = requests.utils.quote(conjur_variable, safe='')

            response = requests.post(
                f"{self.conjur_url}/secrets/{self.conjur_account}/variable/{encoded_var}",
                headers=headers,
                data=secret.value
            )

            return response.status_code == 201

        except Exception as e:
            logger.error(f"Sync error: {e}")
            return False

    def sync_conjur_to_keyvault(self,
                                 conjur_variable: str,
                                 kv_secret_name: str) -> bool:
        """Sync secret from Conjur to Key Vault"""
        try:
            # Get from Conjur
            headers = {
                'Authorization': f'Token token="{self.conjur_token}"'
            }
            encoded_var = requests.utils.quote(conjur_variable, safe='')

            response = requests.get(
                f"{self.conjur_url}/secrets/{self.conjur_account}/variable/{encoded_var}",
                headers=headers
            )

            if response.status_code != 200:
                return False

            # Set in Key Vault
            self.kv_client.set_secret(kv_secret_name, response.text)
            return True

        except Exception as e:
            logger.error(f"Sync error: {e}")
            return False


# Azure Function for periodic sync
def main(mytimer):
    """Azure Function timer trigger"""
    import os

    integration = AzureConjurIntegration(
        key_vault_url=os.environ['KEY_VAULT_URL'],
        conjur_url=os.environ['CONJUR_URL'],
        conjur_account=os.environ['CONJUR_ACCOUNT']
    )

    integration.authenticate_conjur_azure()

    # Process sync mappings from configuration
    mappings = json.loads(os.environ.get('SYNC_MAPPINGS', '[]'))

    for mapping in mappings:
        if mapping['direction'] == 'kv_to_conjur':
            integration.sync_keyvault_to_conjur(
                mapping['kv_secret'],
                mapping['conjur_variable']
            )
        else:
            integration.sync_conjur_to_keyvault(
                mapping['conjur_variable'],
                mapping['kv_secret']
            )
```

---

## GCP Deployment

### CyberArk PAM on GCP

```yaml
# gcp_pam_deployment.yaml
# Terraform configuration for CyberArk PAM on GCP

resource "google_compute_network" "pam_vpc" {
  name                    = "pam-vpc-${var.environment}"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "vault_subnet" {
  name          = "vault-subnet-${var.environment}"
  ip_cidr_range = "10.150.1.0/24"
  region        = var.region
  network       = google_compute_network.pam_vpc.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "component_subnet" {
  name          = "component-subnet-${var.environment}"
  ip_cidr_range = "10.150.10.0/24"
  region        = var.region
  network       = google_compute_network.pam_vpc.id
}

# Vault Instance
resource "google_compute_instance" "vault_primary" {
  name         = "vault-primary-${var.environment}"
  machine_type = "n2-standard-4"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = var.vault_image
      size  = 100
      type  = "pd-ssd"
    }
    kms_key_self_link = google_kms_crypto_key.vault_key.id
  }

  attached_disk {
    source      = google_compute_disk.vault_data.id
    device_name = "vault-data"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vault_subnet.id
    # No external IP - private only
  }

  service_account {
    email  = google_service_account.vault_sa.email
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  tags = ["vault", var.environment]
}

# Data disk for Vault safes
resource "google_compute_disk" "vault_data" {
  name = "vault-data-${var.environment}"
  type = "pd-ssd"
  zone = "${var.region}-a"
  size = 500

  disk_encryption_key {
    kms_key_self_link = google_kms_crypto_key.vault_key.id
  }
}

# KMS for encryption
resource "google_kms_key_ring" "pam_keyring" {
  name     = "pam-keyring-${var.environment}"
  location = var.region
}

resource "google_kms_crypto_key" "vault_key" {
  name     = "vault-encryption-key"
  key_ring = google_kms_key_ring.pam_keyring.id

  rotation_period = "7776000s" # 90 days

  lifecycle {
    prevent_destroy = true
  }
}

# Firewall rules
resource "google_compute_firewall" "vault_ingress" {
  name    = "vault-ingress-${var.environment}"
  network = google_compute_network.pam_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["1858"]
  }

  source_ranges = [google_compute_subnetwork.component_subnet.ip_cidr_range]
  target_tags   = ["vault"]
}

resource "google_compute_firewall" "deny_all" {
  name    = "deny-all-${var.environment}"
  network = google_compute_network.pam_vpc.name

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 65534
}

# Internal Load Balancer for PVWA
resource "google_compute_forwarding_rule" "pvwa_ilb" {
  name                  = "pvwa-ilb-${var.environment}"
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.pvwa_backend.id
  ports                 = ["443"]
  network               = google_compute_network.pam_vpc.id
  subnetwork            = google_compute_subnetwork.component_subnet.id
}
```

### Conjur on GKE

```yaml
# conjur_gke_deployment.yaml
# Conjur deployment for GKE with Workload Identity

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: conjur-primary
  namespace: conjur
spec:
  serviceName: conjur
  replicas: 1
  selector:
    matchLabels:
      app: conjur
  template:
    metadata:
      labels:
        app: conjur
    spec:
      serviceAccountName: conjur-gke-sa
      nodeSelector:
        iam.gke.io/gke-metadata-server-enabled: "true"
      containers:
        - name: conjur
          image: cyberark/conjur:latest
          env:
            - name: CONJUR_AUTHENTICATORS
              value: "authn,authn-gcp/gcp,authn-k8s/gke-cluster"
            - name: GCP_PROJECT_ID
              valueFrom:
                configMapKeyRef:
                  name: gcp-config
                  key: project-id
          ports:
            - containerPort: 443
          volumeMounts:
            - name: conjur-ssl
              mountPath: /opt/conjur/etc/ssl
            - name: conjur-data
              mountPath: /var/lib/postgresql/data
      volumes:
        - name: conjur-ssl
          secret:
            secretName: conjur-ssl-cert
  volumeClaimTemplates:
    - metadata:
        name: conjur-data
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: premium-rwo
        resources:
          requests:
            storage: 100Gi

---
# GKE Workload Identity ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: conjur-gke-sa
  namespace: conjur
  annotations:
    iam.gke.io/gcp-service-account: conjur-wi@project-id.iam.gserviceaccount.com

---
# GCP Authenticator Policy
apiVersion: v1
kind: ConfigMap
metadata:
  name: conjur-gcp-authn
  namespace: conjur
data:
  policy.yml: |
    - !policy
      id: authn-gcp/gcp
      body:
        - !webservice

        - !group gcp-hosts

        - !permit
          role: !group gcp-hosts
          privileges: [read, authenticate]
          resource: !webservice

    # GCE Instance identity
    - !host
      id: gcp/projects/<project-number>/zones/<zone>/instances/<instance-name>
      annotations:
        authn-gcp/project-id: <project-id>
        authn-gcp/service-account-id: <sa-id>
        authn-gcp/service-account-email: <sa>@<project>.iam.gserviceaccount.com

    - !grant
      role: !group authn-gcp/gcp/gcp-hosts
      member: !host gcp/projects/<project-number>/zones/<zone>/instances/<instance-name>

---
# GKE Ingress with Cloud Armor
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: conjur-ingress
  namespace: conjur
  annotations:
    kubernetes.io/ingress.class: "gce-internal"
    kubernetes.io/ingress.regional-static-ip-name: "conjur-ip"
spec:
  tls:
    - hosts:
        - conjur.gcp.example.com
      secretName: conjur-tls
  rules:
    - host: conjur.gcp.example.com
      http:
        paths:
          - path: /*
            pathType: ImplementationSpecific
            backend:
              service:
                name: conjur
                port:
                  number: 443
```

### GCP Secret Manager Integration

```python
#!/usr/bin/env python3
"""
gcp_conjur_integration.py
GCP Secret Manager and Conjur integration
"""

from google.cloud import secretmanager
from google.auth import default
from google.auth.transport.requests import Request
import google.auth.transport.requests
import requests
import json
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class GCPConjurIntegration:
    """Integrate GCP Secret Manager with Conjur"""

    def __init__(self,
                 project_id: str,
                 conjur_url: str,
                 conjur_account: str):
        self.project_id = project_id
        self.sm_client = secretmanager.SecretManagerServiceClient()
        self.conjur_url = conjur_url
        self.conjur_account = conjur_account

        # Get GCP credentials
        self.credentials, _ = default()

    def authenticate_conjur_gcp(self) -> str:
        """Authenticate to Conjur using GCP identity"""
        # Refresh credentials
        auth_req = google.auth.transport.requests.Request()
        self.credentials.refresh(auth_req)

        # Get identity token
        id_token = self.credentials.token

        # Authenticate to Conjur
        response = requests.post(
            f"{self.conjur_url}/authn-gcp/gcp/{self.conjur_account}/authenticate",
            headers={
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            data={
                'jwt': id_token
            }
        )

        if response.status_code == 200:
            import base64
            self.conjur_token = base64.b64encode(
                response.content
            ).decode('utf-8')
            return self.conjur_token
        else:
            raise Exception(f"GCP auth failed: {response.text}")

    def get_secret_from_gcp(self, secret_name: str,
                            version: str = "latest") -> str:
        """Get secret from GCP Secret Manager"""
        name = f"projects/{self.project_id}/secrets/{secret_name}/versions/{version}"
        response = self.sm_client.access_secret_version(request={"name": name})
        return response.payload.data.decode("UTF-8")

    def set_secret_in_gcp(self, secret_name: str, value: str) -> str:
        """Set secret in GCP Secret Manager"""
        parent = f"projects/{self.project_id}"

        try:
            # Try to create secret
            self.sm_client.create_secret(
                request={
                    "parent": parent,
                    "secret_id": secret_name,
                    "secret": {"replication": {"automatic": {}}},
                }
            )
        except Exception:
            # Secret exists, continue
            pass

        # Add version
        secret_path = f"{parent}/secrets/{secret_name}"
        response = self.sm_client.add_secret_version(
            request={
                "parent": secret_path,
                "payload": {"data": value.encode("UTF-8")},
            }
        )

        return response.name

    def sync_gcp_to_conjur(self,
                           gcp_secret: str,
                           conjur_variable: str) -> bool:
        """Sync from GCP Secret Manager to Conjur"""
        try:
            # Get from GCP
            value = self.get_secret_from_gcp(gcp_secret)

            # Set in Conjur
            headers = {
                'Authorization': f'Token token="{self.conjur_token}"'
            }
            encoded_var = requests.utils.quote(conjur_variable, safe='')

            response = requests.post(
                f"{self.conjur_url}/secrets/{self.conjur_account}/variable/{encoded_var}",
                headers=headers,
                data=value
            )

            return response.status_code == 201

        except Exception as e:
            logger.error(f"Sync error: {e}")
            return False


# Cloud Function for sync
def sync_secrets(request):
    """Cloud Function HTTP trigger"""
    import os

    integration = GCPConjurIntegration(
        project_id=os.environ['GCP_PROJECT'],
        conjur_url=os.environ['CONJUR_URL'],
        conjur_account=os.environ['CONJUR_ACCOUNT']
    )

    integration.authenticate_conjur_gcp()

    request_json = request.get_json(silent=True)
    mappings = request_json.get('mappings', [])

    results = []
    for mapping in mappings:
        success = integration.sync_gcp_to_conjur(
            mapping['gcp_secret'],
            mapping['conjur_variable']
        )
        results.append({'mapping': mapping, 'success': success})

    return json.dumps(results)
```

---

## Cross-Cloud Connectivity

### Network Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   Cross-Cloud Network Topology                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                    ┌──────────────────────┐                            │
│                    │   Transit Hub        │                            │
│                    │   (On-Premises)      │                            │
│                    │   ┌──────────────┐   │                            │
│                    │   │ IPsec VPN    │   │                            │
│                    │   │ Gateway      │   │                            │
│                    │   └──────────────┘   │                            │
│                    └──────────┬───────────┘                            │
│                               │                                         │
│         ┌─────────────────────┼─────────────────────┐                  │
│         │                     │                     │                   │
│         ▼                     ▼                     ▼                   │
│  ┌─────────────┐      ┌─────────────┐      ┌─────────────┐             │
│  │    AWS      │      │    Azure    │      │    GCP      │             │
│  │ Transit GW  │◄────►│   vWAN      │◄────►│ Cloud Int.  │             │
│  └──────┬──────┘      └──────┬──────┘      └──────┬──────┘             │
│         │                    │                    │                     │
│         ▼                    ▼                    ▼                     │
│  ┌─────────────┐      ┌─────────────┐      ┌─────────────┐             │
│  │ PAM VPC     │      │ PAM VNet    │      │ PAM VPC     │             │
│  │ 10.100.0.0  │      │ 10.200.0.0  │      │ 10.150.0.0  │             │
│  │ /16         │      │ /16         │      │ /16         │             │
│  └─────────────┘      └─────────────┘      └─────────────┘             │
│                                                                         │
│  Direct Cloud Interconnects (Optional):                                │
│  ├── AWS Direct Connect + Azure ExpressRoute                           │
│  ├── AWS Direct Connect + GCP Cloud Interconnect                       │
│  └── Azure ExpressRoute + GCP Cloud Interconnect                       │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### VPN Configuration

```yaml
# cross_cloud_vpn.yaml
# VPN configuration for cross-cloud connectivity

aws_vpn:
  # Site-to-Site VPN to On-Premises
  on_prem_connection:
    customer_gateway_ip: "203.0.113.10"
    bgp_asn: 65000
    tunnel_options:
      - tunnel_inside_cidr: "169.254.100.0/30"
        pre_shared_key: "${VPN_PSK_1}"
      - tunnel_inside_cidr: "169.254.100.4/30"
        pre_shared_key: "${VPN_PSK_2}"

  # Transit Gateway for multi-VPC
  transit_gateway:
    asn: 64512
    attachments:
      - vpc_id: "vpc-pam-prod"
        subnet_ids: ["subnet-tgw-a", "subnet-tgw-b"]
      - vpc_id: "vpc-pam-dr"
        subnet_ids: ["subnet-tgw-dr-a"]

azure_vpn:
  # Virtual WAN configuration
  virtual_wan:
    name: "pam-vwan"
    hubs:
      - name: "pam-hub-eastus"
        address_prefix: "10.250.0.0/24"
        vpn_gateway:
          scale_unit: 1

  # VPN to On-Premises
  vpn_site:
    name: "on-prem-dc"
    device_vendor: "Generic"
    links:
      - name: "link1"
        ip_address: "203.0.113.10"
        bgp:
          asn: 65000
          peering_address: "10.0.0.1"

gcp_vpn:
  # Cloud VPN HA
  ha_vpn_gateway:
    name: "pam-vpn-gateway"
    network: "pam-vpc"
    region: "us-central1"

  # Tunnels to On-Premises
  vpn_tunnels:
    - name: "tunnel-to-onprem-1"
      peer_ip: "203.0.113.10"
      shared_secret: "${VPN_PSK_GCP_1}"
      router: "pam-router"
      vpn_gateway_interface: 0

    - name: "tunnel-to-onprem-2"
      peer_ip: "203.0.113.11"
      shared_secret: "${VPN_PSK_GCP_2}"
      router: "pam-router"
      vpn_gateway_interface: 1

  # Cloud Router for BGP
  cloud_router:
    name: "pam-router"
    network: "pam-vpc"
    asn: 64513
    bgp_peers:
      - name: "peer-onprem-1"
        peer_ip: "169.254.200.1"
        peer_asn: 65000
```

### DNS Configuration

```yaml
# cross_cloud_dns.yaml
# Unified DNS for multi-cloud PAM

dns_zones:
  # Primary zone
  pam_internal:
    name: "pam.internal"
    type: "private"

    # AWS Route 53
    aws:
      hosted_zone_id: "Z1234567890"
      vpc_associations:
        - vpc_id: "vpc-pam-prod"
          region: "us-east-1"

    # Azure Private DNS
    azure:
      resource_group: "pam-rg"
      virtual_network_links:
        - vnet_id: "/subscriptions/.../pam-vnet"
          registration_enabled: false

    # GCP Cloud DNS
    gcp:
      managed_zone: "pam-internal"
      networks:
        - "projects/myproject/global/networks/pam-vpc"

records:
  # CyberArk Vault
  - name: "vault"
    type: "A"
    values:
      - cloud: "aws"
        value: "10.100.1.10"
        health_check: true
      - cloud: "azure"
        value: "10.200.1.10"
        health_check: true
        weight: 0  # Standby

  # PVWA
  - name: "pvwa"
    type: "A"
    values:
      - cloud: "aws"
        value: "10.100.10.100"  # ALB internal IP
      - cloud: "azure"
        value: "10.200.10.100"

  # Conjur
  - name: "conjur"
    type: "A"
    values:
      - cloud: "aws"
        value: "10.100.20.10"
      - cloud: "azure"
        value: "10.200.20.10"
      - cloud: "gcp"
        value: "10.150.20.10"

  # Region-specific endpoints
  - name: "conjur.aws"
    type: "A"
    value: "10.100.20.10"

  - name: "conjur.azure"
    type: "A"
    value: "10.200.20.10"

  - name: "conjur.gcp"
    type: "A"
    value: "10.150.20.10"
```

---

## Identity Federation

### Cross-Cloud Identity Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Identity Federation Architecture                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                    ┌──────────────────────┐                            │
│                    │   Identity Provider  │                            │
│                    │   (Okta/Azure AD)    │                            │
│                    └──────────┬───────────┘                            │
│                               │                                         │
│                    ┌──────────▼───────────┐                            │
│                    │      Conjur          │                            │
│                    │  (Central Authority) │                            │
│                    └──────────┬───────────┘                            │
│                               │                                         │
│         ┌─────────────────────┼─────────────────────┐                  │
│         │                     │                     │                   │
│         ▼                     ▼                     ▼                   │
│  ┌─────────────┐      ┌─────────────┐      ┌─────────────┐             │
│  │  AWS IAM    │      │ Azure AD    │      │  GCP IAM    │             │
│  │             │      │             │      │             │             │
│  │ authn-iam   │      │ authn-azure │      │ authn-gcp   │             │
│  └─────────────┘      └─────────────┘      └─────────────┘             │
│         │                     │                     │                   │
│         ▼                     ▼                     ▼                   │
│  ┌─────────────┐      ┌─────────────┐      ┌─────────────┐             │
│  │ AWS         │      │ Azure       │      │ GCP         │             │
│  │ Workloads   │      │ Workloads   │      │ Workloads   │             │
│  └─────────────┘      └─────────────┘      └─────────────┘             │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Unified Policy Example

```yaml
# multicloud_identity_policy.yml
# Conjur policy for multi-cloud identity federation

# Root policy structure
- !policy
  id: multicloud
  body:
    # Cloud-specific host factories
    - !policy
      id: aws
      body:
        - !layer ec2-instances
        - !layer lambda-functions
        - !layer ecs-tasks

        # AWS IAM role mapping
        - !host-factory
          id: aws-hosts
          layers:
            - !layer ec2-instances
            - !layer lambda-functions

    - !policy
      id: azure
      body:
        - !layer vms
        - !layer functions
        - !layer aks-pods

        # Azure managed identity mapping
        - !host-factory
          id: azure-hosts
          layers:
            - !layer vms
            - !layer functions

    - !policy
      id: gcp
      body:
        - !layer gce-instances
        - !layer cloud-functions
        - !layer gke-pods

        # GCP service account mapping
        - !host-factory
          id: gcp-hosts
          layers:
            - !layer gce-instances
            - !layer cloud-functions

    # Cross-cloud application secrets
    - !policy
      id: apps
      body:
        - !policy
          id: payment-service
          body:
            # Secrets used by payment service across clouds
            - &payment-secrets
              - !variable database/host
              - !variable database/username
              - !variable database/password
              - !variable api/key
              - !variable encryption/key

            # Grant access to all cloud layers running payment service
            - !permit
              role: !layer /multicloud/aws/ecs-tasks
              privileges: [read, execute]
              resources: *payment-secrets

            - !permit
              role: !layer /multicloud/azure/aks-pods
              privileges: [read, execute]
              resources: *payment-secrets

            - !permit
              role: !layer /multicloud/gcp/gke-pods
              privileges: [read, execute]
              resources: *payment-secrets

# AWS IAM Authenticator
- !policy
  id: authn-iam
  body:
    - !webservice aws

    - !group authenticated-roles

    - !permit
      role: !group authenticated-roles
      privileges: [read, authenticate]
      resource: !webservice aws

# Azure AD Authenticator
- !policy
  id: authn-azure
  body:
    - !webservice azure

    - !variable provider-uri

    - !group authenticated-identities

    - !permit
      role: !group authenticated-identities
      privileges: [read, authenticate]
      resource: !webservice azure

# GCP Authenticator
- !policy
  id: authn-gcp
  body:
    - !webservice gcp

    - !group authenticated-accounts

    - !permit
      role: !group authenticated-accounts
      privileges: [read, authenticate]
      resource: !webservice gcp
```

---

## Secrets Synchronization

### Synchronization Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                 Secrets Synchronization Patterns                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Pattern A: Conjur as Single Source of Truth                           │
│  ┌─────────────────────────────────────────────────────────┐           │
│  │                                                          │           │
│  │              ┌──────────────┐                           │           │
│  │              │    Conjur    │                           │           │
│  │              │   (Leader)   │                           │           │
│  │              └──────┬───────┘                           │           │
│  │                     │                                    │           │
│  │        ┌────────────┼────────────┐                      │           │
│  │        │            │            │                       │           │
│  │        ▼            ▼            ▼                       │           │
│  │   ┌────────┐  ┌────────┐  ┌────────┐                    │           │
│  │   │ AWS SM │  │ Az KV  │  │ GCP SM │ (Read-only sync)   │           │
│  │   └────────┘  └────────┘  └────────┘                    │           │
│  │                                                          │           │
│  └─────────────────────────────────────────────────────────┘           │
│                                                                         │
│  Pattern B: Bidirectional Sync with Conflict Resolution                │
│  ┌─────────────────────────────────────────────────────────┐           │
│  │                                                          │           │
│  │   ┌────────┐        ┌────────┐        ┌────────┐        │           │
│  │   │ AWS SM │◄──────►│ Conjur │◄──────►│ Az KV  │        │           │
│  │   └────────┘        └────────┘        └────────┘        │           │
│  │        │                │                  │             │           │
│  │        └────────────────┼──────────────────┘             │           │
│  │                         │                                │           │
│  │                    ┌────────┐                            │           │
│  │                    │ GCP SM │                            │           │
│  │                    └────────┘                            │           │
│  │                                                          │           │
│  │  Conflict Resolution: Last-write-wins with timestamps    │           │
│  │                                                          │           │
│  └─────────────────────────────────────────────────────────┘           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Synchronization Service

```python
#!/usr/bin/env python3
"""
multicloud_secrets_sync.py
Unified secrets synchronization across cloud providers
"""

import asyncio
from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from typing import Dict, List, Optional
import logging
import hashlib

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class CloudProvider(Enum):
    AWS = "aws"
    AZURE = "azure"
    GCP = "gcp"
    CONJUR = "conjur"


@dataclass
class SecretMetadata:
    name: str
    provider: CloudProvider
    version: str
    last_modified: datetime
    checksum: str


@dataclass
class SyncMapping:
    source_provider: CloudProvider
    source_path: str
    target_provider: CloudProvider
    target_path: str
    direction: str  # "one-way" or "bidirectional"


class MultiCloudSecretsSync:
    """Synchronize secrets across cloud providers"""

    def __init__(self, config: Dict):
        self.config = config
        self.clients = {}
        self._initialize_clients()

    def _initialize_clients(self):
        """Initialize cloud provider clients"""
        # AWS
        if 'aws' in self.config:
            import boto3
            self.clients[CloudProvider.AWS] = boto3.client(
                'secretsmanager',
                region_name=self.config['aws']['region']
            )

        # Azure
        if 'azure' in self.config:
            from azure.identity import DefaultAzureCredential
            from azure.keyvault.secrets import SecretClient
            credential = DefaultAzureCredential()
            self.clients[CloudProvider.AZURE] = SecretClient(
                vault_url=self.config['azure']['vault_url'],
                credential=credential
            )

        # GCP
        if 'gcp' in self.config:
            from google.cloud import secretmanager
            self.clients[CloudProvider.GCP] = secretmanager.SecretManagerServiceClient()

        # Conjur (custom client)
        if 'conjur' in self.config:
            self.clients[CloudProvider.CONJUR] = ConjurClient(
                url=self.config['conjur']['url'],
                account=self.config['conjur']['account']
            )

    async def get_secret(self,
                         provider: CloudProvider,
                         path: str) -> tuple[str, SecretMetadata]:
        """Get secret from specified provider"""
        if provider == CloudProvider.AWS:
            return await self._get_aws_secret(path)
        elif provider == CloudProvider.AZURE:
            return await self._get_azure_secret(path)
        elif provider == CloudProvider.GCP:
            return await self._get_gcp_secret(path)
        elif provider == CloudProvider.CONJUR:
            return await self._get_conjur_secret(path)

    async def set_secret(self,
                         provider: CloudProvider,
                         path: str,
                         value: str) -> bool:
        """Set secret in specified provider"""
        if provider == CloudProvider.AWS:
            return await self._set_aws_secret(path, value)
        elif provider == CloudProvider.AZURE:
            return await self._set_azure_secret(path, value)
        elif provider == CloudProvider.GCP:
            return await self._set_gcp_secret(path, value)
        elif provider == CloudProvider.CONJUR:
            return await self._set_conjur_secret(path, value)

    async def sync_secret(self, mapping: SyncMapping) -> Dict:
        """Sync a single secret based on mapping"""
        result = {
            'mapping': mapping,
            'success': False,
            'action': None
        }

        try:
            # Get source secret
            source_value, source_meta = await self.get_secret(
                mapping.source_provider,
                mapping.source_path
            )

            if mapping.direction == "bidirectional":
                # Check target for newer version
                try:
                    target_value, target_meta = await self.get_secret(
                        mapping.target_provider,
                        mapping.target_path
                    )

                    # Compare timestamps
                    if target_meta.last_modified > source_meta.last_modified:
                        # Target is newer, sync back to source
                        await self.set_secret(
                            mapping.source_provider,
                            mapping.source_path,
                            target_value
                        )
                        result['action'] = 'synced_to_source'
                    elif source_meta.checksum != target_meta.checksum:
                        # Source is newer or same age but different
                        await self.set_secret(
                            mapping.target_provider,
                            mapping.target_path,
                            source_value
                        )
                        result['action'] = 'synced_to_target'
                    else:
                        result['action'] = 'no_change'

                except Exception:
                    # Target doesn't exist, create it
                    await self.set_secret(
                        mapping.target_provider,
                        mapping.target_path,
                        source_value
                    )
                    result['action'] = 'created_in_target'
            else:
                # One-way sync
                await self.set_secret(
                    mapping.target_provider,
                    mapping.target_path,
                    source_value
                )
                result['action'] = 'synced_to_target'

            result['success'] = True

        except Exception as e:
            logger.error(f"Sync failed: {e}")
            result['error'] = str(e)

        return result

    async def run_sync(self, mappings: List[SyncMapping]) -> List[Dict]:
        """Run synchronization for all mappings"""
        tasks = [self.sync_secret(m) for m in mappings]
        results = await asyncio.gather(*tasks, return_exceptions=True)
        return results

    # Provider-specific implementations
    async def _get_aws_secret(self, path: str):
        client = self.clients[CloudProvider.AWS]
        response = client.get_secret_value(SecretId=path)

        metadata = SecretMetadata(
            name=path,
            provider=CloudProvider.AWS,
            version=response['VersionId'],
            last_modified=response.get('CreatedDate', datetime.now()),
            checksum=hashlib.md5(
                response['SecretString'].encode()
            ).hexdigest()
        )

        return response['SecretString'], metadata

    async def _set_aws_secret(self, path: str, value: str) -> bool:
        client = self.clients[CloudProvider.AWS]
        try:
            client.put_secret_value(SecretId=path, SecretString=value)
        except client.exceptions.ResourceNotFoundException:
            client.create_secret(Name=path, SecretString=value)
        return True

    # Similar implementations for Azure, GCP, Conjur...


class ConjurClient:
    """Simplified Conjur client"""

    def __init__(self, url: str, account: str):
        self.url = url
        self.account = account
        self.token = None

    async def get_secret(self, path: str) -> str:
        import requests
        headers = {'Authorization': f'Token token="{self.token}"'}
        encoded = requests.utils.quote(path, safe='')
        response = requests.get(
            f"{self.url}/secrets/{self.account}/variable/{encoded}",
            headers=headers
        )
        return response.text

    async def set_secret(self, path: str, value: str) -> bool:
        import requests
        headers = {'Authorization': f'Token token="{self.token}"'}
        encoded = requests.utils.quote(path, safe='')
        response = requests.post(
            f"{self.url}/secrets/{self.account}/variable/{encoded}",
            headers=headers,
            data=value
        )
        return response.status_code == 201


# Configuration example
sync_config = {
    "aws": {"region": "us-east-1"},
    "azure": {"vault_url": "https://myvault.vault.azure.net"},
    "gcp": {"project_id": "my-project"},
    "conjur": {
        "url": "https://conjur.example.com",
        "account": "myorg"
    }
}

# Mapping example
sync_mappings = [
    SyncMapping(
        source_provider=CloudProvider.CONJUR,
        source_path="apps/payment/database/password",
        target_provider=CloudProvider.AWS,
        target_path="payment-db-password",
        direction="one-way"
    ),
    SyncMapping(
        source_provider=CloudProvider.CONJUR,
        source_path="apps/payment/database/password",
        target_provider=CloudProvider.AZURE,
        target_path="payment-db-password",
        direction="one-way"
    )
]


async def main():
    sync = MultiCloudSecretsSync(sync_config)
    results = await sync.run_sync(sync_mappings)
    for r in results:
        logger.info(f"Sync result: {r}")


if __name__ == "__main__":
    asyncio.run(main())
```

---

## Unified Management

### Multi-Cloud Dashboard

```yaml
# grafana_multicloud_dashboard.yaml
# Grafana dashboard for multi-cloud PAM monitoring

apiVersion: 1
dashboards:
  - name: "Multi-Cloud PAM Overview"
    panels:
      # Health Status Panel
      - title: "Cloud Health Status"
        type: stat
        gridPos: {h: 4, w: 24, x: 0, y: 0}
        targets:
          - expr: 'up{job=~"conjur-.*"}'
            legendFormat: "{{cloud}}"

      # Secrets by Cloud
      - title: "Secrets Distribution"
        type: piechart
        gridPos: {h: 8, w: 8, x: 0, y: 4}
        targets:
          - expr: 'conjur_secrets_total{cloud="aws"}'
            legendFormat: "AWS"
          - expr: 'conjur_secrets_total{cloud="azure"}'
            legendFormat: "Azure"
          - expr: 'conjur_secrets_total{cloud="gcp"}'
            legendFormat: "GCP"

      # Authentication by Cloud
      - title: "Authentications by Cloud"
        type: timeseries
        gridPos: {h: 8, w: 16, x: 8, y: 4}
        targets:
          - expr: 'rate(conjur_authentications_total[5m])'
            legendFormat: "{{cloud}} - {{authenticator}}"

      # Sync Status
      - title: "Cross-Cloud Sync Status"
        type: table
        gridPos: {h: 8, w: 12, x: 0, y: 12}
        targets:
          - expr: 'secrets_sync_last_success'
            format: table

      # Latency by Region
      - title: "API Latency by Cloud Region"
        type: timeseries
        gridPos: {h: 8, w: 12, x: 12, y: 12}
        targets:
          - expr: 'histogram_quantile(0.95, rate(conjur_api_request_duration_seconds_bucket[5m]))'
            legendFormat: "{{cloud}}-{{region}} p95"

      # Error Rates
      - title: "Error Rate by Cloud"
        type: timeseries
        gridPos: {h: 6, w: 24, x: 0, y: 20}
        targets:
          - expr: 'rate(conjur_errors_total[5m])'
            legendFormat: "{{cloud}} - {{error_type}}"
```

### Unified CLI Tool

```python
#!/usr/bin/env python3
"""
pam_multicloud_cli.py
Unified CLI for multi-cloud PAM management
"""

import click
import json
from tabulate import tabulate


@click.group()
@click.option('--config', '-c', default='~/.pam-cli/config.yaml',
              help='Configuration file path')
@click.pass_context
def cli(ctx, config):
    """Multi-Cloud PAM Management CLI"""
    ctx.ensure_object(dict)
    ctx.obj['config'] = load_config(config)


@cli.group()
def secrets():
    """Manage secrets across clouds"""
    pass


@secrets.command('list')
@click.option('--cloud', '-c', type=click.Choice(['aws', 'azure', 'gcp', 'conjur', 'all']),
              default='all', help='Cloud provider')
@click.option('--path', '-p', default='/', help='Secret path prefix')
@click.pass_context
def secrets_list(ctx, cloud, path):
    """List secrets across cloud providers"""
    results = []

    if cloud in ['all', 'conjur']:
        conjur_secrets = list_conjur_secrets(ctx.obj['config'], path)
        results.extend([{'cloud': 'conjur', **s} for s in conjur_secrets])

    if cloud in ['all', 'aws']:
        aws_secrets = list_aws_secrets(ctx.obj['config'], path)
        results.extend([{'cloud': 'aws', **s} for s in aws_secrets])

    if cloud in ['all', 'azure']:
        azure_secrets = list_azure_secrets(ctx.obj['config'], path)
        results.extend([{'cloud': 'azure', **s} for s in azure_secrets])

    if cloud in ['all', 'gcp']:
        gcp_secrets = list_gcp_secrets(ctx.obj['config'], path)
        results.extend([{'cloud': 'gcp', **s} for s in gcp_secrets])

    headers = ['Cloud', 'Name', 'Last Modified', 'Version']
    rows = [[r['cloud'], r['name'], r['modified'], r['version']] for r in results]

    click.echo(tabulate(rows, headers=headers, tablefmt='grid'))


@secrets.command('get')
@click.argument('path')
@click.option('--cloud', '-c', required=True,
              type=click.Choice(['aws', 'azure', 'gcp', 'conjur']))
@click.pass_context
def secrets_get(ctx, path, cloud):
    """Get a secret from specified cloud"""
    if cloud == 'conjur':
        value = get_conjur_secret(ctx.obj['config'], path)
    elif cloud == 'aws':
        value = get_aws_secret(ctx.obj['config'], path)
    elif cloud == 'azure':
        value = get_azure_secret(ctx.obj['config'], path)
    elif cloud == 'gcp':
        value = get_gcp_secret(ctx.obj['config'], path)

    click.echo(value)


@secrets.command('sync')
@click.option('--source', '-s', required=True,
              type=click.Choice(['aws', 'azure', 'gcp', 'conjur']))
@click.option('--target', '-t', required=True,
              type=click.Choice(['aws', 'azure', 'gcp', 'conjur']))
@click.option('--path', '-p', required=True, help='Secret path to sync')
@click.pass_context
def secrets_sync(ctx, source, target, path):
    """Sync a secret between cloud providers"""
    click.echo(f"Syncing {path} from {source} to {target}...")

    # Get from source
    if source == 'conjur':
        value = get_conjur_secret(ctx.obj['config'], path)
    # ... other sources

    # Set in target
    if target == 'aws':
        set_aws_secret(ctx.obj['config'], path, value)
    # ... other targets

    click.echo(f"Successfully synced {path}")


@cli.group()
def health():
    """Check health status across clouds"""
    pass


@health.command('status')
@click.pass_context
def health_status(ctx):
    """Show health status of all PAM components"""
    status = []

    # Check each cloud
    for cloud in ['aws', 'azure', 'gcp']:
        cloud_status = check_cloud_health(ctx.obj['config'], cloud)
        status.extend(cloud_status)

    headers = ['Cloud', 'Component', 'Status', 'Latency', 'Last Check']
    rows = [[s['cloud'], s['component'], s['status'],
             f"{s['latency']}ms", s['timestamp']] for s in status]

    click.echo(tabulate(rows, headers=headers, tablefmt='grid'))


@cli.group()
def policies():
    """Manage Conjur policies"""
    pass


@policies.command('apply')
@click.argument('policy_file', type=click.Path(exists=True))
@click.option('--branch', '-b', default='root', help='Policy branch')
@click.pass_context
def policies_apply(ctx, policy_file, branch):
    """Apply a Conjur policy"""
    with open(policy_file) as f:
        policy_content = f.read()

    result = apply_conjur_policy(ctx.obj['config'], branch, policy_content)
    click.echo(f"Policy applied: {result}")


if __name__ == '__main__':
    cli()
```

---

## Security Considerations

### Multi-Cloud Security Checklist

```markdown
# Multi-Cloud PAM Security Checklist

## Network Security
- [ ] All cross-cloud traffic encrypted (TLS 1.2+)
- [ ] VPN tunnels use strong encryption (AES-256)
- [ ] Network segmentation between PAM and workloads
- [ ] No public IP addresses on PAM components
- [ ] Firewall rules follow least privilege
- [ ] DDoS protection enabled on public endpoints

## Identity Security
- [ ] Federated identity from single IdP
- [ ] MFA required for all privileged access
- [ ] Service account rotation automated
- [ ] Workload identity (no static credentials)
- [ ] Regular access reviews across clouds
- [ ] Break-glass procedures documented

## Data Security
- [ ] Encryption at rest (cloud KMS)
- [ ] Encryption in transit (TLS)
- [ ] Key management centralized
- [ ] Backup encryption separate keys
- [ ] Data residency requirements met
- [ ] No secrets in logs or metrics

## Secrets Management
- [ ] Conjur as single source of truth
- [ ] Automatic rotation configured
- [ ] Secret access audited
- [ ] No hardcoded credentials
- [ ] CI/CD using dynamic credentials
- [ ] Secret sprawl monitoring

## Monitoring & Audit
- [ ] Centralized logging (SIEM)
- [ ] Cross-cloud correlation
- [ ] Real-time alerting
- [ ] Audit trail retention (compliance)
- [ ] Regular security assessments
- [ ] Incident response tested

## Compliance
- [ ] SOC 2 controls mapped
- [ ] PCI-DSS requirements (if applicable)
- [ ] GDPR data handling
- [ ] HIPAA safeguards (if applicable)
- [ ] Regular compliance audits
- [ ] Evidence collection automated
```

### Threat Model

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Multi-Cloud PAM Threat Model                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Threat: Cross-Cloud Credential Theft                                   │
│  ├── Attack Vector: Compromised workload in one cloud                  │
│  ├── Impact: Access to secrets in all clouds                           │
│  └── Mitigation:                                                        │
│      • Workload-specific permissions (least privilege)                  │
│      • Cross-cloud access requires re-authentication                    │
│      • Anomaly detection on access patterns                            │
│                                                                         │
│  Threat: Network Interception                                           │
│  ├── Attack Vector: Man-in-the-middle on VPN traffic                   │
│  ├── Impact: Credential exposure                                       │
│  └── Mitigation:                                                        │
│      • Mutual TLS authentication                                        │
│      • Certificate pinning                                              │
│      • Network monitoring for anomalies                                │
│                                                                         │
│  Threat: Cloud Provider Compromise                                      │
│  ├── Attack Vector: Insider threat at cloud provider                   │
│  ├── Impact: Access to encrypted data                                  │
│  └── Mitigation:                                                        │
│      • Customer-managed encryption keys                                 │
│      • Multi-cloud redundancy                                           │
│      • Confidential computing where available                          │
│                                                                         │
│  Threat: Synchronization Poisoning                                      │
│  ├── Attack Vector: Inject malicious secret during sync                │
│  ├── Impact: Applications use attacker-controlled credentials          │
│  └── Mitigation:                                                        │
│      • Signed secrets with integrity verification                       │
│      • Audit all sync operations                                        │
│      • Alert on unexpected secret changes                              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Operational Patterns

### Runbook: Cross-Cloud Failover

```markdown
# Cross-Cloud PAM Failover Runbook

## Scenario: AWS Region Failure - Failover to Azure

### Prerequisites
- Azure PAM infrastructure in standby
- DNS TTL set to 60 seconds
- Replication lag < 5 minutes

### Failover Steps

1. **Confirm Outage (5 min)**
   ```bash
   # Check AWS health
   aws health describe-events --filter "services=EC2,RDS"

   # Verify Vault unreachable
   curl -s https://vault.aws.example.com/health || echo "UNREACHABLE"
   ```

2. **Initiate Failover Decision (5 min)**
   - Confirm with incident commander
   - Document decision in incident channel
   - Notify stakeholders

3. **Activate Azure Standby (10 min)**
   ```bash
   # Promote Azure Vault
   az vm start --resource-group pam-rg --name vault-standby

   # Verify Vault health
   curl https://vault.azure.example.com:1858/health

   # Start CPM
   az vm start --resource-group pam-rg --name cpm-01
   ```

4. **Update DNS (5 min)**
   ```bash
   # Update Route 53 health check
   aws route53 update-health-check \
     --health-check-id HC123 \
     --disabled

   # DNS will failover automatically
   # Or manual update:
   az network dns record-set a update \
     --resource-group dns-rg \
     --zone-name example.com \
     --name vault \
     --set aRecords[0].ipv4Address=10.200.1.10
   ```

5. **Verify Failover (10 min)**
   ```bash
   # Test authentication
   pvwactl login --url https://vault.example.com

   # Test password retrieval
   pvwactl get-password --safe IT_Windows --object TestAccount

   # Test session launch
   pvwactl connect --target testserver.example.com
   ```

6. **Notify Stakeholders**
   - Send communication
   - Update status page
   - Document timeline

### Estimated RTO: 35 minutes
```

### Monitoring Alerts

```yaml
# multicloud_alerts.yaml
# Alert definitions for multi-cloud PAM

alerts:
  - name: "Conjur Leader Unreachable"
    expr: 'up{job="conjur-leader"} == 0'
    for: 2m
    severity: critical
    annotations:
      summary: "Conjur leader in {{ $labels.cloud }} is unreachable"
      runbook: "https://wiki.example.com/runbooks/conjur-leader-down"

  - name: "Cross-Cloud Sync Lag"
    expr: 'secrets_sync_lag_seconds > 300'
    for: 5m
    severity: warning
    annotations:
      summary: "Secret sync lag exceeds 5 minutes"

  - name: "High Authentication Failure Rate"
    expr: 'rate(conjur_auth_failures_total[5m]) > 10'
    for: 2m
    severity: warning
    annotations:
      summary: "High auth failure rate in {{ $labels.cloud }}"

  - name: "VPN Tunnel Down"
    expr: 'vpn_tunnel_status == 0'
    for: 1m
    severity: critical
    annotations:
      summary: "VPN tunnel {{ $labels.tunnel_name }} is down"

  - name: "Secret Rotation Failure"
    expr: 'increase(secret_rotation_failures_total[1h]) > 0'
    for: 5m
    severity: high
    annotations:
      summary: "Secret rotation failed in {{ $labels.cloud }}"

  - name: "Unusual Secret Access Pattern"
    expr: 'rate(secret_access_total[5m]) > (avg_over_time(secret_access_total[7d]) * 3)'
    for: 10m
    severity: warning
    annotations:
      summary: "Unusual secret access volume detected"
```

---

## Related Documents

- [HA_DR_ARCHITECTURE.md](HA_DR_ARCHITECTURE.md) - High availability patterns
- [KUBERNETES_MULTICLUSTER_GUIDE.md](KUBERNETES_MULTICLUSTER_GUIDE.md) - K8s multi-cluster
- [DEVOPS_CI_CD_GUIDE.md](DEVOPS_CI_CD_GUIDE.md) - CI/CD integration
- [HANDS_ON_LABS_PHASE3.md](HANDS_ON_LABS_PHASE3.md) - Cloud security labs

## External References

- [CyberArk Cloud Deployment Guide](https://docs.cyberark.com/pam/latest/en/content/pas%20cloud/pas-cloud-landing.htm)
- [Conjur Cloud Authenticators](https://docs.conjur.org/Latest/en/Content/Integrations/cloud-authenticators.htm)
- [AWS Well-Architected Framework - Security](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns)
- [GCP Security Best Practices](https://cloud.google.com/security/best-practices)

---

*Last Updated: 2025-12-04*
*Version: 1.0*
