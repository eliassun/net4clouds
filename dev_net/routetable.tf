# github: https://github.com/eliassun/net4clouds
# This script is to create a route table

variable "dev_route_table_cidr_v4" {
  type = string
}

variable "dev_route_table_cidr_v6" {
  type = string
}

resource "aws_route_table" "dev_route_table" {
    vpc_id = aws_vpc.dev_vpc.id
    route {
        cidr_block = var.dev_route_table_cidr_v4
        gateway_id = aws_internet_gateway.dev_internet_gw.id
    }
    route {
        ipv6_cidr_block = var.dev_route_table_cidr_v6
        gateway_id = aws_internet_gateway.dev_internet_gw.id
    }
    tags = {
        Name = "dev_net"
    }
}
