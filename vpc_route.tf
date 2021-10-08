# Public Subnet用 Route Table

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.vpc.id

  # 通信経路の設定
  # このインターネットゲートウェイを経由する全てのIPv4をルーティング
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name="rtb-pub-a"
  }
}

# パブリックサブネットとルートテーブルを紐付け

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

# Private Subnet用 Route Table

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.vpc.id

  # 通信経路の設定
  # このNATゲートウェイを経由する全てのIPv4をルーティング
  route {
    nat_gateway_id = aws_nat_gateway.ngw_pub_a.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name="rtb-priv-a"
  }
}

# プライベートサブネットとルートテーブルを紐付け

resource "aws_route_table_association" "private_a" {

  subnet_id = aws_subnet.private_a.id

  route_table_id = aws_route_table.private_a.id
}