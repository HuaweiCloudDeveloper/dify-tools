output "ecs_ids" {
  value = huaweicloud_compute_instance.ecs[*].id
}

output "access_ips" {
  value = huaweicloud_compute_instance.ecs[*].access_ip_v4
}
output "networks"{
  value = huaweicloud_compute_instance.ecs[*].network
}