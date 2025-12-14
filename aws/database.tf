# Database Configuration - MySQL RDS

# ====================================================================
# RDS MySQL Database Instance
# ====================================================================

resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-db"
  
  # Engine Settings
  engine         = "mysql"
  engine_version = "8.0"
  
  # Resource Settings
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  
  # Credentials
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  # Network Settings
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  
  # Backup Settings
  backup_retention_period = 0
  backup_window          = "03:00-04:00"
  
  # Maintenance Settings
  maintenance_window         = "Mon:04:00-Mon:05:00"
  auto_minor_version_upgrade = true
  
  # Deletion Settings (for dev environment)
  skip_final_snapshot = true
  deletion_protection = false
  
  # Performance & Monitoring
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  
  # Parameter Group
  parameter_group_name = aws_db_parameter_group.main.name
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
    Purpose     = "Application Database"
  }
}

# ====================================================================
# DB Parameter Group
# ====================================================================

resource "aws_db_parameter_group" "main" {
  name        = "${var.project_name}-${var.environment}-mysql-params"
  family      = "mysql8.0"
  description = "MySQL parameter group"
  
  # Max concurrent connections
  parameter {
    name  = "max_connections"
    value = "100"
  }
  
  # Character set for multi-language support
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  
  # Collation
  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
  
  # Event scheduler
  parameter {
    name  = "event_scheduler"
    value = "ON"
  }
  
  # Slow query logging
  parameter {
    name  = "slow_query_log"
    value = "1"
  }
  
  # Slow query threshold (seconds)
  parameter {
    name  = "long_query_time"
    value = "2"
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-mysql-params"
  }
}