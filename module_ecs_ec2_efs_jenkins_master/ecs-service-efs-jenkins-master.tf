resource "aws_ecs_service" "demo_ecs_service_ec2_efs_jenkins_master" {
  name            = "terraform-demo-ecs-service-ec2-efs-jenkins-master"
  iam_role        = "${var.ecs_service_role_name}"
  cluster         = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.demo_ecs_ec2_task_definition_efs_jenkins_master.family}:${max("${aws_ecs_task_definition.demo_ecs_ec2_task_definition_efs_jenkins_master.revision}", "${aws_ecs_task_definition.demo_ecs_ec2_task_definition_efs_jenkins_master.revision}")}"
  desired_count   = 1
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds = 300
  scheduling_strategy = "REPLICA"
  load_balancer {
    target_group_arn = "${aws_alb_target_group.demo_ecs_target_group_instance_efs.arn}"
    container_port   = 8080
    container_name   = "efs-jenkins-master"
  }  
  placement_constraints {
      type       = "memberOf"
      expression = "attribute:ecs.availability-zone in [eu-central-1a, eu-central-1b]"
  }
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }
  deployment_controller {
      type = "ECS"
  }
}