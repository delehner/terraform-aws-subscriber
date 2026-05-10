resource "aws_sqs_queue_policy" "event_queue_policy" {
  queue_url = aws_sqs_queue.event_queue.id
  policy    = data.aws_iam_policy_document.event_consumer_policy.json
}

resource "aws_sqs_queue_policy" "event_deadletter_queue_policy" {
  queue_url = aws_sqs_queue.event_deadletter_queue.id
  policy    = data.aws_iam_policy_document.event_consumer_policy.json
}

data "aws_iam_policy_document" "event_consumer_policy" {
  statement {
    sid = "Lambda"

    effect = "Allow"

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage"
    ]

    resources = [
      aws_sqs_queue.event_queue.arn,
      aws_sqs_queue.event_deadletter_queue.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [var.lambda_arn]
    }
  }

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
      values   = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.event_name}-${var.environment}.fifo"]
    }
  }
}
