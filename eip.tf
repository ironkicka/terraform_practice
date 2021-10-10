# EIPの設定

resource "aws_eip" "ngw_pub_a" {
  # EIPがVPCにあるかどうか
  vpc = true

  tags = {
    Name="ngw-pub-a"
  }
}

resource "aws_eip" "ec2_pub_a" {
  # EIPがVPCにあるかどうか
  vpc = true

  instance = aws_instance.web.id

  tags = {
    Name="ec2-pub-a"
  }
}