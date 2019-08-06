variable common_tags {
  description = "Resources Tags"
  type = "map"
}

variable depends_on { default = [], type = "list"}

variable "vpc_id" {
  description = "description"
}

variable "vpc_cidr" {
  description = "description"
}

variable "web_subnet_cidr" {
  description = "description"
  type = "list"
}

variable "web_subnet_ids" {
  description = "description"
  type = "list"
}
