# DB Subnet Group (for high availability)
resource "aws_db_subnet_group" "saffire-prod_subnet_group" {
  name       = "saffire-prod-app-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "saffire-prod-app-db-subnet-group"
  }
}

# DB Security Group
resource "aws_security_group" "saffire-prod_db_sg" {
  name   = "saffire-prod-app-db-sg"
  vpc_id = aws_vpc.saffire-prod.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# RDS Instance
resource "aws_db_instance" "saffire-prod_db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "saffireproddb"
  username               = "admin"
  password               = "password123"
  db_subnet_group_name   = aws_db_subnet_group.saffire-prod_subnet_group.name
  vpc_security_group_ids = [aws_security_group.saffire-prod_db_sg.id]

  skip_final_snapshot = true

  tags = {
    Name = "saffire-prod-db"
  }
}
