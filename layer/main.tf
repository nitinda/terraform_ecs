terraform {
  required_version = ">= 0.11.7"
}



#######################  IAM

module "aws_resources_module_iam_ecs" {
  source  = "../module_iam_ecs"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags     = "${var.common_tags}"
  aws_account_ids = {
    default = "${data.aws_caller_identity.demo_caller_identity_current.account_id}"
  }
}

# module "aws_resources_module_iam_codedeploy" {
#   source  = "../module_iam_codedeploy"

#   providers = {
#     "aws"  = "aws.aws_services"
#   }

#   common_tags = "${var.common_tags}"
# }

module "aws_resources_module_iam_grafana" {
  source  = "../module_iam_grafana"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags       = "${var.common_tags}"
  ecs_task_role_arn = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
  aws_account_ids  = {
    default = "${data.aws_caller_identity.demo_caller_identity_current.account_id}"
  }
}

########################## SSM Parameters

module "aws_resources_module_kms_ssm_parameters" {
  source = "../module_kms"

  common_tags        = "${var.common_tags}"
  kmy_key_alias_name = "alias/terraform-demo-kms-key-ssm-parameters"
  kmy_key_name       = "terraform-demo-kms-key-ssm-parameters"  
}

module "aws_resources_module_ssm_parameters_database_password" {
  source  = "../module_ssm_parameters"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
  ssm_parameter_name  = "/grafana/terraform-demo-ssm-parameter-database-password"
  ssm_parameter_value = "asdaj1k23hjh1234fghj"
  kms_key_id          = "${module.aws_resources_module_kms_ssm_parameters.kms_key_arn}"
}

module "aws_resources_module_ssm_parameters_grafana_password" {
  source  = "../module_ssm_parameters"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
  ssm_parameter_name  = "/grafana/terraform-demo-ssm-parameter-grafana-password"
  ssm_parameter_value = "asdaj1k23hjh1234fghj"
  kms_key_id          = "${module.aws_resources_module_kms_ssm_parameters.kms_key_arn}"
}



########################## Network

module "aws_resources_module_network" {
  source  = "../module_network"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags = "${var.common_tags}"
}



########################## EFS

# module "aws_resources_module_efs" {
#   source  = "../module_efs"

#   providers = {
#     "aws"  = "aws.aws_services"
#   }

#   common_tags     = "${var.common_tags}"
#   vpc_id          = "${module.aws_resources_module_network.vpc_id}"
#   vpc_cidr        = "${module.aws_resources_module_network.vpc_cidr}"
#   web_subnet_cidr = "${module.aws_resources_module_network.web_subnet_cidr_blocks}"
#   web_subnet_ids  = "${module.aws_resources_module_network.web_subnet_ids}"

#   depends_on      = ["${module.aws_resources_module_network.nat_gateway_ids}"]
# }



########################## RDS

module "aws_resources_module_rds_aurora_serverless_grafana" {
  source = "../module_rds_aurora_serverless"
  
  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags     = "${var.common_tags}"
  vpc_id          = "${module.aws_resources_module_network.vpc_id}"
  db_subnet_ids   = "${module.aws_resources_module_network.db_subnet_ids}"
  web_subnet_cidr = "${module.aws_resources_module_network.web_subnet_cidr_blocks}"

  db_instance_type                   = "db.t2.small"
  cluster_instance_identifier_name   = "terraform-demo-db-cluster-instance-identifier-grafana"
  db_subnet_group_name               = "terraform-demo-db-subnet-group-aurora-grafana"
  master_password                    = "${module.aws_resources_module_ssm_parameters_database_password.ssm_parameter_value}"
  database_name                      = "grafana"
  auto_pause                         = true
  max_capacity                       = 8
  min_capacity                       = 1
  apply_immediately                  = true
  db_cluster_identifier_prefix       = "grafana"
}



########################## ECS on EC2

module "aws_resources_module_ecs_cluster_ec2" {
  source  = "../module_ecs_cluster_ec2"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags               = "${var.common_tags}"
  ecs_cluster_name          = "${var.ecs_cluster_name}"
  vpc_id                    = "${module.aws_resources_module_network.vpc_id}"
  web_subnet_ids            = "${module.aws_resources_module_network.web_subnet_ids}"
  public_subnet_ids         = "${module.aws_resources_module_network.public_subnet_ids}"
  public_subnet_cidr_blocks = "${module.aws_resources_module_network.public_subnet_cidr_blocks}"
  ecs_instance_profile_name = "${module.aws_resources_module_iam_ecs.ecs_instance_profile_name}"
}



########################## ECS on Fargate

# module "aws_resources_module_ecs_cluster_fargate" {
#   source = "../module_ecs_cluster_fargate"

#   providers = {
#     "aws"  = "aws.aws_services"
#   }

#   common_tags              = "${var.common_tags}"
#   ecs_cluster_fargate_name = "${var.ecs_cluster_fargate_name}"
# }




########################## ECS Services

# module "aws_resources_module_ecs_ec2_ebs_jenkins_master" {
#   source  = "../module_ecs_ec2_ebs_jenkins_master"

#   providers = {
#     "aws"  = "aws.aws_services"
#   }

