variable "region" {
  type = string
}

locals {
  bucket_name = "credit-cards"
}

resource "aws_s3_bucket" "credit_cards_bucket" {
  region        = var.region
  bucket        = local.bucket_name
  acl           = "public-read"
  force_destroy = true

  tags = {
    Scope = "PCI",

  }
}
