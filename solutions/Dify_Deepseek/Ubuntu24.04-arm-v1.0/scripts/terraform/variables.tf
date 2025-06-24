variable "admin_password" {
  type        = string
  description = "Administrator password of the ECS instance. The password must contain 8 to 26 characters and must contain at least three types of the following characters: uppercase letters, lowercase letters, digits, and special characters (!@$%^-_=+[{}]:, ./?)."
  nullable    = false
  sensitive   = true
  validation {
    condition = (
    length(var.admin_password) >= 8 && length(var.admin_password) <= 26 &&
    length(regexall(".*[a-zA-Z].*", var.admin_password)) > 0 &&
    length(regexall(".*[0-9].*", var.admin_password)) > 0 &&
    length(regexall(".*[!@\\$%\\^-_=\\+\\[\\{\\}\\]:,\\./\\?].*", var.admin_password)) > 0
    )
    error_message = "The password must contain 8 to 26 characters and must contain at least three types of the following characters: uppercase letters, lowercase letters, digits, and special characters (!@$%^-_=+[{}]:, ./?)."
  }
}
variable "instance_flavor_cpu" {
  description = " Set the cpu (The parameters must meet the product requirements and the Kunpeng general computing-plus server specifications of the actual ECS Kunpeng architecture.)"
  nullable    = false
  type    = number
  default = 8
}

variable "instance_flavor_memory" {
  description = " Set the memory size (The parameters must meet the product requirements and the Kunpeng general computing-plus server specifications of the actual ECS Kunpeng architecture.)"
  nullable    = false
  type    = number
  default = 16
}


variable "ecs_volume_size" {
  description = " Set the system disk size ( requires at least 40G or larger. The default value is 40G). "
  nullable    = false
  type    = number
  default = 40
}

variable "data_disk_size" {
  description = "Set the size of the data disk to be mounted. If no data disk is required, set this parameter to 0. You can set this parameter based on the site requirements. "
  nullable    = false
  type    = number
  default = 0
}

variable "Version" {
  type        = string
  nullable    = false
  description = "Selecting a version number."
  validation {
    condition     = contains(["deepseek-7b-q8_Dify1.4.1-Ubuntu24.04-arm","deepseek-7b-q8_Dify1.4.1-HCE2.0-arm"], var.Version)
    error_message = "The value of input_parameter must exist in the drop-down list box."
  }
}



variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "Specifies the range of available subnets in the VPC. The value ranges from 10.0.0.0/8 to 10.255.255.0/24, 172.16.0.0/12 to 172.31.255.0/24, or 192.168.0.0/16 to 192.168.255.0/24."
}
variable "vpc_subnet_cidr" {
  type        = string
  default     = "192.168.10.0/24"
  description = "Specifies the network segment on which the subnet resides. The value must be in CIDR format and within the CIDR block of the VPC. The subnet mask cannot be greater than 28. Changing this creates a new Subnet."
}
variable "vpc_subnet_gateway_ip" {
  type        = string
  default     = "192.168.10.1"
  description = "Specifies the gateway of the subnet. The value must be a valid IP address in the subnet segment. Changing this creates a new subnet."
}

variable "charging_mode" {
  type        = string
  nullable    = false
  description = " Specifies the charging mode of the disk. The valid values are as follows:prePaid: the yearly/monthly billing mode,postPaid: the pay-per-use billing mode."
  validation {
    condition     = contains(["postPaid", "prePaid"], var.charging_mode)
    error_message = "Allowed values for input_parameter are prePaid or postPaid."
  }
}

variable "period_unit" {
  description = "The period unit of the pre-paid purchase.Valid values are month and year. This parameter is mandatory if charging_mode is set to prePaid. "

  type    = string
  default = "month"
  validation {
    condition     = contains(["month", "year"], var.period_unit)
    error_message = "Allowed values for input_parameter are month or year."
  }
}

variable "period" {
  description = "The period number of the pre-paid purchase. If period_unit is set to month , the value ranges from 1 to 9. If period_unit is set to year, the value ranges from 1 to 3. This parameter is mandatory if charging_mode is set to prePaid. "

  type    = number
  default = 1
}


