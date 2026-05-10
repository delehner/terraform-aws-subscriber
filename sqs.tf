locals {
  application_initials = join("", [for word in split("-", var.application_name) : substr(word, 0, 1)])
}

resource "aws_sqs_queue" "event_queue" {
  name                        = "${local.application_initials}-${var.event_name}-${var.environment}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  message_retention_seconds   = var.retention_period
  visibility_timeout_seconds  = var.visibility_timeout

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.event_deadletter_queue.arn,
    maxReceiveCount     = var.receive_count
  })

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_sqs_queue" "event_deadletter_queue" {
  name                        = "${local.application_initials}-${var.event_name}-${var.environment}-deadletter.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  message_retention_seconds   = var.retention_period
  visibility_timeout_seconds  = var.visibility_timeout

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_sns_topic_subscription" "event_subscription" {
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.event_name}-${var.environment}.fifo"
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.event_queue.arn
}

resource "aws_sns_topic_subscription" "event_subscription_production" {
  count = var.environment == "staging" ? 1 : 0

  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.event_name}-production.fifo"
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.event_queue.arn
}

resource "aws_lambda_event_source_mapping" "event_queue" {
  count = var.environment == "local" ? 0 : 1

  event_source_arn = aws_sqs_queue.event_queue.arn
  function_name    = var.lambda_arn
}
