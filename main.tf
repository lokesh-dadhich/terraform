provider "aws" {
  region = "ap-south-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all default subnets in the VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create ECR repo
resource "aws_ecr_repository" "my_ecr" {
  name = "python-app-repo"
}

# Create EKS cluster using Terraform AWS module
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = data.aws_vpc.default.id
  subnets         = data.aws_subnets.default.ids

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t2.medium"
    }
  }
}
