data "aws_eks_cluster" "blue" {
  name = module.eks_blue.cluster_id
}

data "aws_eks_cluster_auth" "blue" {
  name = module.eks_blue.cluster_id
}

data "aws_eks_cluster" "green" {
  name = module.eks_green.cluster_id
}

data "aws_eks_cluster_auth" "green" {
  name = module.eks_green.cluster_id
}

provider "kubernetes" {
  alias = "blue"
  host  = data.aws_eks_cluster.blue.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.blue.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.blue.token
  load_config_file = false
}

provider "helm" {
  alias = "blue"
  kubernetes {
    host  = data.aws_eks_cluster.blue.endpoint
    token = data.aws_eks_cluster_auth.blue.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.blue.certificate_authority[0].data)
  }
}

provider "kubernetes" {
  alias = "green"
  host  = data.aws_eks_cluster.green.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.green.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.green.token
  load_config_file = false
}

provider "helm" {
  alias = "green"
  kubernetes {
    host  = data.aws_eks_cluster.green.endpoint
    token = data.aws_eks_cluster_auth.green.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.green.certificate_authority[0].data)
  }
}
