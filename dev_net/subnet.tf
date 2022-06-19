# github: https://github.com/eliassun/net4clouds
# This script is to create a subnet

variable "dev_subnet_cidr" {
  type = list
}

variable "us_east_2_az" {
  type = string
}

resource "aws_subnet" "dev_subnet" {
    vpc_id            = aws_vpc.dev_vpc.id
    cidr_block        = var.dev_subnet_cidr[0].cidr_block
    availability_zone = var.us_east_2_az
    tags = {
        Name = var.dev_subnet_cidr[0].name
    }
}

# Associate the dev network subnet to route table

resource "aws_route_table_association" "dev_net_tbl_bind" {
    subnet_id      = aws_subnet.dev_subnet.id
    route_table_id = aws_route_table.dev_route_table.id
}
