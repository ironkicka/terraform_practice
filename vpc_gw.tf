# インターネットゲートウェイ

resource "aws_internet_gateway" "igw" {
  # 作成する VPC IDを設定
  vpc_id = aws_vpc.vpc.id

  # タグを設定
  tags = {
    Name="igw"
  }
}

# NATゲートウェイ

resource "aws_nat_gateway" "ngw_pub_a" {
  # NATゲートウェイに関連づけるElastic IPアドレスの割り当てID
  allocation_id = aws_eip.ngw_pub_a.id
  # NATゲートウェイを配置するサブネットのサブネットID
  subnet_id = aws_subnet.public_a.id

  tags = {
    Name="ngw-pub-a"
  }
}