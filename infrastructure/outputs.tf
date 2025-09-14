output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.main.id
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${aws_instance.main.public_ip}:8000"
}