#   common_tags                               = "${var.common_tags}"
#   vpc_id                                    = "${module.aws_resources_module_network.vpc_id}"
#   public_subnet_ids                         = "${module.aws_resources_module_network.public_subnet_ids}"
#   ecs_cluster_name                          = "${var.ecs_cluster_name}"
#   ecs_service_role_name                     = "${module.aws_resources_module_iam_ecs.ecs_service_role_name}"
#   ecs_task_execution_role_arn               = "${module.aws_resources_module_iam_ecs.ecs_task_execution_role_arn}"
#   ecs_task_role_arn                         = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
# }

# module "aws_resources_module_ecs_ec2_efs_jenkins_master" {
#   source  = "../module_ecs_ec2_efs_jenkins_master"

#   providers = {
#     "aws"  = "aws.aws_services"
#   }

#   common_tags                 = "${var.common_tags}"
#   vpc_id                      = "${module.aws_resources_module_network.vpc_id}"
#   public_subnet_ids           = "${module.aws_resources_module_network.public_subnet_ids}"
#   ecs_cluster_name            = "${var.ecs_cluster_name}"
#   ecs_service_role_name       = "${module.aws_resources_module_iam_ecs.ecs_service_role_name}"
#   ecs_task_execution_role_arn = "${module.aws_resources_module_iam_ecs.ecs_task_execution_role_arn}"
#   ecs_task_role_arn           = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
#   efs_dns_name                = "${module.aws_resources_module_efs.efs_dns_name}"
# }


##################################################################################
##########################    Grafana ECS EC2  ###################################


module "aws_resources_module_ecs_ec2_grafana_rds" {
  source  = "../module_ecs_ec2_grafana_rds"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags                 = "${var.common_tags}"
  vpc_id                      = "${module.aws_resources_module_network.vpc_id}"
  public_subnet_ids           = "${module.aws_resources_module_network.public_subnet_ids}"
  web_subnet_ids              = "${module.aws_resources_module_network.web_subnet_ids}"
  ecs_cluster_name            = "${module.aws_resources_module_ecs_cluster_ec2.ecs_cluster_name}"
  ecs_task_execution_role_arn = "${module.aws_resources_module_iam_ecs.ecs_task_execution_role_arn}"
  ecs_task_role_arn           = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
  grafana_image_url           = "grafana/grafana:6.2.5"

  rds_cluster_endpoint            = "${module.aws_resources_module_rds_aurora_serverless_grafana.rds_cluster_endpoint}"
  grafana_database_password       = "${module.aws_resources_module_ssm_parameters_grafana_password.ssm_parameter_value}"
  rds_cluster_database_name       = "${module.aws_resources_module_rds_aurora_serverless_grafana.rds_cluster_database_name}"
  grafana_security_admin_password = "${module.aws_resources_module_ssm_parameters_grafana_password.ssm_parameter_value}"
}


#######################################################################################
##########################    Grafana ECS Fargate  ###################################


# module "aws_resources_module_ecs_fargate_grafana_rds" {
#   source  = "../module_ecs_fargate_grafana_rds"

#   providers = {
#     "aws"  = "aws.aws_services"
#   }

#   common_tags                 = "${var.common_tags}"
#   vpc_id                      = "${module.aws_resources_module_network.vpc_id}"
#   public_subnet_ids           = "${module.aws_resources_module_network.public_subnet_ids}"
#   web_subnet_ids              = "${module.aws_resources_module_network.web_subnet_ids}"
#   ecs_fargate_cluster_name    = "${module.aws_resources_module_ecs_cluster_fargate.ecs_fargate_cluster_name}"
#   ecs_service_role_name       = "${module.aws_resources_module_iam_ecs.ecs_service_role_name}"
#   ecs_task_execution_role_arn = "${module.aws_resources_module_iam_ecs.ecs_task_execution_role_arn}"
#   ecs_task_role_arn           = "${module.aws_resources_module_iam_ecs.ecs_task_role_arn}"
#   grafana_image_url           = "grafana/grafana:6.2.5"
  
# }

# module "aws_resources_module_code_deploy_ecs_fargate_grafana" {
#   source = "../module_code_deploy_ecs"

#   providers = {
#     "aws"  = "aws.aws_services"
#   }

#   common_tags              = "${var.common_tags}"
#   ecs_cluster_name         = "${module.aws_resources_module_ecs_cluster_fargate.ecs_fargate_cluster_name}"
#   ecs_service_name         = "${module.aws_resources_module_ecs_fargate_grafana_rds.ecs_cluster_fargate_name}"
#   lb_listener_arns         = ["${module.aws_resources_module_ecs_fargate_grafana_rds.alb_listener_arns}"]
#   test_traffic_route_listener_arns = "${module.aws_resources_module_ecs_fargate_grafana_rds.test_traffic_alb_listener_arns}"

#   code_deploy_app                   = "terraform-demo-codedeploy-app-ecs-fargate-grafana"
#   code_deploy_deployment_group_name = "terraform-demo-codedeploy-app-ecs-fargate-grafana"
#   blue_lb_target_group_name         = "${module.aws_resources_module_ecs_fargate_grafana_rds.blue_lb_target_group_name}"
#   green_lb_target_group_name        = "${module.aws_resources_module_ecs_fargate_grafana_rds.green_lb_target_group_name}"
#   action_on_timeout                 = "CONTINUE_DEPLOYMENT"
#   auto_rollback_events              = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
#   code_deploy_service_role_arn      = "${module.aws_resources_module_iam_codedeploy.codedeploy_iam_role_arn}"
# }