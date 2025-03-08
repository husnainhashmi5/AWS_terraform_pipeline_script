# Using Temporary keys for Terraform
variable "aws_region" {
  description = "AWS Region"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 1
}

variable "app_name" {
  type        = string
  description = "App name"
  default     = "alan-ecs-terraform"
}

variable "app_environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

# Variables
variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "var_public_route" {
  type = object({
    cidr_block = string
    gateway_id = string
  })
  default = {
    cidr_block = ""
    gateway_id = ""
  }
}

variable "var_private_route" {
  type = object({
    cidr_block     = string
    nat_gateway_id = string
  })
  default = {
    cidr_block     = ""
    nat_gateway_id = ""
  }
}

variable "infra_params" {
  description = "Infra module paramaters"
  type = object({
    alb_tls_cert_arn     = string
    app_port             = number
    hosted_api_demo_name = string
    hosted_zone_id       = string
  })
}
variable "desired_nat_gateways" {
  description = "Number of NAT gateways to create"
  type        = number
  default     = 2  # Set your default value
}

variable "resource_suffix" {
  type    = string
  default = ""
}

variable "nat_gateway_count" {
  type    = number
  default = 2
}