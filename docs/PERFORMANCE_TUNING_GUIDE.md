# CyberArk PAM and Conjur Performance Tuning Guide

> Comprehensive guide for optimizing performance of CyberArk PAM and Conjur deployments

---

## Table of Contents

1. [Performance Overview](#performance-overview)
2. [Baseline Metrics](#baseline-metrics)
3. [CyberArk Vault Tuning](#cyberark-vault-tuning)
4. [PVWA Optimization](#pvwa-optimization)
5. [CPM Tuning](#cpm-tuning)
6. [PSM Performance](#psm-performance)
7. [Conjur Optimization](#conjur-optimization)
8. [Database Tuning](#database-tuning)
9. [Network Optimization](#network-optimization)
10. [Load Testing](#load-testing)
11. [Monitoring and Alerting](#monitoring-and-alerting)
12. [Troubleshooting Performance Issues](#troubleshooting-performance-issues)

---

## Performance Overview

### Performance Targets

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    PAM Performance Targets                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Component        Metric                    Target        Max Acceptable│
│  ─────────────────────────────────────────────────────────────────────  │
│  Vault            Login response            < 500ms       < 1s          │
│  Vault            Password retrieval        < 200ms       < 500ms       │
│  PVWA             Page load                 < 2s          < 5s          │
│  PVWA             API response (p95)        < 300ms       < 1s          │
│  CPM              Passwords/hour            500+          200+          │
│  CPM              Verification queue        < 100         < 500         │
│  PSM              Session initiation        < 3s          < 10s         │
│  PSM              Recording overhead        < 5%          < 10%         │
│  Conjur           Auth response (p95)       < 100ms       < 300ms       │
│  Conjur           Secret retrieval (p95)    < 50ms        < 150ms       │
│  Conjur           Secrets/second            1000+         500+          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Sizing Guidelines

| Scale | Accounts | Users | Vault Specs | PVWA Instances | CPM Instances |
|-------|----------|-------|-------------|----------------|---------------|
| Small | < 5,000 | < 100 | 4 CPU, 8GB | 1 | 1 |
| Medium | 5-25K | 100-500 | 8 CPU, 16GB | 2-3 | 2 |
| Large | 25-100K | 500-2000 | 16 CPU, 32GB | 4-6 | 3-4 |
| Enterprise | 100K+ | 2000+ | 32 CPU, 64GB | 8+ (LB) | 6+ |

---

## Baseline Metrics

### Establishing Baselines

```bash
#!/bin/bash
# baseline_collection.sh
# Collect performance baseline metrics

BASELINE_DIR="/var/log/pam_baseline"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BASELINE_DIR"

# Collect Vault metrics
echo "=== Collecting Vault Baseline ==="
cat << 'EOF' > "$BASELINE_DIR/vault_baseline_$DATE.txt"
Timestamp: $(date)

System Resources:
$(top -bn1 | head -20)

Disk I/O:
$(iostat -x 1 3)

Memory:
$(free -h)
$(vmstat 1 5)

Network:
$(netstat -s | grep -A 5 Tcp)

Vault Process:
$(ps aux | grep -i vault)

Open Files:
$(lsof -c PrivateArk | wc -l)

Safe Count:
$(pacli safes list | wc -l 2>/dev/null || echo "N/A")
EOF

# Collect PVWA metrics
echo "=== Collecting PVWA Baseline ==="
# Test PVWA response times
for i in {1..10}; do
    curl -o /dev/null -s -w "Response time: %{time_total}s\n" \
        "https://pvwa.example.com/PasswordVault/v10/logon" \
        >> "$BASELINE_DIR/pvwa_response_$DATE.txt"
    sleep 1
done

echo "Baseline collected: $BASELINE_DIR"
```

### Key Performance Indicators

```yaml
# performance_kpis.yaml
# KPIs for PAM performance monitoring

kpis:
  vault:
    - name: "vault_login_latency_p95"
      description: "95th percentile login response time"
      target: 500
      unit: "ms"
      query: 'histogram_quantile(0.95, vault_login_duration_seconds_bucket)'

    - name: "vault_operations_per_second"
      description: "Vault operations throughput"
      target: 100
      unit: "ops/s"
      query: 'rate(vault_operations_total[5m])'

    - name: "vault_safe_cache_hit_ratio"
      description: "Safe cache hit percentage"
      target: 90
      unit: "%"
      query: 'vault_cache_hits / (vault_cache_hits + vault_cache_misses) * 100'

  pvwa:
    - name: "pvwa_api_latency_p95"
      description: "95th percentile API response time"
      target: 300
      unit: "ms"
      query: 'histogram_quantile(0.95, pvwa_request_duration_seconds_bucket)'

    - name: "pvwa_error_rate"
      description: "API error percentage"
      target: 1
      unit: "%"
      query: 'rate(pvwa_errors_total[5m]) / rate(pvwa_requests_total[5m]) * 100'

    - name: "pvwa_concurrent_users"
      description: "Active user sessions"
      target: 500
      unit: "users"
      query: 'pvwa_active_sessions'

  cpm:
    - name: "cpm_rotation_rate"
      description: "Password rotations per hour"
      target: 500
      unit: "rotations/hr"
      query: 'increase(cpm_rotations_total[1h])'

    - name: "cpm_queue_depth"
      description: "Pending operations in queue"
      target: 100
      unit: "operations"
      query: 'cpm_queue_pending'

    - name: "cpm_failure_rate"
      description: "Rotation failure percentage"
      target: 5
      unit: "%"
      query: 'rate(cpm_failures_total[1h]) / rate(cpm_rotations_total[1h]) * 100'

  conjur:
    - name: "conjur_auth_latency_p95"
      description: "95th percentile authentication time"
      target: 100
      unit: "ms"
      query: 'histogram_quantile(0.95, conjur_authn_duration_seconds_bucket)'

    - name: "conjur_secrets_throughput"
      description: "Secrets retrieved per second"
      target: 1000
      unit: "secrets/s"
      query: 'rate(conjur_secrets_fetched_total[5m])'

    - name: "conjur_connection_pool_usage"
      description: "Database connection pool utilization"
      target: 70
      unit: "%"
      query: 'conjur_db_pool_active / conjur_db_pool_size * 100'
```

---

## CyberArk Vault Tuning

### Server Configuration

```ini
# DBParm.ini - Vault Performance Settings
# Location: \Server\Conf\DBParm.ini

[Main]
# Increase cache sizes for large deployments
CacheSize=500000
FileCacheSize=200000
SafeCacheSize=50000

# Connection handling
MaxConcurrentConnections=500
ConnectionTimeout=120

# Transaction logging
TransactionLogSize=1000000
TransactionLogPath=D:\Logs\Vault

# Memory settings
MaxMemory=16384    # MB
MinMemory=4096     # MB

# I/O optimization
AsyncIOThreads=8
ReadAheadSize=65536
WriteBufferSize=131072

# Safe operations
SafeOpenTimeout=30
SafeCloseDelay=5

[Performance]
# Enable performance optimizations
EnableBatchOperations=Yes
BatchSize=100
EnableParallelProcessing=Yes
ParallelThreads=4

# Indexing
EnableIndexing=Yes
IndexUpdateInterval=60

[Logging]
# Reduce logging overhead in production
LogLevel=Error
PerformanceLogging=No
```

### Vault Hardware Optimization

```powershell
# Optimize-VaultServer.ps1
# Windows Server optimization for CyberArk Vault

# Disable unnecessary services
$servicesToDisable = @(
    "Spooler",
    "WSearch",
    "DiagTrack",
    "dmwappushservice"
)

foreach ($svc in $servicesToDisable) {
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
}

# Configure power plan for high performance
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Optimize disk performance
# Disable last access timestamp
fsutil behavior set disablelastaccess 1

# Increase system cache
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" `
    -Name "LargeSystemCache" -Value 1

# Disable pagefile on Vault drive (if sufficient RAM)
# Note: Vault drive should have no pagefile
$computer = Get-WmiObject Win32_ComputerSystem
$computer.AutomaticManagedPagefile = $false
$computer.Put()

# Configure network adapter for performance
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
Set-NetAdapterAdvancedProperty -Name $adapter.Name `
    -RegistryKeyword "*JumboPacket" -RegistryValue 9014 -ErrorAction SilentlyContinue

# Disable SMB signing for internal network (performance trade-off)
# Only if security policy allows
# Set-SmbServerConfiguration -RequireSecuritySignature $false -Force

Write-Host "Vault server optimization complete. Reboot required."
```

### Vault Disk Configuration

```powershell
# Configure-VaultStorage.ps1
# Optimal disk configuration for Vault

# Recommended layout:
# C: - OS (SSD, 100GB)
# D: - Vault Application (SSD, 100GB)
# E: - Safes Data (NVMe/SSD RAID 10, size based on data)
# F: - Transaction Logs (NVMe/SSD, 100GB)
# G: - Metadata/Indexes (SSD, 50GB)

# Storage Spaces configuration for Safes
$disks = Get-PhysicalDisk | Where-Object {$_.CanPool -eq $true}

New-StoragePool -FriendlyName "VaultPool" `
    -StorageSubsystemFriendlyName "Windows Storage*" `
    -PhysicalDisks $disks

# Create striped virtual disk for Safes
New-VirtualDisk -StoragePoolFriendlyName "VaultPool" `
    -FriendlyName "SafesVolume" `
    -ResiliencySettingName Mirror `
    -NumberOfColumns 2 `
    -Size 500GB `
    -Interleave 256KB

# Initialize and format
$vdisk = Get-VirtualDisk -FriendlyName "SafesVolume"
$vdisk | Initialize-Disk -PassThru |
    New-Partition -DriveLetter E -UseMaximumSize |
    Format-Volume -FileSystem NTFS -AllocationUnitSize 64KB `
        -NewFileSystemLabel "Safes"

# Disable indexing and compression on Safes drive
$safesPath = "E:\"
$folder = Get-Item $safesPath
$folder.Attributes = $folder.Attributes -bor [System.IO.FileAttributes]::NotContentIndexed
```

---

## PVWA Optimization

### IIS Configuration

```powershell
# Configure-PVWAPerformance.ps1
# IIS optimization for PVWA

Import-Module WebAdministration

$siteName = "PasswordVault"
$appPoolName = "PasswordVaultAppPool"

# Application Pool settings
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.idleTimeout" -Value "00:00:00"
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "recycling.periodicRestart.time" -Value "00:00:00"
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.maxProcesses" -Value 0
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "queueLength" -Value 5000

# Enable 32-bit applications (if needed for performance)
# Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "enable32BitAppOnWin64" -Value $false

# Worker process settings
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.requestQueueLimit" -Value 5000

# Rapid fail protection
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "failure.rapidFailProtection" -Value $false

# CPU settings
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "cpu.limit" -Value 0

# Memory optimization
Set-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" `
    -Filter "system.web/caching/outputCache" `
    -Name "enableOutputCache" `
    -Value $true

# Compression
Set-WebConfigurationProperty -PSPath "IIS:\" `
    -Filter "system.webServer/httpCompression" `
    -Name "dynamicCompressionLevel" `
    -Value 4

# Connection limits
Set-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" `
    -Filter "system.webServer/serverRuntime" `
    -Name "appConcurrentRequestLimit" `
    -Value 10000

Write-Host "PVWA IIS optimization complete"
```

### PVWA Configuration

```xml
<!-- Web.config performance settings -->
<configuration>
  <system.web>
    <!-- Session state optimization -->
    <sessionState
      mode="InProc"
      timeout="20"
      cookieless="UseCookies"
      regenerateExpiredSessionId="true" />

    <!-- Compilation settings -->
    <compilation
      debug="false"
      optimizeCompilations="true"
      batch="true"
      batchTimeout="900" />

    <!-- HTTP runtime -->
    <httpRuntime
      maxRequestLength="102400"
      executionTimeout="300"
      enableVersionHeader="false"
      requestValidationMode="2.0"
      targetFramework="4.8" />

    <!-- Caching -->
    <caching>
      <outputCache enableOutputCache="true" />
      <outputCacheSettings>
        <outputCacheProfiles>
          <add name="StaticContent" duration="86400" varyByParam="none" />
          <add name="APICache" duration="60" varyByParam="*" />
        </outputCacheProfiles>
      </outputCacheSettings>
    </caching>
  </system.web>

  <system.webServer>
    <!-- Static content caching -->
    <staticContent>
      <clientCache cacheControlMode="UseMaxAge" cacheControlMaxAge="7.00:00:00" />
    </staticContent>

    <!-- Output compression -->
    <urlCompression doStaticCompression="true" doDynamicCompression="true" />

    <!-- Connection management -->
    <serverRuntime
      appConcurrentRequestLimit="10000"
      uploadReadAheadSize="1048576" />
  </system.webServer>
</configuration>
```

### Load Balancer Configuration

```yaml
# pvwa_lb_config.yaml
# Load balancer settings for PVWA cluster

load_balancer:
  type: "application"  # Layer 7
  scheme: "internal"

  health_check:
    path: "/PasswordVault/api/Auth/Health"
    protocol: "HTTPS"
    interval: 10
    timeout: 5
    healthy_threshold: 2
    unhealthy_threshold: 3

  session_affinity:
    enabled: true
    type: "cookie"
    cookie_name: "PVWA_AFFINITY"
    ttl: 3600

  connection_draining:
    enabled: true
    timeout: 30

  backend_settings:
    request_timeout: 300
    connection_timeout: 10

  # Traffic distribution
  algorithm: "least_connections"

  # SSL termination
  ssl:
    certificate: "arn:aws:acm:xxx/pvwa-cert"
    policy: "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  # Rate limiting (optional)
  rate_limiting:
    enabled: true
    requests_per_second: 100
    burst_size: 200
```

---

## CPM Tuning

### CPM Configuration

```ini
# CPM.ini - Central Policy Manager Performance Settings

[Main]
# Increase worker threads for parallel processing
MaxConcurrentTasks=50
TaskTimeout=300
RetryCount=3
RetryInterval=30

# Queue management
MaxQueueSize=10000
QueueProcessingInterval=5
PriorityQueueEnabled=Yes

# Connection pooling
ConnectionPoolSize=100
ConnectionTimeout=30
ConnectionRetries=3

[Performance]
# Batch operations
BatchModeEnabled=Yes
BatchSize=50
BatchTimeout=60

# Parallel verification
ParallelVerification=Yes
VerificationThreads=10

# Parallel rotation
ParallelRotation=Yes
RotationThreads=20

# Cache settings
EnablePlatformCache=Yes
PlatformCacheTimeout=3600

[Logging]
# Reduce logging for performance
LogLevel=Warning
DetailedLogging=No
PerformanceLogging=Yes
PerformanceLogInterval=300

[Platform]
# Platform-specific optimizations
WindowsConnectTimeout=10
UnixConnectTimeout=15
DatabaseConnectTimeout=20
```

### CPM Scaling

```powershell
# Scale-CPM.ps1
# CPM scaling and workload distribution

# Get all CPM servers
$cpmServers = @(
    "cpm01.example.com",
    "cpm02.example.com",
    "cpm03.example.com"
)

# Platform assignment for load distribution
$platformAssignment = @{
    "cpm01.example.com" = @("WinServerLocal", "WinDomain", "WinDesktopLocal")
    "cpm02.example.com" = @("UnixSSH", "UnixSSHKeys", "UnixSU")
    "cpm03.example.com" = @("Oracle", "MSSql", "MySQL", "PostgreSQL")
}

# Configure platform assignments via PVWA API
foreach ($cpm in $cpmServers) {
    $platforms = $platformAssignment[$cpm]

    foreach ($platform in $platforms) {
        # Assign platform to CPM
        $body = @{
            PlatformID = $platform
            CPMName = $cpm
        } | ConvertTo-Json

        Invoke-RestMethod -Uri "$pvwaUrl/api/Platforms/$platform/CPM" `
            -Method PUT `
            -Headers $headers `
            -Body $body
    }
}

# Monitor CPM queue depth
function Get-CPMQueueMetrics {
    param($cpmServer)

    $metrics = @{
        Server = $cpmServer
        PendingRotations = (Get-CPMQueue -Type Rotation).Count
        PendingVerifications = (Get-CPMQueue -Type Verification).Count
        FailedOperations = (Get-CPMQueue -Type Failed).Count
        ProcessingRate = (Get-CPMStats -Interval 3600).OperationsPerHour
    }

    return $metrics
}
```

### CPM Platform Optimization

```yaml
# platform_tuning.yaml
# Platform-specific performance settings

platforms:
  WinServerLocal:
    concurrent_connections: 20
    connection_timeout: 10
    command_timeout: 30
    retry_count: 2
    batch_enabled: true

  UnixSSH:
    concurrent_connections: 30
    connection_timeout: 15
    command_timeout: 45
    # SSH specific
    ssh_timeout: 20
    ssh_keepalive: 60
    use_connection_pool: true
    pool_size: 50

  Oracle:
    concurrent_connections: 15
    connection_timeout: 20
    command_timeout: 60
    # Database specific
    use_tns: true
    connection_pool_size: 20

  AWSAccessKeys:
    concurrent_connections: 25
    api_timeout: 30
    # AWS specific
    use_assume_role: true
    max_retries: 3
    exponential_backoff: true

# Rotation scheduling
rotation_windows:
  high_priority:
    start: "02:00"
    end: "06:00"
    max_concurrent: 100

  normal:
    start: "00:00"
    end: "23:59"
    max_concurrent: 50

  low_priority:
    start: "22:00"
    end: "02:00"
    max_concurrent: 200
```

---

## PSM Performance

### PSM Server Optimization

```powershell
# Optimize-PSMServer.ps1
# PSM server performance tuning

# RDS Configuration
Import-Module RemoteDesktop

# Session settings
Set-RDSessionCollectionConfiguration -CollectionName "PSM" `
    -IdleSessionLimit 30 `
    -DisconnectedSessionLimit 5 `
    -MaxRedirectedMonitors 4 `
    -UserGroup "PSM_Users"

# GPU settings for session recording
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" `
    -Name "AVC444ModePreferred" -Value 1

# Disable visual effects for performance
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" `
    -Name "VisualFXSetting" -Value 2

# Network Level Authentication
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
    -Name "UserAuthentication" -Value 1

# Optimize RDP settings
$rdpSettings = @{
    "fDisableCam" = 1          # Disable camera redirection
    "fDisableCdm" = 0          # Enable drive redirection (if needed)
    "fDisableCcm" = 1          # Disable COM port redirection
    "fDisableLPT" = 1          # Disable LPT port redirection
    "fEnableSmartCard" = 1     # Enable smart card
}

foreach ($setting in $rdpSettings.GetEnumerator()) {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
        -Name $setting.Key -Value $setting.Value
}

# PSM-specific settings
$psmPath = "HKLM:\SOFTWARE\CyberArk\PSM"
Set-ItemProperty -Path $psmPath -Name "MaxConcurrentSessions" -Value 100
Set-ItemProperty -Path $psmPath -Name "SessionRecordingQuality" -Value "Medium"
Set-ItemProperty -Path $psmPath -Name "RecordingCompression" -Value "High"
```

### Session Recording Optimization

```yaml
# psm_recording_config.yaml
# Session recording performance settings

recording:
  # Quality vs Performance trade-offs
  quality_profile: "balanced"  # low, balanced, high

  profiles:
    low:
      fps: 5
      resolution: "1280x720"
      color_depth: 16
      compression: "high"
      keyframe_interval: 60

    balanced:
      fps: 10
      resolution: "1920x1080"
      color_depth: 24
      compression: "medium"
      keyframe_interval: 30

    high:
      fps: 15
      resolution: "native"
      color_depth: 32
      compression: "low"
      keyframe_interval: 15

  storage:
    # Recording storage path
    primary_path: "D:\\PSM\\Recordings"
    archive_path: "\\\\storage\\PSM_Archive"

    # Compression settings
    compress_on_save: true
    compression_level: 6  # 1-9

    # Retention
    local_retention_days: 7
    archive_retention_days: 365

    # Cleanup
    cleanup_schedule: "daily"
    cleanup_time: "03:00"

  streaming:
    # Live monitoring buffer
    buffer_size_mb: 50
    max_concurrent_viewers: 5
```

### PSM Load Balancing

```powershell
# Configure-PSMLoadBalancing.ps1
# PSM farm load balancing configuration

# Get PSM servers
$psmServers = @(
    @{Name="PSM01"; IP="10.0.1.10"; MaxSessions=100; Weight=100}
    @{Name="PSM02"; IP="10.0.1.11"; MaxSessions=100; Weight=100}
    @{Name="PSM03"; IP="10.0.1.12"; MaxSessions=100; Weight=100}
)

# Configure Connection Broker
$brokerConfig = @{
    LoadBalanceType = "LeastConnections"  # RoundRobin, LeastConnections, WeightBased
    HealthCheckInterval = 30
    HealthCheckTimeout = 10
    DrainOnDisable = $true
    DrainTimeout = 300
}

# PSM farm configuration via PVWA
$farmConfig = @{
    FarmName = "PSM_Production"
    LoadBalanceMethod = $brokerConfig.LoadBalanceType
    Servers = $psmServers | ForEach-Object {
        @{
            ServerName = $_.Name
            IPAddress = $_.IP
            MaxSessions = $_.MaxSessions
            Weight = $_.Weight
            Enabled = $true
        }
    }
}

# Apply configuration
Set-PSMFarmConfiguration -Config $farmConfig

# Monitor session distribution
function Get-PSMLoadMetrics {
    $metrics = @()

    foreach ($server in $psmServers) {
        $sessions = Get-PSMSessions -Server $server.Name

        $metrics += @{
            Server = $server.Name
            ActiveSessions = $sessions.Count
            Utilization = [math]::Round(($sessions.Count / $server.MaxSessions) * 100, 2)
            AvgSessionDuration = ($sessions | Measure-Object -Property Duration -Average).Average
        }
    }

    return $metrics
}
```

---

## Conjur Optimization

### Conjur Server Tuning

```yaml
# conjur_performance.yaml
# Conjur performance configuration

# Application settings
conjur:
  # Puma web server settings
  puma:
    workers: 4              # Number of worker processes
    threads_min: 5          # Minimum threads per worker
    threads_max: 16         # Maximum threads per worker
    worker_timeout: 60      # Worker timeout in seconds
    preload_app: true       # Preload app before forking

  # Rails settings
  rails:
    environment: production
    log_level: warn
    cache_classes: true
    eager_load: true

  # Connection pool
  database:
    pool_size: 25           # Connections per worker
    pool_timeout: 5         # Pool checkout timeout
    statement_timeout: 30   # Query timeout (seconds)

  # Caching
  cache:
    enabled: true
    backend: redis          # memory, redis
    redis_url: "redis://redis:6379/0"
    ttl: 300               # Default TTL in seconds

  # Rate limiting
  rate_limiting:
    enabled: true
    requests_per_minute: 1000
    burst: 100

  # Authentication caching
  authn_cache:
    enabled: true
    ttl: 60                # Token validity cache

# Kubernetes-specific settings
kubernetes:
  resources:
    requests:
      memory: "2Gi"
      cpu: "1000m"
    limits:
      memory: "4Gi"
      cpu: "2000m"

  # Horizontal Pod Autoscaler
  hpa:
    min_replicas: 2
    max_replicas: 10
    target_cpu_utilization: 70
    target_memory_utilization: 80

  # Pod Disruption Budget
  pdb:
    min_available: 1
```

### Conjur Follower Tuning

```yaml
# follower_config.yaml
# Conjur follower performance settings

follower:
  # Replication settings
  replication:
    sync_interval: 5        # Seconds between sync checks
    batch_size: 1000       # Max changes per sync
    compression: true      # Compress replication traffic

  # Local caching
  cache:
    secrets:
      enabled: true
      max_size: 10000      # Max cached secrets
      ttl: 60              # Cache TTL in seconds

    policies:
      enabled: true
      ttl: 300             # Policy cache TTL

  # Connection handling
  connections:
    max_idle: 50
    max_active: 200
    idle_timeout: 300

  # Health check
  health:
    replication_lag_threshold: 60  # Alert if lag > 60s

# Deployment across regions
regional_followers:
  us-east-1:
    replicas: 2
    affinity: "zone"

  eu-west-1:
    replicas: 2
    affinity: "zone"

  ap-southeast-1:
    replicas: 1
    affinity: "none"
```

### Conjur API Optimization

```python
#!/usr/bin/env python3
"""
conjur_client_optimization.py
Optimized Conjur client patterns
"""

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
import threading
from functools import lru_cache
import time


class OptimizedConjurClient:
    """Performance-optimized Conjur client"""

    def __init__(self,
                 conjur_url: str,
                 account: str,
                 pool_connections: int = 10,
                 pool_maxsize: int = 50):
        self.conjur_url = conjur_url
        self.account = account
        self._token = None
        self._token_expiry = 0
        self._token_lock = threading.Lock()

        # Configure connection pooling
        self.session = requests.Session()

        retry_strategy = Retry(
            total=3,
            backoff_factor=0.5,
            status_forcelist=[429, 500, 502, 503, 504]
        )

        adapter = HTTPAdapter(
            pool_connections=pool_connections,
            pool_maxsize=pool_maxsize,
            max_retries=retry_strategy
        )

        self.session.mount("https://", adapter)

    @property
    def token(self) -> str:
        """Thread-safe token management with caching"""
        with self._token_lock:
            if time.time() >= self._token_expiry - 60:  # Refresh 60s before expiry
                self._refresh_token()
            return self._token

    def _refresh_token(self) -> None:
        """Refresh authentication token"""
        # Implementation depends on auth method
        # Token typically valid for 8 minutes
        self._token_expiry = time.time() + 480

    @lru_cache(maxsize=1000)
    def get_secret_cached(self, variable_id: str) -> str:
        """Get secret with local caching"""
        return self._fetch_secret(variable_id)

    def get_secret(self, variable_id: str, use_cache: bool = True) -> str:
        """Get secret with optional caching"""
        if use_cache:
            return self.get_secret_cached(variable_id)
        return self._fetch_secret(variable_id)

    def _fetch_secret(self, variable_id: str) -> str:
        """Fetch secret from Conjur"""
        encoded_id = requests.utils.quote(variable_id, safe='')
        url = f"{self.conjur_url}/secrets/{self.account}/variable/{encoded_id}"

        response = self.session.get(
            url,
            headers={'Authorization': f'Token token="{self.token}"'},
            timeout=(5, 30)  # (connect, read) timeouts
        )
        response.raise_for_status()
        return response.text

    def get_secrets_batch(self, variable_ids: list) -> dict:
        """Batch retrieve multiple secrets"""
        # Use batch endpoint for efficiency
        url = f"{self.conjur_url}/secrets"
        params = {'variable_ids': ','.join(variable_ids)}

        response = self.session.get(
            url,
            params=params,
            headers={'Authorization': f'Token token="{self.token}"'},
            timeout=(5, 60)
        )
        response.raise_for_status()
        return response.json()

    def invalidate_cache(self, variable_id: str = None) -> None:
        """Invalidate cache entries"""
        if variable_id:
            self.get_secret_cached.cache_clear()
        else:
            self.get_secret_cached.cache_clear()


# Connection pool for high-throughput scenarios
class ConjurConnectionPool:
    """Thread-safe connection pool for Conjur"""

    def __init__(self, url: str, account: str, pool_size: int = 10):
        self.url = url
        self.account = account
        self.pool_size = pool_size
        self._pool = []
        self._lock = threading.Lock()

        # Initialize pool
        for _ in range(pool_size):
            self._pool.append(OptimizedConjurClient(url, account))

    def get_client(self) -> OptimizedConjurClient:
        """Get a client from the pool"""
        with self._lock:
            if self._pool:
                return self._pool.pop()
        # Create new client if pool exhausted
        return OptimizedConjurClient(self.url, self.account)

    def return_client(self, client: OptimizedConjurClient) -> None:
        """Return client to pool"""
        with self._lock:
            if len(self._pool) < self.pool_size:
                self._pool.append(client)
```

---

## Database Tuning

### PostgreSQL for Conjur

```sql
-- postgresql_tuning.sql
-- PostgreSQL performance tuning for Conjur

-- Connection settings
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET superuser_reserved_connections = 5;

-- Memory settings
ALTER SYSTEM SET shared_buffers = '4GB';           -- 25% of RAM
ALTER SYSTEM SET effective_cache_size = '12GB';    -- 75% of RAM
ALTER SYSTEM SET work_mem = '256MB';
ALTER SYSTEM SET maintenance_work_mem = '1GB';

-- Write Ahead Log (WAL)
ALTER SYSTEM SET wal_buffers = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET max_wal_size = '4GB';
ALTER SYSTEM SET min_wal_size = '1GB';

-- Query planner
ALTER SYSTEM SET random_page_cost = 1.1;           -- SSD storage
ALTER SYSTEM SET effective_io_concurrency = 200;   -- SSD storage
ALTER SYSTEM SET default_statistics_target = 100;

-- Parallel queries
ALTER SYSTEM SET max_parallel_workers_per_gather = 4;
ALTER SYSTEM SET max_parallel_workers = 8;
ALTER SYSTEM SET parallel_tuple_cost = 0.01;
ALTER SYSTEM SET parallel_setup_cost = 500;

-- Logging (reduce for performance)
ALTER SYSTEM SET log_min_duration_statement = 1000;  -- Log slow queries > 1s
ALTER SYSTEM SET log_checkpoints = on;
ALTER SYSTEM SET log_lock_waits = on;

-- Vacuum settings
ALTER SYSTEM SET autovacuum_vacuum_scale_factor = 0.1;
ALTER SYSTEM SET autovacuum_analyze_scale_factor = 0.05;
ALTER SYSTEM SET autovacuum_max_workers = 4;

-- Reload configuration
SELECT pg_reload_conf();

-- Create performance indexes for Conjur
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_secrets_resource_id
    ON secrets(resource_id);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_credentials_role_id
    ON credentials(role_id);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_permissions_resource_role
    ON permissions(resource_id, role_id);

-- Analyze tables
ANALYZE VERBOSE secrets;
ANALYZE VERBOSE credentials;
ANALYZE VERBOSE permissions;
ANALYZE VERBOSE roles;
```

### Vault Database (MS SQL)

```sql
-- vault_db_tuning.sql
-- SQL Server performance tuning for CyberArk Vault

-- Memory configuration
EXEC sp_configure 'max server memory', 16384;  -- MB
EXEC sp_configure 'min server memory', 4096;   -- MB
RECONFIGURE;

-- Parallelism
EXEC sp_configure 'max degree of parallelism', 4;
EXEC sp_configure 'cost threshold for parallelism', 50;
RECONFIGURE;

-- TempDB optimization
-- Move tempdb to fast storage and add multiple files
ALTER DATABASE tempdb MODIFY FILE (
    NAME = tempdev,
    SIZE = 4096MB,
    FILEGROWTH = 512MB
);

-- Add additional tempdb files (one per CPU core, up to 8)
ALTER DATABASE tempdb ADD FILE (
    NAME = tempdev2,
    FILENAME = 'D:\SQLData\tempdb2.ndf',
    SIZE = 4096MB,
    FILEGROWTH = 512MB
);

-- Index maintenance for Vault tables
-- Update statistics
UPDATE STATISTICS dbo.Safes WITH FULLSCAN;
UPDATE STATISTICS dbo.Objects WITH FULLSCAN;
UPDATE STATISTICS dbo.AuditLog WITH FULLSCAN;

-- Rebuild fragmented indexes
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql +
    'ALTER INDEX ' + QUOTENAME(i.name) +
    ' ON ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) +
    ' REBUILD;' + CHAR(13)
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE ips.avg_fragmentation_in_percent > 30
  AND i.name IS NOT NULL;

EXEC sp_executesql @sql;

-- Query store for performance monitoring
ALTER DATABASE VaultDB SET QUERY_STORE = ON;
ALTER DATABASE VaultDB SET QUERY_STORE (
    OPERATION_MODE = READ_WRITE,
    CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30),
    DATA_FLUSH_INTERVAL_SECONDS = 900,
    MAX_STORAGE_SIZE_MB = 1024
);
```

---

## Network Optimization

### Network Configuration

```yaml
# network_optimization.yaml
# Network performance settings for PAM

network:
  # TCP tuning
  tcp_settings:
    # Linux settings
    linux:
      net.core.somaxconn: 65535
      net.core.netdev_max_backlog: 65535
      net.ipv4.tcp_max_syn_backlog: 65535
      net.ipv4.tcp_fin_timeout: 15
      net.ipv4.tcp_keepalive_time: 300
      net.ipv4.tcp_keepalive_probes: 5
      net.ipv4.tcp_keepalive_intvl: 15
      net.ipv4.tcp_tw_reuse: 1
      net.core.rmem_max: 16777216
      net.core.wmem_max: 16777216

    # Windows settings
    windows:
      TcpTimedWaitDelay: 30
      MaxUserPort: 65534
      TcpMaxDataRetransmissions: 3
      SynAttackProtect: 1
      EnableDynamicBacklog: 1

  # Load balancer settings
  load_balancer:
    connection_timeout: 10
    request_timeout: 300
    idle_timeout: 60
    keepalive_timeout: 300

  # DNS optimization
  dns:
    cache_ttl: 300
    negative_cache_ttl: 60
    use_tcp: false
    retries: 2
    timeout: 5

  # Firewall optimization
  firewall:
    connection_tracking:
      max_connections: 1048576
      timeout_established: 432000
      timeout_close_wait: 60
```

### TLS Optimization

```yaml
# tls_optimization.yaml
# TLS/SSL performance settings

tls:
  # Protocol versions
  min_version: "TLSv1.2"
  max_version: "TLSv1.3"

  # Cipher suites (ordered by performance)
  cipher_suites:
    - "TLS_AES_256_GCM_SHA384"
    - "TLS_CHACHA20_POLY1305_SHA256"
    - "TLS_AES_128_GCM_SHA256"
    - "ECDHE-ECDSA-AES256-GCM-SHA384"
    - "ECDHE-RSA-AES256-GCM-SHA384"

  # Session resumption
  session_cache:
    enabled: true
    size: 50000
    timeout: 86400  # 24 hours

  # OCSP stapling
  ocsp_stapling:
    enabled: true
    cache_timeout: 3600

  # Certificate settings
  certificate:
    key_type: "ecdsa"  # Faster than RSA
    curve: "secp384r1"

  # HTTP/2
  http2:
    enabled: true
    max_concurrent_streams: 128
    initial_window_size: 65535
```

---

## Load Testing

### Load Test Scenarios

```python
#!/usr/bin/env python3
"""
pam_load_test.py
Load testing framework for PAM components
"""

from locust import HttpUser, task, between, events
import random
import time


class PVWAUser(HttpUser):
    """PVWA load test user"""

    wait_time = between(1, 5)
    host = "https://pvwa.example.com"

    def on_start(self):
        """Login on start"""
        response = self.client.post("/PasswordVault/API/Auth/CyberArk/Logon", json={
            "username": f"testuser{random.randint(1, 100)}",
            "password": "TestPassword123!"
        })
        self.token = response.json().get("CyberArkLogonResult")

    @task(10)
    def get_accounts(self):
        """List accounts - most common operation"""
        self.client.get(
            "/PasswordVault/API/Accounts",
            headers={"Authorization": self.token}
        )

    @task(5)
    def retrieve_password(self):
        """Retrieve a password"""
        account_id = f"1_{random.randint(1, 1000)}"
        self.client.post(
            f"/PasswordVault/API/Accounts/{account_id}/Password/Retrieve",
            headers={"Authorization": self.token},
            json={"reason": "Load test"}
        )

    @task(2)
    def search_accounts(self):
        """Search accounts"""
        self.client.get(
            "/PasswordVault/API/Accounts?search=admin",
            headers={"Authorization": self.token}
        )

    @task(1)
    def get_safes(self):
        """List safes"""
        self.client.get(
            "/PasswordVault/API/Safes",
            headers={"Authorization": self.token}
        )


class ConjurUser(HttpUser):
    """Conjur load test user"""

    wait_time = between(0.1, 1)
    host = "https://conjur.example.com"

    def on_start(self):
        """Authenticate on start"""
        import base64

        # API key authentication
        api_key = "test_api_key"
        login = f"host/app-{random.randint(1, 100)}"

        response = self.client.post(
            f"/authn/myorg/{login}/authenticate",
            data=api_key
        )

        self.token = base64.b64encode(response.content).decode()

    @task(10)
    def fetch_secret(self):
        """Fetch a secret - primary operation"""
        secret_id = f"apps/app{random.randint(1, 50)}/database/password"
        encoded_id = requests.utils.quote(secret_id, safe='')

        self.client.get(
            f"/secrets/myorg/variable/{encoded_id}",
            headers={"Authorization": f'Token token="{self.token}"'}
        )

    @task(2)
    def batch_secrets(self):
        """Batch fetch secrets"""
        secrets = [f"apps/app1/secret{i}" for i in range(1, 6)]

        self.client.get(
            "/secrets",
            params={"variable_ids": ",".join(secrets)},
            headers={"Authorization": f'Token token="{self.token}"'}
        )

    @task(1)
    def reauthenticate(self):
        """Re-authenticate"""
        self.on_start()


# Event handlers for metrics
@events.request.add_listener
def record_request(request_type, name, response_time, response_length, **kwargs):
    """Record request metrics"""
    pass


# Run configuration
# locust -f pam_load_test.py --host=https://pvwa.example.com
# --users=100 --spawn-rate=10 --run-time=30m
```

### Benchmark Results Template

```markdown
# PAM Performance Benchmark Results

## Test Environment
- Date: YYYY-MM-DD
- Duration: 30 minutes
- Users: 100 concurrent
- Ramp-up: 10 users/second

## PVWA Results

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Requests/sec | 250 | 200+ | PASS |
| Avg Response Time | 180ms | <300ms | PASS |
| p95 Response Time | 450ms | <1000ms | PASS |
| p99 Response Time | 800ms | <2000ms | PASS |
| Error Rate | 0.1% | <1% | PASS |
| Max Concurrent Users | 100 | 100 | PASS |

### Response Time Distribution
- 0-100ms: 35%
- 100-300ms: 45%
- 300-500ms: 15%
- 500-1000ms: 4%
- >1000ms: 1%

## Conjur Results

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Requests/sec | 1200 | 1000+ | PASS |
| Avg Response Time | 25ms | <50ms | PASS |
| p95 Response Time | 80ms | <100ms | PASS |
| p99 Response Time | 150ms | <200ms | PASS |
| Error Rate | 0.01% | <0.1% | PASS |

## Resource Utilization

### Vault Server
- CPU: 45% avg, 78% peak
- Memory: 12GB / 16GB (75%)
- Disk I/O: 150 IOPS avg

### PVWA Servers (x2)
- CPU: 55% avg, 85% peak
- Memory: 6GB / 8GB (75%)
- Network: 100 Mbps avg

### Conjur (x2 pods)
- CPU: 800m avg / 2000m limit
- Memory: 2.5GB / 4GB limit

## Recommendations
1. [Recommendation based on results]
2. [Optimization opportunity]
3. [Scaling recommendation]
```

---

## Monitoring and Alerting

### Performance Monitoring Dashboard

```yaml
# grafana_performance_dashboard.yaml
# Performance monitoring dashboard

apiVersion: 1
dashboards:
  - name: "PAM Performance Overview"
    panels:
      # Response Time Panel
      - title: "API Response Times"
        type: timeseries
        gridPos: {h: 8, w: 12, x: 0, y: 0}
        targets:
          - expr: 'histogram_quantile(0.95, rate(pvwa_request_duration_seconds_bucket[5m]))'
            legendFormat: "PVWA p95"
          - expr: 'histogram_quantile(0.95, rate(conjur_request_duration_seconds_bucket[5m]))'
            legendFormat: "Conjur p95"
        thresholds:
          - value: 0.3
            color: green
          - value: 0.5
            color: yellow
          - value: 1.0
            color: red

      # Throughput Panel
      - title: "Requests per Second"
        type: timeseries
        gridPos: {h: 8, w: 12, x: 12, y: 0}
        targets:
          - expr: 'rate(pvwa_requests_total[5m])'
            legendFormat: "PVWA"
          - expr: 'rate(conjur_requests_total[5m])'
            legendFormat: "Conjur"
          - expr: 'rate(cpm_operations_total[5m])'
            legendFormat: "CPM"

      # Error Rate Panel
      - title: "Error Rates"
        type: stat
        gridPos: {h: 4, w: 8, x: 0, y: 8}
        targets:
          - expr: 'rate(pvwa_errors_total[5m]) / rate(pvwa_requests_total[5m]) * 100'
            legendFormat: "PVWA Error %"

      # Resource Utilization
      - title: "CPU Utilization"
        type: gauge
        gridPos: {h: 4, w: 4, x: 8, y: 8}
        targets:
          - expr: 'avg(node_cpu_utilization{component="vault"})'

      - title: "Memory Utilization"
        type: gauge
        gridPos: {h: 4, w: 4, x: 12, y: 8}
        targets:
          - expr: 'node_memory_utilization{component="vault"}'

      # CPM Queue Depth
      - title: "CPM Queue Depth"
        type: timeseries
        gridPos: {h: 6, w: 12, x: 0, y: 12}
        targets:
          - expr: 'cpm_queue_pending{type="rotation"}'
            legendFormat: "Rotation Queue"
          - expr: 'cpm_queue_pending{type="verification"}'
            legendFormat: "Verification Queue"

      # Database Performance
      - title: "Database Query Time"
        type: timeseries
        gridPos: {h: 6, w: 12, x: 12, y: 12}
        targets:
          - expr: 'histogram_quantile(0.95, rate(pg_query_duration_seconds_bucket[5m]))'
            legendFormat: "PostgreSQL p95"
```

### Performance Alerts

```yaml
# performance_alerts.yaml
# Performance-focused alerting rules

groups:
  - name: pam_performance
    rules:
      - alert: HighPVWALatency
        expr: histogram_quantile(0.95, rate(pvwa_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "PVWA p95 latency exceeds 1 second"
          runbook: "https://wiki/runbooks/pvwa-latency"

      - alert: HighConjurLatency
        expr: histogram_quantile(0.95, rate(conjur_request_duration_seconds_bucket[5m])) > 0.2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Conjur p95 latency exceeds 200ms"

      - alert: CPMQueueBacklog
        expr: cpm_queue_pending > 500
        for: 15m
        labels:
          severity: warning
        annotations:
          summary: "CPM queue backlog exceeds 500 operations"

      - alert: LowThroughput
        expr: rate(conjur_requests_total[5m]) < 100
        for: 10m
        labels:
          severity: info
        annotations:
          summary: "Conjur throughput below expected baseline"

      - alert: HighErrorRate
        expr: rate(pvwa_errors_total[5m]) / rate(pvwa_requests_total[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "PVWA error rate exceeds 5%"

      - alert: DatabaseConnectionPoolExhausted
        expr: conjur_db_pool_active / conjur_db_pool_size > 0.9
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Database connection pool > 90% utilized"
```

---

## Troubleshooting Performance Issues

### Performance Troubleshooting Decision Tree

```
┌─────────────────────────────────────────────────────────────────────────┐
│              Performance Troubleshooting Decision Tree                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Symptom: Slow Response Times                                           │
│  │                                                                      │
│  ├── Is CPU > 80%?                                                     │
│  │   ├── YES → Check for:                                              │
│  │   │         • Long-running queries                                  │
│  │   │         • Inefficient code paths                                │
│  │   │         • Need for horizontal scaling                           │
│  │   │                                                                  │
│  │   └── NO → Check Memory                                             │
│  │                                                                      │
│  ├── Is Memory > 85%?                                                  │
│  │   ├── YES → Check for:                                              │
│  │   │         • Memory leaks                                          │
│  │   │         • Cache size configuration                              │
│  │   │         • GC tuning needed                                      │
│  │   │                                                                  │
│  │   └── NO → Check Disk I/O                                           │
│  │                                                                      │
│  ├── Is Disk I/O saturated?                                            │
│  │   ├── YES → Check for:                                              │
│  │   │         • Index fragmentation                                   │
│  │   │         • Log file growth                                       │
│  │   │         • Storage upgrade needed                                │
│  │   │                                                                  │
│  │   └── NO → Check Network                                            │
│  │                                                                      │
│  └── Is Network latency high?                                          │
│      ├── YES → Check for:                                              │
│      │         • Packet loss                                           │
│      │         • Bandwidth saturation                                  │
│      │         • Firewall inspection delays                            │
│      │                                                                  │
│      └── NO → Check Application                                        │
│              • Query optimization                                       │
│              • Connection pool settings                                │
│              • Cache configuration                                     │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Common Performance Issues

```yaml
# performance_issues.yaml
# Common issues and resolutions

issues:
  - problem: "Slow PVWA page loads"
    symptoms:
      - Page load > 5 seconds
      - High IIS queue length
    causes:
      - Large result sets
      - Missing indexes
      - Session state issues
    solutions:
      - Enable pagination
      - Add database indexes
      - Configure output caching
      - Increase app pool worker processes

  - problem: "CPM queue backlog"
    symptoms:
      - Pending operations > 500
      - Rotation SLA breaches
    causes:
      - Slow target systems
      - Network connectivity issues
      - Insufficient CPM workers
    solutions:
      - Increase parallel threads
      - Add CPM instances
      - Optimize platform timeouts
      - Check target system health

  - problem: "Conjur high latency"
    symptoms:
      - p95 > 200ms
      - Increased error rates
    causes:
      - Database connection exhaustion
      - Follower replication lag
      - Memory pressure
    solutions:
      - Increase connection pool
      - Add follower replicas
      - Enable secret caching
      - Scale horizontally

  - problem: "Vault login slowness"
    symptoms:
      - Login > 2 seconds
      - Connection timeouts
    causes:
      - LDAP/AD latency
      - License validation
      - Safe enumeration
    solutions:
      - Cache AD queries
      - Optimize safe permissions
      - Review user policies
```

### Performance Analysis Scripts

```powershell
# Analyze-PAMPerformance.ps1
# Comprehensive performance analysis

param(
    [string]$Component = "All",  # Vault, PVWA, CPM, Conjur, All
    [int]$DurationMinutes = 5
)

function Analyze-Vault {
    Write-Host "=== Vault Performance Analysis ===" -ForegroundColor Cyan

    # Process metrics
    $vaultProcess = Get-Process -Name "PrivateArk*" -ErrorAction SilentlyContinue

    if ($vaultProcess) {
        Write-Host "CPU: $([math]::Round($vaultProcess.CPU, 2))%"
        Write-Host "Memory: $([math]::Round($vaultProcess.WorkingSet64/1GB, 2)) GB"
        Write-Host "Handles: $($vaultProcess.HandleCount)"
        Write-Host "Threads: $($vaultProcess.Threads.Count)"
    }

    # Disk I/O
    $diskCounters = Get-Counter '\PhysicalDisk(*)\*' -SampleInterval 1 -MaxSamples 5
    $avgReadTime = ($diskCounters.CounterSamples |
        Where-Object {$_.Path -like "*avg*read*"} |
        Measure-Object -Property CookedValue -Average).Average

    Write-Host "Avg Disk Read Time: $([math]::Round($avgReadTime, 2)) ms"

    # Connection count
    $connections = Get-NetTCPConnection -LocalPort 1858 -State Established
    Write-Host "Active Connections: $($connections.Count)"
}

function Analyze-PVWA {
    Write-Host "`n=== PVWA Performance Analysis ===" -ForegroundColor Cyan

    # IIS metrics
    $w3wpProcess = Get-Process -Name "w3wp" -ErrorAction SilentlyContinue

    foreach ($proc in $w3wpProcess) {
        Write-Host "W3WP PID $($proc.Id):"
        Write-Host "  CPU: $([math]::Round($proc.CPU, 2))%"
        Write-Host "  Memory: $([math]::Round($proc.WorkingSet64/1MB, 0)) MB"
    }

    # Response time test
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = Invoke-WebRequest -Uri "https://localhost/PasswordVault/api/Health" `
        -UseBasicParsing -TimeoutSec 30
    $stopwatch.Stop()

    Write-Host "Health check response: $($stopwatch.ElapsedMilliseconds) ms"
}

function Analyze-CPM {
    Write-Host "`n=== CPM Performance Analysis ===" -ForegroundColor Cyan

    # Queue depth
    $pendingRotations = (Get-Content "C:\CPM\Logs\pm.log" |
        Select-String "Pending" | Select-Object -Last 1).ToString()

    Write-Host "Queue Status: $pendingRotations"

    # Rotation rate
    $rotations = Get-Content "C:\CPM\Logs\pm.log" -Tail 1000 |
        Select-String "Password changed successfully" |
        Measure-Object

    Write-Host "Recent Successful Rotations: $($rotations.Count)"
}

# Main execution
switch ($Component) {
    "Vault" { Analyze-Vault }
    "PVWA" { Analyze-PVWA }
    "CPM" { Analyze-CPM }
    "All" {
        Analyze-Vault
        Analyze-PVWA
        Analyze-CPM
    }
}

Write-Host "`nAnalysis complete" -ForegroundColor Green
```

---

## Related Documents

- [HA_DR_ARCHITECTURE.md](HA_DR_ARCHITECTURE.md) - High availability architecture
- [MULTICLOUD_PATTERNS.md](MULTICLOUD_PATTERNS.md) - Multi-cloud deployment
- [PAM_INCIDENT_RESPONSE.md](PAM_INCIDENT_RESPONSE.md) - Incident response
- [KUBERNETES_MULTICLUSTER_GUIDE.md](KUBERNETES_MULTICLUSTER_GUIDE.md) - K8s performance

## External References

- [CyberArk Performance Guide](https://docs.cyberark.com/pam)
- [Conjur Performance Tuning](https://docs.conjur.org/Latest/en/Content/Operations/Scaling/scaling.htm)
- [PostgreSQL Performance Tuning](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [IIS Performance Tuning](https://docs.microsoft.com/en-us/iis/manage/managing-performance-settings)

---

*Last Updated: 2025-12-04*
*Version: 1.0*
