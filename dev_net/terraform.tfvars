access_key         = "your_aws_access_key"
secret_key         = "your_aws_secret_key"
defaul_region      = "us-east-2"

dev_vpc_name      = "elias-dev-vpc"
dev_vpc_cidrs     = ["10.10.0.0/16"]

dev_route_table_cidr_v4 = "0.0.0.0/0"
dev_route_table_cidr_v6 = "::/0"
dev_subnet_cidr  = [{cidr_block = "10.10.1.0/24", name = "dev-10.10.1.0-24"}]

dev_access_server_nic_ips = ["10.10.1.100"]

us_east_2_ec2_ubuntu_ami   = "ami-0aeb7c931a5a61206"
us_east_2_ec2_ubuntu_size  = "t2.nano"
us_east_2_ec2_key_name     = "ohio-demo-keypair"
us_east_2_ec2_ubuntu_az    = "us-east-2b"

us_east_2_az = "us-east-2b"
