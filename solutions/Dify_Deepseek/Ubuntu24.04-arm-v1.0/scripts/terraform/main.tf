// Create a VPC
module "vpc" {
  source = "./modules/vpc"

  # config of vpc
  name_suffix       = local.name_suffix
  vpc_name          = format("%s-%s", local.app_id, "vpc")
  vpc_cidr          = var.vpc_cidr
  vpc_tags          = local.tags

  # config of subnet
  subnet_name           = format("%s-%s", local.app_id, "subnet")
  vpc_subnet_dns_list   = local.subnet_dns_list_maps[data.huaweicloud_availability_zones.az.region]
  vpc_subnet_cidr       = var.vpc_subnet_cidr
  vpc_subnet_gateway_ip = var.vpc_subnet_gateway_ip
  subnet_tags           = local.tags
}


# Create security group for ecs
module "ecs-security-group" {
  source = "./modules/security-group"

  is_secgroup_create = true

  name_suffix             = local.name_suffix
  secgroup_name           = format("%s-%s", local.app_id, "ecssecgroup")
  is_delete_default_rules = true

  //TODO 服务器安全组修改
  // 服务器安全组配置
  secgroup_rules_configuration = [
    { description      = null, direction = "ingress", ethertype = "IPv4", protocol = "tcp", ports = "22",
      remote_ip_prefix = "0.0.0.0/0", remote_group_id = null
    },
    { description      = null, direction = "ingress", ethertype = "IPv4", protocol = "tcp", ports = "80",
      remote_ip_prefix = "0.0.0.0/0", remote_group_id = null
    },       
    { description      = null, direction = "egress", ethertype = "IPv4", protocol = null, ports = null,
      remote_ip_prefix = "0.0.0.0/0", remote_group_id = null
    }
  ]
}

module "ecs" {
  source = "./modules/ecs"

  is_instance_create = true
  # The total number of The ECS instance
  instance_count = 1

  instance_image_id  = var.Version == "deepseek-7b-q8_Dify1.4.1-Ubuntu24.04-arm" ? local.instance_image_id_maps_v1[data.huaweicloud_availability_zones.az.region] : (var.Version == "deepseek-7b-q8_Dify1.4.1-HCE2.0-arm" ? local.instance_image_id_maps_v2[data.huaweicloud_availability_zones.az.region] : local.instance_image_id_maps_v2[data.huaweicloud_availability_zones.az.region] )
  instance_flavor_id = data.huaweicloud_compute_flavors.flavors.ids[0]

  # You need to change the performance type cpu and memory of the ECS based on the your requirements.
  instance_flavor_performance = local.instance_performance_type
  instance_flavor_cpu         = var.instance_flavor_cpu
  instance_flavor_memory      = var.instance_flavor_memory

  name_suffix   = local.name_suffix
  instance_name = format("%s-%s", local.app_id, "ecs")

  security_group_ids = module.ecs-security-group.secgroup_id

  # Default size and type of the system disk, You need to modify it according to your actual situation. And the size must be greater than the minimum memory size required by the image.
  system_disk_type = local.ecs_volume_type
  system_disk_size = var.ecs_volume_size
  data_disks       = var.data_disk_size == 0 ? [] :[{ data_disk_type = "GPSSD", data_disk_size = var.data_disk_size }]
  # If you need to create multiple network adapters, you need to configure multiple data records.
  networks_configuration = [
    { subnet_id      = module.vpc.subnet_id, fixed_ip_v4 = null, ipv6_enable = false, source_dest_check = true,
      access_network = false
    },
  ]

  charging_mode = local.charging_mode
  period_unit   = local.period_unit
  period        = local.period

  admin_pass    = var.admin_password
  instance_tags = local.tags

  #将eip输出的id绑定到ecs的参数eip_id
  eip_id = flatten(module.eip[*].id[0])[0]


 # TODO 软件包相关操作（示例如下）
  user_data = <<-EOF
  #! /bin/bash
  echo 'root:${var.admin_password}' | chpasswd
  #数据盘初始化操作
  if [ "${var.data_disk_size}" -ne 0 ]; then
    sleep 10
    Dev=$(fdisk -l 2>/dev/null | grep -o "/dev/.*d[b-z]")
    Mfile=/data
    mkdir $Mfile
    fdisk_mkfs() {
    echo -e "n\np\n1\n\n\nwq" | fdisk -S 56 $1
    mkfs.ext4 $${1}1
    }
    fdisk_mkfs $Dev > /dev/null 2>&1
    mount $${Dev}1 $Mfile
    uuids=`blkid |grep $${Dev}1|awk '{print $2}'|awk -F'[="]+' '{print $2}'`
    echo "UUID=$uuids $Mfile ext4 defaults 0 2" >> /etc/fstab  
  fi

  EOF

}


// Create an EIP, if you do not need to create an EIP, delete the code and modules/eip directory
module "eip" {
  source        = "./modules/eip"
  is_eip_create = true

  name_suffix = local.name_suffix
  eip_name    = format("%s-%s", local.app_id, "eip")

  publicip_type         = local.publicip_type
  bandwidth_name        = format("%s-%s", local.app_id, "bandwidth")
  bandwidth_share_type  = local.bandwidth_share_type
  bandwidth_charge_mode = local.bandwidth_charge_mode
  bandwidth_size        = local.bandwidth_size

  charging_mode = local.charging_mode
  period_unit   = local.period_unit
  period        = local.period
  eip_tags = local.tags
}




