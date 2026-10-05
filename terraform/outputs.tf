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
  value = "zeyaulhaq-flask-service"
}

output "container_name" {
  value = "flask-app"
}