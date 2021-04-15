resource "aws_iam_policy" "SQSPolicy" {
  name = "SQSPolicy"
  policy = jsonencode(
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                 Action: [
                     "sqs:*"
                 ],
                 Resource: "*",
                 Effect: "Allow",
              }
          ]
      }
  )
}
resource "aws_iam_role_policy_attachment" "SQSPolicyAttachment" {
  role = aws_iam_role.EC2Role.name
  policy_arn = aws_iam_policy.SQSPolicy.arn
}