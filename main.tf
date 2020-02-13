#
# Set minimum Terraform version and Terraform Cloud backend
#
terraform {
  required_version = ">= 0.12"
}

#
# Configure AWS provider
#
provider "aws" {}

#
# Create a random id
#
resource "random_id" "id" {
  byte_length = 2
}


