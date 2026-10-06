# ---------------------------------------------------------------
# Which environment are we deploying? (must be given in .tfvars)
# ---------------------------------------------------------------
variable "environment" {
  description = "Environment name, e.g. dev or prod"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be either \"dev\" or \"prod\"."
  }
}

# ---------------------------------------------------------------
# Values that are usually the SAME for every environment
# (they have defaults, but any .tfvars file can override them)
# ---------------------------------------------------------------
variable "owner" {
  description = "Owner name, used at the start of every resource name"
  type        = string
  default     = "zeyaulhaq"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name tag of the existing VPC to deploy into"
  type        = string
  default     = "sctp-vpc-ce13"
}

variable "container_port" {
  description = "Port the Flask app listens on inside the container"
  type        = number
  default     = 8080
}

# ---------------------------------------------------------------
# Values that are usually DIFFERENT per environment
# (no defaults, so every .tfvars file MUST set them)
# ---------------------------------------------------------------
variable "task_cpu" {
  description = "Fargate task CPU units (256 = 0.25 vCPU, 512 = 0.5 vCPU)"
  type        = number
}

variable "task_memory" {
  description = "Fargate task memory in MB"
  type        = number
}

variable "desired_count" {
  description = "How many copies of the container to run"
  type        = number
}