provider "aws" {}

resource "aws_vpc" "tharris_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "cluster_subnet" {
  vpc_id     = [aws_vpc.tharris_vpc.id]
  cidr_block = "10.50.0.0/24"
}

output "vpc_id" {
    value = [aws_vpc.tharris_vpc.id]
}

output "subnet_id" {
    value = [aws_subnet.cluster_subnet.id]
}
  