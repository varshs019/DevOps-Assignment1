variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
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
  description = "Backend container image URI (ACR login server/repo:tag)"
  type        = string
  default     = ""
}

variable "frontend_image" {
  description = "Frontend container image URI (ACR login server/repo:tag)"
  type        = string
  default     = ""
}
