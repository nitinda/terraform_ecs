resource "aws_alb" "demo_ecs_ec2_efs_load_balancer" {
    name                = "tf-demo-ecs-ec2-efs-alb"
    security_groups     = ["${aws_security_group.demo_ecs_ec2_efs_security_group_alb.id}"]
    subnets             = ["${var.public_subnet_ids}"]

    tags = "${merge(var.common_tags, map(
        "Name", "tf-demo-ecs-ec2-efs-alb",
    ))}"
}

resource "aws_alb_target_group" "demo_ecs_target_group_instance_efs" {
    name                = "tf-demo-ecs-ec2-tg-instance-efs"
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
    lifecycle {
        create_before_destroy = true
    }
    deregistration_delay = 5
    tags = "${merge(var.common_tags, map(
        "Name", "tf-demo-ecs-tg-instance-efs",
    ))}"
}

resource "aws_alb_listener" "demo_alb_listener" {
    load_balancer_arn = "${aws_alb.demo_ecs_ec2_efs_load_balancer.arn}"
    # port              = "443"
    # protocol          = "HTTPS"
    # ssl_policy        = "ELBSecurityPolicy-2016-08"
    # certificate_arn   = "${var.certificate_arn}"
    depends_on        = ["aws_alb.demo_ecs_ec2_efs_load_balancer"]
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.demo_ecs_target_group_instance_efs.arn}"
        type             = "forward"
    }
}

