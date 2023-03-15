resource "aws_s3_bucket" "bucket" {
  bucket        = "${terraform.workspace}-${var.project_name}-terraform-aws-django"
  force_destroy = true
  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = [aws_lb.production.dns_name, "*.${var.hosted_zone}", "*.amazonaws.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "prod_website" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
               "s3:*"
            ],
            "Resource": [
               "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
            ]
        }
      ]
  }
  POLICY
}
