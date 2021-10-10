# DB Subnet Group 設定

# DB用のサブネットグループを構築

resource "aws_db_subnet_group" "db_subgrp" {
  # サブネットグループ名
  name = "db-subgrp"

  # サブネットのIDを設定
  subnet_ids = [aws_subnet.dbsub_a.id,aws_subnet.dbsub_c.id]

  # タグを設定
  tags = {
    Name="db-subnet-group"
  }
}

# RDS Parameter Group　設定

# RDSクラスター用のパラメータグループを構築
resource "aws_rds_cluster_parameter_group" "db_clstr_pmtgrp" {
  name ="db-clstr-pmtgrp"

  family = "aurora-mysql5.7"

  description = "RDS Cluster Parameter Group"

  # character_set_serverをutf8に設定
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  # character_set_clientをutf8に設定
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  # time_zoneをAsia/Tokyoに設定
  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"

    # 即時適用
    apply_method = "immediate"
  }

}

# DBインスタンス用のパラメーターグループを構築

resource "aws_db_parameter_group" "db_pmtgrp" {

  name = "db-pmtgrp"

  family = "aurora-mysql5.7"

  description = "RDS Instance Parameter Group"
}
# RDS Cluster設定

variable "rds_master_password" {}

resource "aws_rds_cluster" "aurora_clstr" {
  cluster_identifier = "aurora-cluster"

  # クラスター作成時に自動生成されるデータベース名を記述
  database_name = "mydb"
  master_username = "admin"
  master_password = var.rds_master_password

  # DBが接続を受け入れるポートを設定
  port = 3306
  apply_immediately = false

  skip_final_snapshot = true

  engine = "aurora-mysql"

  engine_version = "5.7.mysql_aurora.2.07.2"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # 利用するDBサブネットの名称を設定
  # aws_db_subnet_groupで定義したサブネットグループをクラスターに設定
  db_subnet_group_name = aws_db_subnet_group.db_subgrp.name

  # aws_db_parameter_groupで定義したパラメータグループをクラスターに設定
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_clstr_pmtgrp.name

  tags = {
    Name = "aurora-cluster"
  }
}

# RDS Instance 設定

resource "aws_rds_cluster_instance" "aurora_instance" {
  # 構築するインスタンスの台数を設定
  count = 2
  # RDSインスタンスの識別子を設定
  identifier = "aurora-cluster-${count.index}"

  # RDSインスタンスを起動するクラスターのidを指定
  cluster_identifier = aws_rds_cluster.aurora_clstr.id

  # インスタンスのクラスを設定
  instance_class     = "db.t2.small"

  # データベースの変更をすぐに適用するか、次のメンテナンス期間中に適用するかを指定
  apply_immediately = false

  # RDS インスタンスで利用するデータベースのエンジンを設定
  engine = "aurora-mysql"

  # aurora-mysqlのバージョンを設定
  engine_version = "5.7.mysql_aurora.2.07.2"

  # 利用するDBサブネットの名称を設定
  # aws_db_subnet_groupで定義したサブネットグループをクラスターに設定
  db_subnet_group_name = aws_db_subnet_group.db_subgrp.name

  # aws_db_parameter_groupで定義したパラメータグループをインスタンスーに設定
  db_parameter_group_name = aws_db_parameter_group.db_pmtgrp.name

  tags = {
    Name = "aurora-instance"
  }
}

## RDS　クラスターの書き込み用エンドポイントを出力
#output "rds-endpoint" {
#  value = aws_rds_cluster.aurora_clstr.endpoint
#}
#
## RDS　クラスターの読み込み用エンドポイントを出力
#output "rds-endpoint-ro" {
#  value = aws_rds_cluster.aurora_clstr.reader_endpoint
#}
