# Create a network by Terraform
# github: https://github.com/eliassun/net4clouds

terraform {

}

# get my current public IP and keys

data "external" "dev_local_env" {
  program = ["python3","local_env.py"]
  query = {
  }
}

