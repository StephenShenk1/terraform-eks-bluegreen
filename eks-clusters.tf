module "eks_blue" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 19.0.0"

  cluster_name    = "blue-cluster-${var.env}"
  cluster_version = "1.27"
  subnets         = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
  vpc_id          = aws_vpc.this.id

  node_groups = {
    blue_nodes = {
      desired_capacity = var.cluster_node_count
      max_capacity     = var.cluster_node_count + 1
      min_capacity     = 1
      instance_types   = [var.cluster_node_type]
      tags = { "Name" = "blue-node-${var.env}" }
    }
  }

  tags = { Environment = var.env, Cluster = "blue" }
}

module "eks_green" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 19.0.0"

  cluster_name    = "green-cluster-${var.env}"
  cluster_version = "1.27"
  subnets         = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
  vpc_id          = aws_vpc.this.id

  node_groups = {
    green_nodes = {
      desired_capacity = var.cluster_node_count
      max_capacity     = var.cluster_node_count + 1
      min_capacity     = 1
      instance_types   = [var.cluster_node_type]
      tags = { "Name" = "green-node-${var.env}" }
    }
  }

  tags = { Environment = var.env, Cluster = "green" }
}
