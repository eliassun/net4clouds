# github: https://github.com/eliassun/net4clouds

# Create a network by Terraform


terraform {

}

# get my current public IP and keys

data "external" "local_env" {
  program = ["python3","dev_local_env.py"]
  query = {
  }
}
