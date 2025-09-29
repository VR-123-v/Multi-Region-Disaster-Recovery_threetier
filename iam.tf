resource "aws_iam_user" "dr_user" {
  provider = aws.primary
  name     = "dr-user"
}

resource "aws_iam_access_key" "dr_user_key" {
  provider = aws.primary
  user    = aws_iam_user.dr_user.name
}
