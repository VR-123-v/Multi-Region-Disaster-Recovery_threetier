# ---------- PRIMARY REGION VPC ----------
resource "aws_vpc" "vpc_primary" {
  provider             = aws.primary
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "DR-VPC-Primary" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.vpc_primary.id
  tags     = { Name = "DR-IGW-Primary" }
}

# Public Web Subnets
resource "aws_subnet" "public_web_az1" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.vpc_primary.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.primary_region}a"
  map_public_ip_on_launch = true
  tags                    = { Name = "Public-Web-AZ1" }
}

resource "aws_subnet" "public_web_az2" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.vpc_primary.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.primary_region}b"
  map_public_ip_on_launch = true
  tags                    = { Name = "Public-Web-AZ2" }
}

# Private App Subnets
resource "aws_subnet" "private_app_az1" {
  provider          = aws.primary
  vpc_id            = aws_vpc.vpc_primary.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.primary_region}a"
  tags              = { Name = "Private-App-AZ1" }
}

resource "aws_subnet" "private_app_az2" {
  provider          = aws.primary
  vpc_id            = aws_vpc.vpc_primary.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.primary_region}b"
  tags              = { Name = "Private-App-AZ2" }
}

# Private DB Subnets
resource "aws_subnet" "private_db_az1" {
  provider          = aws.primary
  vpc_id            = aws_vpc.vpc_primary.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "${var.primary_region}a"
  tags              = { Name = "Private-DB-AZ1" }
}

resource "aws_subnet" "private_db_az2" {
  provider          = aws.primary
  vpc_id            = aws_vpc.vpc_primary.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "${var.primary_region}b"
  tags              = { Name = "Private-DB-AZ2" }
}

# ---------- SECONDARY REGION VPC ----------
resource "aws_vpc" "vpc_secondary" {
  provider             = aws.secondary
  cidr_block           = var.vpc_cidr_secondary
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "DR-VPC-Secondary" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.vpc_secondary.id
  tags     = { Name = "DR-IGW-Secondary" }
}

# Public Web Subnets Secondary
resource "aws_subnet" "public_web_az1_secondary" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.vpc_secondary.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "${var.secondary_region}a"
  map_public_ip_on_launch = true
  tags                    = { Name = "Public-Web-AZ1-Secondary" }
}

resource "aws_subnet" "public_web_az2_secondary" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.vpc_secondary.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "${var.secondary_region}b"
  map_public_ip_on_launch = true
  tags                    = { Name = "Public-Web-AZ2-Secondary" }
}

# Private App Subnets Secondary
resource "aws_subnet" "private_app_az1_secondary" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.vpc_secondary.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "${var.secondary_region}a"
  tags              = { Name = "Private-App-AZ1-Secondary" }
}

resource "aws_subnet" "private_app_az2_secondary" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.vpc_secondary.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "${var.secondary_region}b"
  tags              = { Name = "Private-App-AZ2-Secondary" }
}

# Private DB Subnets Secondary
resource "aws_subnet" "private_db_az1_secondary" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.vpc_secondary.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = "${var.secondary_region}a"
  tags              = { Name = "Private-DB-AZ1-Secondary" }
}

resource "aws_subnet" "private_db_az2_secondary" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.vpc_secondary.id
  cidr_block        = "10.1.6.0/24"
  availability_zone = "${var.secondary_region}b"
  tags              = { Name = "Private-DB-AZ2-Secondary" }
}
