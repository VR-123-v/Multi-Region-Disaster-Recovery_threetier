#!/bin/bash
# jenkins/scripts/s3-sync.sh

# Fetch S3 bucket names from Terraform outputs
PRIMARY_BUCKET=$(terraform -chdir=../terraform output -raw s3_primary_bucket_name)
SECONDARY_BUCKET=$(terraform -chdir=../terraform output -raw s3_secondary_bucket_name)

# Sync local web content to primary bucket
aws s3 sync ./web-content "s3://${PRIMARY_BUCKET}" --delete

# Optional: sync to secondary bucket (for DR)
aws s3 sync ./web-content "s3://${SECONDARY_BUCKET}" --delete
