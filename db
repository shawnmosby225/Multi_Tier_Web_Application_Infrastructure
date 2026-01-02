// 1. RDS DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.db[*].id // Uses Private DB Subnets
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

// 2. RDS Multi-AZ Instance
resource "aws_db_instance" "multi_az_db" {
  identifier                = "${var.project_name}-rds-db"
  allocated_storage         = 20
  engine                    = "mysql"
  engine_version            = "8.0"
  instance_class            = "db.t3.micro"
  db_name                   = "multiappdb"
  username                  = "admin"
  password                  = "yourStrongPassword123" 
  parameter_group_name      = "default.mysql8.0"
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.rds.id]
  multi_az                  = true 
  skip_final_snapshot       = true
  publicly_accessible       = false
}
