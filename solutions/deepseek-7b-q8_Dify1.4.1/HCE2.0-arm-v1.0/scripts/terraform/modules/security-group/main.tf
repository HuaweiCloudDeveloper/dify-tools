resource "huaweicloud_networking_secgroup" "secgroup" {
  count = var.is_secgroup_create ? 1 : 0
  name                 = var.name_suffix != null ? format("%s-%s", var.secgroup_name, var.name_suffix) : var.secgroup_name
  description          = var.secgroup_description
  delete_default_rules = var.is_delete_default_rules
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rules" {
  count = var.is_secgroup_create && var.secgroup_rules_configuration != null ? length(var.secgroup_rules_configuration) : 0
  
  security_group_id = huaweicloud_networking_secgroup.secgroup[0].id
  description      = lookup(element(var.secgroup_rules_configuration, count.index), "description")
  direction        = lookup(element(var.secgroup_rules_configuration, count.index), "direction")
  ethertype        = lookup(element(var.secgroup_rules_configuration, count.index), "ethertype")
  protocol         = lookup(element(var.secgroup_rules_configuration, count.index), "protocol")
  ports            = lookup(element(var.secgroup_rules_configuration, count.index), "ports")
  remote_ip_prefix = lookup(element(var.secgroup_rules_configuration, count.index), "remote_ip_prefix")
  remote_group_id = lookup(element(var.secgroup_rules_configuration, count.index), "remote_group_id")
}
