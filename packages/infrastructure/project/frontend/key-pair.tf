resource "aws_cloudfront_public_key" "cf_key" {
  name        = "object-signing-key"
  comment     = "Object Link Public Key"
  encoded_key = jsondecode(var.cf_key_json_output).publicKey
}

resource "aws_cloudfront_key_group" "object_signing_key_group" {
  comment = "Valid Object Signing Keys"
  items = [
    aws_cloudfront_public_key.cf_key.id
  ]
  name = "object-keys"
}