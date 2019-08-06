output "ecs_fargate_cluster_name" {
  value = "${aws_ecs_cluster.demo_ecs_cluster_fargate.name}"
}
