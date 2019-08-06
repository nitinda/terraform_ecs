resource "aws_alb" "demo_ecs_ec2_ebs_load_balancer" {
    name                = "tf-demo-ecs-ec2-ebs-alb"
    security_groups     = ["${aws_security_group.demo_ecs_ec2_ebs_security_group_alb.id}"]
    subnets             = ["${var.public_subnet_ids}"]

    tags = "${merge(var.common_tags, map(
        "Name", "tf-demo-ecs-ec2-ebs-alb",
    ))}"
}

resource "aws_alb_target_group" "demo_ecs_target_group_instance_ebs" {
    name                = "tf-demo-ecs-ec2-tg-instance-ebs"
    port                = "8080"
    protocol            = "HTTP"
    vpc_id              = "${var.vpc_id}"
    health_check {
        healthy_threshold   = "2"
        unhealthy_threshold = "2"
        interval            = "5"
        matcher             = "200"
        path                = "/login"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "3"
    }
    deregistration_delay = 5
    lifecycle {
        create_before_destroy = true
    }
    tags = "${merge(var.common_tags, map(
        "Name", "tf-demo-ecs-tg-instance-ebs",
    ))}"
}

resource "aws_alb_listener" "demo_alb_listener" {
    load_balancer_arn = "${aws_alb.demo_ecs_ec2_ebs_load_balancer.arn}"
    # port              = "443"
    # protocol          = "HTTPS"
    # ssl_policy        = "ELBSecurityPolicy-2016-08"
    # certificate_arn   = "${var.certificate_arn}"
    depends_on        = ["aws_alb.demo_ecs_ec2_ebs_load_balancer"]
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.demo_ecs_target_group_instance_ebs.arn}"
        type             = "forward"
    }
}

