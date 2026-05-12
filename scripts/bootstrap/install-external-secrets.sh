#!/bin/bash

set -e

echo "========================================"
echo "INSTALLING EXTERNAL SECRETS OPERATOR"
echo "========================================"

helm repo add external-secrets https://charts.external-secrets.io

helm repo update

kubectl create namespace external-secrets \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install external-secrets \
  external-secrets/external-secrets \
  --namespace external-secrets \
  --set serviceAccount.create=false \
  --set serviceAccount.name=external-secrets-sa

echo ""
echo "Waiting for External Secrets deployment..."

kubectl rollout status deployment external-secrets \
  -n external-secrets \
  --timeout=300s

echo ""
echo "External Secrets installed successfully."
