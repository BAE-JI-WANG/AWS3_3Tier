# ALB
resource "aws_lb" "awsome-ap2-was-nlb" {
    name               = "awsome-ap2-wab-nlb"
    internal           = true
    load_balancer_type = "network"

    subnets            = [aws_subnet.awesome-ap-was-sub-2a.id, aws_subnet.awesome-ap-was-sub-2c.id]
    tags = {
        "Name" = "awsome-ap2-was-nlb"
    }
}

# Target Group
resource "aws_lb_target_group" "awsome-ap2-was-tg" {
    name     = "awsome-ap2-was-tg"
    port     = 8009
    protocol = "TCP"
    vpc_id   = aws_vpc.awesome-vpc.id

    tags = {
        "Name" = "awsome-ap2-was-tg"
    }
}

resource "aws_lb_target_group_attachment" "awsome-ap2-was-tg-att" {
    target_group_arn = aws_lb_target_group.awsome-ap2-was-tg.arn
    target_id = aws_launch_configuration.awsome-ap2-was-conf.id
    port = 8009
}

resource "aws_lb_listener" "awsome-ap2-was-nlb-listen" {
    load_balancer_arn = aws_lb.awsome-ap2-was-nlb.arn
    port = 8009
    protocol = "TCP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.awsome-ap2-was-tg.arn
    }
}

# Launch Configuration
resource "aws_launch_configuration" "awsome-ap2-was-conf" {
    name_prefix     = "awsome-ap2-was-"
    image_id        = var.was_ami
    instance_type   = "t2.micro"
    user_data       = <<EOF
#!/bin/bash
sudo su
source /etc/profile
cd /mnt/efs/app/spring-petclinic/target/
java -jar -Dspring.profiles.active="mysql" *.jar
EOF
    security_groups = [aws_security_group.awesome-ap2-was-sg.id]
    lifecycle {
        create_before_destroy = true
    }
}

# Auto Scaling group
resource "aws_autoscaling_group" "awsome-ap2-was-as" {
    min_size             = 4
    max_size             = 8
    desired_capacity     = 4
    launch_configuration = aws_launch_configuration.awsome-ap2-was-conf.name
    vpc_zone_identifier  = [aws_subnet.awesome-ap-was-sub-2a.id, aws_subnet.awesome-ap-was-sub-2c.id]
}