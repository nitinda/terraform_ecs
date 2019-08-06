resource "aws_alb" "demo_alb_ecs_fargate_grafana" {
    name                = "tf-demo-alb-ecs-fargate-grafana"
    security_groups     = ["${aws_security_group.demo_security_group_alb_ecs_fargate_grafana.id}"]
    subnets             = ["${var.public_subnet_ids}"]

    tags = "${merge(var.common_tags, map(
        "Name", "terraform-demo-alb-ecs-fargate-grafana",
    ))}"
}

resource "aws_alb_target_group" "demo_alb_target_group_ecs_fargate_grafana_green" {
    name                 = "fargate-grafana-green"
    port                 = "3000"
    protocol             = "HTTP"
    vpc_id               = "${var.vpc_id}"
    deregistration_delay = 5
    target_type          = "ip"
    depends_on           = ["aws_alb.demo_alb_ecs_fargate_grafana"]

    lifecycle {
        create_before_destroy = true
    }

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

    tags = "${merge(var.common_tags, map(
        "Name", "terraform-demo-alb-target-group-ecs-fargate-grafana-green",
        "Description", "Target Group for Grafana",
    ))}"
}

resource "aws_alb_target_group" "demo_alb_target_group_ecs_grafana_blue" {
    name                 = "fargate-grafana-blue"
    port                 = "3000"
    protocol             = "HTTP"
    vpc_id               = "${var.vpc_id}"
    deregistration_delay = 5
    target_type          = "ip"
    depends_on           = ["aws_alb.demo_alb_ecs_fargate_grafana"]

    lifecycle {
        create_before_destroy = true
    }

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

    tags = "${merge(var.common_tags, map(
        "Name", "tf-demo-alb-target-group-ecs-fargate-grafana-blue",
        "Description", "Target Group for Grafana",
    ))}"
}

resource "aws_alb_listener" "demo_alb_listener_ecs_fargate_grafana_front_end_http" {
    load_balancer_arn = "${aws_alb.demo_alb_ecs_fargate_grafana.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.demo_alb_target_group_ecs_fargate_grafana_green.arn}"
        type             = "forward"
    }
}

resource "aws_alb_listener" "demo_alb_listener_ecs_fargate_grafana_test_front_end_http" {
    load_balancer_arn = "${aws_alb.demo_alb_ecs_fargate_grafana.arn}"
    port              = "8080"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.demo_alb_target_group_ecs_grafana_blue.arn}"
        type             = "forward"
    }
}
