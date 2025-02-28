
resource "aws_iam_role" "lambda_role" {
  name               = "Kafka-Atlas-Lambda-Role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "Kafka-Atlas-Lambda-Policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
   },
   {
      "Effect": "Allow",
      "Action": [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    },
    {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect" : "Allow",
        "Resource": "${var.dbConnectionSecretArn}"
    }
 ]
}
EOF
}

resource "aws_security_group" "lambda_security_group" {
  vpc_id = var.vpcId
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    cidr_blocks = [var.vpcCidr]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "zip_create_product" {
  type        = "zip"
  source_file = "${path.module}/../../dist/create-product-lambda.js"
  output_path = "${path.module}/create-product-lambda.zip"
}

resource "aws_lambda_function" "create_product_func" {
  filename         = data.archive_file.zip_create_product.output_path
  function_name    = "CreateProduct${var.environment}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "create-product-lambda.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.zip_create_product.output_base64sha256
  timeout          = 10
  vpc_config {
    subnet_ids         = [var.privateSubnetId]
    security_group_ids = [aws_security_group.lambda_security_group.id]
  }
  environment {
    variables = {
      MONGO_DB_SECRET : var.dbConnectionSecretName
    }
  }
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role, data.archive_file.zip_create_product]
}
