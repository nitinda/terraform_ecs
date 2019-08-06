output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.demo_ecs_cluster_ec2.name}"
}
