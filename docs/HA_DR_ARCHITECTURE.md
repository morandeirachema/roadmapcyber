# High Availability and Disaster Recovery Architecture Guide

Comprehensive guide for designing and implementing HA/DR solutions for CyberArk PAM and Conjur environments.

---

## Table of Contents

1. [HA/DR Fundamentals](#hadr-fundamentals)
2. [CyberArk PAM HA Architecture](#cyberark-pam-ha-architecture)
3. [Conjur HA Architecture](#conjur-ha-architecture)
4. [Database HA](#database-ha)
5. [Disaster Recovery Strategies](#disaster-recovery-strategies)
6. [Backup and Recovery](#backup-and-recovery)
7. [Failover Procedures](#failover-procedures)
8. [Testing and Validation](#testing-and-validation)
9. [Monitoring for HA/DR](#monitoring-for-hadr)
10. [Runbooks](#runbooks)

---

## HA/DR Fundamentals

### Key Metrics

| Metric | Definition | Target |
|--------|-----------|--------|
| **RTO** (Recovery Time Objective) | Maximum acceptable downtime | < 1 hour |
| **RPO** (Recovery Point Objective) | Maximum acceptable data loss | < 15 minutes |
| **MTBF** (Mean Time Between Failures) | Average time between failures | > 8,760 hours (1 year) |
| **MTTR** (Mean Time To Repair) | Average time to restore service | < 30 minutes |

### HA vs DR

```
┌────────────────────────────────────────────────────────────────┐
│                    High Availability (HA)                       │
├────────────────────────────────────────────────────────────────┤
│  • Prevents downtime from component failures                    │
│  • Automatic failover (no human intervention)                   │
│  • Same site/region                                             │
│  • Near-zero RTO/RPO                                           │
│  • Examples: Active-Active, Active-Passive                      │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│                  Disaster Recovery (DR)                         │
├────────────────────────────────────────────────────────────────┤
│  • Recovers from site-wide failures                            │
│  • May require manual intervention                              │
│  • Different site/region                                        │
│  • RTO: minutes to hours, RPO: minutes                         │
│  • Examples: Hot site, Warm site, Cold site                     │
└────────────────────────────────────────────────────────────────┘
```

### Architecture Tiers

```
┌─────────────────────────────────────────────────────────────────┐
│                     Tier 1: Gold (Mission Critical)             │
│  RTO: < 15 min | RPO: < 5 min | Cost: $$$$                     │
│  • Active-Active across regions                                 │
│  • Synchronous replication                                      │
│  • Automatic failover                                           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     Tier 2: Silver (Business Critical)          │
│  RTO: < 1 hr | RPO: < 15 min | Cost: $$$                       │
│  • Active-Passive with hot standby                              │
│  • Asynchronous replication                                     │
│  • Semi-automatic failover                                      │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     Tier 3: Bronze (Standard)                   │
│  RTO: < 4 hr | RPO: < 1 hr | Cost: $$                          │
│  • Warm standby                                                 │
│  • Periodic backup replication                                  │
│  • Manual failover                                              │
└─────────────────────────────────────────────────────────────────┘
```

---

## CyberArk PAM HA Architecture

### Component Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                 CyberArk PAM HA Architecture                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                    Load Balancer (Active-Active)                 │
│                           │                                      │
│              ┌────────────┼────────────┐                        │
│              ▼            ▼            ▼                        │
│         ┌────────┐  ┌────────┐  ┌────────┐                     │
│         │ PVWA 1 │  │ PVWA 2 │  │ PVWA 3 │  Web Access (HA)   │
│         └────────┘  └────────┘  └────────┘                     │
│              │            │            │                        │
│              └────────────┼────────────┘                        │
│                           ▼                                      │
│         ┌────────────────────────────────┐                      │
│         │     Password Vault (HA)        │                      │
│         │  ┌────────┐    ┌────────┐     │                      │
│         │  │Primary │◄──►│Standby │     │                      │
│         │  │ Vault  │    │ Vault  │     │                      │
│         │  └────────┘    └────────┘     │                      │
│         └────────────────────────────────┘                      │
│                           │                                      │
│              ┌────────────┼────────────┐                        │
│              ▼            ▼            ▼                        │
│         ┌────────┐  ┌────────┐  ┌────────┐                     │
│         │ CPM 1  │  │ CPM 2  │  │ PSM 1  │  Components (HA)    │
│         │        │  │        │  │ PSM 2  │                      │
│         └────────┘  └────────┘  └────────┘                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Password Vault HA

**Primary-Standby Configuration**:

```
┌─────────────────┐                 ┌─────────────────┐
│  Primary Vault  │                 │  Standby Vault  │
│                 │  Replication    │                 │
│  ┌───────────┐  │ ──────────────► │  ┌───────────┐  │
│  │  SafeNet  │  │   (Automatic)   │  │  SafeNet  │  │
│  │   HSM     │  │                 │  │   HSM     │  │
│  └───────────┘  │                 │  └───────────┘  │
│                 │                 │                 │
│  ┌───────────┐  │                 │  ┌───────────┐  │
│  │   Data    │  │                 │  │   Data    │  │
│  │   Files   │  │                 │  │   Files   │  │
│  └───────────┘  │                 │  └───────────┘  │
│                 │                 │                 │
│  Active         │                 │  Passive        │
│  (Read/Write)   │                 │  (Read Only)    │
└─────────────────┘                 └─────────────────┘
        │                                   │
        └───────────┬───────────────────────┘
                    │
            ┌───────▼───────┐
            │   Cluster     │
            │   Virtual IP  │
            └───────────────┘
```

**Vault Replication Configuration**:
```ini
; dbparm.ini - Primary Vault
[Main]
ReplicationType=Primary
ReplicationInterval=5
ReplicationTimeout=30
StandbyVault=standby-vault.example.com
StandbyVaultPort=1858

; dbparm.ini - Standby Vault
[Main]
ReplicationType=Standby
PrimaryVault=primary-vault.example.com
PrimaryVaultPort=1858
```

### PVWA HA (Load Balanced)

```yaml
# PVWA Load Balancer Configuration
upstream pvwa_servers {
    least_conn;
    server pvwa1.example.com:443 weight=5;
    server pvwa2.example.com:443 weight=5;
    server pvwa3.example.com:443 weight=5;

    # Health check
    health_check interval=10s fails=3 passes=2;
}

server {
    listen 443 ssl;
    server_name pvwa.example.com;

    ssl_certificate /etc/nginx/ssl/pvwa.crt;
    ssl_certificate_key /etc/nginx/ssl/pvwa.key;

    location / {
        proxy_pass https://pvwa_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # Session stickiness for PVWA
        proxy_cookie_path / "/; SameSite=Strict; Secure";
    }

    location /health {
        proxy_pass https://pvwa_servers/PasswordVault/v10/logon;
        proxy_connect_timeout 5s;
        proxy_read_timeout 5s;
    }
}
```

### CPM HA

```
┌─────────────────────────────────────────────────────────────────┐
│                    CPM High Availability                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐                        ┌─────────────┐        │
│  │   CPM 1     │                        │   CPM 2     │        │
│  │  (Active)   │                        │  (Active)   │        │
│  │             │                        │             │        │
│  │ Manages:    │                        │ Manages:    │        │
│  │ - Safe A    │                        │ - Safe C    │        │
│  │ - Safe B    │                        │ - Safe D    │        │
│  └─────────────┘                        └─────────────┘        │
│         │                                      │                │
│         └──────────────┬───────────────────────┘                │
│                        ▼                                        │
│              ┌─────────────────┐                               │
│              │  Password Vault │                               │
│              │   (Shared)      │                               │
│              └─────────────────┘                               │
│                                                                  │
│  Note: CPMs operate Active-Active with Safe-level partitioning  │
│  If CPM 1 fails, CPM 2 can take over Safe A and B              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### PSM HA

```yaml
# PSM Load Balancer (for RDP/SSH gateway)
upstream psm_rdp {
    least_conn;
    server psm1.example.com:3389;
    server psm2.example.com:3389;
}

upstream psm_ssh {
    least_conn;
    server psm1.example.com:22;
    server psm2.example.com:22;
}

# PSM for Web (HTML5 Gateway)
upstream psmgw {
    least_conn;
    server psmgw1.example.com:443;
    server psmgw2.example.com:443;
}
```

---

## Conjur HA Architecture

### Conjur Primary-Follower Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                   Conjur HA Architecture                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                       Region 1 (Primary)                         │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                                                          │    │
│  │  ┌─────────────┐           ┌─────────────┐             │    │
│  │  │   Conjur    │           │   Conjur    │             │    │
│  │  │   Primary   │───────────│   Standby   │             │    │
│  │  │   (Master)  │  Sync     │  (Failover) │             │    │
│  │  └─────────────┘           └─────────────┘             │    │
│  │         │                         │                     │    │
│  │         └────────────┬────────────┘                     │    │
│  │                      ▼                                  │    │
│  │              ┌───────────────┐                         │    │
│  │              │  PostgreSQL   │                         │    │
│  │              │  (Primary)    │                         │    │
│  │              └───────────────┘                         │    │
│  │                      │                                  │    │
│  └──────────────────────┼──────────────────────────────────┘    │
│                         │ Replication                           │
│                         ▼                                       │
│                       Region 2 (DR)                             │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                                                          │   │
│  │  ┌─────────────┐           ┌───────────────┐           │   │
│  │  │   Conjur    │           │  PostgreSQL   │           │   │
│  │  │  Follower   │◄──────────│   Replica     │           │   │
│  │  │   (DR)      │           │               │           │   │
│  │  └─────────────┘           └───────────────┘           │   │
│  │                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│              Region 3 (Application Cluster)                     │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                                                          │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │   │
│  │  │   Conjur    │  │   Conjur    │  │   Conjur    │    │   │
│  │  │  Follower 1 │  │  Follower 2 │  │  Follower 3 │    │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘    │   │
│  │                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Kubernetes Conjur HA

```yaml
# Conjur HA StatefulSet
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: conjur
  namespace: conjur-system
spec:
  serviceName: conjur
  replicas: 3
  podManagementPolicy: Parallel
  selector:
    matchLabels:
      app: conjur
  template:
    metadata:
      labels:
        app: conjur
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - conjur
            topologyKey: kubernetes.io/hostname
      containers:
      - name: conjur
        image: cyberark/conjur:latest
        ports:
        - containerPort: 443
          name: https
        env:
        - name: CONJUR_DATA_KEY
          valueFrom:
            secretKeyRef:
              name: conjur-data-key
              key: key
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: conjur-database
              key: url
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "2000m"
        readinessProbe:
          httpGet:
            path: /health
            port: 443
            scheme: HTTPS
          initialDelaySeconds: 15
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /health
            port: 443
            scheme: HTTPS
          initialDelaySeconds: 30
          periodSeconds: 20
---
apiVersion: v1
kind: Service
metadata:
  name: conjur
  namespace: conjur-system
spec:
  selector:
    app: conjur
  ports:
  - port: 443
    targetPort: 443
  type: ClusterIP
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: conjur-pdb
  namespace: conjur-system
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: conjur
```

---

## Database HA

### PostgreSQL HA with Patroni

```yaml
# Patroni PostgreSQL HA for Conjur
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: patroni
  namespace: conjur-system
spec:
  serviceName: patroni
  replicas: 3
  selector:
    matchLabels:
      app: patroni
  template:
    metadata:
      labels:
        app: patroni
    spec:
      containers:
      - name: patroni
        image: patroni:latest
        env:
        - name: PATRONI_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: PATRONI_KUBERNETES_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: PATRONI_KUBERNETES_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: PATRONI_SUPERUSER_PASSWORD
          valueFrom:
            secretKeyRef:
              name: patroni-credentials
              key: superuser-password
        - name: PATRONI_REPLICATION_PASSWORD
          valueFrom:
            secretKeyRef:
              name: patroni-credentials
              key: replication-password
        ports:
        - containerPort: 5432
          name: postgresql
        - containerPort: 8008
          name: patroni
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
        - name: patroni-config
          mountPath: /etc/patroni
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 50Gi
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: patroni-config
  namespace: conjur-system
data:
  patroni.yml: |
    scope: conjur-postgres
    namespace: /service/
    name: ${PATRONI_NAME}

    restapi:
      listen: 0.0.0.0:8008
      connect_address: ${PATRONI_KUBERNETES_POD_IP}:8008

    etcd:
      hosts: etcd-0.etcd:2379,etcd-1.etcd:2379,etcd-2.etcd:2379

    bootstrap:
      dcs:
        ttl: 30
        loop_wait: 10
        retry_timeout: 10
        maximum_lag_on_failover: 1048576
        postgresql:
          use_pg_rewind: true
          use_slots: true
          parameters:
            max_connections: 200
            shared_buffers: 512MB
            wal_level: replica
            hot_standby: on
            max_wal_senders: 5
            max_replication_slots: 5
            wal_keep_segments: 64

      initdb:
        - encoding: UTF8
        - data-checksums

    postgresql:
      listen: 0.0.0.0:5432
      connect_address: ${PATRONI_KUBERNETES_POD_IP}:5432
      data_dir: /var/lib/postgresql/data
      authentication:
        superuser:
          username: postgres
          password: ${PATRONI_SUPERUSER_PASSWORD}
        replication:
          username: replicator
          password: ${PATRONI_REPLICATION_PASSWORD}
```

### SQL Server HA (for CyberArk)

```sql
-- SQL Server Always On Availability Group for CyberArk
-- Primary replica configuration

-- Create endpoint for database mirroring
CREATE ENDPOINT [Hadr_endpoint]
    STATE = STARTED
    AS TCP (LISTENER_PORT = 5022)
    FOR DATA_MIRRORING (
        ROLE = ALL,
        AUTHENTICATION = WINDOWS NEGOTIATE,
        ENCRYPTION = REQUIRED ALGORITHM AES
    );

-- Create Availability Group
CREATE AVAILABILITY GROUP [CyberArkAG]
    WITH (
        AUTOMATED_BACKUP_PREFERENCE = PRIMARY,
        FAILURE_CONDITION_LEVEL = 3,
        HEALTH_CHECK_TIMEOUT = 30000
    )
    FOR DATABASE [PasswordVault]
    REPLICA ON
        N'SQL-PRIMARY' WITH (
            ENDPOINT_URL = N'TCP://sql-primary.example.com:5022',
            AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
            FAILOVER_MODE = AUTOMATIC,
            SEEDING_MODE = AUTOMATIC,
            PRIMARY_ROLE(ALLOW_CONNECTIONS = ALL),
            SECONDARY_ROLE(ALLOW_CONNECTIONS = READ_ONLY)
        ),
        N'SQL-SECONDARY' WITH (
            ENDPOINT_URL = N'TCP://sql-secondary.example.com:5022',
            AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
            FAILOVER_MODE = AUTOMATIC,
            SEEDING_MODE = AUTOMATIC,
            PRIMARY_ROLE(ALLOW_CONNECTIONS = ALL),
            SECONDARY_ROLE(ALLOW_CONNECTIONS = READ_ONLY)
        );

-- Create listener
ALTER AVAILABILITY GROUP [CyberArkAG]
    ADD LISTENER N'CyberArkListener' (
        WITH IP (
            (N'10.0.1.100', N'255.255.255.0')
        ),
        PORT = 1433
    );
```

---

## Disaster Recovery Strategies

### Hot Site (RTO < 15 min)

```
Primary Site                          DR Site
┌─────────────────┐                   ┌─────────────────┐
│                 │                   │                 │
│  ┌───────────┐  │  Synchronous     │  ┌───────────┐  │
│  │  Active   │  │  Replication     │  │  Standby  │  │
│  │  Systems  │──┼─────────────────►│  │  Systems  │  │
│  └───────────┘  │                   │  └───────────┘  │
│                 │                   │                 │
│  Data: Current  │                   │  Data: Current  │
│  State: Active  │                   │  State: Hot     │
│                 │                   │  Standby        │
└─────────────────┘                   └─────────────────┘

Recovery: Automatic failover, DNS switch
```

### Warm Site (RTO < 1 hour)

```
Primary Site                          DR Site
┌─────────────────┐                   ┌─────────────────┐
│                 │                   │                 │
│  ┌───────────┐  │  Asynchronous    │  ┌───────────┐  │
│  │  Active   │  │  Replication     │  │  Standby  │  │
│  │  Systems  │──┼─────────────────►│  │  Systems  │  │
│  └───────────┘  │  (15-60 min lag) │  └───────────┘  │
│                 │                   │                 │
│  Data: Current  │                   │  Data: Near-    │
│  State: Active  │                   │  current        │
│                 │                   │  State: Warm    │
└─────────────────┘                   └─────────────────┘

Recovery: Manual promotion, some data replay needed
```

### Cold Site (RTO < 24 hours)

```
Primary Site                          DR Site
┌─────────────────┐                   ┌─────────────────┐
│                 │                   │                 │
│  ┌───────────┐  │  Daily Backup    │  ┌───────────┐  │
│  │  Active   │  │  Transfer        │  │  Powered  │  │
│  │  Systems  │──┼─────────────────►│  │   Off     │  │
│  └───────────┘  │                   │  └───────────┘  │
│                 │                   │                 │
│  Data: Current  │                   │  Data: Last     │
│  State: Active  │                   │  backup         │
│                 │                   │  State: Cold    │
└─────────────────┘                   └─────────────────┘

Recovery: Power on systems, restore from backup
```

### Multi-Region Active-Active

```yaml
# Global Load Balancer Configuration
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: conjur-global
  annotations:
    kubernetes.io/ingress.global-static-ip-name: "conjur-global-ip"
    networking.gke.io/load-balancer-type: "External"
spec:
  rules:
  - host: conjur.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: conjur-global-backend
            port:
              number: 443
---
# Route53 Health Check and Failover
# aws-route53-config.json
{
  "HealthCheckConfig": {
    "IPAddress": "primary-conjur.example.com",
    "Port": 443,
    "Type": "HTTPS",
    "ResourcePath": "/health",
    "FailureThreshold": 3,
    "RequestInterval": 10
  }
}
```

---

## Backup and Recovery

### Backup Strategy

```bash
#!/bin/bash
# comprehensive-backup.sh

BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/${BACKUP_DATE}"
S3_BUCKET="s3://pam-backups"

mkdir -p "${BACKUP_DIR}"

echo "Starting PAM backup - ${BACKUP_DATE}"

# 1. CyberArk Vault Backup
echo "Backing up CyberArk Vault..."
/opt/CyberArk/Vault/backup.sh -output "${BACKUP_DIR}/vault_backup.cab"

# 2. Conjur Backup
echo "Backing up Conjur..."
kubectl exec -n conjur-system conjur-0 -- conjurctl export > "${BACKUP_DIR}/conjur_export.tar"

# 3. PostgreSQL Backup
echo "Backing up PostgreSQL..."
kubectl exec -n conjur-system postgres-0 -- pg_dump -U postgres conjur > "${BACKUP_DIR}/conjur_db.sql"

# 4. Kubernetes Secrets Backup
echo "Backing up Kubernetes secrets..."
kubectl get secrets -n conjur-system -o yaml > "${BACKUP_DIR}/k8s_secrets.yaml"

# 5. Configuration Files
echo "Backing up configuration..."
cp -r /etc/cyberark "${BACKUP_DIR}/cyberark_config/"
cp -r /etc/conjur "${BACKUP_DIR}/conjur_config/"

# 6. Encrypt backup
echo "Encrypting backup..."
tar czf - "${BACKUP_DIR}" | gpg --symmetric --cipher-algo AES256 \
    --passphrase-file /root/.backup-key > "${BACKUP_DIR}.tar.gz.gpg"

# 7. Upload to S3
echo "Uploading to S3..."
aws s3 cp "${BACKUP_DIR}.tar.gz.gpg" "${S3_BUCKET}/${BACKUP_DATE}/"

# 8. Verify backup
echo "Verifying backup..."
aws s3 ls "${S3_BUCKET}/${BACKUP_DATE}/"

# 9. Cleanup old local backups (keep 7 days)
find /backup -type d -mtime +7 -exec rm -rf {} +

echo "Backup complete - ${BACKUP_DATE}"
```

### Recovery Procedure

```bash
#!/bin/bash
# disaster-recovery.sh

BACKUP_DATE=$1  # e.g., 20241201_120000
S3_BUCKET="s3://pam-backups"
RESTORE_DIR="/restore/${BACKUP_DATE}"

if [ -z "$BACKUP_DATE" ]; then
    echo "Usage: $0 <backup_date>"
    exit 1
fi

echo "Starting disaster recovery from ${BACKUP_DATE}"

# 1. Download backup from S3
echo "Downloading backup..."
mkdir -p "${RESTORE_DIR}"
aws s3 cp "${S3_BUCKET}/${BACKUP_DATE}/" "${RESTORE_DIR}/" --recursive

# 2. Decrypt backup
echo "Decrypting backup..."
gpg --decrypt --passphrase-file /root/.backup-key \
    "${RESTORE_DIR}/${BACKUP_DATE}.tar.gz.gpg" | tar xzf - -C "${RESTORE_DIR}"

# 3. Verify backup integrity
echo "Verifying backup integrity..."
if [ ! -f "${RESTORE_DIR}/vault_backup.cab" ]; then
    echo "ERROR: Vault backup not found"
    exit 1
fi

# 4. Restore CyberArk Vault
echo "Restoring CyberArk Vault..."
/opt/CyberArk/Vault/restore.sh -input "${RESTORE_DIR}/vault_backup.cab"

# 5. Restore PostgreSQL
echo "Restoring PostgreSQL..."
kubectl exec -n conjur-system postgres-0 -- psql -U postgres < "${RESTORE_DIR}/conjur_db.sql"

# 6. Restore Conjur
echo "Restoring Conjur..."
kubectl exec -n conjur-system conjur-0 -- conjurctl import < "${RESTORE_DIR}/conjur_export.tar"

# 7. Restore Kubernetes secrets
echo "Restoring Kubernetes secrets..."
kubectl apply -f "${RESTORE_DIR}/k8s_secrets.yaml"

# 8. Verify services
echo "Verifying services..."
kubectl get pods -n conjur-system
curl -k https://conjur.example.com/health

echo "Disaster recovery complete"
```

### Backup Verification

```yaml
# backup-verification-job.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-verification
  namespace: conjur-system
spec:
  schedule: "0 6 * * 0"  # Weekly on Sunday at 6 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: verify
            image: backup-tools:latest
            command:
            - /bin/bash
            - -c
            - |
              # Download latest backup
              LATEST=$(aws s3 ls s3://pam-backups/ --recursive | sort | tail -1 | awk '{print $4}')
              aws s3 cp "s3://pam-backups/${LATEST}" /tmp/backup.tar.gz.gpg

              # Decrypt
              gpg --decrypt --passphrase-file /secrets/backup-key /tmp/backup.tar.gz.gpg > /tmp/backup.tar.gz

              # Extract and verify
              tar tzf /tmp/backup.tar.gz || exit 1

              # Test restore to temp database
              createdb test_restore
              psql test_restore < /tmp/conjur_db.sql || exit 1
              dropdb test_restore

              echo "Backup verification successful"
            volumeMounts:
            - name: backup-key
              mountPath: /secrets
          volumes:
          - name: backup-key
            secret:
              secretName: backup-encryption-key
          restartPolicy: OnFailure
```

---

## Failover Procedures

### Automatic Failover Script

```bash
#!/bin/bash
# automatic-failover.sh

PRIMARY_HOST="primary-vault.example.com"
STANDBY_HOST="standby-vault.example.com"
HEALTH_ENDPOINT="/health"
MAX_FAILURES=3
CHECK_INTERVAL=10

failure_count=0

check_primary() {
    curl -sf "https://${PRIMARY_HOST}${HEALTH_ENDPOINT}" > /dev/null 2>&1
    return $?
}

promote_standby() {
    echo "$(date): Promoting standby to primary..."

    # Stop primary (if reachable)
    ssh ${PRIMARY_HOST} "systemctl stop cyberark-vault" 2>/dev/null

    # Promote standby
    ssh ${STANDBY_HOST} "/opt/CyberArk/Vault/promote-to-primary.sh"

    # Update DNS
    aws route53 change-resource-record-sets \
        --hosted-zone-id ZONEID \
        --change-batch file://dns-failover.json

    # Notify team
    send_alert "PAM Failover" "Standby promoted to primary due to primary failure"

    echo "$(date): Failover complete"
}

send_alert() {
    local subject=$1
    local message=$2

    # Slack notification
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"${subject}: ${message}\"}" \
        "${SLACK_WEBHOOK_URL}"

    # PagerDuty
    curl -X POST https://events.pagerduty.com/v2/enqueue \
        -H "Content-Type: application/json" \
        -d "{
            \"routing_key\": \"${PAGERDUTY_KEY}\",
            \"event_action\": \"trigger\",
            \"payload\": {
                \"summary\": \"${subject}\",
                \"severity\": \"critical\",
                \"source\": \"pam-failover\"
            }
        }"
}

# Main monitoring loop
while true; do
    if check_primary; then
        failure_count=0
    else
        ((failure_count++))
        echo "$(date): Primary check failed (${failure_count}/${MAX_FAILURES})"

        if [ $failure_count -ge $MAX_FAILURES ]; then
            promote_standby
            exit 0
        fi
    fi

    sleep $CHECK_INTERVAL
done
```

### Manual Failover Runbook

```markdown
# PAM Failover Runbook

## Pre-Failover Checklist
- [ ] Confirm primary is truly unavailable (not network issue)
- [ ] Verify standby is healthy
- [ ] Notify stakeholders
- [ ] Document incident start time

## Failover Steps

### Step 1: Stop Primary (if accessible)
```bash
ssh primary-vault.example.com
systemctl stop PrivateArk
systemctl stop cyberark-vault
```

### Step 2: Verify Standby Readiness
```bash
ssh standby-vault.example.com
/opt/CyberArk/Vault/tools/CheckVaultStatus.sh
# Confirm replication is caught up
```

### Step 3: Promote Standby
```bash
ssh standby-vault.example.com
/opt/CyberArk/Vault/tools/PromoteStandby.sh
# Follow prompts
```

### Step 4: Update Load Balancer
```bash
# AWS ALB
aws elbv2 modify-target-group \
  --target-group-arn <tg-arn> \
  --targets Id=<standby-instance-id>

# Or update DNS
aws route53 change-resource-record-sets \
  --hosted-zone-id ZONEID \
  --change-batch file://failover-dns.json
```

### Step 5: Verify Services
```bash
# Test PVWA
curl -k https://pvwa.example.com/PasswordVault/v10/logon

# Test CPM
ssh cpm.example.com "systemctl status cyberark-cpm"

# Test PSM
ssh psm.example.com "systemctl status cyberark-psm"
```

### Step 6: Notify Applications
- Update application configurations if needed
- Restart applications using PAM

## Post-Failover
- [ ] Document incident
- [ ] Plan primary restoration
- [ ] Review failover performance
```

---

## Testing and Validation

### DR Test Plan

```yaml
# DR Test Checklist
dr_test:
  frequency: Quarterly
  duration: 4 hours
  participants:
    - PAM Administrator
    - DBA
    - Network Engineer
    - Application Owner

  pre_test:
    - [ ] Notify stakeholders 48 hours in advance
    - [ ] Verify backup integrity
    - [ ] Confirm DR site resources available
    - [ ] Prepare rollback plan

  test_scenarios:
    - name: "Vault Failover"
      steps:
        - Simulate primary vault failure
        - Verify automatic failover
        - Confirm applications reconnect
        - Measure RTO achieved
      success_criteria:
        - RTO < 15 minutes
        - No data loss
        - All applications functional

    - name: "Database Failover"
      steps:
        - Simulate PostgreSQL primary failure
        - Verify Patroni automatic failover
        - Confirm Conjur reconnects
      success_criteria:
        - RTO < 5 minutes
        - RPO < 1 minute

    - name: "Full Site Failover"
      steps:
        - Simulate complete site outage
        - Activate DR site
        - Verify all services
        - Run integration tests
      success_criteria:
        - RTO < 1 hour
        - All critical services operational

  post_test:
    - [ ] Document results
    - [ ] Identify improvements
    - [ ] Update runbooks
    - [ ] Schedule remediation
```

### Automated DR Testing

```bash
#!/bin/bash
# automated-dr-test.sh

LOG_FILE="/var/log/dr-test-$(date +%Y%m%d).log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

test_vault_failover() {
    log "Starting Vault failover test..."

    # Record start time
    start_time=$(date +%s)

    # Simulate primary failure (stop service)
    ssh primary-vault "systemctl stop PrivateArk"
    log "Primary vault stopped"

    # Wait for failover
    sleep 30

    # Check if standby is now primary
    standby_status=$(ssh standby-vault "/opt/CyberArk/Vault/tools/CheckVaultStatus.sh | grep 'Primary'")

    if [[ $standby_status == *"Primary"* ]]; then
        end_time=$(date +%s)
        rto=$((end_time - start_time))
        log "SUCCESS: Failover completed in ${rto} seconds"
    else
        log "FAILURE: Standby did not become primary"
        return 1
    fi

    # Restore primary
    ssh primary-vault "systemctl start PrivateArk"
    log "Primary vault restored"

    return 0
}

test_database_failover() {
    log "Starting database failover test..."

    # Get current primary
    current_primary=$(kubectl exec -n conjur-system patroni-0 -- \
        patronictl list | grep Leader | awk '{print $2}')
    log "Current primary: ${current_primary}"

    # Trigger failover
    kubectl exec -n conjur-system patroni-0 -- \
        patronictl switchover --force

    sleep 15

    # Verify new primary
    new_primary=$(kubectl exec -n conjur-system patroni-0 -- \
        patronictl list | grep Leader | awk '{print $2}')

    if [[ "${current_primary}" != "${new_primary}" ]]; then
        log "SUCCESS: Database failover successful. New primary: ${new_primary}"
    else
        log "FAILURE: Database failover did not occur"
        return 1
    fi

    return 0
}

# Run tests
log "=== DR Test Started ==="

test_vault_failover
vault_result=$?

test_database_failover
db_result=$?

# Summary
log "=== DR Test Summary ==="
log "Vault Failover: $([ $vault_result -eq 0 ] && echo 'PASSED' || echo 'FAILED')"
log "Database Failover: $([ $db_result -eq 0 ] && echo 'PASSED' || echo 'FAILED')"

# Send report
mail -s "DR Test Results" operations@example.com < $LOG_FILE
```

---

## Monitoring for HA/DR

### Health Check Endpoints

```yaml
# Prometheus ServiceMonitor for HA monitoring
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: conjur-ha
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: conjur
  endpoints:
  - port: https
    path: /health
    interval: 10s
    scheme: https
    tlsConfig:
      insecureSkipVerify: true
---
# Alerting rules for HA
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: ha-alerts
  namespace: monitoring
spec:
  groups:
  - name: ha-alerts
    rules:
    - alert: ConjurReplicaDown
      expr: up{job="conjur"} == 0
      for: 1m
      labels:
        severity: critical
      annotations:
        summary: "Conjur replica down"
        description: "Conjur replica {{ $labels.instance }} is down"

    - alert: ConjurReplicationLag
      expr: conjur_replication_lag_seconds > 60
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: "Conjur replication lag"
        description: "Replication lag is {{ $value }} seconds"

    - alert: DatabaseFailover
      expr: changes(patroni_master_node[5m]) > 0
      labels:
        severity: warning
      annotations:
        summary: "Database failover occurred"
        description: "PostgreSQL master changed in the last 5 minutes"
```

### HA Dashboard

```json
{
  "dashboard": {
    "title": "PAM HA/DR Status",
    "panels": [
      {
        "title": "Vault Primary Status",
        "type": "stat",
        "targets": [
          {
            "expr": "up{job='vault-primary'}",
            "legendFormat": "Primary"
          }
        ]
      },
      {
        "title": "Vault Standby Status",
        "type": "stat",
        "targets": [
          {
            "expr": "up{job='vault-standby'}",
            "legendFormat": "Standby"
          }
        ]
      },
      {
        "title": "Replication Lag",
        "type": "graph",
        "targets": [
          {
            "expr": "conjur_replication_lag_seconds",
            "legendFormat": "{{ instance }}"
          }
        ]
      },
      {
        "title": "Database Cluster Status",
        "type": "table",
        "targets": [
          {
            "expr": "patroni_cluster_status",
            "legendFormat": "{{ node }}"
          }
        ]
      }
    ]
  }
}
```

---

## Runbooks

### Quick Reference

| Scenario | Runbook | RTO Target |
|----------|---------|------------|
| Vault Primary Failure | [Vault Failover](#vault-failover-runbook) | 15 min |
| Database Failure | [Database Failover](#database-failover-runbook) | 5 min |
| Full Site Failure | [Site Failover](#site-failover-runbook) | 1 hour |
| Conjur Follower Failure | [Follower Recovery](#follower-recovery-runbook) | 10 min |

### Vault Failover Runbook

See [Manual Failover Runbook](#manual-failover-runbook) section above.

### Database Failover Runbook

```markdown
# PostgreSQL Failover Runbook

## Automatic Failover (Patroni)
Patroni handles failover automatically. Monitor with:
```bash
kubectl exec -n conjur-system patroni-0 -- patronictl list
```

## Manual Failover (if needed)
```bash
# Check current state
kubectl exec -n conjur-system patroni-0 -- patronictl list

# Perform switchover to specific node
kubectl exec -n conjur-system patroni-0 -- \
  patronictl switchover --master patroni-0 --candidate patroni-1 --force

# Verify
kubectl exec -n conjur-system patroni-0 -- patronictl list
```

## Verify Conjur Connection
```bash
kubectl logs -n conjur-system -l app=conjur --tail=100 | grep -i database
```
```

---

## Related Documents

- **Phase 2 Labs**: [HANDS_ON_LABS_PHASE2.md](HANDS_ON_LABS_PHASE2.md)
- **Multi-Cluster Guide**: [KUBERNETES_MULTICLUSTER_GUIDE.md](KUBERNETES_MULTICLUSTER_GUIDE.md)
- **Incident Response**: [PAM_INCIDENT_RESPONSE.md](PAM_INCIDENT_RESPONSE.md)
- **Architecture Diagrams**: [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md)

---

## External References

- [CyberArk Vault HA Documentation](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/PAS%20INST/Disaster-Recovery.htm)
- [Patroni Documentation](https://patroni.readthedocs.io/)
- [PostgreSQL Replication](https://www.postgresql.org/docs/current/high-availability.html)
- [Kubernetes HA Best Practices](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/)

---

**Last Updated**: 2025-12-04
**Version**: 1.0
