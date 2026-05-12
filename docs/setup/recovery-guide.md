# Recovery Guide

This guide explains how to recover the Petclinic platform after infrastructure loss or cluster destruction.

---

# Recovery Philosophy

The platform is designed to be reproducible using:

- Terraform
- GitOps
- ArgoCD
- Kubernetes manifests
- Bootstrap automation scripts

All desired state is stored in Git repositories.

---

# Recovery Scenarios

| Scenario | Recovery Method |
|---|---|
| EKS cluster deleted | Recreate infrastructure + bootstrap |
| ArgoCD deleted | Re-run platform bootstrap |
| Workloads deleted | ArgoCD self-healing |
| Load balancer deleted | Ingress reconciliation |
| Pods crashing | Kubernetes reconciliation |
| Node failure | EKS managed replacement |

---

# Step 1 — Recreate Infrastructure

Navigate to:

```bash
cd terraform/environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Apply infrastructure:

```bash
terraform apply
```

---

# Step 2 — Reconfigure kubectl

Return to repository root:

```bash
cd ../../..
```

Update kubeconfig:

```bash
./scripts/bootstrap/update-kubeconfig.sh
```

Verify:

```bash
kubectl get nodes
```

---

# Step 3 — Reinstall Platform Components

Bootstrap ArgoCD:

```bash
./scripts/bootstrap/bootstrap-platform.sh
```

Install External Secrets:

```bash
./scripts/bootstrap/install-external-secrets.sh
```

Install AWS Load Balancer Controller:

```bash
./scripts/bootstrap/install-aws-load-balancer-controller.sh
```

---

# Step 4 — Restore GitOps Applications

Run:

```bash
./scripts/bootstrap/bootstrap-apps.sh
```

Verify:

```bash
kubectl get applications -n argocd
```

---

# Step 5 — Validate Recovery

Run:

```bash
./scripts/validate/validate-cluster.sh
```

---

# Expected Recovery Result

The following should recover automatically:

- Kubernetes namespaces
- Deployments
- Services
- Ingress resources
- AWS Load Balancer
- Secrets synchronization
- Petclinic workloads

---

# Important Notes

- GitHub Actions pipelines remain functional after recovery.
- ArgoCD automatically reconciles desired cluster state.
- Terraform remote state remains preserved in S3.
- Secrets remain stored in AWS Secrets Manager.

---

# Operational Recommendations

- Always commit infrastructure changes to Git.
- Avoid manual Kubernetes drift when possible.
- Prefer declarative changes over imperative changes.
- Validate cluster health after recovery.
