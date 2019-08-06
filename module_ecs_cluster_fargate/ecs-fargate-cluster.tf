resource "aws_ecs_cluster" "demo_ecs_cluster_fargate" {
  name = "${var.ecs_cluster_fargate_name}"
  tags = "${var.common_tags}"
}