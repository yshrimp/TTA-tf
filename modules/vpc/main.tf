
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_name
  }
}
#################### Subnets ###################################
resource "aws_subnet" "private_eks" {
    for_each = var.private_subnets_eks

    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = false

    tags = {
      Name  = "private-${each.key}"
    }
}

resource "aws_subnet" "private_db" {
  count = 4

  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 20 + count.index)
  availability_zone = var.azs[count.index]

  map_public_ip_on_launch = false
  tags = {
    Name = "private-db${count.index}"
  }
}

resource "aws_subnet" "public_alb" {
  for_each = var.public_subnets_alb

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${each.key}"
    "kubernetes.io/cluster/test-eks" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}
################## Routing Tables #################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_alb

  subnet_id = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = local.all_ips
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private_eks" {
  for_each = aws_subnet.private_eks

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {
  count = length(aws_subnet.private_db)

  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private.id
}

################ NAT Gateway ######################################
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public_alb)[0].id

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}


################### Security Groups ############################################

resource "aws_security_group" "pub-ec2" {
  name = "pub-ec2-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "pub-ec2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.pub-ec2.id
  cidr_ipv4 = local.all_ips
  from_port = local.ssh_port
  to_port = local.ssh_port
  ip_protocol = local.tcp_protocol
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http" {
  security_group_id = aws_security_group.pub-ec2.id
  cidr_ipv4 = local.all_ips
  from_port = local.http_port
  to_port = local.http_port
  ip_protocol = local.tcp_protocol
}

resource "aws_vpc_security_group_ingress_rule" "ec2_https" {
  security_group_id = aws_security_group.pub-ec2.id
  cidr_ipv4 = local.all_ips
  from_port = local.https_port
  to_port = local.https_port
  ip_protocol = local.tcp_protocol
}

resource "aws_vpc_security_group_egress_rule" "ec2_all_out" {
  security_group_id = aws_security_group.pub-ec2.id
  cidr_ipv4         = local.all_ips
  ip_protocol       = local.any_protocol
}

resource "aws_security_group" "rds" {
  name = "rds-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4 = local.all_ips
  from_port = local.db_port
  to_port = local.db_port
  ip_protocol = local.tcp_protocol
}

resource "aws_vpc_security_group_egress_rule" "rds_out" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = local.all_ips
  ip_protocol       = local.any_protocol
}



# resource "aws_security_group" "alb" {
#   name        = "eks_alb"
#   description = "Allow HTTP & HTTPS inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "eks_web"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
#   security_group_id = aws_security_group.alb.id
#   cidr_ipv4         = local.all_ips
#   from_port         = local.https_port
#   ip_protocol       = local.tcp_protocol
#   to_port           = local.https_port
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
#   security_group_id = aws_security_group.alb.id
#   cidr_ipv4         = local.all_ips
#   from_port         = local.http_port
#   ip_protocol       = local.tcp_protocol
#   to_port           = local.http_port
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.alb.id
#   cidr_ipv4         = local.all_ips
#   ip_protocol       = local.any_protocol # semantically equivalent to all ports
# }