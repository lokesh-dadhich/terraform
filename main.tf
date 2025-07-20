provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_ecr_repository" "my_ecr" {
  name = "python-app-repo"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = data.aws_vpc.default.id

  subnet_ids = data.aws_subnets.default.ids

  eks_managed_node_groups = {
    default_node_group = {
      instance_types = ["t2.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
}
