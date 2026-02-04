# Terraform - Subscription Module

This Terraform module provides all the necessary resources for an application to subscribe to an SNS topic using an SQS queue.

## Usage

Here's a code example of how you can use this module:

```hcl
module "event_subscription" {
  source  = "app.terraform.io/<organization>/subscriber/aws"
  version = "~> 1"

  application_name = "serverless-boilerplate"
  environment      = "development"
  event_name       = "UserActivated"
  lambda_arn       = module.serverless.lambda.arn
}
```
