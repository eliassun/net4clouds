

This project builds networks for different Cloud Service Providers based on terraform. Run the projec, then it will generate services:
1. A basic Web service


To run this program, please change the terraform.tfvars, e.g.
1. Change the key name ohio-demo-keypair to your key pair to ssh
2. Change the network CIDRs to fit into your network design

To support HTTPS over AWS ELB, please follow the link below to create certs.
1. https://faun.pub/how-to-create-and-upload-an-ssl-certificate-to-your-aws-account-using-aws-iam-4a247c4e5966
2. Then copy the certificate.crt and private.pem to overwrite the cert and the key in this folder

Run the project by:

1. terraform plan
2. terraform apply

After running this program, you should be able to test the results:
1. http://ec2-domain-name or IP address to check the web page
2. http://elb-domain-name to check web page

More:
install_apache.sh is a shell script to install apache2 after a EC2 is launched. 
install_softwares.sh is a python script to install apache2 and other softwares automatically after a EC2 is launched. 


Network components are created in AWS:
1. VPC
2. Subnet
3. Route Table
4. Internet Gateway
5. Security Group
6. Network Interface
7. Elastic IP 
8. Ubuntu EC2 Instance
9. Elastic Load Balancer

Best security pratices in the project:
1. SSH is only allowed from the same IP to run this project
2. Hide the key instead of any static key in the project to prevent any key(e.g. AWS keys) to be pushed to github or any public place


===================
dev_net
===================
This project builds a network for the developer to build Python and Go Apps.
