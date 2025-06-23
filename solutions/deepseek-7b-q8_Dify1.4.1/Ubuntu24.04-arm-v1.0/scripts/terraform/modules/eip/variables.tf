######################################################################
# Attributes of the payment
######################################################################

variable "charging_mode" {
  description = "Specifies the charging mode of the elastic IP. Valid values are prePaid and postPaid. The valid values are as follows:prePaid: the year/month billing mode,postPaid: the pay-per-use billing mode."

  type    = string
  default = null
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
  description = "Specifies whether auto renew is enabled. Valid values are true and false. Defaults to false."

  type    = bool
  default = false
}

######################################################################
# Attributes of the bandwidth
######################################################################

variable "bandwidth_share_type" {
  description = "Specifies whether the bandwidth is dedicated or shared.Possible values are as follows:PER: Dedicated bandwidth, WHOLE: Shared bandwidth"

  type    = string
  default = null
}

variable "bandwidth_name" {
  description = "Specifies the bandwidth name.The name can contain 1 to 64 characters, including letters, digits, underscores (_), hyphens (-), and periods (.). This parameter is mandatory when share_type is set to PER"

  type    = string
  default = null
}

variable "bandwidth_size" {
  description = "The bandwidth size.The value ranges from 1 to 300 Mbit/s. This parameter is mandatory when share_type is set to PER."

  type    = number
  default = null
}

variable "bandwidth_id" {
  description = "The shared bandwidth ID.This parameter is mandatory when share_type is set to WHOLE."

  type    = string
  default = null
}

variable "bandwidth_charge_mode" {
  description = "Specifies whether the bandwidth is billed by traffic or by bandwidth size. The value can be traffic or bandwidth."

  type    = string
  default = null
}


######################################################################
# Attributes of the EIP
######################################################################

variable "name_suffix" {
  description = "The suffix string of name for all eip resources"

  type    = string
  default = "mkp"
}

variable "eip_name" {
  description = "The name of the EIP"

  type    = string
  default = null
}

variable "eip_tags" {
  description = "The tags configuration of the EIP"

  type    = map(string)
  default = { Purpose = "MkpApplication" }
}

variable "is_eip_create" {
  description = "Controls whether a EIP should be created (it affects all EIP related resources under this module)"

  type    = bool
  default = true
}

variable "associated_configuration" {
  description = "Associates an EIP to a specified IP address or port."
  type = list(object({
    fixed_ip   = string
    network_id = string
    port_id    = string
  }))
  default = []
}

######################################################################
# Attributes of the publicip
######################################################################

variable "publicip_type" {
  description = "Specifies the EIP type. Possible values are 5_bgp (dynamic BGP) and 5_sbgp (static BGP), the default value is 5_bgp."
  type        = string
  default     = null
}

variable "publicip_address" {
  description = "Specifies the EIP address to be assigned.The value must be a valid IPv4 address in the available IP address range. The system automatically assigns an EIP if you do not specify it. "

  type    = string
  default = null
}

variable "publicip_version" {
  description = "Specifies the IP version, either 4 (default) or 6"

  type    = number
  default = null
}


