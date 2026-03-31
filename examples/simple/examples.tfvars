project_id  = "your-project-id"
metric_name = "services_error_count"
filter      = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=~\"service-a|service-b\" AND severity>=ERROR"

labels = [
  {
    key         = "service_name"
    value_type  = "STRING"
    description = "Cloud Run service name"
  }
]

label_extractors = {
  service_name = "EXTRACT(resource.labels.service_name)"
}

wait_for_metric = true
