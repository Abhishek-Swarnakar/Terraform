
//ASG SG FOR EC2 TEMPLATE
resource "aws_security_group" "ASG_SG" {
    name = var.ASG_NAME
    description = "ALLOW SSH &  HTTP traffic"
    vpc_id = var.vpc_id
    

    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol= "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol= "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

  
}
// EC2 KEY PAIR
/*
resource "aws_key_pair" "example" {
  key_name   = "LOGIN2"  
  public_key = file("C:/Users/ABHISHEK/.ssh/id_rsa.pub")
}*/

data "aws_key_pair" "example" {
  key_name = "LOGIN"
}


//EC2 LAUNCH TEMPLATE

resource "aws_launch_template" "ASG-TEMPLATE" {
    name_prefix = var.ASG_NAME
    image_id = var.EC2_IMAGE
    instance_type = var.EC2_TYPE
    key_name = data.aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.ASG_SG.id]
}

//ASG CONFIGURATION

resource "aws_autoscaling_group" "ASG" {
    
    name = var.NAME
    max_size = var.MAX_CAPACITY
    min_size = var.MIN_CAPACITY
    desired_capacity = var.DESIRED_CAPACITY
    vpc_zone_identifier =  var.private_subnet_ids

    target_group_arns = [aws_alb_target_group.ALB_TG.arn]

    launch_template {
      id = aws_launch_template.ASG-TEMPLATE.id
      version = "$Latest"
    }
}

//ALB

resource "aws_lb" "ALB" {
    name = var.ALB_NAME
    load_balancer_type = "application"
    subnets = var.public_subnet_ids
    security_groups = [aws_security_group.ASG_SG.id]
  
}

//TARGET GROUP

resource "aws_alb_target_group" "ALB_TG" {
    name =var.ASG_NAME
    port = 8000
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
      enabled = true
      healthy_threshold = 3
      unhealthy_threshold = 10
      timeout = 5
      interval = 10
      path = "/"
      port = "traffic-port"
    }
  
}

//LISTENER

resource "aws_alb_listener" "LISTENER" {
    load_balancer_arn = aws_lb.ALB.arn
    port = 80
    protocol = "HTTP"

    default_action {
      target_group_arn = aws_alb_target_group.ALB_TG.arn
      type = "forward"
    }
  
}

resource "aws_alb_listener_rule" "LISTENER_RULE" {
    listener_arn = aws_alb_listener.LISTENER.arn
    priority = 100

    action {
      target_group_arn = aws_alb_target_group.ALB_TG.arn
      type = "forward"
    }

    condition {
    path_pattern {
      values = ["/"]
    }
  }
  
}


