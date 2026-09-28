variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availablity_zones" {
  description = "Availability zones used by the infrastructure"
  type        = list(string)

  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}