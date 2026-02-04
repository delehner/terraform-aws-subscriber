output "event_queue" {
  value       = aws_sqs_queue.event_queue
  description = "Event queue for the event."
}

output "event_deadletter_queue" {
  value       = aws_sqs_queue.event_deadletter_queue
  description = "Event deadletter queue for the event."
}

output "event_subscription" {
  value       = aws_sns_topic_subscription.event_subscription
  description = "Event SNS subscription."
}
