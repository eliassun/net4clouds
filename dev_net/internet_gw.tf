# github: https://github.com/eliassun/net4clouds

# Create an Internet Gateway

resource "aws_internet_gateway" "dev_internet_gw" {
    vpc_id = aws_vpc.dev_vpc.id
}
