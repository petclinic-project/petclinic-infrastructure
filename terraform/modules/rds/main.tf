resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-db-subnet-group-${var.environment}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project}-db-subnet-group-${var.environment}"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.project}-rds-${var.environment}"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "${var.project}-rds-${var.environment}"
  }
}
