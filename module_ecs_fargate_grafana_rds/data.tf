data "aws_region" "demo_current" {}

data "template_file" "demo_template_file_ecs_fargate_task_definition_grafana" {
  template = "${file("${path.module}/task-definitions/ecs-fargate-grafana-rds.json")}"

  vars {
    grafana_image_url        = "${var.grafana_image_url}"
    grafana_log_group_region = "${data.aws_region.demo_current.name}"
    grafana_log_group_name   = "${aws_cloudwatch_log_group.demo_cloudwatch_log_group_ecs_fargate_grafana.name}"
  }
}