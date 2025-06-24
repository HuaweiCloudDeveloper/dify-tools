data "huaweicloud_availability_zones" "az" {}

// Query flavors of all az
data "huaweicloud_compute_flavors" "flavors" {
  count = length(data.huaweicloud_availability_zones.az.names)

  availability_zone = data.huaweicloud_availability_zones.az.names[count.index]

  performance_type = var.instance_flavor_performance
  cpu_core_count   = var.instance_flavor_cpu
  memory_size      = var.instance_flavor_memory
}

locals {
  # az and available flavors map, such as {cn-north-4a = ["ac7.large.2", "c3ne.large.2"]}
  available_flavors_id_maps = { for i, flavor_ids in data.huaweicloud_compute_flavors.flavors[*].ids : data.huaweicloud_availability_zones.az.names[i] => flavor_ids if length(flavor_ids) > 0 }
  # az and available flavors map, such as {ac7.large.2 = ["cn-north-4a", "cn-north-4b"]}
  flavors2az_maps = transpose(local.available_flavors_id_maps)
  # Only flavors that exist in two or more AZs are reserved.
  available_flavors_map = { for flavor_id, azs in local.flavors2az_maps : flavor_id => azs if length(azs) >= 1 }
  # Obtains an available flavor.
  okFlavor = var.instance_flavor_id != null && contains(keys(local.available_flavors_map), var.instance_flavor_id) ? var.instance_flavor_id : keys(local.available_flavors_map)[0]
  # Obtain the AZs of the master and slave nodes.
  availability_zone = local.available_flavors_map[local.okFlavor][0]
}

// Parameter details refer to:https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/compute_instance
resource "huaweicloud_compute_instance" "ecs" {
  count = var.is_instance_create ? (var.instance_count > 0 ? var.instance_count : 1) : 0

  image_id          = var.instance_image_id
  availability_zone = var.availability_zone != null ? var.availability_zone : local.availability_zone
  flavor_id         = local.okFlavor

  name = var.name_suffix != null ? format("%s-%s", var.instance_name, var.name_suffix) : var.instance_name

  security_group_ids          = var.security_group_ids
  system_disk_type            = var.system_disk_type
  system_disk_size            = var.system_disk_size
  eip_id                      = var.eip_id
  stop_before_destroy         = var.stop_before_destroy
  delete_disks_on_termination = var.delete_disks_on_termination
  delete_eip_on_termination = var.delete_eip_on_termination

  user_data  = var.user_data
  admin_pass = var.admin_pass

  dynamic "data_disks" {
    for_each = var.data_disks

    content {
      type = data_disks.value["data_disk_type"]
      size = data_disks.value["data_disk_size"]
    }
  }

  dynamic "network" {
    for_each = var.networks_configuration

    content {
      uuid              = network.value["subnet_id"]
      fixed_ip_v4       = network.value["fixed_ip_v4"]
      ipv6_enable       = network.value["ipv6_enable"]
      source_dest_check = network.value["source_dest_check"]
      access_network    = network.value["access_network"]
    }
  }
//  eip_type = var.eip_type
//  bandwidth{
//    share_type = var.bandwidth_share_type
//    size = var.bandwidth_size
//    charge_mode = var.bandwidth_charge_mode
//  }


  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.is_auto_renew

  agent_list = var.agent_list

  tags = var.instance_tags
}