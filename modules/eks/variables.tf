variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "eks_node_role_arn" {
  type = string
}

variable "desired_size" {
  type = number
  default = 2
}

variable "max_size" {
  type = number
  default = 3
}

variable "min_size" {
  type = number
  default = 1
}