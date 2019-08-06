resource "aws_ecs_task_definition" "demo_ecs_task_definition_fargate_grafana" {
  family                   = "terraform-demo-ecs-fargate-task-definition-fargate-grafana"
  container_definitions    = "${data.template_file.demo_template_file_ecs_fargate_task_definition_grafana.rendered}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "${var.ecs_task_role_arn}"
  execution_role_arn       = "${var.ecs_task_execution_role_arn}"
  network_mode             = "awsvpc"
}