# Kubernetes Multi-Cluster Architecture Guide

Comprehensive guide for managing PAM and Conjur across multiple Kubernetes clusters, including federation, secrets synchronization, and multi-cluster security patterns.

---

## Table of Contents

1. [Multi-Cluster Overview](#multi-cluster-overview)
2. [Architecture Patterns](#architecture-patterns)
3. [Cluster Federation](#cluster-federation)
4. [Conjur Multi-Cluster Deployment](#conjur-multi-cluster-deployment)
5. [Secrets Synchronization](#secrets-synchronization)
6. [Network Security](#network-security)
7. [Identity and Access Management](#identity-and-access-management)
8. [Disaster Recovery](#disaster-recovery)
9. [Monitoring and Observability](#monitoring-and-observability)
10. [Best Practices](#best-practices)

---

## Multi-Cluster Overview

### Why Multi-Cluster?

Organizations adopt multi-cluster Kubernetes architectures for:

| Driver | Description | Example |
|--------|-------------|---------|
| **High Availability** | Survive cluster/region failures | Active-active across regions |
| **Compliance** | Data residency requirements | EU data in EU cluster |
| **Isolation** | Separate environments/tenants | Dev, staging, prod clusters |
| **Scale** | Exceed single cluster limits | 5000+ nodes need multiple clusters |
| **Multi-Cloud** | Avoid vendor lock-in | EKS + AKS + GKE |
| **Edge** | Workloads close to users | Regional edge clusters |

### Multi-Cluster Challenges

```
┌─────────────────────────────────────────────────────────────────┐
│                Multi-Cluster Challenges                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ Secrets     │  │ Identity    │  │ Network     │             │
│  │ Management  │  │ Federation  │  │ Connectivity│             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│         │               │               │                       │
│         ▼               ▼               ▼                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ How to sync │  │ How to      │  │ How to      │             │
│  │ secrets     │  │ authenticate│  │ connect     │             │
│  │ across      │  │ across      │  │ clusters    │             │
│  │ clusters?   │  │ clusters?   │  │ securely?   │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ Policy      │  │ Disaster    │  │ Observa-    │             │
│  │ Consistency │  │ Recovery    │  │ bility      │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Architecture Patterns

### Pattern 1: Hub and Spoke

Central management cluster with satellite workload clusters.

```
                    ┌─────────────────┐
                    │   Hub Cluster   │
                    │   (Management)  │
                    │                 │
                    │ ┌─────────────┐ │
                    │ │   Conjur    │ │
                    │ │   Primary   │ │
                    │ └─────────────┘ │
                    │ ┌─────────────┐ │
                    │ │   ArgoCD    │ │
                    │ └─────────────┘ │
                    └────────┬────────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
           ▼                 ▼                 ▼
    ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
    │   Spoke 1   │   │   Spoke 2   │   │   Spoke 3   │
    │   (Dev)     │   │  (Staging)  │   │   (Prod)    │
    │             │   │             │   │             │
    │ ┌─────────┐ │   │ ┌─────────┐ │   │ ┌─────────┐ │
    │ │ Conjur  │ │   │ │ Conjur  │ │   │ │ Conjur  │ │
    │ │Follower │ │   │ │Follower │ │   │ │Follower │ │
    │ └─────────┘ │   │ └─────────┘ │   │ └─────────┘ │
    └─────────────┘   └─────────────┘   └─────────────┘
```

**Use Cases**:
- Centralized management
- Clear separation of concerns
- Controlled deployments

**Implementation**:
```yaml
# Hub cluster - Conjur primary
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: conjur-primary
  namespace: conjur-system
spec:
  replicas: 1
  serviceName: conjur-primary
  selector:
    matchLabels:
      app: conjur-primary
  template:
    metadata:
      labels:
        app: conjur-primary
    spec:
      containers:
      - name: conjur
        image: cyberark/conjur:latest
        env:
        - name: CONJUR_ROLE
          value: "master"
        - name: CONJUR_AUTHENTICATORS
          value: "authn,authn-k8s/hub,authn-k8s/spoke1,authn-k8s/spoke2,authn-k8s/spoke3"
```

### Pattern 2: Federated (Peer-to-Peer)

Multiple independent clusters with federated identity and secrets.

```
    ┌─────────────────┐     ┌─────────────────┐
    │   Cluster 1     │     │   Cluster 2     │
    │   (US-East)     │◄───►│   (US-West)     │
    │                 │     │                 │
    │ ┌─────────────┐ │     │ ┌─────────────┐ │
    │ │   Conjur    │ │     │ │   Conjur    │ │
    │ │  Instance   │ │     │ │  Instance   │ │
    │ └─────────────┘ │     │ └─────────────┘ │
    └────────┬────────┘     └────────┬────────┘
             │                       │
             │    ┌─────────────┐    │
             └───►│   Secrets   │◄───┘
                  │    Sync     │
                  └─────────────┘
                         │
             ┌───────────┴───────────┐
             ▼                       ▼
    ┌─────────────────┐     ┌─────────────────┐
    │   Cluster 3     │     │   Cluster 4     │
    │   (EU-West)     │     │   (AP-East)     │
    └─────────────────┘     └─────────────────┘
```

**Use Cases**:
- Geographic distribution
- Regulatory compliance (data residency)
- High availability without single point of failure

### Pattern 3: Active-Passive

Primary cluster with standby for disaster recovery.

```
    ┌─────────────────────┐         ┌─────────────────────┐
    │   Primary Cluster   │         │   Standby Cluster   │
    │      (Active)       │         │     (Passive)       │
    │                     │  Sync   │                     │
    │ ┌─────────────────┐ │ ─────►  │ ┌─────────────────┐ │
    │ │ Conjur Primary  │ │         │ │ Conjur Standby  │ │
    │ │                 │ │         │ │   (Read-Only)   │ │
    │ └─────────────────┘ │         │ └─────────────────┘ │
    │                     │         │                     │
    │ ┌─────────────────┐ │         │ ┌─────────────────┐ │
    │ │   Workloads     │ │         │ │   Workloads     │ │
    │ │    (Active)     │ │         │ │   (Standby)     │ │
    │ └─────────────────┘ │         │ └─────────────────┘ │
    └─────────────────────┘         └─────────────────────┘
              │                               │
              ▼                               ▼
         ┌─────────┐                    ┌─────────┐
         │ Traffic │ ──── Failover ───► │ Traffic │
         └─────────┘                    └─────────┘
```

**Use Cases**:
- Disaster recovery
- Maintenance windows
- Cost-effective HA

---

## Cluster Federation

### Kubernetes Federation v2 (KubeFed)

```bash
# Install KubeFed
helm repo add kubefed https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
helm install kubefed kubefed/kubefed --namespace kube-federation-system --create-namespace

# Join clusters to federation
kubefedctl join cluster1 --host-cluster-context=cluster1 --v=2
kubefedctl join cluster2 --host-cluster-context=cluster1 --cluster-context=cluster2 --v=2
kubefedctl join cluster3 --host-cluster-context=cluster1 --cluster-context=cluster3 --v=2

# Verify federation
kubectl get kubefedclusters -n kube-federation-system
```

### Federated Resources

```yaml
# FederatedNamespace - propagates to all clusters
apiVersion: types.kubefed.io/v1beta1
kind: FederatedNamespace
metadata:
  name: conjur-system
  namespace: conjur-system
spec:
  placement:
    clusters:
    - name: cluster1
    - name: cluster2
    - name: cluster3
---
# FederatedSecret - sync secrets across clusters
apiVersion: types.kubefed.io/v1beta1
kind: FederatedSecret
metadata:
  name: conjur-data-key
  namespace: conjur-system
spec:
  template:
    data:
      key: <base64-encoded-key>
  placement:
    clusters:
    - name: cluster1
    - name: cluster2
    - name: cluster3
  overrides:
  - clusterName: cluster3
    clusterOverrides:
    - path: "/data/key"
      value: <different-key-for-cluster3>
```

### Multi-Cluster Service Discovery

```yaml
# Using Submariner for cross-cluster service discovery
apiVersion: multicluster.x-k8s.io/v1alpha1
kind: ServiceExport
metadata:
  name: conjur
  namespace: conjur-system
---
# Import service in other clusters
apiVersion: multicluster.x-k8s.io/v1alpha1
kind: ServiceImport
metadata:
  name: conjur
  namespace: conjur-system
spec:
  type: ClusterSetIP
  ports:
  - port: 443
    protocol: TCP
```

---

## Conjur Multi-Cluster Deployment

### Hub Cluster Configuration

```yaml
# conjur-primary.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: conjur-system
---
apiVersion: v1
kind: Secret
metadata:
  name: conjur-data-key
  namespace: conjur-system
type: Opaque
data:
  key: <base64-encoded-data-key>
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: conjur-primary
  namespace: conjur-system
spec:
  serviceName: conjur-primary
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
    spec:
      containers:
      - name: conjur
        image: cyberark/conjur:latest
        command: ["conjurctl", "server"]
        env:
        - name: DATABASE_URL
          value: "postgres://postgres@conjur-postgres:5432/conjur"
        - name: CONJUR_DATA_KEY
          valueFrom:
            secretKeyRef:
              name: conjur-data-key
              key: key
        - name: CONJUR_AUTHENTICATORS
          value: "authn,authn-k8s/hub,authn-k8s/spoke-dev,authn-k8s/spoke-staging,authn-k8s/spoke-prod"
        - name: CONJUR_ACCOUNT
          value: "myorg"
        ports:
        - containerPort: 80
          name: http
        - containerPort: 443
          name: https
        volumeMounts:
        - name: conjur-ssl
          mountPath: /opt/conjur/etc/ssl
      volumes:
      - name: conjur-ssl
        secret:
          secretName: conjur-ssl-cert
---
apiVersion: v1
kind: Service
metadata:
  name: conjur
  namespace: conjur-system
spec:
  type: LoadBalancer
  selector:
    app: conjur
    role: primary
  ports:
  - name: https
    port: 443
    targetPort: 443
```

### Spoke Cluster Configuration

```yaml
# conjur-follower.yaml (deploy in each spoke cluster)
apiVersion: v1
kind: Namespace
metadata:
  name: conjur-system
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: conjur-config
  namespace: conjur-system
data:
  CONJUR_MASTER_URL: "https://conjur.hub-cluster.example.com"
  CONJUR_ACCOUNT: "myorg"
  CONJUR_AUTHENTICATOR_ID: "spoke-dev"  # Unique per spoke
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: conjur-follower
  namespace: conjur-system
spec:
  replicas: 2
  selector:
    matchLabels:
      app: conjur
      role: follower
  template:
    metadata:
      labels:
        app: conjur
        role: follower
    spec:
      initContainers:
      - name: seed-fetcher
        image: cyberark/conjur-seed-fetcher:latest
        env:
        - name: MASTER_URL
          valueFrom:
            configMapKeyRef:
              name: conjur-config
              key: CONJUR_MASTER_URL
        - name: CONJUR_ACCOUNT
          valueFrom:
            configMapKeyRef:
              name: conjur-config
              key: CONJUR_ACCOUNT
        volumeMounts:
        - name: seed
          mountPath: /seed
      containers:
      - name: conjur
        image: cyberark/conjur:latest
        command: ["conjurctl", "server", "-f"]  # Follower mode
        env:
        - name: CONJUR_DATA_KEY
          valueFrom:
            secretKeyRef:
              name: conjur-data-key
              key: key
        - name: CONJUR_AUTHENTICATORS
          valueFrom:
            configMapKeyRef:
              name: conjur-config
              key: CONJUR_AUTHENTICATOR_ID
        ports:
        - containerPort: 443
          name: https
        volumeMounts:
        - name: seed
          mountPath: /opt/conjur/seed
      volumes:
      - name: seed
        emptyDir:
          medium: Memory
---
apiVersion: v1
kind: Service
metadata:
  name: conjur
  namespace: conjur-system
spec:
  selector:
    app: conjur
    role: follower
  ports:
  - name: https
    port: 443
    targetPort: 443
```

### Multi-Cluster Authenticator Policy

```yaml
# conjur-policy-multicluster.yml
# Policy for multi-cluster Kubernetes authentication

# Hub cluster authenticator
- !policy
  id: conjur/authn-k8s/hub
  body:
    - !webservice
    - !variable ca/key
    - !variable ca/cert
    - !group apps
    - !permit
      role: !group apps
      privilege: [ authenticate ]
      resource: !webservice

# Spoke cluster authenticators
- !policy
  id: conjur/authn-k8s/spoke-dev
  body:
    - !webservice
    - !variable ca/key
    - !variable ca/cert
    - !group apps
    - !permit
      role: !group apps
      privilege: [ authenticate ]
      resource: !webservice

- !policy
  id: conjur/authn-k8s/spoke-staging
  body:
    - !webservice
    - !variable ca/key
    - !variable ca/cert
    - !group apps
    - !permit
      role: !group apps
      privilege: [ authenticate ]
      resource: !webservice

- !policy
  id: conjur/authn-k8s/spoke-prod
  body:
    - !webservice
    - !variable ca/key
    - !variable ca/cert
    - !group apps
    - !permit
      role: !group apps
      privilege: [ authenticate ]
      resource: !webservice

# Application hosts per cluster
- !policy
  id: apps
  body:
    # Hub cluster apps
    - !host
      id: hub/monitoring/prometheus
      annotations:
        authn-k8s/namespace: monitoring
        authn-k8s/service-account: prometheus
        authn-k8s/authentication-container-name: authenticator

    # Dev cluster apps
    - !host
      id: dev/default/myapp
      annotations:
        authn-k8s/namespace: default
        authn-k8s/service-account: myapp-sa
        authn-k8s/authentication-container-name: authenticator

    # Staging cluster apps
    - !host
      id: staging/default/myapp
      annotations:
        authn-k8s/namespace: default
        authn-k8s/service-account: myapp-sa
        authn-k8s/authentication-container-name: authenticator

    # Production cluster apps
    - !host
      id: prod/default/myapp
      annotations:
        authn-k8s/namespace: default
        authn-k8s/service-account: myapp-sa
        authn-k8s/authentication-container-name: authenticator

    # Grant authentication permissions
    - !grant
      role: !group /conjur/authn-k8s/hub/apps
      member: !host hub/monitoring/prometheus

    - !grant
      role: !group /conjur/authn-k8s/spoke-dev/apps
      member: !host dev/default/myapp

    - !grant
      role: !group /conjur/authn-k8s/spoke-staging/apps
      member: !host staging/default/myapp

    - !grant
      role: !group /conjur/authn-k8s/spoke-prod/apps
      member: !host prod/default/myapp
```

---

## Secrets Synchronization

### External Secrets Operator

```bash
# Install External Secrets Operator
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets \
  -n external-secrets --create-namespace
```

```yaml
# ClusterSecretStore pointing to Conjur
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: conjur-store
spec:
  provider:
    conjur:
      url: https://conjur.hub-cluster.example.com
      account: myorg
      auth:
        apikey:
          account: myorg
          userRef:
            name: conjur-credentials
            namespace: external-secrets
            key: hostid
          apiKeyRef:
            name: conjur-credentials
            namespace: external-secrets
            key: apikey
---
# ExternalSecret - syncs secrets from Conjur to K8s
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: myapp-secrets
  namespace: default
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: conjur-store
    kind: ClusterSecretStore
  target:
    name: myapp-secrets
    creationPolicy: Owner
  data:
  - secretKey: database-password
    remoteRef:
      key: apps/myapp/database/password
  - secretKey: api-key
    remoteRef:
      key: apps/myapp/api/key
```

### Replicator Pattern

```yaml
# Using kubernetes-replicator for cross-namespace sync
apiVersion: v1
kind: Secret
metadata:
  name: shared-secret
  namespace: source-namespace
  annotations:
    replicator.v1.mittwald.de/replicate-to: "target-namespace-1,target-namespace-2"
type: Opaque
data:
  password: <base64-encoded>
```

### Custom Sync Controller

```go
// Custom controller for multi-cluster secret sync
package main

import (
    "context"
    "k8s.io/client-go/kubernetes"
    "k8s.io/client-go/tools/clientcmd"
)

type MultiClusterSecretSync struct {
    sourceClient *kubernetes.Clientset
    targetClients map[string]*kubernetes.Clientset
}

func (s *MultiClusterSecretSync) SyncSecret(namespace, name string) error {
    // Get secret from source cluster
    secret, err := s.sourceClient.CoreV1().Secrets(namespace).Get(
        context.Background(), name, metav1.GetOptions{})
    if err != nil {
        return err
    }

    // Sync to all target clusters
    for clusterName, client := range s.targetClients {
        _, err := client.CoreV1().Secrets(namespace).Update(
            context.Background(), secret, metav1.UpdateOptions{})
        if err != nil {
            log.Printf("Failed to sync to %s: %v", clusterName, err)
        }
    }
    return nil
}
```

---

## Network Security

### Cross-Cluster Network Policies

```yaml
# Allow traffic from specific clusters only
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-conjur-from-spokes
  namespace: conjur-system
spec:
  podSelector:
    matchLabels:
      app: conjur
  policyTypes:
  - Ingress
  ingress:
  - from:
    # Spoke cluster CIDRs
    - ipBlock:
        cidr: 10.1.0.0/16  # Spoke 1
    - ipBlock:
        cidr: 10.2.0.0/16  # Spoke 2
    - ipBlock:
        cidr: 10.3.0.0/16  # Spoke 3
    ports:
    - protocol: TCP
      port: 443
```

### Service Mesh (Istio) Multi-Cluster

```yaml
# Istio multi-cluster configuration
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  name: istio-multicluster
spec:
  profile: default
  values:
    global:
      meshID: mesh1
      multiCluster:
        clusterName: cluster1
      network: network1
  components:
    ingressGateways:
    - name: istio-eastwestgateway
      label:
        istio: eastwestgateway
      enabled: true
      k8s:
        env:
        - name: ISTIO_META_ROUTER_MODE
          value: sni-dnat
---
# Cross-cluster service entry
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: conjur-cluster2
  namespace: conjur-system
spec:
  hosts:
  - conjur.conjur-system.svc.cluster2.global
  location: MESH_INTERNAL
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  resolution: DNS
  endpoints:
  - address: <cluster2-eastwest-gateway-ip>
    ports:
      https: 15443
```

### mTLS Between Clusters

```yaml
# Certificate for cluster-to-cluster communication
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cluster-mtls-cert
  namespace: conjur-system
spec:
  secretName: cluster-mtls-tls
  duration: 8760h  # 1 year
  renewBefore: 720h  # 30 days
  issuerRef:
    name: cluster-ca-issuer
    kind: ClusterIssuer
  commonName: conjur.cluster1.example.com
  dnsNames:
  - conjur.cluster1.example.com
  - conjur.conjur-system.svc.cluster.local
  usages:
  - server auth
  - client auth
```

---

## Identity and Access Management

### Cross-Cluster RBAC

```yaml
# ClusterRole for multi-cluster management
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: multi-cluster-admin
rules:
- apiGroups: [""]
  resources: ["secrets", "configmaps"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
- apiGroups: [""]
  resources: ["namespaces"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
---
# Federated ClusterRoleBinding
apiVersion: types.kubefed.io/v1beta1
kind: FederatedClusterRoleBinding
metadata:
  name: multi-cluster-admin-binding
  namespace: kube-federation-system
spec:
  template:
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: multi-cluster-admin
    subjects:
    - kind: ServiceAccount
      name: cluster-admin-sa
      namespace: kube-system
  placement:
    clusters:
    - name: cluster1
    - name: cluster2
    - name: cluster3
```

### Workload Identity Federation

```yaml
# AWS EKS IRSA for cross-account access
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cross-account-sa
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::TARGET_ACCOUNT:role/CrossAccountRole
---
# Azure Workload Identity
apiVersion: v1
kind: ServiceAccount
metadata:
  name: azure-workload-sa
  namespace: default
  annotations:
    azure.workload.identity/client-id: <AZURE_CLIENT_ID>
  labels:
    azure.workload.identity/use: "true"
```

---

## Disaster Recovery

### Backup Strategy

```bash
#!/bin/bash
# Multi-cluster backup script

CLUSTERS=("cluster1" "cluster2" "cluster3")
BACKUP_DIR="/backup/$(date +%Y%m%d)"

for cluster in "${CLUSTERS[@]}"; do
    echo "Backing up $cluster..."

    # Switch context
    kubectl config use-context $cluster

    # Backup Conjur data
    kubectl exec -n conjur-system conjur-0 -- conjurctl backup > "$BACKUP_DIR/$cluster-conjur.tar"

    # Backup secrets
    kubectl get secrets -A -o yaml > "$BACKUP_DIR/$cluster-secrets.yaml"

    # Backup configmaps
    kubectl get configmaps -A -o yaml > "$BACKUP_DIR/$cluster-configmaps.yaml"

    echo "Backup complete for $cluster"
done

# Encrypt and upload to S3
tar czf - "$BACKUP_DIR" | gpg -c > "$BACKUP_DIR.tar.gz.gpg"
aws s3 cp "$BACKUP_DIR.tar.gz.gpg" s3://backups/kubernetes/
```

### Failover Procedure

```yaml
# ArgoCD ApplicationSet for multi-cluster failover
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: myapp-multicluster
  namespace: argocd
spec:
  generators:
  - clusters:
      selector:
        matchLabels:
          environment: production
  template:
    metadata:
      name: 'myapp-{{name}}'
    spec:
      project: default
      source:
        repoURL: https://github.com/org/myapp
        targetRevision: HEAD
        path: k8s/overlays/{{metadata.labels.region}}
      destination:
        server: '{{server}}'
        namespace: myapp
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
```

### Recovery Runbook

```markdown
# Multi-Cluster Failover Runbook

## Prerequisites
- [ ] Backup verified within last 24 hours
- [ ] Secondary cluster healthy
- [ ] DNS TTL < 5 minutes

## Failover Steps

### 1. Verify Primary Cluster Failure
```bash
kubectl --context=primary get nodes
kubectl --context=primary get pods -n conjur-system
```

### 2. Promote Secondary Conjur
```bash
kubectl --context=secondary exec -n conjur-system conjur-0 -- \
  conjurctl standby promote
```

### 3. Update DNS
```bash
aws route53 change-resource-record-sets \
  --hosted-zone-id ZONE_ID \
  --change-batch file://dns-failover.json
```

### 4. Verify Applications
```bash
kubectl --context=secondary get pods -A
curl -k https://app.example.com/health
```

### 5. Notify Stakeholders
- Send notification to #ops-alerts
- Update status page
```

---

## Monitoring and Observability

### Prometheus Federation

```yaml
# prometheus-federation.yaml
global:
  scrape_interval: 15s

scrape_configs:
  # Federate from spoke clusters
  - job_name: 'federate-spoke1'
    honor_labels: true
    metrics_path: '/federate'
    params:
      'match[]':
        - '{job="conjur"}'
        - '{job="kubernetes-pods"}'
    static_configs:
      - targets:
        - 'prometheus.spoke1.example.com:9090'
    relabel_configs:
      - source_labels: [__address__]
        target_label: cluster
        replacement: spoke1

  - job_name: 'federate-spoke2'
    honor_labels: true
    metrics_path: '/federate'
    params:
      'match[]':
        - '{job="conjur"}'
    static_configs:
      - targets:
        - 'prometheus.spoke2.example.com:9090'
    relabel_configs:
      - source_labels: [__address__]
        target_label: cluster
        replacement: spoke2
```

### Multi-Cluster Dashboards

```yaml
# Grafana dashboard for multi-cluster view
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboard-multicluster
  namespace: monitoring
data:
  multicluster.json: |
    {
      "title": "Multi-Cluster Overview",
      "panels": [
        {
          "title": "Conjur Requests by Cluster",
          "type": "graph",
          "targets": [
            {
              "expr": "sum(rate(conjur_http_requests_total[5m])) by (cluster)",
              "legendFormat": "{{cluster}}"
            }
          ]
        },
        {
          "title": "Secret Access by Cluster",
          "type": "graph",
          "targets": [
            {
              "expr": "sum(rate(conjur_secret_access_total[5m])) by (cluster)",
              "legendFormat": "{{cluster}}"
            }
          ]
        }
      ]
    }
```

### Centralized Logging

```yaml
# Fluent Bit configuration for multi-cluster logging
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-config
  namespace: logging
data:
  fluent-bit.conf: |
    [SERVICE]
        Parsers_File parsers.conf

    [INPUT]
        Name tail
        Path /var/log/containers/conjur*.log
        Parser docker
        Tag conjur.*
        Mem_Buf_Limit 5MB

    [FILTER]
        Name record_modifier
        Match *
        Record cluster ${CLUSTER_NAME}
        Record region ${CLUSTER_REGION}

    [OUTPUT]
        Name es
        Match *
        Host elasticsearch.logging.svc.cluster.local
        Port 9200
        Index conjur-logs
        Type _doc
```

---

## Best Practices

### Design Principles

1. **Minimize Cross-Cluster Dependencies**
   - Applications should function with local Conjur follower
   - Hub cluster failure shouldn't break spoke operations

2. **Consistent Policy Across Clusters**
   - Use GitOps for policy management
   - Version control all Conjur policies

3. **Network Segmentation**
   - Separate management traffic from application traffic
   - Use dedicated networks for cluster communication

4. **Secrets Locality**
   - Keep secrets close to where they're used
   - Use followers/replicas in each cluster

5. **Automated Recovery**
   - Automate failover procedures
   - Regular DR testing

### Security Checklist

- [ ] mTLS between clusters enabled
- [ ] Network policies restrict cross-cluster traffic
- [ ] Separate service accounts per cluster
- [ ] Audit logging enabled on all clusters
- [ ] Secrets encrypted at rest
- [ ] Regular secret rotation
- [ ] Backup encryption enabled

### Operational Checklist

- [ ] Monitoring covers all clusters
- [ ] Alerting configured for cross-cluster issues
- [ ] Runbooks documented for common scenarios
- [ ] DR tested quarterly
- [ ] Capacity planning across clusters

---

## Related Documents

- **Phase 1 Labs**: [HANDS_ON_LABS_PHASE1.md](HANDS_ON_LABS_PHASE1.md)
- **Phase 2 Labs**: [HANDS_ON_LABS_PHASE2.md](HANDS_ON_LABS_PHASE2.md)
- **HA/DR Architecture**: [HA_DR_ARCHITECTURE.md](HA_DR_ARCHITECTURE.md)
- **CKS Certification**: [CKS_CERTIFICATION_GUIDE.md](CKS_CERTIFICATION_GUIDE.md)

---

## External References

- [Kubernetes Multi-Cluster SIG](https://github.com/kubernetes/community/tree/master/sig-multicluster)
- [KubeFed Documentation](https://github.com/kubernetes-sigs/kubefed)
- [Submariner](https://submariner.io/)
- [Istio Multi-Cluster](https://istio.io/latest/docs/setup/install/multicluster/)
- [CyberArk Conjur Followers](https://docs.conjur.org/Latest/en/Content/Deployment/followers.htm)

---

**Last Updated**: 2025-12-04
**Version**: 1.0
