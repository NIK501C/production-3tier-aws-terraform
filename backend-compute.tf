# Backend Launch Template
resource "aws_launch_template" "backend" {
  name_prefix   = "production-3tier-backend"
  image_id      = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -eux

    apt-get update -y
    apt-get install -y python3

    mkdir -p /opt/backend

    cat > /opt/backend/app.py <<'PYTHON'
    from http.server import BaseHTTPRequestHandler, HTTPServer

    class BackendHandler(BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"Backend application is running successfully.")

    def main():
        HTTPServer(("0.0.0.0", 8080), BackendHandler).serve_forever()

    if __name__ == "__main__":
        main()
    PYTHON

    cat > /etc/systemd/system/backend.service << "SERVICE"
    [Unit]
    Description = Production 3-Tier Backend Test Service
    After = network.target

    [Service]
    ExecStart = /usr/bin/python3 /opt/backend/app.py
    Restart = always
    RestartSec = 5

    [Install]
    WantedBy = multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable --now backend.service
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "production-3tier-backend"
      Tier = "backend"
    }
  }
}

# Backend Auto Scaling Group
resource "aws_autoscaling_group" "backend" {
  name             = "production-3tier-backend-asg"
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.subnets["backend_az1"].id,
    aws_subnet.subnets["backend_az2"].id
  ]

  health_check_type         = "EC2"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "production-3tier-backend"
    propagate_at_launch = true
  }
}