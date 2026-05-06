#!/bin/bash
set -e

REGION="ap-south-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="pc-tfstate-${ACCOUNT_ID}-${REGION}"
TABLE_NAME="pc-tfstate-locks"

echo "Creating S3 bucket: ${BUCKET_NAME} in ${REGION}..."
if ! aws s3api head-bucket --bucket "${BUCKET_NAME}" 2>/dev/null; then
    aws s3api create-bucket \
        --bucket "${BUCKET_NAME}" \
        --region "${REGION}" \
        --create-bucket-configuration LocationConstraint="${REGION}"
    
    # Enable versioning (Crucial for recovering from corrupted state)
    aws s3api put-bucket-versioning \
        --bucket "${BUCKET_NAME}" \
        --versioning-configuration Status=Enabled
        
    # Enable encryption
    aws s3api put-bucket-encryption \
        --bucket "${BUCKET_NAME}" \
        --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

    # Block all public access (Security Best Practice)
    aws s3api put-public-access-block \
        --bucket "${BUCKET_NAME}" \
        --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    echo "S3 Bucket created and secured."
else
    echo "S3 Bucket already exists."
fi

echo "Creating DynamoDB table: ${TABLE_NAME}..."
if ! aws dynamodb describe-table --table-name "${TABLE_NAME}" --region "${REGION}" 2>/dev/null; then
    aws dynamodb create-table \
        --table-name "${TABLE_NAME}" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region "${REGION}" > /dev/null
    
    # Wait for the table to become active
    aws dynamodb wait table-exists --table-name "${TABLE_NAME}" --region "${REGION}"
    echo "DynamoDB table created and active."
else
    echo "DynamoDB table already exists."
fi

echo ""
echo "✅ Bootstrap Complete!"
echo "Your S3 Bucket Name: ${BUCKET_NAME}"
echo "Your DynamoDB Table Name: ${TABLE_NAME}"
