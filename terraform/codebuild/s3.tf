# S3 bucket for backend
resource "aws_s3_bucket" "tf-awesome-tfstate" {
  bucket = "tf-awesome-tfstate"
}
