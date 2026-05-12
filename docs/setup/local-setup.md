# Local Setup Guide

This guide explains how to prepare the local development environment for the Petclinic platform.

---

# Clone Repositories

## Infrastructure Repository

```bash
git clone https://github.com/petclinic-project/petclinic-infrastructure.git
```

## Application Repository

```bash
git clone https://github.com/petclinic-project/spring-petclinic-microservices.git
```

---

# Repository Responsibilities

| Repository | Responsibility |
|---|---|
| petclinic-infrastructure | Terraform, Kubernetes manifests, ArgoCD, platform engineering |
| spring-petclinic-microservices | Spring Boot microservices source code |

---

# Configure AWS CLI

Verify AWS identity:

```bash
aws sts get-caller-identity
```

---

# Configure Terraform Backend

Navigate to:

```text
terraform/environments/dev
```

Initialize Terraform:

```bash
terraform init
```

---

# Configure kubectl

Update kubeconfig:

```bash
./scripts/bootstrap/update-kubeconfig.sh
```

---

# Verify Cluster Access

```bash
kubectl get nodes
```

---

# Verify Helm

```bash
helm version
```

---

# Verify ArgoCD Access

```bash
kubectl get pods -n argocd
```

---

# Recommended Workflow

1. Deploy infrastructure using Terraform
2. Update kubeconfig
3. Bootstrap platform components
4. Bootstrap ArgoCD applications
5. Validate cluster health
6. Push application changes through GitHub Actions

---

# Important Notes

- Infrastructure and application repositories are intentionally separated.
- ArgoCD is responsible for workload reconciliation.
- GitHub Actions is responsible for CI automation.
- AWS ECR stores Docker images.
- External Secrets Operator syncs secrets from AWS Secrets Manager.
