variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "devops-assignment"
}

variable "backend_image" {
  description = "Backend container image URI (use ECR URL from output if empty)"
  type        = string
  default     = ""
}

variable "frontend_image" {
  description = "Frontend container image URI (use ECR URL from output if empty)"
  type        = string
  default     = ""
}

