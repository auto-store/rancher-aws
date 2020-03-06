data "terraform_remote_state" "server" {
  backend = "remote"
  config = {
    organization = "demo-env"
    workspaces = {
      name = "rancher-server-aws"
    }
  }
}

provider "rancher2" {}

variable "aws_access" {}

variable "aws_secret" {}

resource "rancher2_cloud_credential" "aws_cluster" {
  name = "aws_cluster"
  amazonec2_credential_config {
    access_key = var.aws_access
    secret_key = var.aws_secret 
  }
}

resource "rancher2_cloud_credential" "aws_credentials" {
  name = "aws_cluster"
  amazonec2_credential_config {
    access_key = var.aws_access
    secret_key = var.aws_secret 
  }
}

output "aws_credentials" {
  value = [rancher2_cloud_credential.aws_credentials.id]
}