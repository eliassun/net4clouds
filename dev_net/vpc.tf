# github: https://github.com/eliassun/net4clouds

# Create a VPC, e.g. elias-dev-vpc

variable "dev_vpc_name" {
    type = string
}

variable "dev_vpc_cidrs" {
    type = list
}

resource "aws_vpc" "dev_vpc" {
    cidr_block = var.dev_vpc_cidrs[0]
    tags = {
        Name = var.dev_vpc_name
    }
}


