# Web サーバーが端末のグローバルIPからSSh／SFTPとHTTPを受け入れるセキュリティグループ設定

resource "aws_security_group" "pub_a" {
  name = "sg_pub_a"

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name="sg-pub-a"
  }
}

# 出ていく通信の設定
resource "aws_security_group_rule" "egress_pub_a" {
  type = "egress"

  # ポートの範囲設定
  from_port         = 0
  to_port           = 0

  # プロトコル設定
  # 全てのIPv4トラフィックを許可
  protocol          = "-1"

  # 許可するIPの範囲を指定
  # 以下は全てのIPv4トラフィックを許容する設定
  cidr_blocks = ["0.0.0.0/0"]

  # このルールを付与するセキュリティグループの設定
  security_group_id = aws_security_group.pub_a.id
}

# SSH/SFTPを受け入れる設定

resource "aws_security_group_rule" "ingress_pub_a_22" {
  type              = "ingress"

  # ポートの範囲を設定
  from_port         = "22"
  to_port           = "22"

  # プロトコルはtcpを設定
  protocol          = "tcp"

  # 許可するIPの範囲を設定
  cidr_blocks = [aws_ssm_parameter.home_global_ip.value,aws_ssm_parameter.phone_global_ip.value]

  # このルールを付与するセキュリティグループの設定
  security_group_id = aws_security_group.pub_a.id
}

# HTTPを受け入れる設定

resource "aws_security_group_rule" "ingress_pub_a_80" {
  type              = "ingress"

  # ポートの範囲を設定
  from_port         = "80"
  to_port           = "80"

  # プロトコルはtcpを設定
  protocol          = "tcp"

  # 許可するIPの範囲を設定
  cidr_blocks = [aws_ssm_parameter.home_global_ip.value,aws_ssm_parameter.phone_global_ip.value]

  # このルールを付与するセキュリティグループの設定
  security_group_id = aws_security_group.pub_a.id
}

# APサーバーがWebサーバーからVPC内部IPを利用し,SSHを受け入れるSG設定

resource "aws_security_group" "priv_a" {

  name = "sg_priv_a"

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name="sg-priv-a"
  }

}

resource "aws_security_group_rule" "egress_priv_a" {
  type              = "egress"

  # ポートの範囲設定
  from_port         = 0
  to_port           = 0

  # プロトコル設定
  # 全てのIPv4トラフィックを許容する
  protocol          = "-1"

  # 許容するIPの範囲を指定
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.priv_a.id
}

# SSHを受け入れる設定

resource "aws_security_group_rule" "ingress_priv_a_22" {
  type              = "ingress"
  # ポートの範囲を設定
  from_port         = "22"
  to_port           = "22"

  # プロトコルはtcpを設定
  protocol          = "tcp"

  # 許可するIPの範囲を設定
  # Webサーバーを配置しているサブネットのCIDRを設定
  cidr_blocks = ["10.0.1.0/24"]

  # このルールを付与するセキュリティグループの設定
  security_group_id = aws_security_group.priv_a.id
}


# RDSがAPサーバーから3306ポートを利用した通信を受け入れるSG設定

resource "aws_security_group" "rds_sg" {

  name = "rds-sg"

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name="rds-sg"
  }
}

# 出ていく通信の設定

resource "aws_security_group_rule" "egress_rds_sg" {
  type="egress"

  # ポートの範囲設定
  from_port = 0
  to_port = 0

  protocol  = "-1"

  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}

# 3306ポートを受け入れる設定
resource "aws_security_group_rule" "ingress_rds_3306" {
  type="ingress"

  from_port         = "3306"
  to_port           = "3306"

  protocol          = "tcp"
  # Webサーバーを配置しているサブネットのCIDRを設定
  cidr_blocks = ["10.0.2.0/24"]
  security_group_id = aws_security_group.rds_sg.id
}