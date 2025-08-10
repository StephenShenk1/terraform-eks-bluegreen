variable "aws_region" { default = "eu-west-1" }
variable "env" { default = "prod" }
variable "vpc_cidr" { default = "10.0.0.0/16" }

variable "cluster_node_count" { default = 2 }
variable "cluster_node_type"  { default = "t3.medium" }
