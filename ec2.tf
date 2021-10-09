# Webサーバー設定

data "template_file" "web_shell" {
  template = file("${path.module}/web.sh.tpl")
}

# Webサーバーの構築

resource "aws_instance" "web" {
  ami = data.aws_ami.amzn2.id

  instance_type = "t2.micro"

  key_name = aws_key_pair.auth.id

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  subnet_id = aws_subnet.public_a.id

  vpc_security_group_ids = [aws_security_group.pub_a.id]

  root_block_device {
    # ボリュームの種類を指定
    volume_type = "gp2"
    volume_size = 8
    # インスタンス削除時にボリュームも併せて削除する
    delete_on_termination = true
  }

  tags = {
    Name="web-instance"
  }

  # 初めにdata化したweb.sh.tplを参照
  # 設定をbase64にしてencode
  user_data = base64encode(data.template_file.web_shell.rendered)
}