# ADR-0004 — Networking Strategy

## Status

Accepted

## Context

The platform requires a production-realistic networking architecture while maintaining strict cost optimization for a temporary showcase environment.

The infrastructure must support:

* EKS Auto Mode
* AWS ALB ingress
* GitOps delivery
* RDS database isolation
* observability tooling
* public HTTPS access

while avoiding unnecessary operational and financial overhead.

## Decision

Use a hybrid subnet architecture:

* Public subnets for ALB and EKS worker nodes
* Private isolated subnets for RDS
* No NAT Gateway

## Rationale

### Public Worker Nodes

Public EKS worker nodes significantly reduce infrastructure cost by eliminating NAT Gateway requirements.

Security is maintained through:

* restrictive security groups
* no SSH exposure
* IAM least privilege
* IRSA
* Kubernetes RBAC
* HTTPS-only ingress

### Private Database Subnets

The database layer is isolated into private subnets to demonstrate proper network segmentation and reduce exposure risk.

RDS does not require outbound internet access, allowing private subnets without NAT Gateway dependency.

## Consequences

### Advantages

* Lower monthly AWS cost
* Cleaner network segmentation
* Production-realistic architecture
* Easier operational explanation
* Reduced attack surface for database layer

### Tradeoffs

* Worker nodes remain publicly routable
* Less enterprise-grade isolation than fully private clusters
* Requires careful security group management

## Alternatives Considered

### Fully Private Architecture with NAT Gateway

Rejected due to unnecessary cost overhead for a temporary learning/showcase platform.

### Fully Public Architecture

Rejected because database isolation remains an important production design principle.
