variable "application_name" {
  type        = string
  description = "Application's name."
}

variable "environment" {
  type        = string
  description = "Environment where the resource is running."
}

variable "event_name" {
  type        = string
  description = "Event's name."
}

variable "lambda_arn" {
  type        = string
  description = "Lambda's ARN."
}

variable "retention_period" {
  type        = number
  default     = 900
  description = "Message retention period."
}

variable "visibility_timeout" {
  type        = number
  default     = 30
  description = "Visibility timeout."
}

variable "receive_count" {
  type        = number
  default     = 4
  description = "Max Receive Count."
}
