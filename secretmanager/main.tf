# locals {
#   name = "Jenkins-Ansible-Auto-discovery1"
# }

# resource "aws_kms_key" "kms_rds_key" {
#   description             = "KMS key for RDS"
#   is_enabled              = true
#   enable_key_rotation     = true
#   deletion_window_in_days = 8
#   tags = {
#     Name = "${local.name}-rds_kms_key"
#   }
# }

# resource "random_password" "password1" {
#   length           = 16
#   special          = true
#   override_special = "_!%^"
# }

# resource "aws_secretsmanager_secret" "autodiscovery" {
#   kms_key_id              = aws_kms_key.kms_rds_key.id
#   name                    = "admin"
#   description             = "RDS Admin password"
#   recovery_window_in_days = 14

#   tags = {
#     Name = "${local.name}-rds-secretmanager"
#   }
# }

# resource "aws_secretsmanager_secret_version" "autodiscovery" {
#   secret_id     = aws_secretsmanager_secret.autodiscovery.id
#   secret_string = random_password.password1.result
# }