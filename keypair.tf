# Webサーバー用　公開鍵設定
variable "ssh_key_path" {}

data "template_file" "ssh_key" {
  template = file(var.ssh_key_path)
}

# EC２インスタンスへのログインアクセスを制御するために使用

resource "aws_key_pair" "auth" {
  # Web サーバ用のキーペア名を定義
  key_name = "id_rsa.pub"

  # template_fileのWebサーバー用の公開鍵を設定
  public_key = data.template_file.ssh_key.rendered
}