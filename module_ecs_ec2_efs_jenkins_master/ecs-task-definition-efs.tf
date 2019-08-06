resource "aws_ecs_task_definition" "demo_ecs_ec2_task_definition_efs_jenkins_master" {
    family        = "terraform-demo-ecs-ec2-task-definition-efs-jenkins-master"
    execution_role_arn = "${var.ecs_task_execution_role_arn}"
    task_role_arn      = "${var.ecs_task_role_arn}"
    network_mode  = "bridge"
    volume {
        name      = "jenkins-efs-vol"
        docker_volume_configuration {
            scope         = "shared"
            autoprovision = true
            driver        = "local"
            driver_opts {
                type = "nfs"
                device = "${var.efs_dns_name}:/"
                o = "addr=${var.efs_dns_name},nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,rw"
            }
            # labels {
            #     Project      = "${replace(var.common_tags["Project"], " ", "-")}"
            #     Owner        = "${replace(var.common_tags["Owner"], " ", "-")}"
            #     Environment  = "${replace(var.common_tags["Environment"], " ", "-")}"
            #     BusinessUnit = "${replace(var.common_tags["BusinessUnit"], " ", "-")}"
            # }
        }
#         host_path = "/mnt/efs"
    }
    placement_constraints {
        type       = "memberOf"
        expression = "attribute:ecs.availability-zone in [eu-central-1a, eu-central-1b]"
    }
    container_definitions = "${file("${path.module}/../module_ecs_efs_jenkins_master/task-definitions/ecs-efs-jenkins-master.json")}"
    tags                  = "${var.common_tags}"
}