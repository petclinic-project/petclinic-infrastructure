# Bootstrap Guide

This guide explains how to bootstrap the Petclinic platform from scratch.

---

# Step 1 — Deploy Infrastructure

Navigate to:

```bash
cd terraform/environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Review execution plan:

```bash
terraform plan
```

Apply infrastructure:

```bash
terraform apply
```

---

# Step 2 — Configure kubectl

Return to repository root:

```bash
cd ../../..
```

Update kubeconfig:

```bash
./scripts/bootstrap/update-kubeconfig.sh
```

Verify cluster access:

```bash
kubectl get nodes
```

---

# Step 3 — Bootstrap ArgoCD

Run:

```bash
./scripts/bootstrap/bootstrap-platform.sh
```

Verify:

```bash
kubectl get pods -n argocd
```

---

# Step 4 — Install External Secrets Operator

Run:

```bash
./scripts/bootstrap/install-external-secrets.sh
```

Verify:

```bash
kubectl get pods -n external-secrets
```

---

# Step 5 — Install AWS Load Balancer Controller

Run:

```bash
./scripts/bootstrap/install-aws-load-balancer-controller.sh
```

Verify:

```bash
kubectl get pods -n kube-system
```

---

# Step 6 — Bootstrap ArgoCD Applications

Run:

```bash
./scripts/bootstrap/bootstrap-apps.sh
```

Verify:

```bash
kubectl get applications -n argocd
```

---

# Step 7 — Validate Platform

Run:

```bash
./scripts/validate/validate-cluster.sh
```

---

# Expected Result

The following components should become available:

- EKS cluster
- ArgoCD
- External Secrets Operator
- AWS Load Balancer Controller
- Petclinic workloads
- Application Load Balancer
- petclinic.praty.dev

---

# Notes

- ArgoCD handles continuous deployment (CD).
- GitHub Actions handles continuous integration (CI).
- Docker images are stored in AWS ECR.
- Secrets are synchronized from AWS Secrets Manager.
