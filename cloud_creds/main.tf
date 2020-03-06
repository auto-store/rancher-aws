provider "rancher2" {
  api_url    = data.terraform_remote_state.server.outputs.rancher-url
}

variable "aws_access" {}

variable "aws_secret" {}

resource "rancher2_cloud_credential" "aws_cluster" {
  name = "aws_cluster"
  amazonec2_credential_config {
    access_key = var.aws_access
    secret_key = var.aws_secret 
  }
}