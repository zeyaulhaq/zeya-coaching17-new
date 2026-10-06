locals {
  # e.g. "zeyaulhaq-dev" or "zeyaulhaq-prod"
  prefix = "${var.owner}-${var.environment}"

  # e.g. "zeyaulhaq-dev-flask-service"
  service_name = "${local.prefix}-flask-service"

  # Container name stays the same in every environment
  container_name = "flask-app"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "class_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
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