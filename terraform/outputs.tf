output "api_endpoint" {
  value       = aws_lambda_function_url.api_url.function_url
  description = "public, free url address"
}

output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "ARN for GitHub Actions"
}