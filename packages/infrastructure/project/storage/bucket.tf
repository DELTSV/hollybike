data "aws_iam_policy_document" "bucket_policy_document_application_storage" {
  statement {
    actions   = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.application_storage.arn,
      "${aws_s3_bucket.application_storage.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_oai_iam_arn]
    }
  }
}


resource "aws_s3_bucket" "application_storage" {
  bucket_prefix = "hollybike-application-storage"
  force_destroy = false
}

resource "aws_s3_bucket_ownership_controls" "application_storage_acl_ownership" {
  bucket = aws_s3_bucket.application_storage.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_s3_bucket_public_access_block" "public_block_application_storage" {
  bucket                  = aws_s3_bucket.application_storage.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.application_storage.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_frontend_policy" {
  bucket = aws_s3_bucket.application_storage.id
  policy = data.aws_iam_policy_document.bucket_policy_document_application_storage.json
}
