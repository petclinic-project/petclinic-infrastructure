#!/bin/bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="ap-south-1"
BUCKET_NAME="pc-tfstate-${ACCOUNT_ID}-${REGION}"

echo "Creating S3 bucket: ${BUCKET_NAME}..."
aws s3api create-bucket \
    --bucket ${BUCKET_NAME} \
    --region ${REGION} \
    --create-bucket-configuration LocationConstraint=${REGION}

aws s3api put-bucket-versioning \
    --bucket ${BUCKET_NAME} \
    --versioning-configuration Status=Enabled

echo "Bucket created successfully: ${BUCKET_NAME}"
