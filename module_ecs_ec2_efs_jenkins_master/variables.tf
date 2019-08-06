variable "ecs_cluster_name" {
  description = "description"
}

variable "ecs_service_role_name" {
  description = "description"
}

variable "ecs_task_role_arn" {
  description = "description"
}
variable "ecs_task_execution_role_arn" {
  description = "description"
}

variable common_tags {
  description = "Resources Tags"
  type = "map"
}

variable "public_subnet_ids" {
  description = "description"
  type        = "list"
}

variable "vpc_id" {
  description = "description"
}

variable "efs_dns_name" {
  description = "description"
}
