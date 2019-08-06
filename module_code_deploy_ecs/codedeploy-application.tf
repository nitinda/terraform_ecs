resource "aws_codedeploy_app" "demo_codedeploy_application" {
  compute_platform = "ECS"
  name             = "${var.code_deploy_app}"
}