resource "aws_security_group" "demo_security_group_efs" {
  name        = "terraform-demo-eks-security-efs"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${var.vpc_id}"
  revoke_rules_on_delete = true

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-eks-security-efs",
  ))}"
}