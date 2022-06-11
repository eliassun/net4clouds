
variable "defaul_region" {
    type = string
}

variable "access_key" {
    type = string
}

variable "secret_key" {
    type = string
}


# CSP is AWS
provider "aws" {
    region     = var.defaul_region
    access_key = var.access_key != "your_aws_access_key" ? var.access_key : data.external.local_env.result.aws_access_key
    secret_key = var.secret_key != "your_aws_secret_key" ? var.secret_key : data.external.local_env.result.aws_secret_key
}
