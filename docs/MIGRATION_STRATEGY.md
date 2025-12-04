# PAM Migration Strategy Guide

> Comprehensive framework for migrating from legacy PAM solutions to CyberArk and Conjur

---

## Table of Contents

1. [Migration Overview](#migration-overview)
2. [Assessment Phase](#assessment-phase)
3. [Planning Phase](#planning-phase)
4. [Migration Patterns](#migration-patterns)
5. [CyberArk PAM Migration](#cyberark-pam-migration)
6. [Conjur Migration](#conjur-migration)
7. [Data Migration](#data-migration)
8. [Integration Migration](#integration-migration)
9. [Testing and Validation](#testing-and-validation)
10. [Cutover Strategy](#cutover-strategy)
11. [Rollback Procedures](#rollback-procedures)
12. [Post-Migration Tasks](#post-migration-tasks)

---

## Migration Overview

### Migration Scenarios

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     Common Migration Paths                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Legacy PAM → CyberArk PAM                                             │
│  ├── Thycotic Secret Server → CyberArk PAS                             │
│  ├── BeyondTrust → CyberArk PAS                                        │
│  ├── Centrify → CyberArk PAS                                           │
│  └── HashiCorp Vault → CyberArk PAS                                    │
│                                                                         │
│  Secrets Management → Conjur                                            │
│  ├── HashiCorp Vault → Conjur                                          │
│  ├── AWS Secrets Manager → Conjur                                      │
│  ├── Azure Key Vault → Conjur                                          │
│  └── Custom Solutions → Conjur                                         │
│                                                                         │
│  Hybrid Migrations                                                      │
│  ├── Legacy PAM + Secrets → CyberArk PAS + Conjur                      │
│  └── Multi-vendor → Unified CyberArk Platform                          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Migration Principles

1. **Zero Downtime**: Minimize service interruption
2. **Data Integrity**: Preserve all credentials and audit history
3. **Security First**: No security gaps during transition
4. **Phased Approach**: Incremental migration reduces risk
5. **Reversibility**: Maintain rollback capability

---

## Assessment Phase

### Current State Discovery

```bash
#!/bin/bash
# discovery_script.sh - Legacy PAM Discovery

echo "=== PAM Environment Discovery ==="

# Inventory Categories
cat << 'EOF'
DISCOVERY CHECKLIST:

1. Credential Inventory
   □ Privileged accounts (count, types)
   □ Service accounts
   □ Application credentials
   □ SSH keys
   □ Certificates

2. Platform Inventory
   □ Windows servers/workstations
   □ Linux/Unix servers
   □ Network devices
   □ Databases
   □ Cloud resources
   □ SaaS applications

3. Integration Inventory
   □ LDAP/Active Directory
   □ SIEM systems
   □ Ticketing systems
   □ CI/CD pipelines
   □ Custom applications

4. Access Patterns
   □ User access frequency
   □ Automation usage
   □ API integrations
   □ Session recording usage

5. Compliance Requirements
   □ Regulatory frameworks
   □ Audit requirements
   □ Retention policies
   □ Access policies
EOF
```

### Discovery Tools

```python
#!/usr/bin/env python3
"""
legacy_pam_discovery.py
Discovers credentials and integrations from legacy PAM systems
"""

import json
import csv
from datetime import datetime
from typing import Dict, List, Any

class PAMDiscovery:
    """Base class for PAM discovery operations"""

    def __init__(self, source_system: str):
        self.source_system = source_system
        self.discovery_date = datetime.now()
        self.credentials: List[Dict] = []
        self.safes: List[Dict] = []
        self.integrations: List[Dict] = []

    def discover_credentials(self) -> List[Dict]:
        """Override in subclass for specific PAM system"""
        raise NotImplementedError

    def discover_integrations(self) -> List[Dict]:
        """Override in subclass for specific PAM system"""
        raise NotImplementedError

    def generate_report(self, output_file: str) -> None:
        """Generate discovery report"""
        report = {
            "source_system": self.source_system,
            "discovery_date": self.discovery_date.isoformat(),
            "summary": {
                "total_credentials": len(self.credentials),
                "total_safes": len(self.safes),
                "total_integrations": len(self.integrations)
            },
            "credentials": self.credentials,
            "safes": self.safes,
            "integrations": self.integrations
        }

        with open(output_file, 'w') as f:
            json.dump(report, f, indent=2)

        print(f"Discovery report saved to {output_file}")


class ThycoticDiscovery(PAMDiscovery):
    """Discovery for Thycotic Secret Server"""

    def __init__(self, base_url: str, token: str):
        super().__init__("Thycotic Secret Server")
        self.base_url = base_url
        self.token = token

    def discover_credentials(self) -> List[Dict]:
        """Discover secrets from Thycotic"""
        # API call to list all secrets
        # GET /api/v1/secrets

        credentials = []
        # Map Thycotic fields to standard format
        mapping = {
            "secretId": "legacy_id",
            "name": "account_name",
            "secretTemplateName": "account_type",
            "folderId": "container",
            "lastPasswordChangeAttempt": "last_changed",
            "checkOutEnabled": "checkout_enabled"
        }

        # Process and return credentials
        return credentials

    def discover_integrations(self) -> List[Dict]:
        """Discover Thycotic integrations"""
        integrations = []

        # Discovery categories
        categories = [
            "ldap_sync",      # AD/LDAP configurations
            "radius",         # RADIUS authentication
            "saml",           # SAML/SSO
            "event_subs",     # Event subscriptions (SIEM)
            "launchers",      # Session launchers
            "discovery"       # Discovery rules
        ]

        return integrations


class BeyondTrustDiscovery(PAMDiscovery):
    """Discovery for BeyondTrust Password Safe"""

    def __init__(self, base_url: str, api_key: str):
        super().__init__("BeyondTrust Password Safe")
        self.base_url = base_url
        self.api_key = api_key

    def discover_credentials(self) -> List[Dict]:
        """Discover managed accounts from BeyondTrust"""
        # API: GET /BeyondTrust/api/public/v3/ManagedAccounts

        credentials = []
        mapping = {
            "AccountId": "legacy_id",
            "AccountName": "account_name",
            "SystemName": "target_system",
            "PlatformID": "platform",
            "DomainName": "domain",
            "LastChangeDate": "last_changed"
        }

        return credentials


# Export functions
def export_to_cyberark_format(credentials: List[Dict],
                              output_file: str) -> None:
    """Export credentials to CyberArk import format"""

    cyberark_headers = [
        "Safe", "Folder", "Object Name", "Password",
        "DeviceType", "PolicyID", "Address", "UserName",
        "LogonDomain", "Port"
    ]

    with open(output_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=cyberark_headers)
        writer.writeheader()

        for cred in credentials:
            row = map_to_cyberark(cred)
            writer.writerow(row)

    print(f"Exported {len(credentials)} credentials to {output_file}")


def map_to_cyberark(credential: Dict) -> Dict:
    """Map legacy credential to CyberArk format"""
    return {
        "Safe": credential.get("target_safe", "MigratedAccounts"),
        "Folder": "Root",
        "Object Name": credential.get("account_name"),
        "Password": "",  # Populated separately for security
        "DeviceType": map_device_type(credential.get("platform")),
        "PolicyID": map_platform_policy(credential.get("platform")),
        "Address": credential.get("target_address"),
        "UserName": credential.get("username"),
        "LogonDomain": credential.get("domain", ""),
        "Port": credential.get("port", "")
    }


def map_device_type(platform: str) -> str:
    """Map legacy platform to CyberArk device type"""
    mapping = {
        "windows": "Operating System",
        "linux": "Operating System",
        "unix": "Operating System",
        "oracle": "Database",
        "mssql": "Database",
        "mysql": "Database",
        "cisco": "Network Device",
        "aws": "Cloud",
        "azure": "Cloud"
    }
    return mapping.get(platform.lower(), "Operating System")


def map_platform_policy(platform: str) -> str:
    """Map to CyberArk platform policy ID"""
    mapping = {
        "windows": "WinServerLocal",
        "windows_domain": "WinDomain",
        "linux": "UnixSSH",
        "oracle": "Oracle",
        "mssql": "MSSql",
        "cisco": "CiscoIOS",
        "aws": "AWSAccessKeys",
        "azure": "AzurePasswordManagement"
    }
    return mapping.get(platform.lower(), "WinServerLocal")
```

### Assessment Report Template

```markdown
# PAM Migration Assessment Report

## Executive Summary
- Current PAM Platform: [Legacy System Name]
- Target Platform: CyberArk PAS / Conjur
- Total Credentials: [X,XXX]
- Estimated Migration Duration: [X weeks/months]
- Risk Level: [Low/Medium/High]

## Current State Analysis

### Credential Inventory
| Category | Count | Complexity |
|----------|-------|------------|
| Windows Local | X,XXX | Low |
| Windows Domain | X,XXX | Medium |
| Linux/Unix | X,XXX | Low |
| Database | XXX | Medium |
| Network Devices | XXX | Medium |
| Cloud Resources | XXX | High |
| Application Secrets | X,XXX | High |

### Integration Inventory
| Integration Type | Count | Migration Effort |
|-----------------|-------|------------------|
| AD/LDAP Sync | X | Low |
| SIEM Integration | X | Medium |
| Ticketing System | X | Medium |
| CI/CD Pipelines | XX | High |
| Custom Applications | XX | High |

### Gap Analysis
| Feature | Current State | Target State | Gap |
|---------|---------------|--------------|-----|
| Session Recording | Partial | Full | Medium |
| Threat Analytics | None | PTA | High |
| Cloud Integration | Limited | Native | High |
| DevOps Secrets | None | Conjur | High |

## Recommendations
1. [Recommendation 1]
2. [Recommendation 2]
3. [Recommendation 3]

## Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | M | H | [Mitigation] |
| [Risk 2] | L | H | [Mitigation] |
```

---

## Planning Phase

### Migration Approach Selection

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Migration Approach Decision Tree                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Credential Count < 500?                                                │
│  ├── YES → Consider Big Bang Migration                                 │
│  │         (Complete cutover in single maintenance window)              │
│  │                                                                       │
│  └── NO → Phased Migration Required                                     │
│           │                                                              │
│           ├── By Platform/Technology                                    │
│           │   (All Windows, then Linux, then DB, etc.)                  │
│           │                                                              │
│           ├── By Business Unit                                          │
│           │   (Finance, HR, IT, etc.)                                   │
│           │                                                              │
│           ├── By Criticality                                            │
│           │   (Tier 3, then Tier 2, then Tier 1)                        │
│           │                                                              │
│           └── By Geography                                              │
│               (Region A, then B, then C)                                │
│                                                                         │
│  Zero Downtime Required?                                                │
│  ├── YES → Parallel Run with Gradual Cutover                           │
│  └── NO → Direct Cutover with Maintenance Window                       │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Migration Timeline Template

```
Week 1-2: Discovery & Assessment
├── Complete credential inventory
├── Document integrations
├── Identify dependencies
└── Create risk assessment

Week 3-4: Environment Preparation
├── Deploy CyberArk/Conjur infrastructure
├── Configure base policies
├── Set up safe structure
└── Establish connectivity

Week 5-6: Pilot Migration
├── Migrate pilot group (50-100 accounts)
├── Validate functionality
├── Test integrations
└── Gather feedback

Week 7-10: Phase 1 Migration
├── Windows servers (local accounts)
├── Linux/Unix servers
├── Basic automation
└── Validation testing

Week 11-14: Phase 2 Migration
├── Database credentials
├── Network devices
├── Domain accounts
└── Application integration

Week 15-18: Phase 3 Migration
├── Cloud credentials
├── DevOps secrets
├── Complex integrations
└── Custom applications

Week 19-20: Cutover & Validation
├── Final data sync
├── Legacy system decommission prep
├── Full validation
└── Documentation update

Week 21-24: Stabilization
├── Monitor operations
├── Address issues
├── Performance tuning
└── Legacy decommission
```

### Safe Structure Planning

```yaml
# safe_structure.yaml - CyberArk Safe Design

safe_hierarchy:
  naming_convention: "{BU}_{Platform}_{Environment}"

  structure:
    # Infrastructure Safes
    - name: "IT_Windows_Production"
      description: "Windows Server Local Accounts - Production"
      cpm: "PasswordManager"
      retention: 30
      owners:
        - name: "WindowsAdmins"
          permissions: "UseAccounts,ListAccounts"
        - name: "PAMAdmins"
          permissions: "Full"

    - name: "IT_Windows_NonProd"
      description: "Windows Server Local Accounts - Non-Production"
      cpm: "PasswordManager"
      retention: 14
      owners:
        - name: "WindowsAdmins"
          permissions: "UseAccounts,ListAccounts,RetrieveAccounts"
        - name: "DevOps"
          permissions: "UseAccounts"

    - name: "IT_Linux_Production"
      description: "Linux/Unix Accounts - Production"
      cpm: "PasswordManager"
      retention: 30
      owners:
        - name: "LinuxAdmins"
          permissions: "UseAccounts,ListAccounts"

    - name: "IT_Database_Production"
      description: "Database Credentials - Production"
      cpm: "PasswordManager"
      retention: 30
      owners:
        - name: "DBATeam"
          permissions: "UseAccounts,ListAccounts"

    # Application Safes
    - name: "APP_WebServices_Production"
      description: "Web Service Credentials - Production"
      cpm: "PasswordManager"
      retention: 30
      conjur_sync: true

    # Cloud Safes
    - name: "Cloud_AWS_Production"
      description: "AWS IAM Keys and Secrets"
      cpm: "AWSRotator"
      retention: 30

    - name: "Cloud_Azure_Production"
      description: "Azure Service Principals"
      cpm: "AzureRotator"
      retention: 30

  safe_templates:
    standard_safe:
      manage_daily_by_cpm: true
      auto_purge: true
      object_level_audit: true
      retention: 30

    high_security_safe:
      manage_daily_by_cpm: true
      auto_purge: true
      object_level_audit: true
      retention: 90
      dual_control: true
      exclusive_access: true
```

---

## Migration Patterns

### Pattern 1: Lift and Shift

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     Lift and Shift Migration                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Legacy PAM                              CyberArk PAS                   │
│  ┌─────────────────┐                    ┌─────────────────┐             │
│  │ Credential Store │ ──────────────▶  │ Password Vault   │             │
│  │ (Thycotic)       │    Export/Import  │                 │             │
│  └─────────────────┘                    └─────────────────┘             │
│                                                                         │
│  Characteristics:                                                       │
│  • Direct credential export/import                                      │
│  • Minimal transformation                                               │
│  • Quick migration                                                      │
│  • Limited optimization                                                 │
│                                                                         │
│  Best For:                                                              │
│  • Time-constrained migrations                                          │
│  • Similar platform features                                            │
│  • Simple credential types                                              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Pattern 2: Parallel Run

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       Parallel Run Migration                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────┐        ┌─────────────────┐                        │
│  │   Legacy PAM    │        │  CyberArk PAS   │                        │
│  │  (Read-Only)    │        │   (Primary)     │                        │
│  └────────┬────────┘        └────────┬────────┘                        │
│           │                          │                                  │
│           │    ┌──────────────┐     │                                  │
│           └────┤  Sync Bridge  ├────┘                                  │
│                │  (One-way)    │                                        │
│                └──────────────┘                                        │
│                                                                         │
│  Phase 1: Both systems active, legacy primary                          │
│  Phase 2: CyberArk primary, legacy read-only                           │
│  Phase 3: Legacy decommissioned                                        │
│                                                                         │
│  Duration: 2-4 weeks per phase                                         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Pattern 3: Strangler Fig

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      Strangler Fig Migration                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Time ──────────────────────────────────────────────────────────▶      │
│                                                                         │
│  T0: Legacy 100% ┃███████████████████████████████████████████          │
│                  ┃                                                      │
│  T1: Legacy 80%  ┃█████████████████████████████████ │ CyberArk 20%     │
│                  ┃                                  │                   │
│  T2: Legacy 50%  ┃████████████████████ │ CyberArk 50%                  │
│                  ┃                     │                                │
│  T3: Legacy 20%  ┃████████│ CyberArk 80%                               │
│                  ┃        │                                            │
│  T4: CyberArk    ┃ CyberArk 100% ███████████████████████████████████   │
│      100%        ┃                                                      │
│                                                                         │
│  Incremental migration, gradually shifting traffic/credentials          │
│  from legacy to new platform                                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## CyberArk PAM Migration

### Credential Export from Legacy Systems

```powershell
# Export-ThycoticSecrets.ps1
# Export credentials from Thycotic Secret Server

param(
    [string]$ThycoticUrl,
    [string]$ApiToken,
    [string]$OutputPath = ".\thycotic_export.csv"
)

# Get all secrets
$headers = @{
    "Authorization" = "Bearer $ApiToken"
    "Content-Type" = "application/json"
}

$secrets = Invoke-RestMethod -Uri "$ThycoticUrl/api/v1/secrets" `
    -Headers $headers -Method Get

# Export to CSV for CyberArk import
$exportData = foreach ($secret in $secrets.records) {
    # Get secret details
    $details = Invoke-RestMethod -Uri "$ThycoticUrl/api/v1/secrets/$($secret.id)" `
        -Headers $headers -Method Get

    [PSCustomObject]@{
        Safe = Map-ToSafe -FolderPath $secret.folderPath
        ObjectName = $secret.name
        Address = Get-FieldValue -Fields $details.items -FieldName "Machine"
        UserName = Get-FieldValue -Fields $details.items -FieldName "Username"
        Platform = Map-ToPlatform -TemplateName $secret.secretTemplateName
        DeviceType = Map-ToDeviceType -TemplateName $secret.secretTemplateName
        # Password exported separately via secure process
        PasswordHash = "MIGRATE_REQUIRED"
    }
}

$exportData | Export-Csv -Path $OutputPath -NoTypeInformation

Write-Host "Exported $($exportData.Count) credentials to $OutputPath"
```

### CyberArk Bulk Import

```powershell
# Import-ToCyberArk.ps1
# Bulk import credentials to CyberArk

param(
    [string]$PVWAUrl,
    [string]$ImportFile,
    [PSCredential]$Credential
)

# Authenticate to CyberArk
$session = New-PASSession -BaseURI $PVWAUrl -Credential $Credential

# Read import file
$credentials = Import-Csv -Path $ImportFile

# Import each credential
foreach ($cred in $credentials) {
    try {
        # Check if safe exists
        $safe = Get-PASSafe -SafeName $cred.Safe -ErrorAction SilentlyContinue

        if (-not $safe) {
            Write-Warning "Safe $($cred.Safe) does not exist. Creating..."
            Add-PASSafe -SafeName $cred.Safe `
                -ManagingCPM "PasswordManager" `
                -NumberOfVersionsRetention 10
        }

        # Add account
        Add-PASAccount -SafeName $cred.Safe `
            -PlatformID $cred.Platform `
            -Address $cred.Address `
            -UserName $cred.UserName `
            -Name $cred.ObjectName `
            -SecretType Password `
            -Secret (Get-MigratedPassword -ObjectName $cred.ObjectName)

        Write-Host "Imported: $($cred.ObjectName)" -ForegroundColor Green

    } catch {
        Write-Error "Failed to import $($cred.ObjectName): $_"
        # Log failure for retry
        $cred | Export-Csv -Path ".\import_failures.csv" -Append -NoTypeInformation
    }
}

Close-PASSession
```

### Platform Configuration

```powershell
# Configure-MigrationPlatforms.ps1
# Create platform policies for migrated accounts

# Windows Local Account Platform (customized for migration)
$windowsPlatform = @{
    PlatformID = "WinMigrated"
    BasePlatform = "WinServerLocal"
    Properties = @{
        MinValidityPeriod = 1
        ResetOveridesMinValidity = $true
        ImmediateInterval = "Yes"
        Interval = 1
        # Allow initial password verification
        VFAllowClearText = "Yes"
    }
}

# Linux Platform for migrated accounts
$linuxPlatform = @{
    PlatformID = "UnixMigrated"
    BasePlatform = "UnixSSH"
    Properties = @{
        MinValidityPeriod = 1
        UseSudo = "Yes"
        SshKeyPath = "/etc/ssh/ssh_host_rsa_key"
    }
}
```

---

## Conjur Migration

### Vault to Conjur Migration

```bash
#!/bin/bash
# vault_to_conjur_migration.sh
# Migrate secrets from HashiCorp Vault to Conjur

set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-https://vault.example.com:8200}"
CONJUR_URL="${CONJUR_URL:-https://conjur.example.com}"
CONJUR_ACCOUNT="${CONJUR_ACCOUNT:-myorg}"

# Export secrets from Vault
export_from_vault() {
    local path=$1
    local output_file=$2

    echo "Exporting secrets from Vault path: $path"

    # List all secrets at path
    vault kv list -format=json "$path" | jq -r '.[]' | while read secret; do
        # Get secret data
        vault kv get -format=json "$path/$secret" >> "$output_file"
    done
}

# Import secrets to Conjur
import_to_conjur() {
    local input_file=$1
    local conjur_policy=$2

    echo "Importing secrets to Conjur policy: $conjur_policy"

    # Process each secret
    jq -c '.' "$input_file" | while read secret_json; do
        local secret_name=$(echo "$secret_json" | jq -r '.data.data | keys[0]')
        local secret_value=$(echo "$secret_json" | jq -r '.data.data | values[0]')

        # Set secret in Conjur
        conjur variable set \
            -i "$conjur_policy/$secret_name" \
            -v "$secret_value"

        echo "Imported: $conjur_policy/$secret_name"
    done
}

# Create migration mapping policy
create_conjur_policy() {
    local policy_name=$1

    cat << EOF | conjur policy load -b root -f -
- !policy
  id: $policy_name
  body:
    - !group admins
    - !group consumers

    # Migrated variables will be created under this policy
    - &variables
      - !variable database/username
      - !variable database/password
      - !variable api/key
      - !variable api/secret

    # Permissions
    - !permit
      role: !group admins
      privileges: [read, update, execute]
      resources: *variables

    - !permit
      role: !group consumers
      privileges: [read, execute]
      resources: *variables
EOF
}

# Main migration workflow
main() {
    echo "=== Vault to Conjur Migration ==="

    # 1. Export from Vault
    export_from_vault "secret/data/apps" "vault_export.json"

    # 2. Create Conjur policy structure
    create_conjur_policy "migrated-secrets"

    # 3. Import to Conjur
    import_to_conjur "vault_export.json" "migrated-secrets"

    # 4. Validate migration
    echo "=== Validating Migration ==="
    conjur list -k variable | grep "migrated-secrets"

    echo "Migration complete!"
}

main "$@"
```

### AWS Secrets Manager to Conjur

```python
#!/usr/bin/env python3
"""
aws_secrets_to_conjur.py
Migrate secrets from AWS Secrets Manager to Conjur
"""

import boto3
import json
import requests
from typing import Dict, List, Optional

class AWSToConjurMigration:
    def __init__(self,
                 aws_region: str,
                 conjur_url: str,
                 conjur_account: str,
                 conjur_token: str):
        self.secrets_client = boto3.client('secretsmanager',
                                           region_name=aws_region)
        self.conjur_url = conjur_url
        self.conjur_account = conjur_account
        self.conjur_token = conjur_token

    def list_aws_secrets(self) -> List[Dict]:
        """List all secrets in AWS Secrets Manager"""
        secrets = []
        paginator = self.secrets_client.get_paginator('list_secrets')

        for page in paginator.paginate():
            secrets.extend(page['SecretList'])

        return secrets

    def get_secret_value(self, secret_name: str) -> Optional[str]:
        """Retrieve secret value from AWS"""
        try:
            response = self.secrets_client.get_secret_value(
                SecretId=secret_name
            )
            return response.get('SecretString')
        except Exception as e:
            print(f"Error retrieving {secret_name}: {e}")
            return None

    def create_conjur_variable(self, variable_id: str) -> bool:
        """Create variable in Conjur via policy"""
        policy = f"""
- !variable {variable_id}
"""
        headers = {
            'Authorization': f'Token token="{self.conjur_token}"',
            'Content-Type': 'text/plain'
        }

        response = requests.post(
            f"{self.conjur_url}/policies/{self.conjur_account}/policy/root",
            headers=headers,
            data=policy
        )

        return response.status_code in [200, 201]

    def set_conjur_secret(self, variable_id: str, value: str) -> bool:
        """Set secret value in Conjur"""
        headers = {
            'Authorization': f'Token token="{self.conjur_token}"',
            'Content-Type': 'text/plain'
        }

        # URL encode the variable ID
        encoded_id = requests.utils.quote(variable_id, safe='')

        response = requests.post(
            f"{self.conjur_url}/secrets/{self.conjur_account}/variable/{encoded_id}",
            headers=headers,
            data=value
        )

        return response.status_code == 201

    def migrate_secret(self, aws_secret: Dict,
                       conjur_path: str = "migrated-aws") -> bool:
        """Migrate single secret from AWS to Conjur"""
        secret_name = aws_secret['Name']
        conjur_variable = f"{conjur_path}/{secret_name.replace('/', '-')}"

        print(f"Migrating: {secret_name} -> {conjur_variable}")

        # Get value from AWS
        value = self.get_secret_value(secret_name)
        if not value:
            return False

        # Create variable in Conjur
        if not self.create_conjur_variable(conjur_variable):
            print(f"  Failed to create variable: {conjur_variable}")
            return False

        # Set value in Conjur
        if not self.set_conjur_secret(conjur_variable, value):
            print(f"  Failed to set secret: {conjur_variable}")
            return False

        print(f"  Successfully migrated: {conjur_variable}")
        return True

    def migrate_all(self, conjur_path: str = "migrated-aws") -> Dict:
        """Migrate all AWS secrets to Conjur"""
        secrets = self.list_aws_secrets()
        results = {
            'total': len(secrets),
            'success': 0,
            'failed': 0,
            'failures': []
        }

        for secret in secrets:
            if self.migrate_secret(secret, conjur_path):
                results['success'] += 1
            else:
                results['failed'] += 1
                results['failures'].append(secret['Name'])

        return results


def main():
    import os

    migration = AWSToConjurMigration(
        aws_region=os.environ.get('AWS_REGION', 'us-east-1'),
        conjur_url=os.environ['CONJUR_URL'],
        conjur_account=os.environ['CONJUR_ACCOUNT'],
        conjur_token=os.environ['CONJUR_TOKEN']
    )

    results = migration.migrate_all()

    print("\n=== Migration Summary ===")
    print(f"Total secrets: {results['total']}")
    print(f"Successful: {results['success']}")
    print(f"Failed: {results['failed']}")

    if results['failures']:
        print("\nFailed secrets:")
        for name in results['failures']:
            print(f"  - {name}")


if __name__ == "__main__":
    main()
```

---

## Data Migration

### Password Migration Strategies

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   Password Migration Strategies                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Strategy 1: Direct Password Migration                                  │
│  ┌─────────────────────────────────────────────────────────┐           │
│  │ Legacy PAM ──[export passwords]──▶ CyberArk Import      │           │
│  │                                                          │           │
│  │ • Passwords transferred encrypted                        │           │
│  │ • Immediate verification and rotation                    │           │
│  │ • Risk: Password exposure during transfer                │           │
│  └─────────────────────────────────────────────────────────┘           │
│                                                                         │
│  Strategy 2: Verify and Rotate                                          │
│  ┌─────────────────────────────────────────────────────────┐           │
│  │ 1. Import account metadata (no passwords)                │           │
│  │ 2. CyberArk verifies current password (from legacy)      │           │
│  │ 3. Immediate rotation to new password                    │           │
│  │                                                          │           │
│  │ • No password transfer                                   │           │
│  │ • Fresh passwords in target                              │           │
│  │ • Requires target system connectivity                    │           │
│  └─────────────────────────────────────────────────────────┘           │
│                                                                         │
│  Strategy 3: Fresh Start                                                │
│  ┌─────────────────────────────────────────────────────────┐           │
│  │ 1. Import account metadata only                          │           │
│  │ 2. Set random initial password                           │           │
│  │ 3. CPM rotates all passwords                             │           │
│  │                                                          │           │
│  │ • Cleanest approach                                      │           │
│  │ • No legacy password dependencies                        │           │
│  │ • Potential service disruption                           │           │
│  └─────────────────────────────────────────────────────────┘           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Audit History Migration

```sql
-- audit_migration.sql
-- Migrate audit history from legacy PAM to CyberArk

-- Create staging table for legacy audit data
CREATE TABLE legacy_audit_staging (
    id INT PRIMARY KEY IDENTITY,
    legacy_id VARCHAR(100),
    timestamp DATETIME,
    user_name VARCHAR(255),
    action VARCHAR(100),
    target_account VARCHAR(255),
    target_safe VARCHAR(255),
    source_ip VARCHAR(50),
    result VARCHAR(50),
    details TEXT,
    imported_date DATETIME DEFAULT GETDATE()
);

-- Import from legacy system (example for Thycotic)
INSERT INTO legacy_audit_staging (
    legacy_id, timestamp, user_name, action,
    target_account, source_ip, result, details
)
SELECT
    CAST(AuditId AS VARCHAR(100)),
    DateRecorded,
    DisplayName,
    Action,
    ItemId,
    IpAddress,
    CASE WHEN Success = 1 THEN 'Success' ELSE 'Failure' END,
    Notes
FROM ThycoticAudit.dbo.tbAudit;

-- Generate CyberArk-compatible audit report
SELECT
    'MIGRATED_' + legacy_id AS AuditID,
    timestamp AS TimeStamp,
    user_name AS Issuer,
    action AS ActionType,
    target_account AS ObjectName,
    target_safe AS Safe,
    source_ip AS SourceAddress,
    result AS Result,
    'Legacy Migration: ' + details AS Message
FROM legacy_audit_staging
ORDER BY timestamp;
```

---

## Integration Migration

### LDAP/AD Integration

```powershell
# Migrate-LDAPConfiguration.ps1
# Migrate LDAP/AD directory integration settings

# Document legacy LDAP configuration
$legacyLDAPConfig = @{
    ServerAddress = "ldap.example.com"
    Port = 636
    UseSSL = $true
    BaseDN = "DC=example,DC=com"
    BindDN = "CN=PAMService,OU=ServiceAccounts,DC=example,DC=com"
    UserSearchBase = "OU=Users,DC=example,DC=com"
    GroupSearchBase = "OU=Groups,DC=example,DC=com"
    UserFilter = "(&(objectClass=user)(sAMAccountName={0}))"
    GroupFilter = "(&(objectClass=group)(member={0}))"
}

# Configure CyberArk Directory Mapping
# Via PVWA: Administration > LDAP Integration

$cyberarkLDAPConfig = @{
    DirectoryType = "MicrosoftADDS"
    DomainName = "example.com"
    DomainController = "dc1.example.com"
    BindUser = "PAMService@example.com"
    # SSL Certificate should be imported to Vault server
    UseSSL = $true
    MappingRules = @(
        @{
            LDAPAttribute = "sAMAccountName"
            VaultProperty = "UserName"
        },
        @{
            LDAPAttribute = "mail"
            VaultProperty = "Email"
        },
        @{
            LDAPAttribute = "memberOf"
            VaultProperty = "Groups"
        }
    )
}

# Migrate user-to-safe mappings
# Export from legacy and import to CyberArk vault groups
```

### SIEM Integration Migration

```yaml
# siem_integration_migration.yaml
# Migrate SIEM integration from legacy PAM to CyberArk

legacy_siem_config:
  type: "syslog"
  destination: "siem.example.com"
  port: 514
  protocol: "tcp"
  format: "cef"
  events:
    - login
    - logout
    - password_retrieve
    - password_change
    - session_start
    - session_end

cyberark_siem_config:
  # Option 1: Syslog Publisher
  syslog_publisher:
    enabled: true
    destination: "siem.example.com"
    port: 514
    protocol: "tcp"
    format: "CEF"
    severity_mapping:
      info: 4
      warning: 6
      error: 8
      critical: 10

  # Option 2: SIEM Integration (REST)
  rest_integration:
    enabled: true
    endpoint: "https://siem.example.com/api/events"
    authentication: "api_key"
    batch_size: 100
    interval_seconds: 60

  # Event mapping from legacy to CyberArk
  event_mapping:
    login: "Logon"
    logout: "Logoff"
    password_retrieve: "Retrieve password"
    password_change: "CPM password changed"
    session_start: "PSM Connect"
    session_end: "PSM Disconnect"

# Splunk-specific configuration
splunk_config:
  # CyberArk Splunk Add-on
  ta_cyberark:
    version: "2.0"
    inputs:
      - type: "pvwa_api"
        index: "cyberark"
        sourcetype: "cyberark:vault"
      - type: "pta_api"
        index: "cyberark"
        sourcetype: "cyberark:pta"
```

### CI/CD Integration Migration

```yaml
# cicd_migration.yaml
# Migrate CI/CD secrets integration from legacy to Conjur

legacy_integration:
  jenkins:
    plugin: "thycotic-secret-server-plugin"
    credential_type: "secret_server_credential"
    folder_path: "/CI-CD/Jenkins"

  gitlab_ci:
    integration: "hashicorp_vault"
    engine: "kv-v2"
    path: "ci-cd/gitlab"

conjur_integration:
  jenkins:
    # Install Conjur Credentials Plugin
    plugin: "conjur-credentials"
    configuration:
      conjur_url: "https://conjur.example.com"
      account: "myorg"
      auth_method: "jwt"
      jwt_audience: "conjur"
      identity_path: "host/jenkins"

    # Credential mapping
    credential_migration:
      - legacy_id: "database-prod-password"
        conjur_path: "ci-cd/jenkins/database/password"
      - legacy_id: "api-key-prod"
        conjur_path: "ci-cd/jenkins/api/key"

  gitlab_ci:
    # JWT Authentication with Conjur
    integration: "conjur_jwt"
    configuration:
      conjur_url: "https://conjur.example.com"
      account: "myorg"
      service_id: "gitlab"

    # .gitlab-ci.yml migration
    example_job:
      before_script:
        # Legacy Vault
        - "export SECRET=$(vault kv get -field=password secret/ci-cd/db)"
        # New Conjur
        - "export SECRET=$(conjur variable get -i ci-cd/gitlab/db/password)"
```

---

## Testing and Validation

### Migration Validation Framework

```python
#!/usr/bin/env python3
"""
migration_validation.py
Comprehensive validation framework for PAM migration
"""

import json
from dataclasses import dataclass, field
from typing import List, Dict, Optional
from enum import Enum
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class ValidationStatus(Enum):
    PASSED = "PASSED"
    FAILED = "FAILED"
    WARNING = "WARNING"
    SKIPPED = "SKIPPED"


@dataclass
class ValidationResult:
    test_name: str
    status: ValidationStatus
    message: str
    details: Optional[Dict] = None


@dataclass
class ValidationReport:
    migration_id: str
    timestamp: str
    results: List[ValidationResult] = field(default_factory=list)

    @property
    def passed(self) -> int:
        return sum(1 for r in self.results
                   if r.status == ValidationStatus.PASSED)

    @property
    def failed(self) -> int:
        return sum(1 for r in self.results
                   if r.status == ValidationStatus.FAILED)

    @property
    def overall_status(self) -> str:
        if self.failed > 0:
            return "FAILED"
        return "PASSED"


class MigrationValidator:
    """Validates PAM migration completeness and correctness"""

    def __init__(self, legacy_client, cyberark_client):
        self.legacy = legacy_client
        self.cyberark = cyberark_client
        self.report = ValidationReport(
            migration_id=f"VAL-{datetime.now().strftime('%Y%m%d%H%M%S')}",
            timestamp=datetime.now().isoformat()
        )

    def validate_credential_count(self) -> ValidationResult:
        """Verify all credentials were migrated"""
        logger.info("Validating credential count...")

        legacy_count = self.legacy.get_credential_count()
        cyberark_count = self.cyberark.get_credential_count(
            safe_filter="Migrated*"
        )

        if legacy_count == cyberark_count:
            return ValidationResult(
                test_name="Credential Count Match",
                status=ValidationStatus.PASSED,
                message=f"All {legacy_count} credentials migrated",
                details={
                    "legacy_count": legacy_count,
                    "cyberark_count": cyberark_count
                }
            )
        else:
            return ValidationResult(
                test_name="Credential Count Match",
                status=ValidationStatus.FAILED,
                message=f"Count mismatch: {legacy_count} vs {cyberark_count}",
                details={
                    "legacy_count": legacy_count,
                    "cyberark_count": cyberark_count,
                    "difference": legacy_count - cyberark_count
                }
            )

    def validate_password_verification(self,
                                       sample_size: int = 100) -> ValidationResult:
        """Verify passwords work on target systems"""
        logger.info(f"Validating passwords (sample: {sample_size})...")

        # Get sample of migrated accounts
        accounts = self.cyberark.get_accounts(
            safe_filter="Migrated*",
            limit=sample_size
        )

        verified = 0
        failed = []

        for account in accounts:
            try:
                # Trigger CPM verification
                result = self.cyberark.verify_account(account['id'])
                if result['status'] == 'success':
                    verified += 1
                else:
                    failed.append({
                        'account': account['name'],
                        'reason': result.get('reason', 'Unknown')
                    })
            except Exception as e:
                failed.append({
                    'account': account['name'],
                    'reason': str(e)
                })

        success_rate = verified / len(accounts) * 100

        if success_rate >= 95:
            status = ValidationStatus.PASSED
        elif success_rate >= 80:
            status = ValidationStatus.WARNING
        else:
            status = ValidationStatus.FAILED

        return ValidationResult(
            test_name="Password Verification",
            status=status,
            message=f"{verified}/{len(accounts)} passwords verified ({success_rate:.1f}%)",
            details={
                "verified": verified,
                "failed": len(failed),
                "success_rate": success_rate,
                "failures": failed[:10]  # First 10 failures
            }
        )

    def validate_safe_permissions(self) -> ValidationResult:
        """Verify safe permissions match legacy access controls"""
        logger.info("Validating safe permissions...")

        # Get legacy folder permissions
        legacy_permissions = self.legacy.get_folder_permissions()

        # Get CyberArk safe permissions
        cyberark_permissions = self.cyberark.get_safe_members()

        mismatches = []

        for legacy_folder, users in legacy_permissions.items():
            safe_name = self._map_folder_to_safe(legacy_folder)
            cyberark_users = cyberark_permissions.get(safe_name, [])

            # Compare user access
            legacy_set = set(u['name'] for u in users)
            cyberark_set = set(u['name'] for u in cyberark_users)

            missing = legacy_set - cyberark_set
            if missing:
                mismatches.append({
                    'safe': safe_name,
                    'missing_users': list(missing)
                })

        if not mismatches:
            return ValidationResult(
                test_name="Permission Validation",
                status=ValidationStatus.PASSED,
                message="All permissions correctly migrated"
            )
        else:
            return ValidationResult(
                test_name="Permission Validation",
                status=ValidationStatus.WARNING,
                message=f"{len(mismatches)} permission mismatches found",
                details={'mismatches': mismatches}
            )

    def validate_integrations(self) -> ValidationResult:
        """Validate all integrations are working"""
        logger.info("Validating integrations...")

        integration_tests = [
            ('LDAP Authentication', self._test_ldap_auth),
            ('CPM Password Rotation', self._test_cpm_rotation),
            ('PSM Session Launch', self._test_psm_launch),
            ('SIEM Event Forwarding', self._test_siem_events),
        ]

        results = []
        for name, test_func in integration_tests:
            try:
                success = test_func()
                results.append({
                    'integration': name,
                    'status': 'PASSED' if success else 'FAILED'
                })
            except Exception as e:
                results.append({
                    'integration': name,
                    'status': 'ERROR',
                    'error': str(e)
                })

        failed = [r for r in results if r['status'] != 'PASSED']

        if not failed:
            return ValidationResult(
                test_name="Integration Validation",
                status=ValidationStatus.PASSED,
                message="All integrations working",
                details={'results': results}
            )
        else:
            return ValidationResult(
                test_name="Integration Validation",
                status=ValidationStatus.FAILED,
                message=f"{len(failed)} integration(s) failed",
                details={'results': results}
            )

    def run_all_validations(self) -> ValidationReport:
        """Run complete validation suite"""
        logger.info("Starting migration validation...")

        validations = [
            self.validate_credential_count,
            self.validate_password_verification,
            self.validate_safe_permissions,
            self.validate_integrations,
        ]

        for validation in validations:
            result = validation()
            self.report.results.append(result)
            logger.info(f"  {result.test_name}: {result.status.value}")

        logger.info(f"\nValidation Complete: {self.report.overall_status}")
        logger.info(f"  Passed: {self.report.passed}")
        logger.info(f"  Failed: {self.report.failed}")

        return self.report

    def export_report(self, output_file: str) -> None:
        """Export validation report to JSON"""
        report_dict = {
            'migration_id': self.report.migration_id,
            'timestamp': self.report.timestamp,
            'overall_status': self.report.overall_status,
            'summary': {
                'passed': self.report.passed,
                'failed': self.report.failed,
                'total': len(self.report.results)
            },
            'results': [
                {
                    'test': r.test_name,
                    'status': r.status.value,
                    'message': r.message,
                    'details': r.details
                }
                for r in self.report.results
            ]
        }

        with open(output_file, 'w') as f:
            json.dump(report_dict, f, indent=2)
```

### Functional Test Cases

```yaml
# migration_test_cases.yaml
# Test cases for migration validation

test_suites:
  credential_migration:
    - id: TC-CM-001
      name: "Windows Local Account Migration"
      steps:
        - Verify account exists in CyberArk
        - Verify platform assignment (WinServerLocal)
        - Verify safe assignment
        - Verify password verification succeeds
        - Verify password rotation works
      expected: All steps pass

    - id: TC-CM-002
      name: "Linux SSH Account Migration"
      steps:
        - Verify account exists in CyberArk
        - Verify platform assignment (UnixSSH)
        - Verify SSH key or password migrated
        - Test SSH connection via PSM
      expected: Successful SSH session

    - id: TC-CM-003
      name: "Database Account Migration"
      steps:
        - Verify account exists with correct platform
        - Verify connection parameters (address, port, SID)
        - Test database connection
        - Verify password rotation
      expected: Database accessible

  integration_migration:
    - id: TC-IM-001
      name: "LDAP Authentication"
      steps:
        - Login to PVWA with LDAP user
        - Verify group membership
        - Verify safe access based on groups
      expected: LDAP auth working

    - id: TC-IM-002
      name: "SIEM Event Forwarding"
      steps:
        - Perform privileged action (retrieve password)
        - Check SIEM for event within 5 minutes
        - Verify event format matches expected
      expected: Events visible in SIEM

    - id: TC-IM-003
      name: "CI/CD Secrets Retrieval"
      steps:
        - Run Jenkins pipeline with Conjur credentials
        - Verify secret retrieval in logs
        - Verify no plaintext secrets exposed
      expected: Pipeline succeeds

  access_control:
    - id: TC-AC-001
      name: "Role-Based Access Validation"
      steps:
        - Login as user from each role
        - Verify accessible safes match legacy permissions
        - Verify denied access to unauthorized safes
      expected: Access matches legacy

    - id: TC-AC-002
      name: "Dual Control Workflow"
      steps:
        - Request access to dual-control account
        - Verify approval workflow triggers
        - Approve request
        - Verify access granted
      expected: Dual control working
```

---

## Cutover Strategy

### Cutover Checklist

```markdown
# Migration Cutover Checklist

## Pre-Cutover (T-7 Days)
- [ ] Final data sync from legacy to CyberArk
- [ ] All validation tests passing
- [ ] Rollback procedures documented and tested
- [ ] Communication sent to all stakeholders
- [ ] Support team briefed on cutover procedures
- [ ] Monitoring dashboards configured
- [ ] Emergency contacts list updated

## Pre-Cutover (T-1 Day)
- [ ] Final credential sync completed
- [ ] Legacy system set to read-only (if possible)
- [ ] Backup of both systems completed
- [ ] All teams confirmed ready
- [ ] War room scheduled and confirmed

## Cutover Day (T-0)

### Phase 1: Preparation (00:00 - 01:00)
- [ ] Assemble cutover team
- [ ] Verify all prerequisites complete
- [ ] Open communication channels
- [ ] Final go/no-go decision

### Phase 2: Legacy Disable (01:00 - 02:00)
- [ ] Disable legacy PAM integrations
- [ ] Set legacy system to maintenance mode
- [ ] Document legacy state for rollback

### Phase 3: CyberArk Activation (02:00 - 04:00)
- [ ] Enable CyberArk integrations
- [ ] Update DNS/load balancer (if applicable)
- [ ] Activate SIEM forwarding
- [ ] Enable CI/CD integrations
- [ ] Start CPM services

### Phase 4: Validation (04:00 - 06:00)
- [ ] Execute smoke tests
- [ ] Verify user logins
- [ ] Verify password retrievals
- [ ] Verify session recordings
- [ ] Verify SIEM events
- [ ] Verify CI/CD pipelines

### Phase 5: Stabilization (06:00 - 12:00)
- [ ] Monitor for errors
- [ ] Address any issues
- [ ] User acceptance testing
- [ ] Performance monitoring

## Post-Cutover (T+1 to T+7)
- [ ] Daily health checks
- [ ] Issue tracking and resolution
- [ ] User feedback collection
- [ ] Performance optimization
- [ ] Documentation updates
- [ ] Legacy decommission planning
```

### Cutover Communication Template

```markdown
# PAM Migration Cutover Communication

## Pre-Cutover Notice (T-7 Days)

**Subject: Scheduled PAM System Migration - [DATE]**

Dear Team,

We will be migrating our Privileged Access Management system from [Legacy System] to CyberArk on [DATE]. This email provides important information about the migration and what you need to do.

**Timeline:**
- Migration Window: [DATE] [TIME] - [TIME] [TIMEZONE]
- Expected Duration: [X] hours
- Service Impact: [Description]

**What's Changing:**
- New URL for password management: https://pam.example.com
- Updated desktop shortcut will be deployed
- Session recording now available for all privileged sessions

**Action Required:**
1. Complete the CyberArk training module by [DATE]
2. Test your access to the new system during pilot period
3. Report any issues to [SERVICE DESK]

**Support:**
- During migration: [WAR ROOM NUMBER]
- After migration: [SERVICE DESK]
- Emergency: [EMERGENCY CONTACT]

---

## Cutover Complete Notice

**Subject: PAM Migration Complete - Action Required**

Dear Team,

The PAM migration to CyberArk has been completed successfully.

**Effective Immediately:**
- Use CyberArk for all privileged access: https://pam.example.com
- The legacy [System Name] is now read-only and will be decommissioned on [DATE]

**Known Issues:**
- [List any known issues and workarounds]

**Next Steps:**
1. Login to CyberArk and verify your access
2. Report any missing access to [SERVICE DESK]
3. Update any scripts/automation to use CyberArk APIs

Thank you for your patience during this migration.
```

---

## Rollback Procedures

### Rollback Decision Matrix

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      Rollback Decision Matrix                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Issue Severity        Impact              Decision                     │
│  ────────────────────────────────────────────────────────              │
│  Critical              Business stopped    Immediate rollback           │
│  High                  Major degradation   Rollback within 2 hrs       │
│  Medium                Some impact         Attempt fix, rollback if    │
│                                            not resolved in 4 hrs        │
│  Low                   Minor impact        Fix forward, no rollback    │
│                                                                         │
│  Time-based Triggers:                                                   │
│  • >50% of smoke tests failing → Rollback                              │
│  • >10% users unable to login → Rollback                               │
│  • CPM not rotating passwords after 4 hrs → Rollback                   │
│  • Critical integration down > 2 hrs → Rollback                        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Rollback Procedures

```bash
#!/bin/bash
# rollback_migration.sh
# Emergency rollback procedure

set -euo pipefail

LEGACY_SYSTEM="thycotic.example.com"
CYBERARK_SYSTEM="pam.example.com"
LOG_FILE="/var/log/pam_rollback_$(date +%Y%m%d_%H%M%S).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Phase 1: Disable CyberArk integrations
disable_cyberark() {
    log "=== Phase 1: Disabling CyberArk Integrations ==="

    # Stop CPM service
    log "Stopping CPM services..."
    ssh cpm-server "systemctl stop PasswordManager"

    # Disable SIEM forwarding
    log "Disabling SIEM integration..."
    # Update syslog configuration

    # Disable CI/CD integration
    log "Disabling CI/CD Conjur integration..."
    # Revoke JWT tokens, disable webhook

    log "CyberArk integrations disabled"
}

# Phase 2: Re-enable legacy system
enable_legacy() {
    log "=== Phase 2: Re-enabling Legacy System ==="

    # Take legacy out of maintenance mode
    log "Removing legacy maintenance mode..."
    curl -X POST "https://$LEGACY_SYSTEM/api/maintenance" \
        -H "Authorization: Bearer $LEGACY_TOKEN" \
        -d '{"enabled": false}'

    # Re-enable legacy integrations
    log "Re-enabling legacy LDAP sync..."
    # Enable LDAP sync job

    log "Re-enabling legacy SIEM forwarding..."
    # Update syslog to point to legacy

    log "Legacy system re-enabled"
}

# Phase 3: Update routing
update_routing() {
    log "=== Phase 3: Updating Network Routing ==="

    # Update DNS (if applicable)
    log "Updating DNS records..."
    # pam.example.com -> legacy IP

    # Update load balancer
    log "Updating load balancer..."
    # Switch VIP to legacy backend

    log "Routing updated to legacy system"
}

# Phase 4: Notify stakeholders
notify_stakeholders() {
    log "=== Phase 4: Sending Notifications ==="

    # Send email notification
    cat << EOF | mail -s "PAM Migration Rollback Initiated" pam-team@example.com
PAM Migration Rollback has been initiated.

Time: $(date)
Reason: $ROLLBACK_REASON

Action Required:
- Use legacy system: https://$LEGACY_SYSTEM
- Report any issues to the war room

Status updates will follow.
EOF

    log "Stakeholder notification sent"
}

# Phase 5: Validate rollback
validate_rollback() {
    log "=== Phase 5: Validating Rollback ==="

    # Test legacy login
    log "Testing legacy authentication..."
    # Login test

    # Test password retrieval
    log "Testing password retrieval..."
    # Retrieve test password

    # Test integrations
    log "Testing legacy integrations..."
    # LDAP, SIEM, etc.

    log "Rollback validation complete"
}

# Main rollback procedure
main() {
    ROLLBACK_REASON="${1:-Unspecified}"

    log "=========================================="
    log "PAM MIGRATION ROLLBACK INITIATED"
    log "Reason: $ROLLBACK_REASON"
    log "=========================================="

    read -p "Confirm rollback (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        log "Rollback cancelled"
        exit 1
    fi

    disable_cyberark
    enable_legacy
    update_routing
    notify_stakeholders
    validate_rollback

    log "=========================================="
    log "ROLLBACK COMPLETE"
    log "Legacy system is now active"
    log "=========================================="
}

main "$@"
```

---

## Post-Migration Tasks

### Legacy System Decommission

```markdown
# Legacy PAM Decommission Checklist

## Prerequisites (Complete before decommission)
- [ ] Migration completed successfully (T+30 days minimum)
- [ ] All users migrated to CyberArk
- [ ] No active integrations with legacy system
- [ ] All audit data exported/archived
- [ ] Management approval obtained
- [ ] Decommission date communicated

## Phase 1: Access Removal (T+30)
- [ ] Remove user access to legacy system
- [ ] Disable legacy API keys/tokens
- [ ] Revoke service account permissions
- [ ] Update documentation to remove legacy references

## Phase 2: Data Archival (T+45)
- [ ] Export complete audit history
- [ ] Archive configuration backup
- [ ] Export credential metadata (not passwords)
- [ ] Store archives per retention policy

## Phase 3: Integration Cleanup (T+60)
- [ ] Remove legacy LDAP/AD integration
- [ ] Disable legacy SIEM forwarding
- [ ] Remove legacy CI/CD plugins
- [ ] Update firewall rules

## Phase 4: System Shutdown (T+75)
- [ ] Stop all legacy services
- [ ] Take final system backup
- [ ] Shutdown legacy servers
- [ ] Update CMDB/inventory

## Phase 5: Resource Recovery (T+90)
- [ ] Release server resources (VMs, containers)
- [ ] Cancel legacy vendor licenses
- [ ] Update budget/contracts
- [ ] Close project
```

### Post-Migration Optimization

```yaml
# post_migration_optimization.yaml
# Optimization tasks after migration stabilization

performance_tuning:
  cpm:
    - task: "Tune CPM worker threads"
      metric: "Password changes per hour"
      target: "500+ accounts/hour"

    - task: "Optimize verification schedule"
      metric: "Verification queue backlog"
      target: "< 100 pending verifications"

  vault:
    - task: "Tune database connections"
      metric: "Query response time"
      target: "< 100ms average"

    - task: "Optimize safe cache settings"
      metric: "Cache hit ratio"
      target: "> 90%"

  psm:
    - task: "Tune session recording compression"
      metric: "Storage per session hour"
      target: "< 100MB/hour"

security_hardening:
  - task: "Enable PTA threat detection"
    priority: "High"

  - task: "Configure dual control for Tier 1 accounts"
    priority: "High"

  - task: "Enable exclusive access for sensitive safes"
    priority: "Medium"

  - task: "Configure session isolation"
    priority: "Medium"

operational_improvements:
  - task: "Create operational runbooks"
    deliverable: "Runbook documentation"

  - task: "Set up monitoring dashboards"
    deliverable: "Grafana/SIEM dashboards"

  - task: "Configure alerting thresholds"
    deliverable: "Alert definitions"

  - task: "Train operations team"
    deliverable: "Training completion records"
```

---

## Related Documents

- [HA_DR_ARCHITECTURE.md](HA_DR_ARCHITECTURE.md) - High availability setup
- [PAM_INCIDENT_RESPONSE.md](PAM_INCIDENT_RESPONSE.md) - Incident procedures
- [DEVOPS_CI_CD_GUIDE.md](DEVOPS_CI_CD_GUIDE.md) - CI/CD integration
- [HANDS_ON_LABS_PHASE2.md](HANDS_ON_LABS_PHASE2.md) - Conjur deployment labs

## External References

- [CyberArk Privileged Access Manager Documentation](https://docs.cyberark.com/pam)
- [CyberArk Account Migration Utility](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PASIMP/Migrating-Accounts.htm)
- [Conjur Documentation](https://docs.conjur.org)
- [NIST SP 800-53 - Security Controls](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)

---

*Last Updated: 2025-12-04*
*Version: 1.0*
