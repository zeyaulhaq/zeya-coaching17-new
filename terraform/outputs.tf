output "environment" {
  value = var.environment
}

output "vpc_id" {
  value = data.aws_vpc.class_vpc.id
}

output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

output "ecr_repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}

output "ecr_repository_name" {
  value = aws_ecr_repository.ecr.name
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = local.service_name
}

output "container_name" {
  value = local.container_name
}

output "task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}