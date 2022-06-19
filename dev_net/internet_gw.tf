# github: https://github.com/eliassun/net4clouds
# This script is to create a Internet gateway


resource "aws_internet_gateway" "dev_internet_gw" {
    vpc_id = aws_vpc.dev_vpc.id
}
