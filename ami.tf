# AMI(Amazon Machine Image)の設定

# AMI　の Data Sources(データソーズ)をamzn2という名称で作成

data "aws_ami" "amzn2" {
  most_recent = true

  # 検索を制限するAMI所有者のリスト
  owners = ["amazon"]

  # 一つ以上のnameとvaluesのペアで検索条件を設定
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}