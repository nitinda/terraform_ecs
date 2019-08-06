output "efs_mount_target_ids" {
  value = "${aws_efs_mount_target.demo_efs_mount_targets_ecs.*.id}"
}

output "efs_mount_target_ip_address" {
  value = "${aws_efs_mount_target.demo_efs_mount_targets_ecs.*.ip_address}"
}

output "efs_dns_name" {
  value = "${aws_efs_file_system.demo_efs_ecs.dns_name}"
}

output "efs_id" {
  value = "${aws_efs_file_system.demo_efs_ecs.id}"
}