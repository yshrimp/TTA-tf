data "aws_key_pair" "notebook" {
  key_name = "notebook"
  include_public_key = true
}

resource "aws_instance" "dev" {
  ami = var.ec2_ami
  instance_type = var.instance_type
  key_name = data.aws_key_pair.notebook.key_name
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.pub_ec2_sg_id]
  iam_instance_profile = var.eks_ops_ec2_profile_name
    
  user_data = file("${path.module}/user_data.sh")
  tags = {
    Name = var.ec2_name
  }
}