# Find the latest ubuntu AMI ID
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/noble/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_launch_template" "frontend" {

  name_prefix   = "production-3tier-frontend"
  image_id      = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  user_data = base64encode(<<-EOF
      #!/bin/bash
      sudo apt-get update -y
      sudo apt-get install -y nginx
      sudo systemctl start nginx
      sudo systemctl enable nginx

      cat > /var/www/html/index.html <<'HTML'
      <html>
      <body>
      <h1>Production 3-Tier AWS Project</h1>
      <p>Frontend server is running successfully.</p>
      </body>
      </html>
      HTML
    EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "production-3tier-frontend"
      Tier = "frontend"
    }
  }
}

resource "aws_autoscaling_group" "frontend" {
  name             = "production-3tier-frontend-asg"
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.subnets["frontend_az1"].id,
  aws_subnet.subnets["frontend_az2"].id]

  target_group_arns = [aws_lb_target_group.frontend.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "production-3tier-frontend"
    propagate_at_launch = true
  }
}