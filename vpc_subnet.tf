# Webサーバー用 Public Subnet
# ap-northeast-1aのAvailability ZoneにWebサーバー用のサブネットを構築

resource "aws_subnet" "public_a" {
  # サブネットを構築するVPCのidを設定
  vpc_id     = aws_vpc.vpc.id

  # VPCの範囲内でSubnetに割り当てるCIDRを区切る
  cidr_block = "10.0.1.0/24"

  # サブネットを配置するAvailabilityZoneを東京リージョン1aに設定
  availability_zone = "ap-northeast-1a"

  # このサブネットで起動したインスタンスにパブリックIPを割り当てる
  map_public_ip_on_launch = true

  # タグを設定
  tags = {
    Name="pub-a"
  }
}

# APサーバー用 Private Subnet

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  # サブネットを配置するAvailabilityZoneを東京リージョン1aに設定
  availability_zone = "ap-northeast-1a"
  tags = {
    Name="priv-a"
  }
}