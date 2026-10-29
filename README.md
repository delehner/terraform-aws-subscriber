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
- The SNS topic is not created here: the queue subscribes to `arn:aws:sns:<region>:<account>:<event_name>-<environment>.fifo` in the current account and region, which the publisher must create.
- The main queue gets a resource-based policy that only allows `sns.amazonaws.com` to `sqs:SendMessage`, restricted to the subscribed topic(s). The DLQ has no queue policy (SQS redrive needs none).
- The Lambda reads the queue through its **execution role**, not through the queue policy. That role must allow `sqs:ReceiveMessage`, `sqs:DeleteMessage` and `sqs:GetQueueAttributes` on the queue (the role created by the `serverless` module already does).

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `application_name` | `string` | n/a | Application name. Used (initials only) as the queue name prefix. |
| `environment` | `string` | n/a | Environment where the resource is deployed (e.g. development, staging, production, local). |
| `event_name` | `string` | n/a | Domain event name (e.g. `UserActivated`). Must match the publisher's SNS topic stem. |
| `lambda_arn` | `string` | n/a | ARN of the Lambda that consumes the queue. In `environment = "local"`, the event source mapping is skipped. |
| `retention_period` | `number` | `900` | SQS message retention period in seconds. |
| `visibility_timeout` | `number` | `30` | SQS visibility timeout in seconds. |
| `receive_count` | `number` | `4` | Maximum redrive attempts before a message is moved to the DLQ. |

## Outputs

| Name | Description |
| --- | --- |
| `queue_arn` | ARN of the main SQS FIFO queue. |
| `queue_url` | URL of the main SQS FIFO queue. |
| `queue_name` | Name of the main SQS FIFO queue. |
| `deadletter_queue_arn` | ARN of the dead-letter SQS FIFO queue. |
| `deadletter_queue_url` | URL of the dead-letter SQS FIFO queue. |
| `subscription_arn` | ARN of the SNS to SQS subscription. |
