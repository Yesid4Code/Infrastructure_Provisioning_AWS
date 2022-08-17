# VPC info.
output "SoftServe-vpc_id" {
  description = "The VPC ID"
  value       = try(aws_vpc.SoftServe-vpc.id, "")
}

output "SoftServe-vpc_CIDR" {
  description = "The IPv4 CIDR"
  value       = try(aws_vpc.SoftServe-vpc.cidr_block, "")
}

# Subnet 1 info.
output "arn_instance_1" {
  description = "The ARN of the instance"
  value       = try(aws_instance.web_server_ec2_1.arn, "")
}

output "public_ip_instance_1" {
  description = "The public IP Address assigned to the instance."
  value       = try(aws_instance.web_server_ec2_1.public_ip, "")
}

# Subnet 1
output "arn_instance_2" {
  description = "The ARN of the instance"
  value       = try(aws_instance.web_server_ec2_2.arn, "")
}

output "public_ip_instance_2" {
  description = "The public IP Address assigned to the instance."
  value       = try(aws_instance.web_server_ec2_2.public_ip, "")
}

output "private_ip_instance_1" {
  description = "The private IP addres for the subnet 1"
  value       = try(aws_instance.web_server_ec2_1.private_ip, "")
}

output "private_ip_instance_2" {
  description = "The private IP addres for the subnet 2"
  value       = try(aws_instance.web_server_ec2_2.private_ip, "")
}

# LoadBalancer info.
output "LoadBalancer_ip" {
  description = "LoadBalancer IP"
}
