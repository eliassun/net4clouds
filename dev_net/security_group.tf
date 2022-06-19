# github: https://github.com/eliassun/net4clouds
# This script is to create a security group

resource "aws_security_group" "dev_sg" {
    name        = "dev_security_group"
    description = "dev security group"
    vpc_id      = aws_vpc.dev_vpc.id
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${data.external.local_env.result.local_public_ip}/32"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "dev-sg"
    }
}


