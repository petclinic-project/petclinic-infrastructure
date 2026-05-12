#!/bin/bash

set -e

CLUSTER_NAME="pc-eks-dev"
REGION="ap-south-1"

echo "Updating kubeconfig for cluster: ${CLUSTER_NAME}"

aws eks update-kubeconfig \
  --region ${REGION} \
  --name ${CLUSTER_NAME}

echo "Kubeconfig updated successfully."
