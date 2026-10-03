provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data" {
  #checkov:skip=CKV_AWS_144:Cross-region replication not needed for this demo
  #checkov:skip=CKV_AWS_18:Access logging needs a separate log bucket, out of scope for demo
  #checkov:skip=CKV2_AWS_62:Event notifications not needed for this demo
  #checkov:skip=CKV2_AWS_61:Lifecycle rules not needed for this demo
  #checkov:skip=CKV_AWS_145:Demo uses SSE-S3 (AES256) instead of KMS
  bucket = "my-demo-bucket-12345"
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_security_group" "web" {
  #checkov:skip=CKV2_AWS_5:Not attached to a resource in this demo
  name        = "web-sg"
  description = "SSH access from internal network only"

  ingress {
    description = "SSH from internal network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}
