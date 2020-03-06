provider "rancher2" {
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
}


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

variable "rancher2_access_key" {}

variable "rancher2_secret_key" {}

variable "cluster_name" {}

variable "pool_name" {} 

variable "aws_access" {}

variable "aws_secret" {}

variable "template_region" {}


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
  amazonec2_config {
    access_key = var.aws_access
    secret_key = var.aws_secret
    ami = data.terraform_remote_state.server.outputs.ami
    region = var.template_region
    security_group = data.terraform_remote_state.server.outputs.security_group
    vpc_id = data.terraform_remote_state.network-aws.outputs.vpc_id
    subnet = data.terraform_remote_state.network-aws.outputs.subnet_id
  }
}
# Create a new rancher2 Node Pool
resource "rancher2_node_pool" "pool" {
  cluster_id =  [rancher2_cluster.cluster.id]
  name = var.pool_name 
  hostname_prefix =  "foo-cluster-0"
  node_template_id = [rancher2_node_template.template.id]
  quantity = 3
  control_plane = true
  etcd = true
  worker = true
}
