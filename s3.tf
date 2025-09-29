# --- Primary S3 Bucket ---
resource "aws_s3_bucket" "primary" {
  bucket = "${var.s3_primary_bucket_prefix}-${random_string.bucket_suffix.result}"
  tags   = { Name = "DR-S3-Primary" }
}

# Enable versioning on Primary bucket
resource "aws_s3_bucket_versioning" "primary_versioning" {
  bucket = aws_s3_bucket.primary.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Public access block for Primary
resource "aws_s3_bucket_public_access_block" "primary_block" {
  bucket                  = aws_s3_bucket.primary.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- Secondary S3 Bucket ---
resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary
  bucket   = "${var.s3_secondary_bucket_prefix}-${random_string.bucket_suffix.result}"
  tags     = { Name = "DR-S3-Secondary" }
}

# Enable versioning on Secondary bucket
resource "aws_s3_bucket_versioning" "secondary_versioning" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Public access block for Secondary
resource "aws_s3_bucket_public_access_block" "secondary_block" {
  provider                 = aws.secondary
  bucket                   = aws_s3_bucket.secondary.id
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
}

# --- IAM Role for Replication ---
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "s3.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for replication
resource "aws_iam_role_policy" "replication_policy" {
  role   = aws_iam_role.replication_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${aws_s3_bucket.primary.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "${aws_s3_bucket.secondary.arn}/*"
      }
    ]
  })
}

# --- Cross-Region Replication ---
resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.primary.id
  role   = aws_iam_role.replication_role.arn

rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.secondary.arn
      storage_class = "STANDARD"
    }

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Disabled"
    }
  }
}
