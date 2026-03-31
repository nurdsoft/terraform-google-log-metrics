output "metric_id" {
  description = "The fully-qualified ID of the log-based metric."
  value       = module.log_metric.metric_id
}

output "metric_name" {
  description = "The name of the log-based metric."
  value       = module.log_metric.metric_name
}

output "metric_descriptor_type" {
  description = "The metric descriptor type."
  value       = module.log_metric.metric_descriptor_type
}
