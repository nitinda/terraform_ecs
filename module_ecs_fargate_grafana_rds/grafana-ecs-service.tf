resource "aws_ecs_service" "demo_ecs_service_fargate_grafana" {
  name            = "terraform-demo-ecs-service-fargate-grafana"
  cluster         = "${var.ecs_fargate_cluster_name}"
  # task_definition = "${aws_ecs_task_definition.demo_ecs_task_definition_grafana.arn}"
  task_definition = "${aws_ecs_task_definition.demo_ecs_task_definition_fargate_grafana.family}:${max("${aws_ecs_task_definition.demo_ecs_task_definition_fargate_grafana.revision}", "${aws_ecs_task_definition.demo_ecs_task_definition_fargate_grafana.revision}")}"
  desired_count   = 2
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 300

  network_configuration {
    security_groups = ["${aws_security_group.demo_security_group_ecs_service_fargate_grafana.id}"]
    subnets         = ["${var.web_subnet_ids}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.demo_alb_target_group_ecs_fargate_grafana_green.arn}"
    container_name   = "terraform-demo-container-definition-grafana"
    container_port   = 3000
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # lifecycle {
  #   create_before_destroy = true
  #   ignore_changes = [
  #     "task_definition",
  #     "load_balancer",
  #   ]
  # }

  depends_on = ["aws_alb.demo_alb_ecs_fargate_grafana"]
}