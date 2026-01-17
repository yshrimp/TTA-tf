provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "hdh-tfstate"
    key = "prod/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-lock"
    encrypt = true
  }
}

module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "test"
  igw_name = "test-igw"  
}

module "iam" {
  source = "../../modules/iam"
}

module "eks" {
  source = "../../modules/eks"

  private_subnet_ids = module.vpc.private_subnet_ids
  eks_cluster_name = "test-eks"
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn = module.iam.eks_node_role_arn
  desired_size = 2
  max_size = 3
  min_size = 1

  depends_on = [ module.iam ]
}

module "ec2" {
  source = "../../modules/ec2"

  public_subnet_ids = module.vpc.public_subnet_ids  
  pub_ec2_sg_id = module.vpc.pub_ec2_sg_id
  eks_ops_ec2_profile_name = module.iam.eks_ops_ec2_profile_name

  depends_on = [ module.iam ]
}

module "rds" {
  source = "../../modules/rds"

  db_subnet_ids = module.vpc.private_subnets_db_id
  db_sg_id = [module.vpc.db_sg_id]
}

module "ecr" {
  source = "../../modules/ecr"
  backend_ecr_name = "backend"
  frontend_ecr_name = "frontend"
}

module "s3" {
  source = "../../modules/s3"
  s3_name = "hwang-three-tier-alb-logs"
}