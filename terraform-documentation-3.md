### The next step is to set up our infrastructure to use S3 as a backend for our state file.

### I enabled versioning so we can see the full revision history of our state files
```
  resource "aws_s3_bucket" "terraform_state" {
  bucket = "dele-dev-terraform-bucket-2"
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
### Next, I wcreated a DynamoDB table to handle locks and perform consistency checks. 
### I configured S3 as the backend to store state file and Dynamo DB to handle locking. 


```


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
```


### So, let us run terraform apply to provision resources.
```
terraform apply
```
### We need to have created the S3 bucket and Dynamodb table before configuring the S3 backend below

### Configure S3 Backend
```
terraform {
  backend "s3" {
    bucket         = "dele-dev-terraform-bucket-2"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

![S3 backend success](./images/backend-success.JPG)


### Next, we need to run terraform init ato reinitialise the back end.
```
terraform init
```

### The tfstatefile is now inside the S3 bucket

### The DynamoDB table now has an entry which includes state file status

### Next, I updated the output.tf file so that the S3 bucket Amazon Resource Names ARN and DynamoDB table name can be displayed.

```
output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}
```

### Now, we need to create resources for different environments, such as: Dev, sit, uat, preprod, prod, etc.

### This separation of environments can be achieved using one of two methods:

### a. Terraform Workspaces
### b. Directory based separation using terraform.tfvars file