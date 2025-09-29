# Primary region DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group_primary" {
  provider   = aws.primary
  name       = "db-subnet-group-primary"
  subnet_ids = [
    aws_subnet.private_db_az1.id,
    aws_subnet.private_db_az2.id
  ]
}

# Secondary region DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group_secondary" {
  provider   = aws.secondary
  name       = "db-subnet-group-secondary"
  subnet_ids = [
    aws_subnet.private_db_az1_secondary.id,
    aws_subnet.private_db_az2_secondary.id
  ]
}

# Primary DB Instance
resource "aws_db_instance" "primary_db" {
  provider               = aws.primary
  identifier             = "primary-db"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_primary.name
  vpc_security_group_ids = [aws_security_group.db_sg_primary.id]
  multi_az               = true
  skip_final_snapshot    = true
}

# Read Replica (Secondary DB)
resource "aws_db_instance" "replica_db" {
  provider               = aws.secondary
  identifier             = "replica-db"
  instance_class         = "db.t3.micro"

  # Must use ARN for cross-region replica
  replicate_source_db    = aws_db_instance.primary_db.arn

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_secondary.name
  vpc_security_group_ids = [aws_security_group.db_sg_secondary.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "Replica-DB"
  }
}

