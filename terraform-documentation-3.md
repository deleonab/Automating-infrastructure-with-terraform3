### The next step is to set up our infrastructure to use S3 as a backend for our state file.

### I enabled versioning so we can see the full revision history of our state files
```
  resource "aws_s3_bucket" "terraform_state" {
  bucket = "dele-dev-terraform-bucket"
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
```
