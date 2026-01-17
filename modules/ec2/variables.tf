variable "public_subnet_ids" {
  type = list(string)
}

variable "pub_ec2_sg_id" {
  type = string
}

variable "ec2_ami" {
  type = string
  default = "ami-0a71e3eb8b23101ed"
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}

variable "ec2_name" {
  type = string
  default = "dev"  
}

variable "eks_ops_ec2_profile_name" {
  type = string
}