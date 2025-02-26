variable "environment" {
  description = "The environment using the resource"
  type        = string
}

variable "privateSubnetId" {
  description = "Private Subnet id"
  type        = string
}

variable "vpcId" {
  description = "VPC id"
  type        = string
}

variable "vpcCidr" {
  description = "VPC CIDR"
  type        = string
}

variable "dbConnectionSecretName" {
  description = "Name of the Secret containing the DB connection string"
  type        = string
}

variable "dbConnectionSecretArn" {
  description = "ARN of the Secret containing the DB connection string"
  type        = string
}
