resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  identifier           = "database1"
  engine               = "mysql"
  engine_version       = "8.0.32"
  instance_class       = "db.t3.micro"
  db_name                 = "databasetest"
  username             = "admin"
  password             = "admin123"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
} 
resource "aws_security_group" "mysql_sg" {
  name        = "mysql"
  description = "Allow mysql inbound traffic"
  vpc_id      = "vpc-014fbb6547d6bdbe3"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  }