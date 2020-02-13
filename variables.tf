#variable "AccessKeyID" {}

#variable "SecretAccessKey" {}

variable "prefix" {
  default = "ag2020_3"
}
## Europe Regions need oder Jumphost and BigIP Instance Typs1
## Uncomment needed region below

# US (Ohio)
variable "region" {
  default = "us-east-2"
}

variable "azs" {
  default = ["us-east-2a"]
}

variable "ec2_bigip_type" {
  default = "c4.xlarge"
}
variable "ec2_ubuntu_type" {
  default = "t2.xlarge"
}

variable "cidr" {
  default = "10.70.0.0/16"
}

variable "allowed_mgmt_cidr" {
  default = "0.0.0.0/0"
}

variable "allowed_app_cidr" {
  default = "0.0.0.0/0"
}

variable "management_subnet_offset" {
  default = 10
}

variable "external_subnet_offset" {
  default = 0
}

variable "internal_subnet_offset" {
  default = 20
}

variable "ec2_key_name" {
  default = "VB-ag2020"
}

variable "ec2_key_file" {
  default = "/home/ubuntu/VB-ag2020.pem"
}
