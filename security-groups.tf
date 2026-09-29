resource "aws_security_group" "alb_sg" {
  name        = "production-3tier-alb-sg"
  description = " Security group for the Application load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-3tier-alb-sg"
  }
}

resource "aws_security_group" "frontend_sg" {
  name        = "production-3tier-frontend-sg"
  description = "Security group for the frontend EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-3tier-frontend-sg"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "production-3tier-backend-sg"
  description = "Security group for the backend EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow backend traffic from the frontend"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-3tier-backend-sg"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "production-3tier-database-sg"
  description = "Security group for the database"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow PostgreSQL database traffic from the backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production-3tier-database-sg"
  }
}