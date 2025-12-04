# Hands-On Labs: Phase 2 - Conjur + DevSecOps Mastery

Practical lab exercises with actual commands for Months 12-18. These labs complement the theoretical knowledge from Phase 2 and build on Phase 1 foundations.

**Prerequisites**:
- Phase 1 completed (Kubernetes cluster operational)
- Docker and kubectl installed
- Helm 3.x installed
- Basic CI/CD understanding
- Cloud provider accounts (AWS/Azure free tier acceptable)

**Lab Environment**: Builds on [HANDS_ON_LABS_PHASE1.md](HANDS_ON_LABS_PHASE1.md) infrastructure.

---

## Table of Contents

1. [Conjur Docker Deployment](#conjur-docker-deployment)
2. [Conjur Policy-as-Code](#conjur-policy-as-code)
3. [Conjur Kubernetes Deployment](#conjur-kubernetes-deployment)
4. [Conjur High Availability](#conjur-high-availability)
5. [Secrets Injection Patterns](#secrets-injection-patterns)
6. [Secretless Broker](#secretless-broker)
7. [CI/CD Integration - Jenkins](#cicd-integration---jenkins)
8. [CI/CD Integration - GitLab CI](#cicd-integration---gitlab-ci)
9. [CI/CD Integration - GitHub Actions](#cicd-integration---github-actions)
10. [AWS IAM Integration](#aws-iam-integration)
11. [Azure AD Integration](#azure-ad-integration)
12. [Multi-Cloud Secrets Orchestration](#multi-cloud-secrets-orchestration)
13. [Troubleshooting Commands](#troubleshooting-commands)

---

## Conjur Docker Deployment

### Lab 1.1: Conjur OSS Quick Start (Month 13, Week 49)

```bash
# Create directory for Conjur deployment
mkdir -p ~/conjur-lab && cd ~/conjur-lab

# Pull Conjur OSS images
docker pull cyberark/conjur:latest
docker pull cyberark/conjur-cli:8
docker pull postgres:15

# Create Docker network for Conjur
docker network create conjur-network

# Start PostgreSQL database
docker run --name conjur-postgres \
  --network conjur-network \
  -e POSTGRES_HOST_AUTH_METHOD=trust \
  -e POSTGRES_DB=conjur \
  -d postgres:15

# Wait for PostgreSQL to be ready
sleep 10

# Generate Conjur data key (SAVE THIS!)
docker run --rm cyberark/conjur data-key generate > data_key
export CONJUR_DATA_KEY=$(cat data_key)
echo "CONJUR_DATA_KEY: $CONJUR_DATA_KEY"

# Start Conjur server
docker run --name conjur-server \
  --network conjur-network \
  -p 8080:80 \
  -e DATABASE_URL=postgres://postgres@conjur-postgres/conjur \
  -e CONJUR_DATA_KEY=$CONJUR_DATA_KEY \
  -e CONJUR_AUTHENTICATORS=authn \
  -d cyberark/conjur server

# Wait for Conjur to start
sleep 15

# Create Conjur account
docker exec conjur-server conjurctl account create myorg > admin_credentials.txt
cat admin_credentials.txt

# Save the API key from output (you'll need this!)
export CONJUR_ADMIN_API_KEY=$(grep "API key" admin_credentials.txt | awk '{print $NF}')
echo "Admin API Key: $CONJUR_ADMIN_API_KEY"

# Verify Conjur is running
curl -k http://localhost:8080/info
```

### Lab 1.2: Conjur CLI Setup

```bash
# Start Conjur CLI container
docker run --rm -it \
  --network conjur-network \
  --name conjur-cli \
  -v $(pwd):/workspace \
  -w /workspace \
  cyberark/conjur-cli:8 bash

# Inside the CLI container:
# Initialize Conjur CLI
conjur init -u http://conjur-server -a myorg --self-signed

# Login as admin
conjur login -i admin
# Enter the API key when prompted

# Verify authentication
conjur whoami

# List resources (empty initially)
conjur list
```

### Lab 1.3: Docker Compose Deployment (Production-like)

```bash
# Create docker-compose.yml for Conjur
cat <<'EOF' > docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_HOST_AUTH_METHOD: trust
      POSTGRES_DB: conjur
    volumes:
      - conjur-postgres-data:/var/lib/postgresql/data
    networks:
      - conjur-network
    restart: unless-stopped

  conjur:
    image: cyberark/conjur:latest
    command: server
    environment:
      DATABASE_URL: postgres://postgres@postgres/conjur
      CONJUR_DATA_KEY: ${CONJUR_DATA_KEY}
      CONJUR_AUTHENTICATORS: authn,authn-k8s/my-authenticator
      CONJUR_ACCOUNT: myorg
    ports:
      - "8080:80"
      - "8443:443"
    depends_on:
      - postgres
    networks:
      - conjur-network
    restart: unless-stopped

  conjur-cli:
    image: cyberark/conjur-cli:8
    entrypoint: sleep
    command: infinity
    volumes:
      - ./policy:/policy
    networks:
      - conjur-network

networks:
  conjur-network:
    driver: bridge

volumes:
  conjur-postgres-data:
EOF

# Create policy directory
mkdir -p policy

# Start services
docker-compose up -d

# Check status
docker-compose ps
docker-compose logs conjur
```

---

## Conjur Policy-as-Code

### Lab 2.1: Basic Policy Structure (Month 13, Week 50)

```bash
# Create base policy file
cat <<'EOF' > policy/root.yml
# Root policy - defines organizational structure
- !policy
  id: apps
  owner: !group admins
  body:
    - !group developers
    - !group operators

- !policy
  id: secrets
  owner: !group admins

- !policy
  id: infrastructure
  owner: !group admins

- !group admins

# Grant admins access to all policies
- !grant
  role: !group admins
  member: !user admin
EOF

# Load root policy
docker exec -i conjur-cli conjur policy load -b root -f - < policy/root.yml
```

### Lab 2.2: Application Secrets Policy

```bash
# Create secrets policy for a web application
cat <<'EOF' > policy/apps/webapp.yml
# Web Application Secrets Policy
- !policy
  id: webapp
  body:
    # Define the application identity
    - !layer

    # Define hosts (application instances)
    - !host webapp-prod-01
    - !host webapp-prod-02
    - !host webapp-staging-01

    # Add hosts to the layer
    - !grant
      role: !layer
      members:
        - !host webapp-prod-01
        - !host webapp-prod-02
        - !host webapp-staging-01

    # Define secrets
    - !variable database/host
    - !variable database/port
    - !variable database/username
    - !variable database/password
    - !variable api/key
    - !variable api/secret

    # Grant the layer permission to read secrets
    - !permit
      role: !layer
      privileges: [ read, execute ]
      resources:
        - !variable database/host
        - !variable database/port
        - !variable database/username
        - !variable database/password
        - !variable api/key
        - !variable api/secret
EOF

# Load application policy
docker exec -i conjur-cli conjur policy load -b apps -f - < policy/apps/webapp.yml

# Set secret values
docker exec conjur-cli conjur variable set -i apps/webapp/database/host -v "db.example.com"
docker exec conjur-cli conjur variable set -i apps/webapp/database/port -v "5432"
docker exec conjur-cli conjur variable set -i apps/webapp/database/username -v "webapp_user"
docker exec conjur-cli conjur variable set -i apps/webapp/database/password -v "SuperSecr3tP@ssword!"
docker exec conjur-cli conjur variable set -i apps/webapp/api/key -v "ak_prod_12345"
docker exec conjur-cli conjur variable set -i apps/webapp/api/secret -v "as_prod_secret_67890"

# Verify secrets are stored
docker exec conjur-cli conjur variable get -i apps/webapp/database/password
```

### Lab 2.3: Host Identity Authentication

```bash
# Get host API key for webapp-prod-01
HOST_API_KEY=$(docker exec conjur-cli conjur host rotate-api-key -i apps/webapp/webapp-prod-01)
echo "Host API Key: $HOST_API_KEY"

# Authenticate as the host and retrieve a secret
# Using REST API directly
CONJUR_URL="http://localhost:8080"
ACCOUNT="myorg"
HOST_ID="host/apps/webapp/webapp-prod-01"

# URL encode the host ID
ENCODED_HOST_ID=$(echo -n "$HOST_ID" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read(), safe=''))")

# Authenticate and get access token
ACCESS_TOKEN=$(curl -s -X POST \
  "$CONJUR_URL/authn/$ACCOUNT/$ENCODED_HOST_ID/authenticate" \
  -H "Content-Type: text/plain" \
  -d "$HOST_API_KEY" | base64 | tr -d '\n')

echo "Access Token: ${ACCESS_TOKEN:0:50}..."

# Retrieve secret using the access token
curl -s -H "Authorization: Token token=\"$ACCESS_TOKEN\"" \
  "$CONJUR_URL/secrets/$ACCOUNT/variable/apps%2Fwebapp%2Fdatabase%2Fpassword"
```

### Lab 2.4: Policy Versioning and Git Integration

```bash
# Initialize Git repository for policies
cd ~/conjur-lab/policy
git init
git add .
git commit -m "Initial Conjur policies"

# Create branch for new feature
git checkout -b feature/add-microservice

# Add new microservice policy
cat <<'EOF' > apps/microservice-api.yml
# Microservice API Secrets Policy
- !policy
  id: microservice-api
  body:
    - !layer

    - !host api-instance-01
    - !host api-instance-02

    - !grant
      role: !layer
      members:
        - !host api-instance-01
        - !host api-instance-02

    - !variable jwt/secret
    - !variable redis/connection-string
    - !variable external-api/token

    - !permit
      role: !layer
      privileges: [ read, execute ]
      resources:
        - !variable jwt/secret
        - !variable redis/connection-string
        - !variable external-api/token
EOF

git add apps/microservice-api.yml
git commit -m "Add microservice-api secrets policy"

# Merge to main
git checkout main
git merge feature/add-microservice

# Load new policy
docker exec -i conjur-cli conjur policy load -b apps -f - < apps/microservice-api.yml
```

---

## Conjur Kubernetes Deployment

### Lab 3.1: Deploy Conjur to Kubernetes (Month 14, Week 53)

```bash
# Create namespace for Conjur
kubectl create namespace conjur-system

# Create Conjur data key secret
kubectl create secret generic conjur-data-key \
  --from-literal=key=$(docker run --rm cyberark/conjur data-key generate) \
  -n conjur-system

# Create PostgreSQL deployment
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: conjur-postgres-pvc
  namespace: conjur-system
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: conjur-postgres
  namespace: conjur-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: conjur-postgres
  template:
    metadata:
      labels:
        app: conjur-postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15
        env:
        - name: POSTGRES_HOST_AUTH_METHOD
          value: trust
        - name: POSTGRES_DB
          value: conjur
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: postgres-data
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: postgres-data
        persistentVolumeClaim:
          claimName: conjur-postgres-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: conjur-postgres
  namespace: conjur-system
spec:
  selector:
    app: conjur-postgres
  ports:
  - port: 5432
    targetPort: 5432
EOF

# Wait for PostgreSQL
kubectl wait --for=condition=Ready pod -l app=conjur-postgres -n conjur-system --timeout=120s

# Deploy Conjur server
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: conjur
  namespace: conjur-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: conjur
  template:
    metadata:
      labels:
        app: conjur
    spec:
      containers:
      - name: conjur
        image: cyberark/conjur:latest
        command: ["conjurctl", "server"]
        env:
        - name: DATABASE_URL
          value: postgres://postgres@conjur-postgres:5432/conjur
        - name: CONJUR_DATA_KEY
          valueFrom:
            secretKeyRef:
              name: conjur-data-key
              key: key
        - name: CONJUR_AUTHENTICATORS
          value: authn,authn-k8s/my-authenticator
        - name: CONJUR_ACCOUNT
          value: myorg
        ports:
        - containerPort: 80
          name: http
        - containerPort: 443
          name: https
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
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
  - name: http
    port: 80
    targetPort: 80
  - name: https
    port: 443
    targetPort: 443
EOF

# Wait for Conjur
kubectl wait --for=condition=Ready pod -l app=conjur -n conjur-system --timeout=180s

# Initialize Conjur account
CONJUR_POD=$(kubectl get pod -l app=conjur -n conjur-system -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n conjur-system $CONJUR_POD -- conjurctl account create myorg > conjur-admin-credentials.txt
cat conjur-admin-credentials.txt
```

### Lab 3.2: Kubernetes Authenticator Setup (Month 14, Week 55)

```bash
# Create authenticator policy
cat <<'EOF' > k8s-authenticator-policy.yml
# Kubernetes Authenticator Policy
- !policy
  id: conjur/authn-k8s/my-authenticator
  body:
    - !webservice

    # Define CA for signing certificates
    - !variable ca/key
    - !variable ca/cert

    # Service account for authenticator
    - !group apps

    # Allow apps group to authenticate
    - !permit
      role: !group apps
      privilege: [ authenticate ]
      resource: !webservice

# Application namespace policy
- !policy
  id: apps/k8s
  body:
    # Define application identity by namespace/service-account
    - !host
      id: default/myapp-sa
      annotations:
        authn-k8s/namespace: default
        authn-k8s/service-account: myapp-sa
        authn-k8s/authentication-container-name: authenticator

    # Grant authentication permission
    - !grant
      role: !group /conjur/authn-k8s/my-authenticator/apps
      member: !host default/myapp-sa

    # Application secrets
    - !variable database/password
    - !variable api/key

    # Grant secret access
    - !permit
      role: !host default/myapp-sa
      privileges: [ read, execute ]
      resources:
        - !variable database/password
        - !variable api/key
EOF

# Load authenticator policy (run from Conjur CLI)
kubectl exec -n conjur-system $CONJUR_POD -- conjurctl policy load root /dev/stdin < k8s-authenticator-policy.yml

# Set secret values
kubectl exec -n conjur-system $CONJUR_POD -- conjurctl variable set apps/k8s/database/password "K8sDbP@ssw0rd!"
kubectl exec -n conjur-system $CONJUR_POD -- conjurctl variable set apps/k8s/api/key "k8s-api-key-12345"

# Create ServiceAccount for application
kubectl create serviceaccount myapp-sa -n default

# Create ClusterRole for Conjur authenticator
cat <<'EOF' | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: conjur-authenticator
rules:
- apiGroups: [""]
  resources: ["pods", "serviceaccounts"]
  verbs: ["get", "list"]
- apiGroups: ["extensions"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list"]
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets", "replicasets"]
  verbs: ["get", "list"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create", "get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: conjur-authenticator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: conjur-authenticator
subjects:
- kind: ServiceAccount
  name: conjur
  namespace: conjur-system
EOF
```

---

## Conjur High Availability

### Lab 4.1: Conjur HA with Multiple Replicas (Month 14, Week 54)

```bash
# Update Conjur deployment for HA
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: conjur
  namespace: conjur-system
spec:
  replicas: 3  # HA configuration
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
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - conjur
              topologyKey: kubernetes.io/hostname
      containers:
      - name: conjur
        image: cyberark/conjur:latest
        command: ["conjurctl", "server"]
        env:
        - name: DATABASE_URL
          value: postgres://postgres@conjur-postgres:5432/conjur
        - name: CONJUR_DATA_KEY
          valueFrom:
            secretKeyRef:
              name: conjur-data-key
              key: key
        - name: CONJUR_AUTHENTICATORS
          value: authn,authn-k8s/my-authenticator
        - name: CONJUR_ACCOUNT
          value: myorg
        - name: RAILS_MAX_THREADS
          value: "10"
        ports:
        - containerPort: 80
          name: http
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
EOF

# Verify HA deployment
kubectl get pods -n conjur-system -l app=conjur
kubectl get pods -n conjur-system -o wide | grep conjur
```

### Lab 4.2: PostgreSQL HA with Patroni (Production Pattern)

```bash
# Deploy PostgreSQL HA using Patroni (simplified example)
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: patroni-config
  namespace: conjur-system
data:
  patroni.yml: |
    scope: conjur-postgres
    name: ${HOSTNAME}
    restapi:
      listen: 0.0.0.0:8008
      connect_address: ${POD_IP}:8008
    postgresql:
      listen: 0.0.0.0:5432
      connect_address: ${POD_IP}:5432
      data_dir: /var/lib/postgresql/data
      authentication:
        superuser:
          username: postgres
          password: postgres
        replication:
          username: replicator
          password: replicator
    bootstrap:
      dcs:
        postgresql:
          parameters:
            max_connections: 100
            shared_buffers: 256MB
      initdb:
        - encoding: UTF8
        - data-checksums
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: conjur-postgres-ha
  namespace: conjur-system
spec:
  serviceName: conjur-postgres-ha
  replicas: 3
  selector:
    matchLabels:
      app: conjur-postgres-ha
  template:
    metadata:
      labels:
        app: conjur-postgres-ha
    spec:
      containers:
      - name: postgres
        image: postgres:15
        ports:
        - containerPort: 5432
        env:
        - name: POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
EOF
```

---

## Secrets Injection Patterns

### Lab 5.1: Init Container Pattern (Month 15, Week 57)

```bash
# Deploy application with Conjur secrets via init container
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: conjur-connect
  namespace: default
data:
  CONJUR_ACCOUNT: myorg
  CONJUR_APPLIANCE_URL: http://conjur.conjur-system.svc.cluster.local
  CONJUR_AUTHN_URL: http://conjur.conjur-system.svc.cluster.local/authn-k8s/my-authenticator
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-init-container
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp-init-container
  template:
    metadata:
      labels:
        app: myapp-init-container
    spec:
      serviceAccountName: myapp-sa
      initContainers:
      - name: authenticator
        image: cyberark/conjur-authn-k8s-client:latest
        imagePullPolicy: IfNotPresent
        env:
        - name: CONTAINER_MODE
          value: init
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: MY_POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: CONJUR_AUTHN_LOGIN
          value: host/apps/k8s/default/myapp-sa
        envFrom:
        - configMapRef:
            name: conjur-connect
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
      - name: secretless-init
        image: cyberark/secretless-broker:latest
        command: ["/bin/sh", "-c"]
        args:
          - |
            # Fetch secrets and write to shared volume
            export CONJUR_AUTHN_TOKEN_FILE=/run/conjur/access-token
            # Use summon or custom script to fetch secrets
            echo "Secrets fetched successfully"
        envFrom:
        - configMapRef:
            name: conjur-connect
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
        - name: app-secrets
          mountPath: /etc/secrets
      containers:
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: app-secrets
          mountPath: /etc/secrets
          readOnly: true
      volumes:
      - name: conjur-access-token
        emptyDir:
          medium: Memory
      - name: app-secrets
        emptyDir:
          medium: Memory
EOF
```

### Lab 5.2: Sidecar Pattern

```bash
# Deploy application with Conjur sidecar for continuous secret refresh
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-sidecar
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp-sidecar
  template:
    metadata:
      labels:
        app: myapp-sidecar
    spec:
      serviceAccountName: myapp-sa
      containers:
      - name: authenticator
        image: cyberark/conjur-authn-k8s-client:latest
        imagePullPolicy: IfNotPresent
        env:
        - name: CONTAINER_MODE
          value: sidecar
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: MY_POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: CONJUR_AUTHN_LOGIN
          value: host/apps/k8s/default/myapp-sa
        - name: CONJUR_TOKEN_TIMEOUT
          value: "300"  # Refresh token every 5 minutes
        envFrom:
        - configMapRef:
            name: conjur-connect
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
        env:
        - name: CONJUR_AUTHN_TOKEN_FILE
          value: /run/conjur/access-token
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
          readOnly: true
      volumes:
      - name: conjur-access-token
        emptyDir:
          medium: Memory
EOF
```

### Lab 5.3: Environment Variable Injection with Summon

```bash
# Create summon secrets.yml
cat <<'EOF' > secrets.yml
DATABASE_HOST: !var apps/webapp/database/host
DATABASE_PORT: !var apps/webapp/database/port
DATABASE_USER: !var apps/webapp/database/username
DATABASE_PASSWORD: !var apps/webapp/database/password
API_KEY: !var apps/webapp/api/key
EOF

# Create ConfigMap with secrets.yml
kubectl create configmap summon-secrets --from-file=secrets.yml -n default

# Deploy with Summon
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-summon
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp-summon
  template:
    metadata:
      labels:
        app: myapp-summon
    spec:
      serviceAccountName: myapp-sa
      initContainers:
      - name: authenticator
        image: cyberark/conjur-authn-k8s-client:latest
        env:
        - name: CONTAINER_MODE
          value: init
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: MY_POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: CONJUR_AUTHN_LOGIN
          value: host/apps/k8s/default/myapp-sa
        envFrom:
        - configMapRef:
            name: conjur-connect
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
      containers:
      - name: app
        image: cyberark/summon:latest
        command: ["summon", "-p", "conjur", "--", "/app/start.sh"]
        env:
        - name: CONJUR_AUTHN_TOKEN_FILE
          value: /run/conjur/access-token
        envFrom:
        - configMapRef:
            name: conjur-connect
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
          readOnly: true
        - name: summon-config
          mountPath: /etc/summon
      volumes:
      - name: conjur-access-token
        emptyDir:
          medium: Memory
      - name: summon-config
        configMap:
          name: summon-secrets
EOF
```

---

## Secretless Broker

### Lab 6.1: Secretless Broker for Database Connections (Month 15, Week 58)

```bash
# Create Secretless configuration
cat <<'EOF' > secretless.yml
version: "2"
services:
  postgres:
    protocol: pg
    listenOn: tcp://0.0.0.0:5432
    credentials:
      host:
        from: conjur
        get: apps/webapp/database/host
      port:
        from: conjur
        get: apps/webapp/database/port
      username:
        from: conjur
        get: apps/webapp/database/username
      password:
        from: conjur
        get: apps/webapp/database/password
      sslmode:
        from: literal
        get: disable

  mysql:
    protocol: mysql
    listenOn: tcp://0.0.0.0:3306
    credentials:
      host:
        from: conjur
        get: apps/webapp/mysql/host
      port:
        from: literal
        get: 3306
      username:
        from: conjur
        get: apps/webapp/mysql/username
      password:
        from: conjur
        get: apps/webapp/mysql/password
EOF

# Create ConfigMap for Secretless
kubectl create configmap secretless-config --from-file=secretless.yml -n default

# Deploy application with Secretless Broker
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-secretless
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp-secretless
  template:
    metadata:
      labels:
        app: myapp-secretless
    spec:
      serviceAccountName: myapp-sa
      initContainers:
      - name: authenticator
        image: cyberark/conjur-authn-k8s-client:latest
        env:
        - name: CONTAINER_MODE
          value: init
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: MY_POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: CONJUR_AUTHN_LOGIN
          value: host/apps/k8s/default/myapp-sa
        envFrom:
        - configMapRef:
            name: conjur-connect
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
      containers:
      - name: secretless-broker
        image: cyberark/secretless-broker:latest
        args: ["-f", "/etc/secretless/secretless.yml"]
        env:
        - name: CONJUR_AUTHN_TOKEN_FILE
          value: /run/conjur/access-token
        envFrom:
        - configMapRef:
            name: conjur-connect
        ports:
        - containerPort: 5432
          name: postgres
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
          readOnly: true
        - name: secretless-config
          mountPath: /etc/secretless
      - name: app
        image: your-app-image:latest
        env:
        # App connects to localhost - Secretless handles credentials
        - name: DATABASE_HOST
          value: "localhost"
        - name: DATABASE_PORT
          value: "5432"
        # No credentials in environment!
      volumes:
      - name: conjur-access-token
        emptyDir:
          medium: Memory
      - name: secretless-config
        configMap:
          name: secretless-config
EOF
```

### Lab 6.2: Secretless for HTTP Services

```bash
# Add HTTP service to Secretless config
cat <<'EOF' > secretless-http.yml
version: "2"
services:
  external-api:
    protocol: http
    listenOn: tcp://0.0.0.0:8080
    credentials:
      headers:
        Authorization:
          from: conjur
          get: apps/webapp/api/key
          format: "Bearer {{ .Value }}"
    config:
      forwardAddress: https://api.external-service.com
EOF
```

---

## CI/CD Integration - Jenkins

### Lab 7.1: Jenkins + Conjur Integration (Month 16, Week 61)

```bash
# Create Jenkins policy in Conjur
cat <<'EOF' > policy/jenkins.yml
- !policy
  id: ci-cd/jenkins
  body:
    # Jenkins server identity
    - !host jenkins-master

    # Jenkins job identities
    - !host build-job-frontend
    - !host build-job-backend
    - !host deploy-job-prod

    # Layer for all Jenkins hosts
    - !layer

    - !grant
      role: !layer
      members:
        - !host jenkins-master
        - !host build-job-frontend
        - !host build-job-backend
        - !host deploy-job-prod

    # Secrets for CI/CD
    - !variable docker-registry/username
    - !variable docker-registry/password
    - !variable sonarqube/token
    - !variable artifactory/api-key
    - !variable aws/access-key-id
    - !variable aws/secret-access-key
    - !variable kubernetes/kubeconfig

    # Grant access
    - !permit
      role: !layer
      privileges: [ read, execute ]
      resources:
        - !variable docker-registry/username
        - !variable docker-registry/password
        - !variable sonarqube/token
        - !variable artifactory/api-key
        - !variable aws/access-key-id
        - !variable aws/secret-access-key
        - !variable kubernetes/kubeconfig
EOF

# Load Jenkins policy
docker exec -i conjur-cli conjur policy load -b root -f - < policy/jenkins.yml

# Set CI/CD secrets
docker exec conjur-cli conjur variable set -i ci-cd/jenkins/docker-registry/username -v "jenkins-user"
docker exec conjur-cli conjur variable set -i ci-cd/jenkins/docker-registry/password -v "docker-registry-pass"
docker exec conjur-cli conjur variable set -i ci-cd/jenkins/sonarqube/token -v "sonar-token-12345"
```

### Lab 7.2: Jenkinsfile with Conjur Secrets

```groovy
// Jenkinsfile example with Conjur integration
pipeline {
    agent any

    environment {
        CONJUR_APPLIANCE_URL = 'http://conjur.example.com'
        CONJUR_ACCOUNT = 'myorg'
        CONJUR_AUTHN_LOGIN = 'host/ci-cd/jenkins/build-job-frontend'
    }

    stages {
        stage('Authenticate to Conjur') {
            steps {
                script {
                    // Using Conjur Jenkins plugin or REST API
                    withCredentials([string(credentialsId: 'conjur-host-api-key', variable: 'CONJUR_AUTHN_API_KEY')]) {
                        sh '''
                            # Authenticate to Conjur
                            CONJUR_TOKEN=$(curl -s -X POST \
                                "${CONJUR_APPLIANCE_URL}/authn/${CONJUR_ACCOUNT}/${CONJUR_AUTHN_LOGIN}/authenticate" \
                                -H "Content-Type: text/plain" \
                                -d "${CONJUR_AUTHN_API_KEY}" | base64 | tr -d '\\n')

                            # Store token for subsequent steps
                            echo "${CONJUR_TOKEN}" > /tmp/conjur-token
                        '''
                    }
                }
            }
        }

        stage('Retrieve Secrets') {
            steps {
                script {
                    sh '''
                        CONJUR_TOKEN=$(cat /tmp/conjur-token)

                        # Retrieve Docker registry credentials
                        DOCKER_USER=$(curl -s \
                            -H "Authorization: Token token=\\"${CONJUR_TOKEN}\\"" \
                            "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fjenkins%2Fdocker-registry%2Fusername")

                        DOCKER_PASS=$(curl -s \
                            -H "Authorization: Token token=\\"${CONJUR_TOKEN}\\"" \
                            "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fjenkins%2Fdocker-registry%2Fpassword")

                        # Login to Docker registry
                        echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin registry.example.com
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t registry.example.com/myapp:${BUILD_NUMBER} .'
            }
        }

        stage('Push') {
            steps {
                sh 'docker push registry.example.com/myapp:${BUILD_NUMBER}'
            }
        }

        stage('Cleanup') {
            steps {
                sh 'rm -f /tmp/conjur-token'
                sh 'docker logout registry.example.com'
            }
        }
    }

    post {
        always {
            sh 'rm -f /tmp/conjur-token'
        }
    }
}
```

---

## CI/CD Integration - GitLab CI

### Lab 8.1: GitLab CI + Conjur Integration (Month 16, Week 62)

```yaml
# .gitlab-ci.yml with Conjur integration
variables:
  CONJUR_APPLIANCE_URL: "http://conjur.example.com"
  CONJUR_ACCOUNT: "myorg"
  CONJUR_AUTHN_LOGIN: "host/ci-cd/gitlab/build-job"

stages:
  - authenticate
  - build
  - test
  - deploy

.conjur-auth: &conjur-auth
  before_script:
    - |
      # Authenticate to Conjur
      export CONJUR_TOKEN=$(curl -s -X POST \
        "${CONJUR_APPLIANCE_URL}/authn/${CONJUR_ACCOUNT}/${CONJUR_AUTHN_LOGIN}/authenticate" \
        -H "Content-Type: text/plain" \
        -d "${CONJUR_AUTHN_API_KEY}" | base64 | tr -d '\n')

authenticate:
  stage: authenticate
  script:
    - |
      # Test authentication
      curl -s -H "Authorization: Token token=\"${CONJUR_TOKEN}\"" \
        "${CONJUR_APPLIANCE_URL}/whoami"

build:
  stage: build
  <<: *conjur-auth
  script:
    - |
      # Retrieve Docker credentials from Conjur
      DOCKER_USER=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_TOKEN}\"" \
        "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgitlab%2Fdocker-registry%2Fusername")

      DOCKER_PASS=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_TOKEN}\"" \
        "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgitlab%2Fdocker-registry%2Fpassword")

      # Build and push
      echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin $CI_REGISTRY
      docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
      docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

test:
  stage: test
  <<: *conjur-auth
  script:
    - |
      # Get test database credentials
      DB_HOST=$(curl -s -H "Authorization: Token token=\"${CONJUR_TOKEN}\"" \
        "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgitlab%2Ftest-db%2Fhost")
      DB_PASS=$(curl -s -H "Authorization: Token token=\"${CONJUR_TOKEN}\"" \
        "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgitlab%2Ftest-db%2Fpassword")

      # Run tests with secure credentials
      export DATABASE_URL="postgres://testuser:${DB_PASS}@${DB_HOST}:5432/testdb"
      npm test

deploy-staging:
  stage: deploy
  <<: *conjur-auth
  environment:
    name: staging
  script:
    - |
      # Get Kubernetes credentials
      KUBECONFIG_DATA=$(curl -s \
        -H "Authorization: Token token=\"${CONJUR_TOKEN}\"" \
        "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgitlab%2Fkubernetes%2Fstaging-kubeconfig")

      echo "${KUBECONFIG_DATA}" | base64 -d > /tmp/kubeconfig
      export KUBECONFIG=/tmp/kubeconfig

      kubectl set image deployment/myapp myapp=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n staging
  only:
    - develop
```

---

## CI/CD Integration - GitHub Actions

### Lab 9.1: GitHub Actions + Conjur Integration (Month 16, Week 64)

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD with Conjur

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  CONJUR_APPLIANCE_URL: ${{ secrets.CONJUR_APPLIANCE_URL }}
  CONJUR_ACCOUNT: myorg

jobs:
  authenticate:
    runs-on: ubuntu-latest
    outputs:
      conjur-token: ${{ steps.auth.outputs.token }}
    steps:
      - name: Authenticate to Conjur
        id: auth
        run: |
          TOKEN=$(curl -s -X POST \
            "${CONJUR_APPLIANCE_URL}/authn/${CONJUR_ACCOUNT}/host%2Fci-cd%2Fgithub%2Fbuild-job/authenticate" \
            -H "Content-Type: text/plain" \
            -d "${{ secrets.CONJUR_HOST_API_KEY }}" | base64 | tr -d '\n')
          echo "token=${TOKEN}" >> $GITHUB_OUTPUT

  build:
    needs: authenticate
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Get Docker Credentials
        id: docker-creds
        run: |
          DOCKER_USER=$(curl -s \
            -H "Authorization: Token token=\"${{ needs.authenticate.outputs.conjur-token }}\"" \
            "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgithub%2Fdocker%2Fusername")

          DOCKER_PASS=$(curl -s \
            -H "Authorization: Token token=\"${{ needs.authenticate.outputs.conjur-token }}\"" \
            "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgithub%2Fdocker%2Fpassword")

          echo "::add-mask::${DOCKER_PASS}"
          echo "username=${DOCKER_USER}" >> $GITHUB_OUTPUT
          echo "password=${DOCKER_PASS}" >> $GITHUB_OUTPUT

      - name: Login to Docker Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ steps.docker-creds.outputs.username }}
          password: ${{ steps.docker-creds.outputs.password }}

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}

  deploy:
    needs: [authenticate, build]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Get Kubernetes Credentials
        run: |
          KUBECONFIG=$(curl -s \
            -H "Authorization: Token token=\"${{ needs.authenticate.outputs.conjur-token }}\"" \
            "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/ci-cd%2Fgithub%2Fkubernetes%2Fprod-kubeconfig")

          echo "${KUBECONFIG}" | base64 -d > /tmp/kubeconfig

      - name: Deploy to Kubernetes
        run: |
          export KUBECONFIG=/tmp/kubeconfig
          kubectl set image deployment/myapp myapp=ghcr.io/${{ github.repository }}:${{ github.sha }} -n production
```

### Lab 9.2: GitHub Actions with CyberArk Conjur Action

```yaml
# Using official CyberArk GitHub Action
name: CI/CD with CyberArk Conjur Action

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Retrieve Secrets from Conjur
        uses: cyberark/conjur-action@v1
        with:
          url: ${{ secrets.CONJUR_URL }}
          account: myorg
          host_id: host/ci-cd/github/build-job
          api_key: ${{ secrets.CONJUR_API_KEY }}
          secrets: |
            ci-cd/github/docker/username | DOCKER_USERNAME
            ci-cd/github/docker/password | DOCKER_PASSWORD
            ci-cd/github/aws/access-key-id | AWS_ACCESS_KEY_ID
            ci-cd/github/aws/secret-access-key | AWS_SECRET_ACCESS_KEY

      - name: Login to Docker
        run: |
          echo "${{ env.DOCKER_PASSWORD }}" | docker login -u "${{ env.DOCKER_USERNAME }}" --password-stdin

      - name: Build and Push
        run: |
          docker build -t myapp:${{ github.sha }} .
          docker push myapp:${{ github.sha }}

      - name: Deploy to AWS EKS
        run: |
          aws eks update-kubeconfig --region us-east-1 --name my-cluster
          kubectl set image deployment/myapp myapp=myapp:${{ github.sha }}
```

---

## AWS IAM Integration

### Lab 10.1: AWS IAM Authenticator Setup (Month 16, Week 61)

```bash
# Create AWS IAM authenticator policy in Conjur
cat <<'EOF' > policy/aws-authenticator.yml
# AWS IAM Authenticator Policy
- !policy
  id: conjur/authn-iam/aws
  body:
    - !webservice

    - !group apps

    - !permit
      role: !group apps
      privilege: [ authenticate ]
      resource: !webservice

# AWS Application Identities
- !policy
  id: apps/aws
  body:
    # EC2 instance identity
    - !host
      id: ec2-webapp
      annotations:
        authn-iam/aws: true
        authn-iam/role-arn: arn:aws:iam::123456789012:role/webapp-role

    # Lambda function identity
    - !host
      id: lambda-processor
      annotations:
        authn-iam/aws: true
        authn-iam/role-arn: arn:aws:iam::123456789012:role/lambda-processor-role

    # EKS pod identity
    - !host
      id: eks-backend
      annotations:
        authn-iam/aws: true
        authn-iam/role-arn: arn:aws:iam::123456789012:role/eks-backend-role

    # Grant authentication permission
    - !grant
      role: !group /conjur/authn-iam/aws/apps
      members:
        - !host ec2-webapp
        - !host lambda-processor
        - !host eks-backend

    # Application secrets
    - !variable database/connection-string
    - !variable api/key
    - !variable encryption/key

    # Grant secret access
    - !permit
      role: !host ec2-webapp
      privileges: [ read, execute ]
      resources:
        - !variable database/connection-string
        - !variable api/key

    - !permit
      role: !host lambda-processor
      privileges: [ read, execute ]
      resources:
        - !variable api/key
        - !variable encryption/key
EOF

# Load AWS IAM policy
docker exec -i conjur-cli conjur policy load -b root -f - < policy/aws-authenticator.yml
```

### Lab 10.2: AWS EC2 Instance Authentication

```bash
# Script to run on EC2 instance to authenticate with Conjur
#!/bin/bash

CONJUR_APPLIANCE_URL="https://conjur.example.com"
CONJUR_ACCOUNT="myorg"
CONJUR_AUTHN_LOGIN="host/apps/aws/ec2-webapp"

# Get AWS STS signed headers for IAM authentication
get_aws_signed_headers() {
    local service="sts"
    local host="sts.amazonaws.com"
    local region="us-east-1"
    local endpoint="https://sts.amazonaws.com/"
    local request_parameters="Action=GetCallerIdentity&Version=2011-06-15"

    # Use AWS CLI to get signed request
    aws sts get-caller-identity --query 'Account' --output text
}

# Authenticate to Conjur using IAM
authenticate_to_conjur() {
    # Get IAM role credentials from instance metadata
    ROLE_NAME=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/)
    CREDS=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/$ROLE_NAME)

    export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r '.AccessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r '.SecretAccessKey')
    export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r '.Token')

    # Create signed request body
    SIGNED_REQUEST=$(python3 << 'PYTHON'
import boto3
from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest
import json

session = boto3.Session()
credentials = session.get_credentials()
region = 'us-east-1'

request = AWSRequest(method='POST', url='https://sts.amazonaws.com/',
                     data='Action=GetCallerIdentity&Version=2011-06-15',
                     headers={'Content-Type': 'application/x-www-form-urlencoded'})

SigV4Auth(credentials, 'sts', region).add_auth(request)

print(json.dumps({
    'host': request.headers['Host'],
    'x-amz-date': request.headers['X-Amz-Date'],
    'x-amz-security-token': request.headers.get('X-Amz-Security-Token', ''),
    'authorization': request.headers['Authorization']
}))
PYTHON
)

    # Authenticate to Conjur
    CONJUR_TOKEN=$(curl -s -X POST \
        "${CONJUR_APPLIANCE_URL}/authn-iam/${CONJUR_ACCOUNT}/host%2Fapps%2Faws%2Fec2-webapp/authenticate" \
        -H "Content-Type: application/json" \
        -d "${SIGNED_REQUEST}" | base64 | tr -d '\n')

    echo $CONJUR_TOKEN
}

# Retrieve secret
retrieve_secret() {
    local secret_id=$1
    local token=$2

    curl -s -H "Authorization: Token token=\"${token}\"" \
        "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/${secret_id}"
}

# Main
CONJUR_TOKEN=$(authenticate_to_conjur)
DB_CONNECTION=$(retrieve_secret "apps%2Faws%2Fdatabase%2Fconnection-string" $CONJUR_TOKEN)
echo "Database Connection: $DB_CONNECTION"
```

### Lab 10.3: AWS Lambda with Conjur

```python
# Lambda function with Conjur integration
import json
import boto3
import requests
import base64
from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest

def get_conjur_token():
    """Authenticate to Conjur using AWS IAM"""
    conjur_url = "https://conjur.example.com"
    conjur_account = "myorg"
    host_id = "host/apps/aws/lambda-processor"

    # Create signed STS request
    session = boto3.Session()
    credentials = session.get_credentials()

    request = AWSRequest(
        method='POST',
        url='https://sts.amazonaws.com/',
        data='Action=GetCallerIdentity&Version=2011-06-15',
        headers={'Content-Type': 'application/x-www-form-urlencoded'}
    )
    SigV4Auth(credentials, 'sts', 'us-east-1').add_auth(request)

    # Prepare authentication payload
    auth_payload = json.dumps({
        'host': request.headers['Host'],
        'x-amz-date': request.headers['X-Amz-Date'],
        'x-amz-security-token': request.headers.get('X-Amz-Security-Token', ''),
        'authorization': request.headers['Authorization']
    })

    # Authenticate to Conjur
    response = requests.post(
        f"{conjur_url}/authn-iam/{conjur_account}/{requests.utils.quote(host_id, safe='')}/authenticate",
        headers={'Content-Type': 'application/json'},
        data=auth_payload
    )

    return base64.b64encode(response.content).decode('utf-8')

def get_secret(token, secret_id):
    """Retrieve secret from Conjur"""
    conjur_url = "https://conjur.example.com"
    conjur_account = "myorg"

    response = requests.get(
        f"{conjur_url}/secrets/{conjur_account}/variable/{requests.utils.quote(secret_id, safe='')}",
        headers={'Authorization': f'Token token="{token}"'}
    )

    return response.text

def lambda_handler(event, context):
    # Get Conjur token
    token = get_conjur_token()

    # Retrieve secrets
    api_key = get_secret(token, "apps/aws/api/key")
    encryption_key = get_secret(token, "apps/aws/encryption/key")

    # Use secrets in your Lambda logic
    # ... your application code here ...

    return {
        'statusCode': 200,
        'body': json.dumps('Secrets retrieved successfully')
    }
```

---

## Azure AD Integration

### Lab 11.1: Azure AD Authenticator Setup (Month 16, Week 62)

```bash
# Create Azure AD authenticator policy in Conjur
cat <<'EOF' > policy/azure-authenticator.yml
# Azure AD Authenticator Policy
- !policy
  id: conjur/authn-azure/azure
  body:
    - !webservice

    - !variable provider-uri

    - !group apps

    - !permit
      role: !group apps
      privilege: [ authenticate ]
      resource: !webservice

# Azure Application Identities
- !policy
  id: apps/azure
  body:
    # Azure VM identity (System Managed Identity)
    - !host
      id: vm-webapp
      annotations:
        authn-azure/subscription-id: 12345678-1234-1234-1234-123456789012
        authn-azure/resource-group: myapp-rg
        authn-azure/user-assigned-identity: webapp-identity

    # Azure AKS pod identity
    - !host
      id: aks-backend
      annotations:
        authn-azure/subscription-id: 12345678-1234-1234-1234-123456789012
        authn-azure/resource-group: aks-rg
        authn-azure/user-assigned-identity: aks-pod-identity

    # Azure Function identity
    - !host
      id: function-processor
      annotations:
        authn-azure/subscription-id: 12345678-1234-1234-1234-123456789012
        authn-azure/resource-group: functions-rg
        authn-azure/system-assigned-identity: function-app-name

    # Grant authentication permission
    - !grant
      role: !group /conjur/authn-azure/azure/apps
      members:
        - !host vm-webapp
        - !host aks-backend
        - !host function-processor

    # Application secrets
    - !variable database/connection-string
    - !variable storage/account-key
    - !variable keyvault/client-secret

    # Grant secret access
    - !permit
      role: !host vm-webapp
      privileges: [ read, execute ]
      resources:
        - !variable database/connection-string
        - !variable storage/account-key

    - !permit
      role: !host aks-backend
      privileges: [ read, execute ]
      resources:
        - !variable database/connection-string

    - !permit
      role: !host function-processor
      privileges: [ read, execute ]
      resources:
        - !variable keyvault/client-secret
EOF

# Load Azure AD policy
docker exec -i conjur-cli conjur policy load -b root -f - < policy/azure-authenticator.yml

# Set Azure provider URI
docker exec conjur-cli conjur variable set \
  -i conjur/authn-azure/azure/provider-uri \
  -v "https://login.microsoftonline.com/your-tenant-id"
```

### Lab 11.2: Azure VM Authentication Script

```bash
#!/bin/bash
# Script to authenticate Azure VM to Conjur using Managed Identity

CONJUR_APPLIANCE_URL="https://conjur.example.com"
CONJUR_ACCOUNT="myorg"
CONJUR_AUTHN_LOGIN="host/apps/azure/vm-webapp"

# Get Azure Managed Identity token
get_azure_token() {
    curl -s -H "Metadata: true" \
        "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/"
}

# Authenticate to Conjur using Azure token
authenticate_to_conjur() {
    AZURE_TOKEN=$(get_azure_token | jq -r '.access_token')

    CONJUR_TOKEN=$(curl -s -X POST \
        "${CONJUR_APPLIANCE_URL}/authn-azure/${CONJUR_ACCOUNT}/${CONJUR_AUTHN_LOGIN//\//%2F}/authenticate" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "jwt=${AZURE_TOKEN}" | base64 | tr -d '\n')

    echo $CONJUR_TOKEN
}

# Retrieve secret
retrieve_secret() {
    local secret_id=$1
    local token=$2

    curl -s -H "Authorization: Token token=\"${token}\"" \
        "${CONJUR_APPLIANCE_URL}/secrets/${CONJUR_ACCOUNT}/variable/${secret_id//\//%2F}"
}

# Main
CONJUR_TOKEN=$(authenticate_to_conjur)
DB_CONNECTION=$(retrieve_secret "apps/azure/database/connection-string" "$CONJUR_TOKEN")
STORAGE_KEY=$(retrieve_secret "apps/azure/storage/account-key" "$CONJUR_TOKEN")

echo "Database Connection: $DB_CONNECTION"
echo "Storage Key: ${STORAGE_KEY:0:10}..."
```

---

## Multi-Cloud Secrets Orchestration

### Lab 12.1: Multi-Cloud Policy Structure (Month 17)

```bash
# Create unified multi-cloud policy
cat <<'EOF' > policy/multicloud.yml
# Multi-Cloud Secrets Management Policy
- !policy
  id: multicloud
  body:
    # Cloud-agnostic application layer
    - !layer apps

    # AWS resources
    - !policy
      id: aws
      body:
        - !variable rds/connection-string
        - !variable s3/access-key
        - !variable s3/secret-key
        - !variable dynamodb/endpoint

    # Azure resources
    - !policy
      id: azure
      body:
        - !variable sql/connection-string
        - !variable blob/account-key
        - !variable cosmosdb/connection-string

    # GCP resources
    - !policy
      id: gcp
      body:
        - !variable cloudsql/connection-string
        - !variable storage/service-account-key
        - !variable firestore/credentials

    # Shared/Common secrets
    - !policy
      id: shared
      body:
        - !variable encryption/master-key
        - !variable api/gateway-key
        - !variable monitoring/datadog-key

    # Grant apps layer access to all cloud secrets
    - !permit
      role: !layer apps
      privileges: [ read, execute ]
      resources:
        - !variable aws/rds/connection-string
        - !variable aws/s3/access-key
        - !variable aws/s3/secret-key
        - !variable azure/sql/connection-string
        - !variable azure/blob/account-key
        - !variable gcp/cloudsql/connection-string
        - !variable shared/encryption/master-key
        - !variable shared/api/gateway-key
EOF

# Load multi-cloud policy
docker exec -i conjur-cli conjur policy load -b root -f - < policy/multicloud.yml
```

### Lab 12.2: Multi-Cloud Application Deployment

```bash
# Deploy application that uses secrets from multiple clouds
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: multicloud-config
  namespace: default
data:
  # Conjur paths for each cloud's secrets
  AWS_DB_SECRET_PATH: "multicloud/aws/rds/connection-string"
  AZURE_DB_SECRET_PATH: "multicloud/azure/sql/connection-string"
  GCP_DB_SECRET_PATH: "multicloud/gcp/cloudsql/connection-string"
  SHARED_KEY_PATH: "multicloud/shared/encryption/master-key"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multicloud-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: multicloud-app
  template:
    metadata:
      labels:
        app: multicloud-app
    spec:
      serviceAccountName: myapp-sa
      initContainers:
      - name: conjur-authenticator
        image: cyberark/conjur-authn-k8s-client:latest
        env:
        - name: CONTAINER_MODE
          value: init
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: MY_POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: CONJUR_AUTHN_LOGIN
          value: host/apps/k8s/default/myapp-sa
        envFrom:
        - configMapRef:
            name: conjur-connect
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
      - name: secrets-provider
        image: cyberark/secrets-provider-for-k8s:latest
        env:
        - name: CONJUR_AUTHN_TOKEN_FILE
          value: /run/conjur/access-token
        - name: SECRETS_DESTINATION
          value: file
        - name: K8S_SECRETS
          value: "false"
        envFrom:
        - configMapRef:
            name: conjur-connect
        - configMapRef:
            name: multicloud-config
        volumeMounts:
        - name: conjur-access-token
          mountPath: /run/conjur
        - name: app-secrets
          mountPath: /etc/secrets
      containers:
      - name: app
        image: your-multicloud-app:latest
        ports:
        - containerPort: 8080
        envFrom:
        - configMapRef:
            name: multicloud-config
        volumeMounts:
        - name: app-secrets
          mountPath: /etc/secrets
          readOnly: true
      volumes:
      - name: conjur-access-token
        emptyDir:
          medium: Memory
      - name: app-secrets
        emptyDir:
          medium: Memory
EOF
```

---

## Troubleshooting Commands

### Conjur Diagnostics

```bash
# Check Conjur server status
curl -k http://localhost:8080/health
curl -k http://localhost:8080/info

# View Conjur logs
docker logs conjur-server --tail 100
kubectl logs -n conjur-system -l app=conjur --tail 100

# Test authentication
docker exec conjur-cli conjur whoami

# List all resources
docker exec conjur-cli conjur list

# Check specific resource
docker exec conjur-cli conjur show variable:apps/webapp/database/password

# Rotate host API key
docker exec conjur-cli conjur host rotate-api-key -i apps/webapp/webapp-prod-01

# Validate policy syntax (dry run)
docker exec -i conjur-cli conjur policy load --dry-run -b root -f - < policy/test.yml
```

### Kubernetes Integration Troubleshooting

```bash
# Check authenticator pod logs
kubectl logs -n conjur-system -l app=conjur -c conjur --tail 100 | grep authn-k8s

# Verify ServiceAccount token
kubectl get secret -n default $(kubectl get sa myapp-sa -n default -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 -d

# Check Conjur ConfigMap
kubectl get configmap conjur-connect -n default -o yaml

# Debug authentication from inside pod
kubectl exec -it myapp-pod -c authenticator -- cat /run/conjur/access-token

# Test Conjur connectivity from pod
kubectl exec -it myapp-pod -- curl -v http://conjur.conjur-system.svc.cluster.local/health
```

### Secrets Retrieval Debugging

```bash
# Manual secret retrieval test
CONJUR_TOKEN=$(docker exec conjur-cli conjur authenticate -H)
curl -s -H "Authorization: Token token=\"$CONJUR_TOKEN\"" \
  "http://localhost:8080/secrets/myorg/variable/apps%2Fwebapp%2Fdatabase%2Fpassword"

# Check variable exists
docker exec conjur-cli conjur variable get -i apps/webapp/database/password

# List permissions on variable
docker exec conjur-cli conjur resource permitted_roles variable:apps/webapp/database/password read
```

---

## Cleanup Commands

```bash
# Remove Conjur Docker deployment
docker-compose down -v
docker network rm conjur-network

# Remove Conjur Kubernetes deployment
kubectl delete namespace conjur-system
kubectl delete clusterrole conjur-authenticator
kubectl delete clusterrolebinding conjur-authenticator

# Remove application resources
kubectl delete deployment myapp-init-container myapp-sidecar myapp-secretless -n default
kubectl delete serviceaccount myapp-sa -n default
kubectl delete configmap conjur-connect summon-secrets secretless-config -n default

# Clean up policy files
rm -rf ~/conjur-lab
```

---

## Related Documents

- **Phase 2 Overview**: [PHASE2_MONTHS_12-18.md](../roadmap/PHASE2_MONTHS_12-18.md)
- **Phase 1 Labs**: [HANDS_ON_LABS_PHASE1.md](HANDS_ON_LABS_PHASE1.md)
- **DevSecOps CI/CD Guide**: [DEVOPS_CI_CD_GUIDE.md](DEVOPS_CI_CD_GUIDE.md)
- **Multi-Cloud Patterns**: [MULTICLOUD_PATTERNS.md](MULTICLOUD_PATTERNS.md)
- **Official Resources**: [OFFICIAL_RESOURCES.md](OFFICIAL_RESOURCES.md)

---

## External References

- [CyberArk Conjur Documentation](https://docs.conjur.org/)
- [Conjur OSS GitHub](https://github.com/cyberark/conjur)
- [Secretless Broker](https://secretless.io/)
- [AWS IAM Authenticator](https://docs.conjur.org/Latest/en/Content/Integrations/Authn-IAM/IAM-authenticator.htm)
- [Azure AD Authenticator](https://docs.conjur.org/Latest/en/Content/Integrations/Authn-Azure/azure-authenticator.htm)

---

**Last Updated**: 2025-12-04
**Version**: 1.0
