output "vpc_eip_address" {
  description = "Elastic ip address for services"
  value       = aws_eip.eip.public_ip
}

output "vpc_prv_subnet_id" {
  description = "Private VPC Subnet"
  value       = aws_subnet.private_subnet.id
}

output "vpcId" {
  description = "Application VPC"
  value       = aws_vpc.app_vpc.id
}

output "vpcCidr" {
  description = "VPC CIDR"
  value       = aws_vpc.app_vpc.cidr_block
}
