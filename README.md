# Terraform - Subscription Module

This Terraform module provides all the necessary resources for an application to subscribe to an SNS topic using an SQS queue.

## Usage

```hcl
module "event_subscription" {
  source  = "app.terraform.io/<organization>/subscriber/aws"
  version = "~> 1.0"

  application_name = "serverless-boilerplate"
  environment      = "development"
  event_name       = "UserActivated"
  lambda_arn       = module.serverless.lambda.arn
}
```

## Behavior notes

- When `environment = "staging"`, the queue is also subscribed to `<event_name>-production.fifo` so staging consumers receive a copy of production traffic.
- When `environment = "local"`, the Lambda event source mapping is skipped — the queue and DLQ are still created, but no Lambda is wired up.

## Outputs

| Name | Description |
| --- | --- |
| `queue_arn` | ARN of the main SQS FIFO queue. |
| `queue_url` | URL of the main SQS FIFO queue. |
| `queue_name` | Name of the main SQS FIFO queue. |
| `deadletter_queue_arn` | ARN of the dead-letter SQS FIFO queue. |
| `deadletter_queue_url` | URL of the dead-letter SQS FIFO queue. |
| `subscription_arn` | ARN of the SNS to SQS subscription. |
