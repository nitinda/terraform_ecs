// The 'writer' endpoint for the cluster
output "cluster_endpoint" {
  value = "${join("", aws_rds_cluster.demo_rds_cluster_aurora_serverless.*.endpoint)}"
}

// A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas
output "reader_endpoint" {
  value = "${join("", aws_rds_cluster.demo_rds_cluster_aurora_serverless.*.reader_endpoint)}"
}

// The ID of the RDS Cluster
output "cluster_identifier" {
  value = "${join("", aws_rds_cluster.demo_rds_cluster_aurora_serverless.*.id)}"
}