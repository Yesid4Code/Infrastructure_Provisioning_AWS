# VPC info.
output "SoftServe-vpc_id" {
  description = "The VPC ID"
  value = try(aws_vpc.SoftServe-vpc.id, "")
}

output "SoftServe-vpc_CIDR" {
  description = "The IPv4 CIDR"
  value = try(aws_vpc.SoftServe-vpc.cidr_block, "")
}

# Subnet 1 info.
output "arn_instance_1" {
  description = "The ARN of the instance"
  value = try(aws_instance.web_server_ec2_1.arn, "")
}

output "public_ip_instance_1" {
  description = "The public IP Address assigned to the instance."
  value = try(aws_instance.web_server_ec2_1, "")
}

# Subnet 1
output "arn_instance_2" {
  description = "The ARN of the instance"
  value = try(aws_instance.web_server_ec2_2.arn, "")
}

output "public_ip_instance_1" {
  description = "The public IP Address assigned to the instance."
  value = try(aws_instance.web_server_ec2_1, "")
}

# LoadBalancer info.
output "public_ip" {
  value = aws_instance.web.public_ip
}
