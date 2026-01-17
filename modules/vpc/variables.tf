variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
}

variable "vpc_name" {
  description = "vpc name"
  type = string
}

variable "igw_name" {
  description = "Internet Gateway name"
  type = string
}

variable "private_subnets_eks" {
  default = {
    apne2a = {
        cidr = "10.0.10.0/24"
        az  =   "ap-northeast-2a"
    }
    apne2b = {
        cidr = "10.0.11.0/24"
        az  =   "ap-northeast-2b"
    }
    apne3c = {
        cidr = "10.0.12.0/24"
        az = "ap-northeast-2c"
    }
  }
}

variable "public_subnets_alb" {
  default = {
    apne2a = {
        cidr = "10.0.1.0/24"
        az = "ap-northeast-2a"
    }
    apne2b = {
        cidr = "10.0.2.0/24"
        az = "ap-northeast-2b"
    }
  }
}

variable "azs" {
  description = "availablity zones list"
  type = list(string)
  default = [ 
    "ap-northeast-2a",
    "ap-northeast-2b",
    "ap-northeast-2c",
    "ap-northeast-2d"
   ]
}


variable "eks_security_group_ids" {
  type    = list(string)
  default = []
}