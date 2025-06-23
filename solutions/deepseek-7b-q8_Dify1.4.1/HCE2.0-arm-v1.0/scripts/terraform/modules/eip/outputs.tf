output "id" {
  value       = huaweicloud_vpc_eip.eip[*].id
  description = "The resource Id of the EIP."
}
output "ip" {
  value       = huaweicloud_vpc_eip.eip[*].address
  description = "The Ipv4 address of the EIP."
}