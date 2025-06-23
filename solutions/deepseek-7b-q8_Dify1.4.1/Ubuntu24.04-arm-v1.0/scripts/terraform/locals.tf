locals {
  // you need to specify a unique name under a tenant according to the business, which will be used as part of the resource name
  app_id = format("%s-%s", "app", formatdate("hhmm", timestamp()))

  name_suffix = "mkp"

  // Tags of HUAWEI CLOUD resources. You can add tags to resources to classify resources.
  // for more details, please refer to https://support.huaweicloud.com/usermanual-tms/zh-cn_topic_0056266263.html
  tags = { Purpose = "MkpApplication" }



  # Configuration of the ECS memory size and number of cores
  # instance_flavor_cpu    = 4
  # instance_flavor_memory = 16
  #  通用计算增强型
  instance_performance_type = "kunpeng_computing"
  # 系统盘: 通用SSD
  ecs_volume_type = "GPSSD"

  # 规格：通用入门型
  #ecs_flavor = "kc1.xlarge.4"

  // Billing model for cloud resources, You need to modify it according to your actual situation.
  // In the development and testing phase, pay-per-use billing is recommended.
  // You can also set these three parameters as variables, allowing users to select at deployment time.
  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period

  // The billing model for bandwidth, You need to modify it according to your actual situation.
  publicip_type         = "5_bgp"     # 全动态
  bandwidth_share_type  = "PER"       # 独享带宽
  bandwidth_charge_mode = "bandwidth" # 按带宽计费
  bandwidth_size        = 10          # 带宽大小

  # Image information in different regions, you need to enter your own image ID or add another region.
  # For Marketplace Image Id,you can log in to Seller Console, view the marketplace image id on Product Specifications section of My Products detail page.
  # 镜像版本：
  #deepseek-7b-q8_Dify1.4.1-Ubuntu24.04-arm
  instance_image_id_maps_v1 = {
#     北京4
    cn-north-4     = "ea9cf8a2-7d17-4f69-9d36-662e7c0c37f4"
#     广州
    cn-south-1     = "5a203250-f018-4dbb-957a-48973dbf5fae"
#     上海一
    cn-east-3      = "cf0fc59d-1636-43dd-a826-4f0ac848ae4d"
#     乌兰察布一
    cn-north-9     = "cfe6edbb-1665-4057-9969-f1dd1b258055"
#     贵阳一
    cn-southwest-2 = "906dde0c-3807-4ee1-884a-b7d9f2390223"

  }
  #deepseek-7b-q8_Dify1.4.1-HCE2.0-arm
  instance_image_id_maps_v2 = {
#     北京4
    cn-north-4     = "0a2e361d-5bb9-4c1c-ab2f-3c99484fc152"
#     广州
    cn-south-1     = "b5d33bae-9572-4488-945b-0f4c1779b34f"
#     上海一
    cn-east-3      = "4c37eeea-96cb-4974-bb17-5abb4b9c4729"
#     乌兰察布一
    cn-north-9     = "3a5c3a2c-fc30-4dee-8edd-725b08aeda1a"
#     贵阳一
    cn-southwest-2 = "4af63001-533d-44eb-82c8-2fc1ba72d3db"

  }  
  # # 其他版本增加（注意修改var参数和镜像的版本的判断部分）
  #  instance_image_id_maps = {
  #   #     北京4
  #   cn-north-4 = ""
  #  }  

  # Specifies the DNS server address list of a subnet. For details about the private DNS address, see https://support.huaweicloud.com/dns_faq/dns_faq_002.html#?
  subnet_dns_list_maps = {
    cn-north-4     = ["100.125.1.250", "100.125.129.250"]
    cn-south-1     = ["100.125.1.250", "100.125.136.29"]
    cn-east-3      = ["100.125.1.250", "100.125.64.250"]
    cn-north-9     = ["100.125.1.250", "100.125.107.250"]
    cn-southwest-2 = ["100.125.1.250", "100.125.129.250"]
  }


}