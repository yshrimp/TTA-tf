resource "aws_db_subnet_group" "main" {
  name = "db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier = var.db_identifier

  allocated_storage = 20
  max_allocated_storage = 100
  storage_type = var.db_storage_type

  db_name = var.db_name
  username = var.db_username
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  
  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.db_sg_id
  publicly_accessible = false

  backup_retention_period = 7
  backup_window = "18:00-19:00"

  enabled_cloudwatch_logs_exports = [
    "error",
    "slowquery"
  ]

  multi_az = false
  deletion_protection = false
  skip_final_snapshot = true
  auto_minor_version_upgrade = true

  tags = {
    Name = var.db_identifier
  }

}