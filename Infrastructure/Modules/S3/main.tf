# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

/*===========================
      AWS S3 resources
============================*/

resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}