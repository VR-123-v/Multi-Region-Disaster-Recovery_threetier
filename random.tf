# Generate a random string for bucket uniqueness
resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  special = false
}
