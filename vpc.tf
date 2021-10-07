# VPC設定

resource "aws_vpc" "vpc" {
  # ネットワークの範囲を設定
  cidr_block = "10.0.0.0/16"

  # タグを設定
  tags = {
    Name="dev-vpc"
  }
}