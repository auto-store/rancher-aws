provider "aws" {}

resource "aws_vpc" "tharris-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = [aws_vpc.tharris-vpc.id]
  cidr_block = "10.50.0.0/24"
}