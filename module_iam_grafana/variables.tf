variable common_tags {
  description = "Resources Tags"
  type        = "map"
}

variable "aws_account_ids" {
  type        = "map"
  description = "A mapping of AWS account IDs that have a Grafana role that allows Grafana to access CloudWatch metrics"
}
