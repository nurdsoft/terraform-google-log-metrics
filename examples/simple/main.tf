# -----------------------------------------------------------------------------
# Example: Log-Based Metric
#
# This example shows how to create a log-based metric that counts ERROR logs
# from Cloud Run services.
# -----------------------------------------------------------------------------
module "log_metric" {
  source = "git::https://github.com/nurdsoft/terraform-google-log-metrics.git?ref=v1.0.0"

  project_id       = var.project_id
  metric_name      = var.metric_name
  filter           = var.filter
  labels           = var.labels
  label_extractors = var.label_extractors
  wait_for_metric  = var.wait_for_metric
}
