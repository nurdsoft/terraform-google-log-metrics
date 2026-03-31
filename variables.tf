# ------------------------------------------------------------------------------
# Required
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "The GCP project ID to deploy resources into."
  type        = string
}

variable "metric_name" {
  description = "The name of the log-based metric."
  type        = string
}

variable "filter" {
  description = "The filter to apply when extracting logs for the metric."
  type        = string
}

# ------------------------------------------------------------------------------
# Optional
# ------------------------------------------------------------------------------

variable "bucket_name" {
  description = "The log bucket name. If not provided, uses the default _Default bucket."
  type        = string
  default     = null
}

variable "description" {
  description = "A description of the log-based metric."
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# Metric Descriptor
# ------------------------------------------------------------------------------

variable "metric_kind" {
  description = "The kind of measurement (DELTA, GAUGE, or CUMULATIVE)."
  type        = string
  default     = "DELTA"
}

variable "value_type" {
  description = "The type of data (INT64, DOUBLE, BOOL, STRING, or DISTRIBUTION)."
  type        = string
  default     = "INT64"
}

variable "unit" {
  description = "The unit of measurement."
  type        = string
  default     = null
}

variable "display_name" {
  description = "The display name for the metric descriptor."
  type        = string
  default     = null
}

variable "labels" {
  description = "List of labels for the metric descriptor."
  type = list(object({
    key         = string
    value_type  = string
    description = string
  }))
  default = []
}

variable "label_extractors" {
  description = "Map of label keys to extraction expressions."
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Bucket Options (for DISTRIBUTION value type)
# ------------------------------------------------------------------------------

variable "bucket_options" {
  description = "Bucket options for DISTRIBUTION metrics."
  type = object({
    linear_buckets = optional(object({
      num_finite_buckets = number
      width              = number
      offset             = number
    }))
    exponential_buckets = optional(object({
      num_finite_buckets = number
      growth_factor      = number
      scale              = number
    }))
    explicit_buckets = optional(object({
      bounds = list(number)
    }))
  })
  default = null
}

# ------------------------------------------------------------------------------
# Wait Configuration
# ------------------------------------------------------------------------------

variable "wait_for_metric" {
  description = "Whether to wait after creating the metric before proceeding (useful when creating alert policies that depend on this metric)."
  type        = bool
  default     = false
}

variable "wait_duration" {
  description = "How long to wait after creating the metric (e.g. '60s')."
  type        = string
  default     = "60s"
}
