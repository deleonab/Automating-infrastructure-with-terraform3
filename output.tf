# I addedd the following outputs to output.tf to print them on screen

output "alb_dns_name" {
  value = aws_lb.ext-alb.dns_name
}

output "lb_target_group_arn" {
  value = aws_lb_target_group.nginx-tgt.arn
}
output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}