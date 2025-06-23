output "secgroup_id" {
  value = huaweicloud_networking_secgroup.secgroup[*].id
}