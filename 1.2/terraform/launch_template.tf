provider "aws" {
    profile = "default"
    region = "us-west-2"
}
#Security Group
resource "aws_security_group" "final-sg" {
  name        = "final-sg"
  vpc_id      = aws_vpc.final-vpc.id

  ingress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_ec2_fleet" "" {
  output_path = ""
  type = ""
  launch_template_config {
    launch_template_specification {
      version = ""
    }
  }
  target_capacity_specification {
    default_target_capacity_type = ""
    total_target_capacity = 0
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "final-gw" {
  vpc_id = aws_vpc.final-vpc.id
  tags = {
    Name = "main"
  }
}

resource "aws_vpc" "final-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Final-VPC"
  }
}

#Route table
resource "aws_route_table" "final-rt" {
  vpc_id = aws_vpc.final-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.final-gw.id
  }
}

resource "aws_main_route_table_association" "final-mrta" {
  vpc_id         = aws_vpc.final-vpc.id
  route_table_id = aws_route_table.final-rt.id
}

#Subnets
resource "aws_subnet" "final-subnet-1" {
  vpc_id     = aws_vpc.final-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Final-Subnet-1"
  }
}

resource "aws_subnet" "final-subnet-2" {
  vpc_id     = aws_vpc.final-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Final-Subnet-2"
  }
}

resource "aws_subnet" "final-subnet-3" {
  vpc_id     = aws_vpc.final-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "Final-Subnet-3"
  }
}
#Launch Conf
resource "aws_launch_configuration" "final-lc" {
  name_prefix   = "final-lc-"
  image_id = "ami-07dd19a7900a1f049"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.final-sg.id]
  associate_public_ip_address = true
  key_name = "mx-linux"
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
  lifecycle {
    create_before_destroy = true
  }
}

#Auto Scaling Policy
resource "aws_autoscaling_policy" "final-ap" {
  name = "final-ap"
  autoscaling_group_name = aws_autoscaling_group.final-asg.name
  #scaling_adjustment = 5
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

#Teraform Project
resource "aws_autoscaling_group" "final-asg" {
  name = "final-asg"
  launch_configuration = aws_launch_configuration.final-lc.name
  vpc_zone_identifier = [aws_subnet.final-subnet-1.id, aws_subnet.final-subnet-2.id]
  health_check_type         = "ELB"
  health_check_grace_period = 120
  max_size = 5
  min_size = 3
  load_balancers = [aws_elb.final-elb.id]

}

resource "aws_autoscaling_attachment" "final-asg-att" {
  elb = aws_elb.final-elb.name
  autoscaling_group_name = aws_autoscaling_group.final-asg.name
}
resource "aws_elb" "final-elb" {
  name = "final-elb"
  subnets = [aws_subnet.final-subnet-1.id, aws_subnet.final-subnet-2.id]
  #availability_zones = ["us-west-2a", "us-west-2b"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 10
    timeout             = 15
    target              = "HTTP:80/check/"
    interval            = 120
  }
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
  security_groups = [aws_security_group.final-sg.id]
//  security_groups = [aws_security_group.final-sg.id]
}
