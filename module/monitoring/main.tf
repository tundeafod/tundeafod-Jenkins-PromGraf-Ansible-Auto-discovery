# Create prometheus & grafana Server
resource "aws_instance" "promgraf-server" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  key_name                    = var.keypair
  vpc_security_group_ids      = [var.promgraf-sg]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.monitoring_instance_profile.name
   user_data                  = local.monitoring-script
  tags = {
    Name = var.name
  }
}

resource "aws_iam_role" "monitoring_role" {
  name               = "monitoring_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "ec2_read_only_policy" {
  name        = "EC2ReadOnlyPolicy"
  description = "Policy for granting read-only access to Amazon EC2 resources"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "ec2:Describe*",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "monitoring_ec2_read_only_attachment" {
  role       = aws_iam_role.monitoring_role.name
  policy_arn = aws_iam_policy.ec2_read_only_policy.arn
}
resource "aws_iam_instance_profile" "monitoring_instance_profile" {
  name = "monitoring_instance_profile"
  role = aws_iam_role.monitoring_role.name 
}

resource "aws_elb" "prom" {
  name            = "elb-prom"
  subnets         = var.elb-subnets
  security_groups = [var.promgraf-sg]
  listener {
    instance_port      = 9090
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.cert-arn
  }
    listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9090"
    interval            = 30
  }


  instances                   = [aws_instance.promgraf-server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "prom-elb"
  }
}

resource "aws_elb" "graf" {
  name            = "elb-graf"
  subnets         = var.elb-subnets
  security_groups = [var.promgraf-sg]
  listener {
    instance_port      = 3000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.cert-arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:3000"
    interval            = 30
  }


  instances                   = [aws_instance.promgraf-server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "graf-elb"
  }
}

resource "aws_elb" "nodeexporter" {
  name            = "elb-nodeexporter"
  subnets         = var.elb-subnets
  security_groups = [var.promgraf-sg]
  listener {
    instance_port      = 9100
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.cert-arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9100"
    interval            = 30
  }


  instances                   = [aws_instance.promgraf-server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "nodeexporter-elb"
  }
}