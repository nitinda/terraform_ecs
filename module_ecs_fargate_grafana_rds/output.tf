output "ecs_cluster_fargate_name" {
  value = "${aws_ecs_service.demo_ecs_service_fargate_grafana.name}"
}

output "blue_lb_target_group_name" {
  value = "${aws_alb_target_group.demo_alb_target_group_ecs_grafana_blue.name}"
}

output "green_lb_target_group_name" {
  value = "${aws_alb_target_group.demo_alb_target_group_ecs_fargate_grafana_green.name}"
}

output "alb_listener_arns" {
  value = "${aws_alb_listener.demo_alb_listener_ecs_fargate_grafana_front_end_http.arn}"
}

output "test_traffic_alb_listener_arns" {
  value = "${aws_alb_listener.demo_alb_listener_ecs_fargate_grafana_test_front_end_http.arn}"
}
