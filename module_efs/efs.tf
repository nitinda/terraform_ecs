resource "aws_efs_file_system" "demo_efs_ecs" {
  creation_token = "terraform-demo-efs-ecs"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-efs-ecs",
  ))}"
}

resource "aws_efs_mount_target" "demo_efs_mount_targets_ecs" {
  count          = 2
  file_system_id = "${aws_efs_file_system.demo_efs_ecs.id}"
  subnet_id      = "${var.web_subnet_ids[count.index]}"
  security_groups = ["${aws_security_group.demo_security_group_efs.id}"]
}