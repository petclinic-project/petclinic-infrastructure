# Petclinic Platform on AWS

Production-style platform engineering project for Spring Petclinic Microservices using AWS, Terraform, Kubernetes, GitHub Actions, ArgoCD, and GitOps principles.

---

# Architecture Overview

This platform provisions and manages:

- Amazon EKS cluster
- Amazon ECR repositories
- Amazon RDS MySQL
- AWS Load Balancer Controller
- External Secrets Operator
- ArgoCD GitOps workflows
- GitHub Actions CI pipelines
- Kubernetes-based microservices deployments

---

# Technology Stack

| Layer | Technology |
|---|---|
| Cloud | AWS |
| Infrastructure as Code | Terraform |
| Container Orchestration | Kubernetes (EKS) |
| GitOps | ArgoCD |
| CI | GitHub Actions |
| Container Registry | Amazon ECR |
| Database | Amazon RDS MySQL |
| Secrets Management | AWS Secrets Manager |
| Ingress | AWS Load Balancer Controller |
| Packaging | Helm + Kustomize |

---

# Repository Structure

```text
.
├── terraform/         # Infrastructure as Code
├── kubernetes/        # Kubernetes manifests
├── argocd/            # GitOps applications and projects
├── scripts/           # Bootstrap and validation scripts
├── docs/              # Operational documentation
├── helm/              # Helm charts
└── monitoring/        # Observability stack
```

---

# Environment Strategy

| Environment | Purpose |
|---|---|
| dev | Development and testing |
| prod | Production-style deployment |

Infrastructure state is isolated per environment.

---

# CI/CD Architecture

## Continuous Integration (CI)

GitHub Actions handles:

- Maven builds
- Docker image builds
- Docker image pushes to ECR
- Infrastructure repository image tag updates

---

## Continuous Deployment (CD)

ArgoCD handles:

- Kubernetes reconciliation
- GitOps synchronization
- Drift correction
- Automated deployments

---

# Bootstrap Workflow

## 1. Provision Infrastructure

```bash
cd terraform/environments/dev

terraform init
terraform apply
```

---

## 2. Configure kubectl

```bash
./scripts/bootstrap/update-kubeconfig.sh
```

---

## 3. Bootstrap Platform

```bash
./scripts/bootstrap/bootstrap-platform.sh
```

---

## 4. Install Platform Controllers

```bash
./scripts/bootstrap/install-external-secrets.sh

./scripts/bootstrap/install-aws-load-balancer-controller.sh
```

---

## 5. Bootstrap GitOps Applications

```bash
./scripts/bootstrap/bootstrap-apps.sh
```

---

# Documentation

Detailed operational documentation:

| Document | Purpose |
|---|---|
| docs/setup/prerequisites.md | Required tools and accounts |
| docs/setup/local-setup.md | Local environment preparation |
| docs/setup/bootstrap-guide.md | Full platform bootstrap |
| docs/setup/destroy-guide.md | Safe infrastructure destruction |
| docs/setup/recovery-guide.md | Disaster recovery workflow |

---

# GitOps Principles

- Desired cluster state is stored in Git.
- ArgoCD continuously reconciles workloads.
- Infrastructure is declarative and reproducible.
- Platform recovery is script-driven and documented.

---

# Current Features

- Multi-environment architecture
- GitOps-based deployments
- Dynamic GitHub Actions pipelines
- Selective microservice builds
- OIDC-based AWS authentication
- External Secrets integration
- AWS ALB ingress integration
- Terraform modular infrastructure

---

# Future Improvements

- Full Helm-based workload deployments
- Observability stack (Prometheus + Grafana)
- Centralized logging
- Distributed tracing
- Automated rollback workflows
- Production-grade monitoring and alerting

---

# Domain

Example deployment:

```text
petclinic.praty.dev
```
