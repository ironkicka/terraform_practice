# EIPの設定

resource "aws_eip" "ngw_pub_a" {
  # EIPがVPCにあるかどうか
  vpc = true

  tags = {
    Name="ngw-pub-a"
  }
}