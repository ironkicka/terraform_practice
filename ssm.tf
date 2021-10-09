variable "home_global_ip" {}
variable "phone_global_ip" {}

resource "aws_ssm_parameter" "home_global_ip" {
  name  = "/IpWhiteList/myHome"
  value = var.home_global_ip
  type  = "String"
}

resource "aws_ssm_parameter" "phone_global_ip" {
  name  = "/IpWhiteList/myPhone"
  value = var.phone_global_ip
  type  = "String"
}