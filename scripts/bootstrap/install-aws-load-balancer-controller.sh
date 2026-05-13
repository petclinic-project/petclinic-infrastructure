#!/bin/bash

set -e

CLUSTER_NAME="pc-eks-dev"
REGION="ap-south-1"
VPC_ID=$(aws eks describe-cluster \
  --name ${CLUSTER_NAME} \
  --region ${REGION} \
  --query "cluster.resourcesVpcConfig.vpcId" \
  --output text)

echo "========================================"
echo "INSTALLING AWS LOAD BALANCER CONTROLLER"
echo "========================================"

helm repo add eks https://aws.github.io/eks-charts

helm repo update

helm upgrade --install aws-load-balancer-controller \
  eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName=${CLUSTER_NAME} \
  --set serviceAccount.create=true \
  --set region=${REGION} \
  --set vpcId=${VPC_ID}

echo ""
echo "Waiting for AWS Load Balancer Controller..."

kubectl rollout status deployment aws-load-balancer-controller \
  -n kube-system \
  --timeout=300s

echo ""
echo "AWS Load Balancer Controller installed successfully."
