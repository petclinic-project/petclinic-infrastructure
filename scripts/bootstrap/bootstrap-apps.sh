#!/bin/bash

set -e

echo "========================================"
echo "BOOTSTRAPPING ARGOCD APPLICATIONS"
echo "========================================"

echo ""
echo "Applying ArgoCD project..."

kubectl apply -f argocd/projects/petclinic-project.yaml

echo ""
echo "Applying platform applications..."

kubectl apply -f argocd/platform/external-secrets.yaml
kubectl apply -f argocd/platform/aws-load-balancer-controller.yaml

echo ""
echo "Applying workload applications..."

kubectl apply -f argocd/apps/petclinic-dev.yaml

echo ""
echo "Waiting a few seconds for ArgoCD reconciliation..."

sleep 10

echo ""
echo "Current ArgoCD applications:"

kubectl get applications -n argocd

echo ""
echo "APPLICATION BOOTSTRAP COMPLETED"
