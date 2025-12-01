# Hands-On Labs: Phase 1 - PAM + Kubernetes Mastery

Practical lab exercises with actual commands for Months 1-11. These labs complement the theoretical knowledge from certification guides.

**Prerequisites**:
- Linux VM (Ubuntu 22.04+ recommended) with 8GB+ RAM
- Docker installed
- kubectl installed
- Basic terminal proficiency

**Lab Environment**: See [GETTING_STARTED.md](../GETTING_STARTED.md) for initial setup.

---

## Table of Contents

1. [Lab Environment Setup](#lab-environment-setup)
2. [Kubernetes Cluster Deployment](#kubernetes-cluster-deployment)
3. [Kubernetes Security Fundamentals](#kubernetes-security-fundamentals)
4. [CyberArk PAM Lab Setup](#cyberark-pam-lab-setup)
5. [PAM + Kubernetes Integration](#pam--kubernetes-integration)
6. [Troubleshooting Commands](#troubleshooting-commands)

---

## Lab Environment Setup

### Month 1, Week 1: Infrastructure Foundation

#### Install Docker

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group (logout/login required)
sudo usermod -aG docker $USER

# Verify installation
docker --version
docker run hello-world
```

#### Install kubectl

```bash
# Download kubectl binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Verify checksum (optional but recommended)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify installation
kubectl version --client
```

#### Install Helm

```bash
# Download Helm installer
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# Install Helm
chmod 700 get_helm.sh
./get_helm.sh

# Verify installation
helm version
```

---

## Kubernetes Cluster Deployment

### Option A: Minikube (Single-Node Development)

```bash
# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start cluster with specific resources
minikube start --cpus=4 --memory=8192 --driver=docker

# Verify cluster status
minikube status
kubectl cluster-info
kubectl get nodes
```

### Option B: kind (Kubernetes in Docker - Multi-Node)

```bash
# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create multi-node cluster configuration
cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF

# Create cluster
kind create cluster --config kind-config.yaml --name pam-lab

# Verify cluster
kubectl get nodes
kubectl get pods -A
```

### Option C: k3s (Lightweight Production-Grade)

```bash
# Install k3s (single command)
curl -sfL https://get.k3s.io | sh -

# Copy kubeconfig
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

# Verify cluster
kubectl get nodes
```

---

## Kubernetes Security Fundamentals

### Lab 3.1: RBAC (Role-Based Access Control)

```bash
# Create namespace for RBAC testing
kubectl create namespace rbac-demo

# Create a ServiceAccount
kubectl create serviceaccount demo-sa -n rbac-demo

# Create a Role with limited permissions
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: rbac-demo
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get"]
EOF

# Create RoleBinding
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: rbac-demo
subjects:
- kind: ServiceAccount
  name: demo-sa
  namespace: rbac-demo
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
EOF

# Verify RBAC setup
kubectl auth can-i list pods --as=system:serviceaccount:rbac-demo:demo-sa -n rbac-demo
kubectl auth can-i delete pods --as=system:serviceaccount:rbac-demo:demo-sa -n rbac-demo
```

### Lab 3.2: Network Policies

```bash
# Create namespace with network policies
kubectl create namespace netpol-demo

# Deploy test pods
kubectl run frontend --image=nginx --labels="app=frontend" -n netpol-demo
kubectl run backend --image=nginx --labels="app=backend" -n netpol-demo
kubectl run database --image=nginx --labels="app=database" -n netpol-demo

# Wait for pods to be ready
kubectl wait --for=condition=Ready pods --all -n netpol-demo --timeout=60s

# Create default deny all ingress policy
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: netpol-demo
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF

# Allow frontend to access backend only
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: netpol-demo
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 80
EOF

# Allow backend to access database only
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-database
  namespace: netpol-demo
spec:
  podSelector:
    matchLabels:
      app: database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 80
EOF

# Verify network policies
kubectl get networkpolicies -n netpol-demo
kubectl describe networkpolicy allow-frontend-to-backend -n netpol-demo
```

### Lab 3.3: Pod Security Standards

```bash
# Create namespace with Pod Security Standards enforced
kubectl create namespace pss-demo

# Label namespace with restricted security level
kubectl label namespace pss-demo \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/audit=restricted \
  pod-security.kubernetes.io/warn=restricted

# Try to create a privileged pod (should fail)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: privileged-pod
  namespace: pss-demo
spec:
  containers:
  - name: nginx
    image: nginx
    securityContext:
      privileged: true
EOF
# Expected: Error - violates PodSecurity "restricted"

# Create compliant pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: pss-demo
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: nginx
    image: nginx
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop:
        - ALL
      readOnlyRootFilesystem: true
    volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: cache
      mountPath: /var/cache/nginx
    - name: run
      mountPath: /var/run
  volumes:
  - name: tmp
    emptyDir: {}
  - name: cache
    emptyDir: {}
  - name: run
    emptyDir: {}
EOF

# Verify pod status
kubectl get pods -n pss-demo
```

### Lab 3.4: Secrets Management

```bash
# Create namespace for secrets demo
kubectl create namespace secrets-demo

# Create a secret from literal values
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password='S3cur3P@ss!' \
  -n secrets-demo

# Create secret from file
echo -n 'my-api-key-12345' > ./api-key.txt
kubectl create secret generic api-secret \
  --from-file=api-key=./api-key.txt \
  -n secrets-demo
rm ./api-key.txt

# View secret (base64 encoded)
kubectl get secret db-credentials -n secrets-demo -o yaml

# Decode secret value
kubectl get secret db-credentials -n secrets-demo -o jsonpath='{.data.password}' | base64 -d

# Use secret in pod as environment variable
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
  namespace: secrets-demo
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "echo DB_USER=\$DB_USERNAME && sleep 3600"]
    env:
    - name: DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: username
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: password
EOF

# Use secret as volume mount
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-volume-pod
  namespace: secrets-demo
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "cat /etc/secrets/username && sleep 3600"]
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secrets
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: db-credentials
EOF

# Verify secrets are mounted
kubectl exec -it secret-volume-pod -n secrets-demo -- cat /etc/secrets/username
```

---

## CyberArk PAM Lab Setup

### Lab 4.1: CyberArk Container Deployment (Development Only)

> **Note**: For production CyberArk deployments, follow official CyberArk documentation. This is for learning purposes only.

```bash
# Create namespace for PAM components
kubectl create namespace cyberark-pam

# Create persistent storage for Vault
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: vault-data
  namespace: cyberark-pam
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
EOF

# Create ConfigMap for Vault configuration
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: vault-config
  namespace: cyberark-pam
data:
  vault.ini: |
    [Main]
    VaultPort=1858
    VaultDebugLevel=5
    VaultLogPath=/var/log/cyberark
EOF
```

### Lab 4.2: HashiCorp Vault (Alternative for PAM Concepts)

For learning PAM concepts without CyberArk license:

```bash
# Deploy HashiCorp Vault for secrets management practice
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

# Install Vault in dev mode
helm install vault hashicorp/vault \
  --namespace vault \
  --create-namespace \
  --set "server.dev.enabled=true" \
  --set "injector.enabled=true"

# Wait for Vault to be ready
kubectl wait --for=condition=Ready pods -l app.kubernetes.io/name=vault -n vault --timeout=120s

# Port forward to access Vault UI
kubectl port-forward svc/vault 8200:8200 -n vault &

# Initialize Vault (if not in dev mode)
# kubectl exec -it vault-0 -n vault -- vault operator init

# Access Vault (dev mode root token is "root")
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

# Enable KV secrets engine
kubectl exec -it vault-0 -n vault -- vault secrets enable -path=secret kv-v2

# Create a secret
kubectl exec -it vault-0 -n vault -- vault kv put secret/myapp/config \
  username="appuser" \
  password="s3cr3t"

# Read secret
kubectl exec -it vault-0 -n vault -- vault kv get secret/myapp/config
```

---

## PAM + Kubernetes Integration

### Lab 5.1: Service Account Token Management

```bash
# Create namespace for integration testing
kubectl create namespace pam-integration

# Create ServiceAccount with limited token lifetime
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-service-account
  namespace: pam-integration
---
apiVersion: v1
kind: Secret
metadata:
  name: app-service-account-token
  namespace: pam-integration
  annotations:
    kubernetes.io/service-account.name: app-service-account
type: kubernetes.io/service-account-token
EOF

# Create pod using ServiceAccount
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
  namespace: pam-integration
spec:
  serviceAccountName: app-service-account
  automountServiceAccountToken: true
  containers:
  - name: app
    image: curlimages/curl
    command: ["sh", "-c", "sleep 3600"]
EOF

# Verify token is mounted
kubectl exec -it app-pod -n pam-integration -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
```

### Lab 5.2: External Secrets Operator (Production Pattern)

```bash
# Install External Secrets Operator
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

helm install external-secrets external-secrets/external-secrets \
  -n external-secrets \
  --create-namespace

# Wait for operator to be ready
kubectl wait --for=condition=Ready pods -l app.kubernetes.io/name=external-secrets -n external-secrets --timeout=120s

# Create SecretStore pointing to HashiCorp Vault
cat <<EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-backend
  namespace: pam-integration
spec:
  provider:
    vault:
      server: "http://vault.vault.svc.cluster.local:8200"
      path: "secret"
      version: "v2"
      auth:
        tokenSecretRef:
          name: vault-token
          key: token
EOF
```

---

## Troubleshooting Commands

### Kubernetes Diagnostics

```bash
# Check cluster status
kubectl cluster-info
kubectl get nodes -o wide
kubectl get componentstatuses

# Check all pods across namespaces
kubectl get pods -A
kubectl get pods -A | grep -v Running

# Check events (sorted by time)
kubectl get events --sort-by='.lastTimestamp' -A

# Check resource usage
kubectl top nodes
kubectl top pods -A

# Describe problematic pod
kubectl describe pod <pod-name> -n <namespace>

# Check pod logs
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous  # Previous container logs
kubectl logs <pod-name> -n <namespace> -f  # Follow logs

# Execute into pod for debugging
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# Check network connectivity from pod
kubectl exec -it <pod-name> -n <namespace> -- nslookup kubernetes.default
kubectl exec -it <pod-name> -n <namespace> -- wget -qO- http://service-name:port

# Verify RBAC permissions
kubectl auth can-i --list
kubectl auth can-i create pods --as=system:serviceaccount:namespace:sa-name

# Check API server audit logs (if enabled)
kubectl logs -n kube-system -l component=kube-apiserver
```

### Security Scanning

```bash
# Install Trivy for container scanning
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Scan container image
trivy image nginx:latest
trivy image --severity HIGH,CRITICAL nginx:latest

# Scan Kubernetes cluster
trivy k8s --report summary cluster

# Scan specific namespace
trivy k8s -n default --report all

# Install kube-bench for CIS benchmarks
kubectl apply -f https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job.yaml

# Check kube-bench results
kubectl logs -l app=kube-bench
```

---

## Cleanup Commands

```bash
# Delete demo namespaces
kubectl delete namespace rbac-demo netpol-demo pss-demo secrets-demo pam-integration --ignore-not-found

# Delete kind cluster
kind delete cluster --name pam-lab

# Delete minikube cluster
minikube delete

# Stop k3s
sudo systemctl stop k3s
```

---

## Related Documents

- **Phase 1 Overview**: [PHASE1_MONTHS_1-11.md](../roadmap/PHASE1_MONTHS_1-11.md)
- **CKS Certification Guide**: [CKS_CERTIFICATION_GUIDE.md](CKS_CERTIFICATION_GUIDE.md)
- **CKS Cheat Sheets**: [CKS_CHEAT_SHEETS.md](CKS_CHEAT_SHEETS.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](../TROUBLESHOOTING.md)
- **Official Resources**: [OFFICIAL_RESOURCES.md](OFFICIAL_RESOURCES.md)

---

## External References

- [Kubernetes Official Documentation](https://kubernetes.io/docs/)
- [CKS Exam Curriculum](https://github.com/cncf/curriculum)
- [CyberArk Documentation](https://docs.cyberark.com)
- [HashiCorp Vault Documentation](https://developer.hashicorp.com/vault/docs)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)

---

**Last Updated**: 2025-12-01
**Version**: 1.0
