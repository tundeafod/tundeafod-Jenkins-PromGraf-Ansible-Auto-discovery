# # IAM User
# resource "aws_iam_user" "prom_user" {
#   name = "prom_user"
# }

# # IAM Access Key
# resource "aws_iam_access_key" "prom_user_key" {
#   user = aws_iam_user.prom_user.name
# }
# #IAM Group
# resource "aws_iam_group" "prom_group" {
#   name = "prom_group"
# }

# # ansible user to prom group
# resource "aws_iam_user_group_membership" "prom_group_membership" {
#   user   = aws_iam_user.prom_user.name
#   groups = [aws_iam_group.prom_group.name]
# }

# resource "aws_iam_group_policy_attachment" "prom_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
#   group      = aws_iam_group.prom_group.name
# }