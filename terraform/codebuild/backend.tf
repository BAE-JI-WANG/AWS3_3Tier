
# terraform {
#   required_version = "= 1.1.8"

#   backend "s3" {
#     bucket         = "tf-awesome-tfstate" # 자신의 버킷으로 수정
#     key            = "terraform/codebuild/terraform.tfstate" # 원하는 키 사용
#     region         = "ap-northeast-2"
#     encrypt        = true
#     dynamodb_table = "terraform-lock" # 앞에서 생성한 DynamoDB 이름
#   }
# }

# resource "aws_s3_bucket_versioning" "tfstate" {
#   bucket = "tf-awesome-tfstate"
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # DynamoDB for terraform state lock
# resource "aws_dynamodb_table" "terraform_state_lock" {
#   name           = "terraform-lock"
#   hash_key       = "LockID"
#   billing_mode   = "PAY_PER_REQUEST"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
