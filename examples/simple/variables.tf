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
# Optional Overrides — all have sensible defaults in the module
# ------------------------------------------------------------------------------

variable "bucket_name" {
  description = "The log bucket name."
  type        = string
  default     = null
}

variable "metric_kind" {
  description = "The kind of measurement."
  type        = string
  default     = "DELTA"
}

variable "value_type" {
  description = "The type of data."
  type        = string
  default     = "INT64"
}

variable "wait_for_metric" {
  description = "Whether to wait after creating the metric."
  type        = bool
  default     = false
}
