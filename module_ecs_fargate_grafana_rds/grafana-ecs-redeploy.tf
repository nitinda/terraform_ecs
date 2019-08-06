# resource "null_resource" "demo_null_resource_ecs_redeploy" {
#   triggers {
#     build_number = "${timestamp()}"
#     task_definition_arn = "${aws_ecs_task_definition.demo_ecs_task_definition_grafana.arn}"
#   }

#   provisioner "local-exec" {
#     command = "./redeploy.sh app_name deploy_group_name nginx 8080 ${aws_ecs_task_definition.demo_ecs_task_definition_grafana.arn}"
#   }
# }