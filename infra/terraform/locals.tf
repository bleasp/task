locals {
  tags = merge(var.tags, {
    "Environment" = var.environment
  })
}