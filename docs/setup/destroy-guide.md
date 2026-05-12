# Destroy Guide

This guide explains how to safely destroy the Petclinic platform infrastructure.

---

# Important Warning

Running Terraform destroy will remove:

- EKS cluster
- Kubernetes workloads
- Load balancers
- RDS database
- VPC resources
- Security groups
- Platform controllers
- ArgoCD workloads

This operation is destructive.

---

# Recommended Pre-Destroy Checklist

Before destroying infrastructure:

- Ensure all Git changes are pushed to GitHub.
- Verify Terraform state backend is healthy.
- Verify important secrets are stored safely.
- Confirm no critical workloads are running.
- Ensure recovery documentation is available.

---

# Step 1 — Navigate to Terraform Environment

```bash
cd terraform/environments/dev
```

---

# Step 2 — Review Current Infrastructure

```bash
terraform state list
```

---

# Step 3 — Review Destroy Plan

```bash
terraform plan -destroy
```

---

# Step 4 — Destroy Infrastructure

```bash
terraform destroy
```

---

# Step 5 — Verify Resource Cleanup

Verify:

- EKS cluster removed
- Load balancers deleted
- Security groups deleted
- RDS removed
- VPC removed

Example verification commands:

```bash
aws eks list-clusters --region ap-south-1
```

```bash
aws ec2 describe-vpcs --region ap-south-1
```

```bash
aws elbv2 describe-load-balancers --region ap-south-1
```

---

# Common Issues

## Security Groups Not Deleting

Cause:
- Load balancers still attached
- ENIs still attached
- Controller cleanup delay

Recommended action:
- Wait several minutes
- Re-run Terraform destroy
- Verify ENIs are deleted

---

# Recovery

To rebuild the platform after destruction:

Refer to:

```text
docs/setup/bootstrap-guide.md
```

---

# Notes

- Terraform remote state remains stored in S3.
- Git repositories remain unchanged.
- GitHub Actions configuration remains intact.
- ArgoCD applications are recreated during bootstrap.
