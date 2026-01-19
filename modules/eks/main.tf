resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "default-ng"
  node_role_arn  = var.eks_node_role_arn
  subnet_ids     = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = ["t3.medium"]
}

