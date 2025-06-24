//ecs相关输出
output "ecs_access_ips" {
  value = flatten(module.ecs[*].access_ips[0])[0]
  description = "The Ipv4 address of the ecs."
}

output "eip_ip" {
  value       = flatten(module.eip[*].ip[0])[0]
  #value       = [for eip in module.eip.ip : eip.ip]
  #value       = module.eip.ip
  description = "The Ipv4 address of the EIP."
}

output "ecs_password" {
  value       = var.admin_password
  sensitive = true
  description = "The password of the ecs."
}