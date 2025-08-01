# Database Subnet Group with two private subnets for high availability# DB Subnet Group (only one instance of this resource)
resource "aws_db_subnet_group" "saffire-dev_subnet_group" {
  name       = "saffire-dev-app-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id] # Use private subnets

  tags = {
    Name = "saffire-dev-app-db-subnet-group"
  }
}

# Security Group for the Database to control access
resource "aws_security_group" "saffire-dev_db_sg" {
  name   = "saffire-dev-app-db-sg"
  vpc_id = aws_vpc.saffire-dev.id # Corrected VPC reference

  # Allow MySQL access (port 3306) from the web server's security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_web_sg.id] # Reference the web server security group
  }

  # Allow outbound traffic to any destination
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Instance for the application database
resource "aws_db_instance" "saffire-dev_db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql" # Change to your desired database engine
  engine_version         = "8.0"   # Specify the desired version
  instance_class         = "db.t3.micro"
  db_name                = "saffiredevdb"  # Corrected to use db_name
  username               = "admin"       # Username for the database
  password               = "password123" # Replace with a secure password
  db_subnet_group_name   = aws_db_subnet_group.saffire-dev_subnet_group.name
  vpc_security_group_ids = [aws_security_group.saffire-dev_db_sg.id] # Reference to the security group for RDS

  skip_final_snapshot = true

  tags = {
    Name = "saffire-dev_db"
  }
}