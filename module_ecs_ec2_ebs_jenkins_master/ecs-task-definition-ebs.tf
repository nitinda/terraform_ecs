# resource "aws_ecs_task_definition" "demo_ecs_ec2_task_definition_ebs_jenkins_master" {
#     family             = "terraform-demo-ecs-ec2-task-definition-ebs-jenkins-master"
#     execution_role_arn = "${var.ecs_task_execution_role_arn}"
#     task_role_arn      = "${var.ecs_task_role_arn}"
#     network_mode       = "bridge"
#     volume {
#         name = "jenkins-ebs-vol"
#         docker_volume_configuration {
#             scope         = "shared"
#             autoprovision = true
#             # driver        = "cloudstor-aws-ebs"
#             # driver_opts {
#             #     size    = "50m",
#             #     backing = "relocatable"
#             #     ebstype = "gp2"
#             # }

#             driver        = "rexray-aws-ebs"
#             driver_opts {
#                 size       = 20,
#                 volumetype = "gp2"
#             }
#             labels {
#                 Project      = "${replace(var.common_tags["Project"], " ", "-")}"
#                 Owner        = "${replace(var.common_tags["Owner"], " ", "-")}"
#                 Environment  = "${replace(var.common_tags["Environment"], " ", "-")}"
#                 BusinessUnit = "${replace(var.common_tags["BusinessUnit"], " ", "-")}"
#             }
#         }
#     }
#     tags = "${var.common_tags}"
#     placement_constraints {
#         type       = "memberOf"
#         expression = "attribute:ecs.availability-zone in [eu-central-1a, eu-central-1b]"
#     }
#     lifecycle {
#         create_before_destroy = true
#     }
#     container_definitions = "${file("${path.module}/../module_ecs_ebs_jenkins_master/task-definitions/ecs-ebs-jenkins-master.json")}"
# }