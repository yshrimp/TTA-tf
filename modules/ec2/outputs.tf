output "ec2_ip" {
  value = aws_instance.dev.public_ip
}