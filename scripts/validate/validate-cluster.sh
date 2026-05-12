#!/bin/bash

set -e

echo "========================================"
echo "VALIDATING PETCLINIC PLATFORM"
echo "========================================"

echo ""
echo "Checking Kubernetes nodes..."

kubectl get nodes

echo ""
echo "Checking namespaces..."

kubectl get ns

echo ""
echo "Checking ArgoCD pods..."

kubectl get pods -n argocd

echo ""
echo "Checking External Secrets pods..."

kubectl get pods -n external-secrets

echo ""
echo "Checking AWS Load Balancer Controller..."

kubectl get pods -n kube-system | grep aws-load-balancer-controller || true

echo ""
echo "Checking ArgoCD applications..."

kubectl get applications -n argocd || true

echo ""
echo "VALIDATION COMPLETED"
