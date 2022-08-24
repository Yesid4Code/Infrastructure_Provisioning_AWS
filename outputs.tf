# VPC info.
output "SoftServe_vpc_id" {
  description = "The VPC ID"
  value       = try(aws_vpc.SoftServe_vpc.id, "")
}

output "SoftServe_vpc_CIDR" {
  description = "The IPv4 CIDR"
  value       = try(aws_vpc.SoftServe_vpc.cidr_block, "")
}

output "arn_web_server_ec2_2a" {
  description = "The ARN of the instance"
  value       = try(aws_instance.web_server_ec2_2a.arn, "")
}

output "arn_web_server_ec2_2b" {
  description = "The ARN of the instance"
  value       = try(aws_instance.web_server_ec2_2b.arn, "")
}

output "public_ip_web_server_ec2_2a" {
  description = "The public IP Address assigned to the instance."
  value       = try(aws_instance.web_server_ec2_2a.public_ip, "")
}

output "public_ip_web_server_ec2_2b" {
  description = "The public IP Address assigned to the instance."
  value       = try(aws_instance.web_server_ec2_2b.public_ip, "")
}

output "private_ip_web_server_ec2_2a" {
  description = "The private IP addres for the subnet 1"
  value       = try(aws_instance.web_server_ec2_2a.private_ip, "")
}

output "private_ip_web_server_ec2_2b" {
  description = "The private IP addres for the subnet 2"
  value       = try(aws_instance.web_server_ec2_2b.private_ip, "")
}

output "NLB_DNS_name" {
  description = "Network Load Balancer"
  value       = try(aws_lb.NLB.dns_name, "")
}
