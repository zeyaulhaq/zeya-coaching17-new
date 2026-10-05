locals {
  prefix = "zeyaulhaq"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "class_vpc" {
  filter {
    name   = "tag:Name"
    values = ["sctp-vpc-ce13"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.class_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}