//  Query the az available for the Region
data "huaweicloud_availability_zones" "az" {}


data "huaweicloud_compute_flavors" "flavors" {
  performance_type  = "kunpeng_computing"
  cpu_core_count    = var.instance_flavor_cpu
  memory_size       = var.instance_flavor_memory
}