output "metric_id" {
  description = "The fully-qualified ID of the log-based metric."
  value       = google_logging_metric.this.id
}

output "metric_name" {
  description = "The name of the log-based metric."
  value       = google_logging_metric.this.name
}

output "metric_descriptor_type" {
  description = "The metric descriptor type (e.g. logging.googleapis.com/user/metric_name)."
  value       = google_logging_metric.this.metric_descriptor[0].metric_kind
}
