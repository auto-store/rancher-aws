data "terraform_remote_state" "server" {
  backend = "remote"
  config = {
    organization = "demo-env"
    workspaces = {
      name = "rancher-server-aws"
    }
  }
}

data "terraform_remote_state" "network-aws" {
  backend = "remote"
  config = {
    organization = "demo-env"
    workspaces = {
      name = "rancher-network-aws"
    }
  }
}

data "terraform_remote_state" "credentials" {
  backend = "remote"
  config = {
    organization = "demo-env"
    workspaces = {
      name = "rancher-creds"
    }
  }
}

provider "rancher2" {
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
}


variable "rancher2_access_key" {}

variable "rancher2_secret_key" {}

variable "cluster_name" {}

variable "pool_name" {} 

variable "aws_access" {}

variable "aws_secret" {}

variable "template_region" {}

variable "hostname_prefix {}


resource "rancher2_cluster" "cluster" {
  name = var.cluster_name
  description = "name of cluster"
  rke_config {
    network {
      plugin = "canal"
    }
  }
}
# Create a new rancher2 Node Template
resource "rancher2_node_template" "template" {
  name = "base_template"
  description = "new template"
  cloud_credential_id = data.terraform_remote_state.credentials.outputs.aws_credentials[0]
  amazonec2_config {
    ami = data.terraform_remote_state.server.outputs.ami
    region = var.template_region
    security_group = data.terraform_remote_state.server.outputs.security_group
    vpc_id = data.terraform_remote_state.network-aws.outputs.vpc_id[0]
    subnet_id = data.terraform_remote_state.network-aws.outputs.subnet_id[0]
    zone = "a"
  }
}
# Create a new rancher2 Node Pool
resource "rancher2_node_pool" "pool" {
  cluster_id =  rancher2_cluster.cluster.id
  name = var.pool_name 
  hostname_prefix =  var.hostname_prefix
  node_template_id = rancher2_node_template.template.id
  quantity = 3
  control_plane = true
  etcd = true
  worker = true
}
