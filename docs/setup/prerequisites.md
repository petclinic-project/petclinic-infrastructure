# Prerequisites

Before setting up the Petclinic platform, ensure the following tools and accounts are configured properly.

---

# Required Tools

## AWS CLI

Install AWS CLI v2:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Verify installation:

```bash
aws --version
```

Configure credentials:

```bash
aws configure
```

## Terraform

Required version:

```
>= 1.6.0
```
Verify:

```
terraform version
```

Install guide:

https://developer.hashicorp.com/terraform/install

## kubectl

Install kubectl:

https://kubernetes.io/docs/tasks/tools/

Verify:

```bash
kubectl version --client
```

## Helm

Install Helm v3:

https://helm.sh/docs/intro/install/

Verify:

```bash
helm version
```

## Git

Verify:

```
git --version
```

# Required AWS Resources

## Route53 Hosted Zone

A Route53 hosted zone is required.

Example:

```
praty.dev
```

## ACM Certificate

An ACM certificate must exist in the same AWS region as the ALB.

Example region:

```
ap-south-1
```

## GitHub Repository Secrets

The following GitHub Actions secrets are required:

| Secret | Purpose |
|---|---|
| INFRA_REPO_TOKEN | Push image tag updates to infrastructure repo |

# Required Permissions

The AWS account/user should have permissions for:

  - EKS
  - EC2
  - IAM
  - ECR
  - RDS
  - Route53
  - ACM
  - Secrets Manager
  - CloudFormation

# Recommended Environment

- Ubuntu / WSL2
- Minimum 8GB RAM
- Stable internet connection
