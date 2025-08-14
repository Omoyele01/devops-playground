# ---------- VPC (the fenced playground) ----------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets = ["10.0.32.0/20", "10.0.48.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true

  # Very important: tag subnets so EKS can place LoadBalancers
  public_subnet_tags = {
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
  }

  tags = { Project = var.project_name }
}

# ---------- EKS (the playground manager + workers) ----------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets # run nodes in private subnets

  # Access (leave public on for learning, tighten later)
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Give your AWS user admin on the cluster (handy while learning)
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      desired_size   = var.node_desired_size
      min_size       = 1
      max_size       = 4
      capacity_type  = "ON_DEMAND" # later we’ll switch to SPOT to save money
    }
  }

  tags = { Project = var.project_name }
}
