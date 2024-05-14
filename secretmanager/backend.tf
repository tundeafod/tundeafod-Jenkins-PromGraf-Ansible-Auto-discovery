# terraform {
#   backend "s3" {
#     bucket         = "tfstate-tspadp"
#     key            = "rds_tf_state/tfstate"
#     dynamodb_table = "tspadp-backend"
#     region         = "eu-west-2"
#     encrypt        = true
#     profile        = "team1"
#   }
# }
