resource "aws_lb" "alb" {
  name               = "production-3tier-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = [aws_subnet.subnets["public_az1"].id, aws_subnet.subnets["public_az2"].id]

  enable_deletion_protection = false

  tags = {
    Name = "production-3tier-alb"
  }
}
