# ---------- General ----------
variable "primary_region" {
  description = "Primary AWS region"
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region for disaster recovery"
  default     = "us-west-2"
}

# ---------- Networking ----------
variable "vpc_cidr" {
  description = "CIDR block for primary VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_secondary" {
  description = "CIDR block for secondary VPC"
  default     = "10.1.0.0/16"
}

# ---------- EC2 / Web Tier ----------
variable "web_ami" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0c94855ba95c71c99"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

# ---------- Database ----------
variable "db_username" {
  description = "RDS master username"
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  default     = "Password123!"
  sensitive   = true
}

# ---------- S3 Buckets ----------

# Primary S3 bucket (random suffix will be added)
variable "s3_primary_bucket_prefix" {
  description = "Primary S3 bucket name prefix (globally unique suffix will be appended)"
  default     = "primary-vr"
}

# Secondary S3 bucket (random suffix will be added)
variable "s3_secondary_bucket_prefix" {
  description = "Secondary S3 bucket name prefix (globally unique suffix will be appended)"
  default     = "secondary-vr"
}

# ---------- Route 53 ----------
variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for DNS failover"
  default     = "<YOUR_HOSTED_ZONE_ID>"
}
