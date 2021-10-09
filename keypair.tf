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

# APサーバー用　公開鍵設定
variable "ssh_key_priv_path" {}

data "template_file" "ssh_key_priv" {
  # ローカルに存在するAPサーバー用の公開鍵を読み込み
  template = file(var.ssh_key_priv_path)
}

# EC2キーペアリソースを設定
# EC２インスタンスへのログインアクセスを制御するために使用

resource "aws_key_pair" "auth_priv" {
  # Web サーバ用のキーペア名を定義
  key_name = "id_rsa_priv.pub"

  # template_fileのWebサーバー用の公開鍵を設定
  public_key = data.template_file.ssh_key_priv.rendered
}