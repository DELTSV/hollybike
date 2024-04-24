data "aws_iam_policy_document" "bucket_policy_document_frontend" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.bucket_frontend.arn,
      "${aws_s3_bucket.bucket_frontend.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai_frontend.iam_arn]
    }
  }
}

resource "aws_s3_bucket" "bucket_frontend" {
  bucket_prefix = "hollybike-frontend"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_frontend_acl_ownership" {
  bucket = aws_s3_bucket.bucket_frontend.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_s3_bucket_public_access_block" "public_block_frontend" {
  bucket                  = aws_s3_bucket.bucket_frontend.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.bucket_frontend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_frontend_policy" {
  bucket = aws_s3_bucket.bucket_frontend.id
  policy = data.aws_iam_policy_document.bucket_policy_document_frontend.json
}
