provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data" {
  bucket = "my-demo-bucket-12345"
  acl    = "public-read"   # INTENTIONAL FLAW
}

resource "aws_security_group" "web" {
  name = "web-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # INTENTIONAL FLAW: SSH open to the world
  }
}