provider "aws" {
    region = "eu-west-2"
}

resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default" {
    availability_zone = "eu-west-2a"

}



#resource "aws_vpc" "tharris_vpc" {
#}
#  cidr_block = "10.0.0.0/16"
#resource "aws_subnet" "cluster_subnet" {
#
#  vpc_id     = [aws_vpc.tharris_vpc.id]
#
#  cidr_block = "10.50.0.0/24"
#  depends_on = [aws_vpc.tharris_vpc]
#}
#

output "vpc_id" {
   value = [aws_default_vpc.default.id]
}

output "subnet_id" {
    value = [aws_default_subnet.cluster_subnet.id]
}
  