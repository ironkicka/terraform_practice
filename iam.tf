# EC2用 iam_roleの定義

# instance_profileが参照するIAMを作成

resource "aws_iam_role" "ec2_role" {
  # AWS上での名前
  name = "ec2-role"

  # IAMロールのディレクトリ分けのような機能
  path = "/"

  # EC2が他のリソースへ一時的にアクセスするassume_rol_policyを作成

  assume_role_policy = <<EOF
{"Version":"2012-10-17",
"Statement":[
{
"Action":"sts:AssumeRole",
"Principal":{
"Service":"ec2.amazonaws.com"
},
"Effect":"Allow",
"Sid":""
}
]
}
  EOF
}


# 用意した iam_role とEC2のinstance_profileを紐付け

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"

  role = aws_iam_role.ec2_role.name
}