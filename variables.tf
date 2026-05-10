variable "application_name" {
  type        = string
  description = "Application name. Used (initials only) as the queue name prefix."
}

variable "environment" {
  type        = string
  description = "Environment where the resource is deployed (e.g. development, staging, production, local)."
}

variable "event_name" {
  type        = string
  description = "Domain event name (e.g. \"UserActivated\"). Must match the publisher's SNS topic stem."
}

variable "lambda_arn" {
  type        = string
  description = "ARN of the Lambda that consumes the queue. In environment=local, the event source mapping is skipped."
}

variable "retention_period" {
  type        = number
  default     = 900
  description = "SQS message retention period in seconds."
}

variable "visibility_timeout" {
  type        = number
  default     = 30
  description = "SQS visibility timeout in seconds."
}

variable "receive_count" {
  type        = number
  default     = 4
  description = "Maximum redrive attempts before a message is moved to the DLQ."
}
