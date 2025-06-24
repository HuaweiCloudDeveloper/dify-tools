variable "images_visibility" {
  type        = string
  default     = null
  description = "(Optional, String) The visibility of the image. Must be one of public, private or shared."
}

variable "name_suffix" {
  description = "The suffix string of name for all eip resources"

  type    = string
  default = "mkp"
}

######################################################################
# Attributes of the VPC resources
######################################################################

variable "networks_configuration" {
  description = "Specifies an array of one or more networks to attach to the instance."
  type = list(object({
    subnet_id         = string
    fixed_ip_v4       = string
    ipv6_enable       = bool
    source_dest_check = bool
    access_network    = bool
  }))
  default = []
}

variable "data_disks" {
  description = "Specifies an array of one or more data disks to attach to the instance."
  type = list(object({
    data_disk_type = string
    data_disk_size = number
  }))
  default = []
}

variable "security_group_ids" {
  description = "The ID list of the security groups to which the ECS instance belongs"

  type    = list(string)
  default = []
}

variable "availability_zone" {
  type        = string
  default     = null
  description = " (Optional) This is the Huawei Cloud availability_zone. It must be provided when using static credentials authentication."
}

######################################################################
# EIP
######################################################################
variable "eip_type" {
  description = "Specifies the type of an EIP that will be automatically assigned to the instance. Available values are 5_bgp (dynamic BGP) and 5_sbgp (static BGP). "
  type    = string
  default = null
}
variable "bandwidth_share_type" {
  description = "Specifies the bandwidth sharing type. PER: Dedicated bandwidth；WHOLE: Shared bandwidth"
  type    = string
  default = null
}
variable "bandwidth_charge_mode" {
  description = "Specifies the bandwidth billing mode. The value can be traffic or bandwidth."
  type    = string
  default = null
}
variable "bandwidth_size" {
  description = "Specifies the bandwidth size."
  type    = number
  default = null
}
######################################################################
# Attributes of the payment
######################################################################

variable "charging_mode" {
  type        = string
  default     = null
  description = " Specifies the charging mode of the disk. The valid values are as follows:prePaid: the yearly/monthly billing mode,postPaid: the pay-per-use billing mode. Changing this creates a new disk."
}

variable "period_unit" {
  description = "The period unit of the pre-paid purchase"

  type    = string
  default = null
}

variable "period" {
  description = "The period number of the pre-paid purchase"

  type    = number
  default = null
}

variable "is_auto_renew" {
  description = "Whether to automatically renew after expiration for ECS resources"

  type    = bool
  default = null
}

######################################################################
# Configuration of ECS instance and related resources
######################################################################

variable "is_instance_create" {
  description = "Controls whether a ECS instance should be created (it affects all ECS related resources under this module)"

  type    = bool
  default = true
}

variable "instance_count" {
  description = "The total number of the ECS instances"

  type    = number
  default = 0
}

variable "instance_name" {
  description = "The name of the ECS instance"

  type    = string
  default = null
}

variable "instance_flavor_id" {
  description = "The ID of the ECS instance flavor"

  type    = string
  default = null
}

# for more details of the Type, please refer to https://support.huaweicloud.com/api-ecs/zh-cn_topic_0020212656.html
variable "instance_flavor_performance" {
  description = "The performance type of the ECS instance flavor. The type value can be: normal(General computing)、computingv3(General computing-plus)、highmem(Memory-optimized)、saphana(Large-memory HANA ECS)、diskintensive(Disk-intensive)"

  type    = string
  default = null
}

variable "instance_flavor_cpu" {
  description = "The CPU number of the ECS instance flavor"

  type    = number
  default = null
}

variable "instance_flavor_memory" {
  description = "The memory number of the ECS instance flavor"

  type    = number
  default = null
}

variable "instance_image_id" {
  description = "The ID of the IMS image used to create the ECS instance"

  type    = string
  default = null
}

variable "instance_image_visibility" {
  description = "The visibility of the image. Must be one of public, private, market or shared"

  type    = string
  default = "public"
}

variable "system_disk_type" {
  description = "The type of the system volume"

  type    = string
  default = "SSD"
}

variable "system_disk_size" {
  description = "The size of the system volume, in GB"

  type    = number
  default = 40
}

variable "eip_id" {
  description = "The ID of the EIP assigned to the ECS instance"

  type    = string
  default = null
}

variable "user_data" {
  type        = string
  description = "Specifies the user data to be injected during the instance creation. Text and text files can be injected."
  default     = null
}

variable "admin_pass" {
  type        = string
  description = "Specifies the administrative password to assign to the instance. If the user_data field is specified for a Linux ECS that is created using an image with Cloud-Init installed, the admin_pass field becomes invalid."
  default     = null
  sensitive   = true
}

variable "stop_before_destroy" {
  description = "Whether to try stop instance gracefully before destroying it, thus giving chance for guest OS daemons to stop correctly"

  type    = bool
  default = true
}

variable "delete_disks_on_termination" {
  description = "Whether to delete the data disks when the instance is terminated"

  type    = bool
  default = true
}

variable "delete_eip_on_termination" {
  description = "Whether to release the EIP when the instance is terminated"

  type    = bool
  default = true
}

variable "agent_list" {
  description = "Specifies the agent list in comma-separated string. Available agents are: ces: enable cloud eye monitoring(free).hss: enable host security basic(free).hss,hss-ent: enable host security enterprise edition."
  type        = string
  default     = "ces"
}

variable "instance_tags" {
  description = "The tags configuration of the ECS instance"

  type    = map(string)
  default = { Purpose = "MkpApplication" }
}