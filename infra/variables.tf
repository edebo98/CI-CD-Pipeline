# variables.tf

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "app_name" {
  description = "Name of the application"
  default     = "cicd-app"
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "container_port" {
  description = "Port the container listens on"
  default     = 3000
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  # This will be overridden by the actual VPC resource later
  default = ""
}
