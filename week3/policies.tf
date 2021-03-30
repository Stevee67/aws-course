
resource "aws_iam_policy" "S3BucketsPolicy" {
  name = "S3BucketsPolicy"
  policy = jsonencode(
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  Action: "s3:GetObject",
                  Resource: "*",
                  Effect: "Allow",
              }
          ]
      }
  )
}

resource "aws_iam_policy" "DynamoDbPolicy" {
  name = "DynamoDbPolicy"
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                Sid: "ListAndDescribe",
                Effect: "Allow",
                Action: [
                    "dynamodb:List*",
                    "dynamodb:DescribeReservedCapacity*",
                    "dynamodb:DescribeLimits",
                    "dynamodb:DescribeTimeToLive"
                ],
                Resource: "*"
            },
            {
                Sid: "SpecificTable",
                Effect: "Allow",
                Action: [
                    "dynamodb:BatchGet*",
                    "dynamodb:DescribeStream",
                    "dynamodb:DescribeTable",
                    "dynamodb:Get*",
                    "dynamodb:Query",
                    "dynamodb:Scan",
                    "dynamodb:BatchWrite*",
                    "dynamodb:CreateTable",
                    "dynamodb:Delete*",
                    "dynamodb:Update*",
                    "dynamodb:PutItem"
                ],
                Resource: "arn:aws:dynamodb:*:*:table/Table1"
            }
        ]
    }
  )
}
resource "aws_iam_policy" "PostgresPolicy" {
  name = "PostgresPolicy"
  policy = jsonencode(
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                 Action: [
                     "rds-db:connect"
                 ],
                  Resource: "*",
                  Effect: "Allow",
              }
          ]
      }
  )
}

resource "aws_iam_role_policy_attachment" "S3BucketPolicyAttachment" {
  role = aws_iam_role.EC2Role.name
  policy_arn = aws_iam_policy.S3BucketsPolicy.arn
}
resource "aws_iam_role_policy_attachment" "DynamoDbPolicyAttachment" {
  role = aws_iam_role.EC2Role.name
  policy_arn = aws_iam_policy.DynamoDbPolicy.arn
}
resource "aws_iam_role_policy_attachment" "PostgresPolicyAttachment" {
  role = aws_iam_role.EC2Role.name
  policy_arn = aws_iam_policy.PostgresPolicy.arn
}
