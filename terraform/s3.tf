resource "aws_s3_bucket" "this" {
  bucket = "na0kia-${local.service_name}-alb-log"

  tags = {
    Name = "na0kia-${local.service_name}-alb-log"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    id     = "log"
    status = "Enabled"
    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_elb_service_account.current.id}:root"
          },
          "Action" : "s3:PutObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
        },
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "delivery.logs.amazonaws.com"
          },
          "Action" : "s3:PutObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.this.id}/*",
          "Condition" : {
            "StringEquals" : {
              "s3:x-amz-acl" : "bucket-owner-full-control"
            }
          }
        },
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "delivery.logs.amazonaws.com"
          },
          "Action" : "s3:GetBucketAcl",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.this.id}"
        }
      ]
    }
  )
}

# -------------------------------------------
# S3: クライアントサイドアップロードの画像用S3
# -------------------------------------------
resource "aws_s3_bucket" "hoteler_image_list" {
  bucket = "hoteler-image-list"

  tags = {
    Name = "hoteler-image-list"
  }
}

resource "aws_s3_bucket_policy" "hoteler_image_list_policy" {
  bucket = aws_s3_bucket.hoteler_image_list.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
        ]
        Principal = {
          AWS = "*"
        }
        Resource = "${aws_s3_bucket.hoteler_image_list.arn}/*"
      },
      {
        Effect = "Allow"
        Action = "s3:ListBucket"
        Principal = {
          AWS = "*"
        }
        Resource = aws_s3_bucket.hoteler_image_list.arn
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "hoteler_image_list_cors" {
  bucket = aws_s3_bucket.hoteler_image_list.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://lovehoteler.com", "http://localhost:3000"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}
