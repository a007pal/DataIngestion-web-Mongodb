resource "aws_iam_role" "kafka_zookeeper_ec2" {
  name = "kafka_zookeeper_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_role_policy" "kafka_zookeeper_secert_policy" {
  name = "kafka_zookeeper_secret_policy"
  role = aws_iam_role.kafka_zookeeper_ec2.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy" "kafka_zookeeper_s3_policy" {
  name = "kafka_zookeeper_s3_policy"
  role = aws_iam_role.kafka_zookeeper_ec2.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::kafka-files-prop",
          "arn:aws:s3:::kafka-files-prop/*"
        ]
      }
    ]

  })


}
resource "aws_iam_instance_profile" "kafka_profile" {
  name = "kafka-zookeeper-instance-profile"
  role = aws_iam_role.kafka_zookeeper_ec2.name

}
