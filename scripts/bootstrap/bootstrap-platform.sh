#!/bin/bash

set -e

echo "========================================"
echo "BOOTSTRAPPING PETCLINIC PLATFORM"
echo "========================================"

echo ""
echo "Creating ArgoCD namespace..."

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Installing ArgoCD..."

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo ""
echo "Waiting for ArgoCD server deployment..."

kubectl rollout status deployment argocd-server \
  -n argocd \
  --timeout=300s

echo ""
echo "Waiting for ArgoCD repo server..."

kubectl rollout status deployment argocd-repo-server \
  -n argocd \
  --timeout=300s

echo ""
echo "Waiting for ArgoCD application controller..."

kubectl rollout status statefulset argocd-application-controller \
  -n argocd \
  --timeout=300s

echo ""
echo "ArgoCD installed successfully."

echo ""
echo "Current ArgoCD resources:"

kubectl get pods -n argocd

echo ""
echo "BOOTSTRAP STEP COMPLETED"
