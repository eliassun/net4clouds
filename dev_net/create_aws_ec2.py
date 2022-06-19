# github: https://github.com/eliassun/net4clouds
# This script is to create an EC2 instance

import json
import logging
import utils

from constants import (
    RET_CREATE_AWS_EC2
)

LOG = logging.getLogger(__name__)

SCRIPT_CREATE_AWS_EC2 = '''

variable "{ec2_name}_ami" {{
    type = string
    default = "{ami}"
}}

variable "{ec2_name}_size" {{
    type = string
    default = "{size}"
}}

variable "{ec2_name}_key_name" {{
    type = string
    default = "{key}"
}}

variable "{ec2_name}_az" {{
    type = string
    default = "{az}"
}}

resource "aws_instance" "{ec2_name}_ec2_instance" {{
    ami               = var.{ec2_name}_ami
    instance_type     = var.{ec2_name}_size
    availability_zone = var.{ec2_name}_az
    key_name          = var.{ec2_name}_key_name
    network_interface {{
        device_index = 0
        network_interface_id = aws_network_interface.{ec2_name}_nic.id
    }}
    user_data = "${{file("install_softwares.sh")}}"
    tags = {{
        Name = "{ec2_name}_ec2_instance"
    }}
}}

output "output-{ec2_name}-ec2-instance-private-ip" {{
    value = aws_instance.{ec2_name}_ec2_instance.private_ip
}}

output "output-{ec2_name}-ec2-instance-server-id" {{
    value = aws_instance.{ec2_name}_ec2_instance.id
}}

'''

SCRIPT_CREATE_AWS_NIC = '''
variable "{ec2_name}_nic_ips" {{
    type = list
    default = ["10.10.1.100"]
}}

resource "aws_network_interface" "{ec2_name}_nic" {{
    subnet_id       = aws_subnet.dev_subnet.id
    private_ips     = var.{ec2_name}_nic_ips
    security_groups = [aws_security_group.dev_sg.id]
}}
'''

SCRIPT_CREATE_AWS_EIP = '''

resource "aws_eip" "{ec2_name}_eip" {{
    vpc                       = true
    network_interface         = aws_network_interface.{ec2_name}_nic.id
    associate_with_private_ip = var.{ec2_name}_nic_ips[0]
    depends_on                = [aws_internet_gateway.dev_internet_gw]
}}

output "output_{ec2_name}_eip" {{
    value = aws_eip.{ec2_name}_eip
}}
'''


def cmd_create_aws_ec2_handler(name, size, ami, key, az):
    """
    Create an AWS EC2 instance
    :param name: EC2 instance name
    :param size: EC2 size
    :return:
    """
    LOG.info('Creating an AWS EC2 instance')
    LOG.info('AWS EC2 name: %s, size=%s, ami=%s, key=%s, az=%s', name, size, ami, key, az)
    ec2_tf = SCRIPT_CREATE_AWS_EC2.format(ec2_name=name, ami=ami, size=size, key=key, az=az)
    nic_tf = SCRIPT_CREATE_AWS_NIC.format(ec2_name=name)
    eip_tf = SCRIPT_CREATE_AWS_EIP.format(ec2_name=name)
    utils.create_file('ec2_{}.tf'.format(name), ec2_tf)
    utils.create_file('nic_{}.tf'.format(name), nic_tf)
    utils.create_file('eip_{}.tf'.format(name), eip_tf)
    return json.dumps({
        'msg_type': RET_CREATE_AWS_EC2,
        'result': True,
        'reason': 'Created'
    })
