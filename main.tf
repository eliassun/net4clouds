terraform {

}

variable "defaul_region" {
    type = string
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}

variable "prod_1_vpc_name" {
    type = string
}

variable "prod_vpc_cidrs" {
    type = list
}

variable "subnet_prod_vpc_1" {
    type = list
}

variable "prod_1_route_table_cidr_v4" {
    type = string
}

variable "prod_1_route_table_cidr_v6" {
    type = string
}

variable "web_server_01_nic_ips" {
    type = list
}

variable "us_east_2_ec2_ubuntu_ami" {
    type = string
}

variable "us_east_2_ec2_ubuntu_size" {
    type = string
}

variable "us_east_2_ec2_key_name" {
    type = string
}

variable "us_east_2_ec2_ubuntu_az" {
    type = string
}

variable "us-east-2-az" {
    type = list
}

# CSP is AWS
provider "aws" {
    region     = var.defaul_region
    access_key = var.access_key
    secret_key = var.secret_key
}

# Create a VPC
resource "aws_vpc" "prod_vpc_1" {
    cidr_block = var.prod_vpc_cidrs[0]
    tags = {
        Name = "production-1"
    }
}

# Create an Internet Gateway

resource "aws_internet_gateway" "prod_internet_gw_1" {
    vpc_id = aws_vpc.prod_vpc_1.id
}

# Create a route table

resource "aws_route_table" "prod_route_table_1" {
    vpc_id = aws_vpc.prod_vpc_1.id
    route {
        cidr_block = var.prod_1_route_table_cidr_v4
        gateway_id = aws_internet_gateway.prod_internet_gw_1.id
    }
    route {
        ipv6_cidr_block = var.prod_1_route_table_cidr_v6
        gateway_id = aws_internet_gateway.prod_internet_gw_1.id
    }
    tags = {
        Name = "prod_1"
    }
}

# Create a subnet
resource "aws_subnet" "prod_vpc_1_subnet_1" {
    vpc_id            = aws_vpc.prod_vpc_1.id
    cidr_block        = var.subnet_prod_vpc_1[0].cidr_block
    availability_zone = var.us_east_2_ec2_ubuntu_az
    tags = {
        Name = var.subnet_prod_vpc_1[0].name
    }
}

# Associate subnet to routetable 

resource "aws_route_table_association" "prod_1_net_1" {
    subnet_id      = aws_subnet.prod_vpc_1_subnet_1.id
    route_table_id = aws_route_table.prod_route_table_1.id
}

# Create security group

resource "aws_security_group" "prod_1_sg_1" {
    name        = "prod_1_sg_1"
    description = "production net-1 security-group-1"
    vpc_id      = aws_vpc.prod_vpc_1.id
    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]      
    }
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]      
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "prod-1-sg-1"
    }
}

# Create a network interface with an IP in the subnet 

resource "aws_network_interface" "web_server_nic_01" {
    subnet_id       = aws_subnet.prod_vpc_1_subnet_1.id
    private_ips     = var.web_server_01_nic_ips
    security_groups = [aws_security_group.prod_1_sg_1.id]
}

# Assign an elastic IP to the network interface created

resource "aws_eip" "web_server_eip_01" {
    vpc                       = true
    network_interface         = aws_network_interface.web_server_nic_01.id
    associate_with_private_ip = var.web_server_01_nic_ips[0]
    depends_on                = [aws_internet_gateway.prod_internet_gw_1]
}

# output elastic IP 
output "output_web_server_eip_01" {
    value = aws_eip.web_server_eip_01
} 

# Create an ubuntu ec2 and install apache2

resource "aws_instance" "test-server-ec2-01" {
    ami               = var.us_east_2_ec2_ubuntu_ami
    instance_type     = var.us_east_2_ec2_ubuntu_size
    availability_zone = var.us_east_2_ec2_ubuntu_az
    key_name          = var.us_east_2_ec2_key_name
    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web_server_nic_01.id
    }
    user_data = "${file("install_softwares.sh")}"
    tags = {
        Name = "test-server-ec2-01"
    }
}

# output the private ip of test-server-ec2-01

output "output-test-server-ec2-01-private-ip" {
    value = aws_instance.test-server-ec2-01.private_ip
}

# output the "server-id" of test-server-ec2-01

output "output-test-server-ec2-01-server-id" {
    value = aws_instance.test-server-ec2-01.id
}

# Import certs

resource "aws_iam_server_certificate" "elb01_test_cert" {
  name             = "elias-test-cert"
  certificate_body = file("certificate.crt")
  private_key      = file("private.pem")
}

# Create a new load balancer

resource "aws_elb" "us-east-2-elb01" {
  name               = "web-us-east-2-elb01"
  #availability_zones = var.us-east-2-az
  subnets            = [aws_subnet.prod_vpc_1_subnet_1.id]
  depends_on         = [aws_internet_gateway.prod_internet_gw_1]
  security_groups = [aws_security_group.prod_1_sg_1.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 443
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = aws_iam_server_certificate.elb01_test_cert.arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.test-server-ec2-01.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "web-us-east-2-elb01"
  }
}

output "us-east-2-elb01-dns-name" {
  description = "The DNS name of the ELB"
  value       = aws_elb.us-east-2-elb01.dns_name
}

