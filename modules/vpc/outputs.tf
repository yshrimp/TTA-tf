output "private_subnet_ids" {
  value = values(aws_subnet.private_eks)[*].id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for s in aws_subnet.public_alb : s.id]
}

output "pub_ec2_sg_id" {
  description = "Public EC2 sg ID"
  value = aws_security_group.pub-ec2.id
}

output "private_subnets_db_id" {
  description = "Private subnets for DB subnet group"
  value = aws_subnet.private_db[*].id
}

output "db_sg_id" {
  description = "RDS for SG ID"
  value = aws_security_group.rds.id
}