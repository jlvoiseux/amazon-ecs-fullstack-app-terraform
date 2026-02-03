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
# Frontend expects: title (string), path (image URL)
locals {
  product_categories = ["Electronics", "Clothing", "Home & Garden", "Sports", "Books", "Toys", "Food", "Beauty", "Automotive", "Health"]
  product_adjectives = ["Premium", "Classic", "Deluxe", "Essential", "Professional", "Compact", "Wireless", "Organic", "Vintage", "Smart"]
  product_nouns      = ["Widget", "Gadget", "Device", "Kit", "Set", "Pack", "Bundle", "Collection", "System", "Tool"]

  products = [
    for i in range(1, 121) : {
      id       = i
      title    = "${local.product_adjectives[i % 10]} ${local.product_nouns[(i + 3) % 10]} ${i}"
      category = local.product_categories[i % 10]
      price    = 9.99 + (i * 2.5)
      path     = "https://picsum.photos/seed/${i}/300/200"
    }
  ]
}

resource "aws_dynamodb_table_item" "products" {
  for_each   = { for p in local.products : p.id => p }
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key

  item = jsonencode({
    id       = { N = tostring(each.value.id) }
    title    = { S = each.value.title }
    category = { S = each.value.category }
    price    = { N = tostring(each.value.price) }
    path     = { S = each.value.path }
  })
}