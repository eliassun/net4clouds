#!/usr/bin/env python3
# github: https://github.com/eliassun/net4clouds

import os

os.system('sudo apt-get update')
os.system('sudo apt-get install -y apache2')
os.system('sudo systemctl start apache2')
os.system('sudo systemctl enable apache2')
os.system('echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html')
os.system('sudo apt-get wget')
os.system('sudo apt-get git')

