output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node.arn
}

output "eks_ops_ec2_profile_name" {
  value = aws_iam_instance_profile.eks_ops_ec2.name
}