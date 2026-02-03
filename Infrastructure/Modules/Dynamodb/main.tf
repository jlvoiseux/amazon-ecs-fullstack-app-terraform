# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

/*=======================================
      Amazon Dynamodb resources
========================================*/

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key
  range_key    = var.range_key

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
}

# Seed the table with sample products
locals {
  product_categories = ["Electronics", "Clothing", "Home & Garden", "Sports", "Books", "Toys", "Food", "Beauty", "Automotive", "Health"]
  product_adjectives = ["Premium", "Classic", "Deluxe", "Essential", "Professional", "Compact", "Wireless", "Organic", "Vintage", "Smart"]
  product_nouns      = ["Widget", "Gadget", "Device", "Kit", "Set", "Pack", "Bundle", "Collection", "System", "Tool"]

  products = [
    for i in range(1, 121) : {
      id          = i
      name        = "${local.product_adjectives[i % 10]} ${local.product_nouns[(i + 3) % 10]} ${i}"
      category    = local.product_categories[i % 10]
      price       = 9.99 + (i * 2.5)
      description = "High-quality ${lower(local.product_adjectives[i % 10])} ${lower(local.product_nouns[(i + 3) % 10])} for all your needs. Product #${i}."
      inStock     = i % 5 != 0
    }
  ]
}

resource "aws_dynamodb_table_item" "products" {
  for_each   = { for p in local.products : p.id => p }
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key

  item = jsonencode({
    id          = { N = tostring(each.value.id) }
    name        = { S = each.value.name }
    category    = { S = each.value.category }
    price       = { N = tostring(each.value.price) }
    description = { S = each.value.description }
    inStock     = { BOOL = each.value.inStock }
  })
}