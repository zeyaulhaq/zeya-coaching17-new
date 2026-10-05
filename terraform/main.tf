resource "aws_ecr_repository" "ecr" {
  name         = "${local.prefix}-ecr"
  force_delete = true
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 7.5.0"

  cluster_name               = "${local.prefix}-ecs"
  cluster_capacity_providers = ["FARGATE"]

  services = {
    zeyaulhaq-flask-service = {
      cpu    = 512
      memory = 1024

      container_definitions = {
        flask-app = {
          essential                = true
          readonly_root_filesystem = false
          image                    = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.region}.amazonaws.com/${local.prefix}-ecr:latest"
          port_mappings = [
            {
              containerPort = 8080
              protocol      = "tcp"
            }
          ]
        }
      }

      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                         = data.aws_subnets.public.ids
      security_group_ids                 = [aws_security_group.ecs_sg.id]
      create_security_group              = false
    }
  }
}