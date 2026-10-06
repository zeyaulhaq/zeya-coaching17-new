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
    (local.service_name) = {
      cpu           = var.task_cpu
      memory        = var.task_memory
      desired_count = var.desired_count

      container_definitions = {
        (local.container_name) = {
          essential                = true
          readonly_root_filesystem = false
          image                    = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.region}.amazonaws.com/${local.prefix}-ecr:latest"
          port_mappings = [
            {
              containerPort = var.container_port
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

      # Challenge 1: use our own custom task role instead of the module's
      create_tasks_iam_role = false
      tasks_iam_role_arn    = aws_iam_role.ecs_task_role.arn
    }
  }
}