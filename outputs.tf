output "queue_arn" {
  value       = aws_sqs_queue.event_queue.arn
  description = "ARN of the main SQS FIFO queue."
}

output "queue_url" {
  value       = aws_sqs_queue.event_queue.url
  description = "URL of the main SQS FIFO queue."
}

output "queue_name" {
  value       = aws_sqs_queue.event_queue.name
  description = "Name of the main SQS FIFO queue."
}

output "deadletter_queue_arn" {
  value       = aws_sqs_queue.event_deadletter_queue.arn
  description = "ARN of the dead-letter SQS FIFO queue."
}

output "deadletter_queue_url" {
  value       = aws_sqs_queue.event_deadletter_queue.url
  description = "URL of the dead-letter SQS FIFO queue."
}

output "subscription_arn" {
  value       = aws_sns_topic_subscription.event_subscription.arn
  description = "ARN of the SNS to SQS subscription."
}
