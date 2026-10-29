# Only the main queue needs a resource-based policy: SNS must be allowed to
# deliver to it. The Lambda reads through the event source mapping, which uses
# the function's execution role (identity-based policy), so no queue policy
# statement is needed for it. The dead-letter queue is fed by SQS redrive,
# which needs no queue policy either.
resource "aws_sqs_queue_policy" "event_queue_policy" {
  queue_url = aws_sqs_queue.event_queue.id
  policy    = data.aws_iam_policy_document.event_consumer_policy.json
}

locals {
  # Topics the main queue is subscribed to (see sqs.tf). In staging the queue
  # also receives a copy of production traffic, so that topic must be allowed
  # to send as well.
  subscribed_topic_arns = concat(
    ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.event_name}-${var.environment}.fifo"],
    var.environment == "staging" ? ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.event_name}-production.fifo"] : []
  )
}

data "aws_iam_policy_document" "event_consumer_policy" {
  statement {
    sid = "SNS"

    effect = "Allow"

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.event_queue.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = local.subscribed_topic_arns
    }
  }
}
