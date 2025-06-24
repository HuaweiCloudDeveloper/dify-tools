variable "is_secgroup_create" {
  description = "Controls whether the secgroup should be created"

  type    = bool
  default = true
}

variable "secgroup_name" {
  description = "Specifies a unique name for the security group."
  type        = string
  default     = null
}

variable "name_suffix" {
  description = "The suffix string of name for all eip resources"

  type    = string
  default = "mkp"
}

variable "secgroup_description" {
  description = "Specifies the supplementary information about the networking security group rule. This parameter can contain a maximum of 255 characters and cannot contain angle brackets (< or >)."
  type        = string
  default     = null
}

variable "is_delete_default_rules" {
  description = "Specifies whether or not to delete the default security rules."
  type        = bool
  default     = true
}

variable "secgroup_rules_configuration" {
  description = "The configuration for security group rule resources to which the security group belongs"
  type = list(object({
    description             = string
    direction               = string
    ethertype               = string
    protocol                = string
    ports                   = string
    remote_ip_prefix        = string
    remote_group_id = string
  }))
  default = []
}