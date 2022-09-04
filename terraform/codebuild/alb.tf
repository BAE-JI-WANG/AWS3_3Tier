# ALB
resource "aws_lb" "awsome-ap2-web-alb" {
    name               = "awsome-ap2-web-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.awesome-ap2-web-alb-sg.id]
    subnets            = [aws_subnet.awesome-ap-pub-sub-2a.id, aws_subnet.awesome-ap-pub-sub-2c.id]
    tags = {
        "Name" = "awsome-ap2-web-alb"
    }
}

# Target Group
resource "aws_lb_target_group" "awsome-ap2-web-tg" {
    name     = "awsome-ap2-web-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.awesome-vpc.id

    tags = {
        "Name" = "awsome-ap2-web-tg"
    }
}

resource "aws_lb_target_group_attachment" "awsome-ap2-web-tg-att" {
    target_group_arn = aws_lb_target_group.awsome-ap2-web-tg.arn
    target_id = aws_launch_configuration.awsome-ap2-web-conf.id
    port = 80
}

resource "aws_lb_listener" "awsome-ap2-web-alb-listen" {
    load_balancer_arn = aws_lb.awsome-ap2-web-alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.awsome-ap2-web-tg.arn
    }
}

# Launch Configuration
resource "aws_launch_configuration" "awsome-ap2-web-conf" {
    name_prefix     = "awsome-ap2-web-"
    image_id        = var.web_ami
    instance_type   = "t2.micro"
    user_data       = <<EOF
#!/bin/bash
sudo su
source /etc/profile
cd /mnt/efs/apache/bin/
./apachectl start
EOF
    security_groups = [aws_security_group.awesome-ap2-web-sg.id]
    lifecycle {
        create_before_destroy = true
    }
}

# Auto Scaling group
resource "aws_autoscaling_group" "awsome-ap2-web-as" {
    min_size             = 2
    max_size             = 4
    desired_capacity     = 2
    launch_configuration = aws_launch_configuration.awsome-ap2-web-conf.name
    vpc_zone_identifier  = [aws_subnet.awesome-ap-web-sub-2a.id, aws_subnet.awesome-ap-web-sub-2c.id]
}