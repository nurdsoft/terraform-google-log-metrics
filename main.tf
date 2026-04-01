resource "google_logging_metric" "this" {
  name        = var.metric_name
  project     = var.project_id
  bucket_name = var.bucket_name
  filter      = var.filter
  description = var.description

  metric_descriptor {
    metric_kind  = var.metric_kind
    value_type   = var.value_type
    unit         = var.unit
    display_name = var.display_name

    dynamic "labels" {
      for_each = var.labels
      content {
        key         = labels.value.key
        value_type  = labels.value.value_type
        description = labels.value.description
      }
    }
  }

  label_extractors = var.label_extractors

  dynamic "bucket_options" {
    for_each = var.bucket_options != null ? [var.bucket_options] : []
    content {
      dynamic "linear_buckets" {
        for_each = bucket_options.value.linear_buckets != null ? [bucket_options.value.linear_buckets] : []
        content {
          num_finite_buckets = linear_buckets.value.num_finite_buckets
          width              = linear_buckets.value.width
          offset             = linear_buckets.value.offset
        }
      }

      dynamic "exponential_buckets" {
        for_each = bucket_options.value.exponential_buckets != null ? [bucket_options.value.exponential_buckets] : []
        content {
          num_finite_buckets = exponential_buckets.value.num_finite_buckets
          growth_factor      = exponential_buckets.value.growth_factor
          scale              = exponential_buckets.value.scale
        }
      }

      dynamic "explicit_buckets" {
        for_each = bucket_options.value.explicit_buckets != null ? [bucket_options.value.explicit_buckets] : []
        content {
          bounds = explicit_buckets.value.bounds
        }
      }
    }
  }
}

resource "time_sleep" "wait_for_metric" {
  count = var.wait_for_metric ? 1 : 0

  depends_on = [
    google_logging_metric.this
  ]

  create_duration = var.wait_duration
}
