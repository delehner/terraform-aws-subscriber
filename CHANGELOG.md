# Changelog

## v1.0.1

### Fixed
- Queue policy no longer has the `Lambda` statement, which had no `Principal`. SQS resource-based policies require a `Principal`, so `aws_sqs_queue_policy` failed on apply with `InvalidAttributeValue` (the plan did not catch it). The statement was also unnecessary: the Lambda event source mapping reads the queue with the function's execution role, which must grant `sqs:ReceiveMessage`, `sqs:DeleteMessage` and `sqs:GetQueueAttributes` (the `terraform-aws-serverless` role already does).
- In `environment = "staging"`, the queue policy now also allows the `<event_name>-production.fifo` topic to send messages. The module already subscribes the staging queue to that topic, but the policy only allowed the staging topic, so SNS deliveries from production were denied.

### Removed
- `aws_sqs_queue_policy.event_deadletter_queue_policy`. The dead-letter queue is fed by SQS redrive and needs no resource-based policy; its only content was the invalid statement above (plus an SNS statement scoped to the main queue). Because the policy could never be applied, no consumer has this resource in state and nothing is destroyed.

### Notes
- No interface change: same variables, same outputs. Consumers on `~> 1` / `~> 1.0` pick it up on the next `terraform init -upgrade`.
- IAM change: the main queue policy is now a single `SNS` statement (`sqs:SendMessage` from `sns.amazonaws.com`, restricted by `aws:SourceArn` to the subscribed topic(s)).

## v1.0.0
- Flatten outputs, tighten variable docs, and refresh README.

## v0.0.1
- Initial release.
