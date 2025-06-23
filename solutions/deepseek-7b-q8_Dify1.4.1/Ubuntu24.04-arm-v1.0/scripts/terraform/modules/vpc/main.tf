//  Parameter details refer to:https://support.huaweicloud.com/api-vpc/vpc_api01_0001.html
resource "huaweicloud_vpc" "vpc" {
  name                  = var.vpc_name
  cidr                  = var.vpc_cidr
  description           = "Creaye By RFS, please don't delete manually."
  enterprise_project_id = var.enterprise_project_id
  tags                  = var.vpc_tags
}

resource "huaweicloud_vpc_subnet" "subnet" {
  vpc_id            = huaweicloud_vpc.vpc.id
  name              = var.name_suffix != null ? format("%s-%s", var.subnet_name, var.name_suffix) : var.subnet_name
  cidr              = var.vpc_subnet_cidr
  gateway_ip        = var.vpc_subnet_gateway_ip
  dns_list          = var.vpc_subnet_dns_list
  availability_zone = var.availability_zone
  tags              = var.subnet_tags
}