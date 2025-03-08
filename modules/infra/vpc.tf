

# Step Create VPC
# enable_dns_support =  Allows the conversation of human readable domains names to IP addresses
# enable_dns_hostnames = Recommended when you have instances in a VPC that need to communicate with external services or when you want to access instances by their DNS names
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.app_name}-vpc",
    Environment = var.app_environment
  }
}
