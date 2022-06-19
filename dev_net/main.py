
# github: https://github.com/eliassun/net4clouds
# This script is to set up the dev env to build Python and Go env after EC2 is launched

# Run this script by "command parameter1 parameter2 ..."
# e.g.  python3 main.py cmd_create_aws_ec2 my_ec2_name t2.micro

import argparse
import sys
import logging

from constants import (
    LOG_FILE_NAME,
    CMD_CREATE_AWS_EC2
)

from create_aws_ec2 import cmd_create_aws_ec2_handler

LOG = logging.getLogger(__name__)


def get_net_parser():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    parser_create_ec2 = subparsers.add_parser(CMD_CREATE_AWS_EC2)
    parser_create_ec2.add_argument('--name', help='AWS EC2 name', default='ec2-from-terraform')
    parser_create_ec2.add_argument('--size', help='AWS EC2 size', default='t2.nano')
    parser_create_ec2.add_argument('--ami', help='AWS EC2 AMI', default='ami-0aeb7c931a5a61206')
    parser_create_ec2.add_argument('--key', help='AWS EC2 key pair', default='ohio-demo-keypair')
    parser_create_ec2.add_argument('--az', help='AWS AZ', default='us-east-2b')
    parser_create_ec2.set_defaults(func=lambda h: cmd_create_aws_ec2_handler(name=h.name, size=h.size, ami=h.ami, key=h.key, az=h.az))

    return parser


def parse_net_args(args=None):
    cmds = get_net_parser().parse_args(args=args)
    return cmds


def main(cmds=None):
    return cmds.func(cmds)


if __name__ == '__main__':
    LOG.progagte = False
    logging.basicConfig(level=logging.INFO, filename=LOG_FILE_NAME, datefmt='%H:%M:%S',
                        format="[%(asctime)s %(filename)s:%(lineno)d %(levelname).1s]  %(message)s")
    print(main(parse_net_args()))
    sys.exit(0)
