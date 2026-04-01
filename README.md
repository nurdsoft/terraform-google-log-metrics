# terraform-google-log-metrics

A Terraform module for creating log-based metrics from Cloud Logging filters for custom monitoring and alerting in Google Cloud Platform.

## Features

- Create log-based metrics from Cloud Logging queries
- Support for metric labels and label extractors
- Configurable metric types (DELTA, GAUGE, CUMULATIVE)
- Support for DISTRIBUTION metrics with bucket options
- Built-in wait functionality for dependent resources
- Automatic metric descriptor configuration

---

## Assumptions

The project assumes the following:

- A basic understanding of [Git](https://git-scm.com/).
- Git version `>= 2.33.0`.
- An existing GCP IAM user or role with access to create/update/delete resources defined in [main.tf](https://github.com/nurdsoft/terraform-google-log-metrics/blob/main/main.tf).
- [GCloud CLI](https://cloud.google.com/sdk/docs/install) `>= 465.0.0`.
- A basic understanding of [Terraform](https://www.terraform.io/).
- Terraform version `>= 1.3.0`.
- (Optional - for local testing) A basic understanding of [Make](https://www.gnu.org/software/make/manual/make.html#Introduction).
  - Make version `>= GNU Make 3.81`.
  - **Important Note**: This project includes a [Makefile](https://github.com/nurdsoft/terraform-google-log-metrics/blob/main/Makefile) to speed up local development in Terraform. The `make` targets act as a wrapper around Terraform commands. As such, `make` has only been tested/verified on **Linux/Mac OS**. Though, it is possible to [install make using Chocolatey](https://community.chocolatey.org/packages/make), we **do not** guarantee this approach as it has not been tested/verified. You may use the commands in the [Makefile](https://github.com/nurdsoft/terraform-google-log-metrics/blob/main/Makefile) as a guide to run each Terraform command locally on Windows.

---

## Test

**Important Note**: This project includes a [Makefile](https://github.com/nurdsoft/terraform-google-log-metrics/blob/main/Makefile) to speed up local development in Terraform. The `make` targets act as a wrapper around Terraform commands. As such, `make` has only been tested/verified on **Linux/Mac OS**. Though, it is possible to [install make using Chocolatey](https://community.chocolatey.org/packages/make), we **do not** guarantee this approach as it has not been tested/verified. You may use the commands in the [Makefile](https://github.com/nurdsoft/terraform-google-log-metrics/blob/main/Makefile) as a guide to run each Terraform command locally on Windows.

```sh
gcloud init # https://cloud.google.com/docs/authentication/gcloud
gcloud auth application-default login

# Copy the example tfvars and customize it
cp examples/simple/examples.tfvars examples/simple/terraform.tfvars
# Edit terraform.tfvars with your values

# Run terraform commands
make plan SVC=simple
make apply SVC=simple
make destroy SVC=simple
```

---

## Contributions

Contributions are always welcome. As such, this project uses the `main` branch as the source of truth to track changes.

**Step 1**. Clone this project.

```sh
# Using SSH
$ git clone git@github.com:nurdsoft/terraform-google-log-metrics.git

# Using HTTPS
$ git clone https://github.com/nurdsoft/terraform-google-log-metrics.git
```

**Step 2**. Checkout a feature branch: `git checkout -b feature/abc`.

**Step 3**. Validate the change/s locally by executing the steps defined under [Test](#test).

**Step 4**. If testing is successful, commit and push the new change/s to the remote.

```sh
$ git add file1 file2 ...

$ git commit -m "Adding some change"

$ git push --set-upstream origin feature/abc
```

**Step 5**. Once pushed, create a [PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) and assign it to a member for review.

- **Important Note**: It can be helpful to attach the `terraform plan` output in the PR.

**Step 6**. A team member reviews/approves/merges the change/s.

**Step 7**. Once merged, deploy the required changes as needed.

**Step 8**. Once deployed, verify that the changes have been deployed.

- If possible, please add a `plan` output using the feature branch so the member reviewing the PR has better visibility into the changes.

---

## Usage

```hcl
module "log_metric" {
  source = "git::https://github.com/nurdsoft/terraform-google-log-metrics.git?ref=main"

  project_id  = "my-project"
  metric_name = "custom_error_count"
  filter      = "resource.type=\"cloud_run_revision\" AND severity>=ERROR"

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
}
```

## Examples

| Example | Description |
|---|---|
| [simple](./examples/simple) | Create a log-based metric for Cloud Run ERROR logs with service name labels |

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.3 |
| google | >= 5.0 |
| time | >= 0.9 |

## Providers

| Name | Version |
|---|---|
| [google](https://registry.terraform.io/providers/hashicorp/google/latest) | >= 5.0 |
| [time](https://registry.terraform.io/providers/hashicorp/time/latest) | >= 0.9 |

## Inputs

### Required

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `project_id` | The GCP project ID to deploy resources into | `string` | n/a | yes |
| `metric_name` | The name of the log-based metric | `string` | n/a | yes |
| `filter` | The filter to apply when extracting logs for the metric | `string` | n/a | yes |

### Optional

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `bucket_name` | The log bucket name. If not provided, uses the default _Default bucket | `string` | `null` | no |
| `description` | A description of the log-based metric | `string` | `null` | no |
| `metric_kind` | The kind of measurement (DELTA, GAUGE, or CUMULATIVE) | `string` | `"DELTA"` | no |
| `value_type` | The type of data (INT64, DOUBLE, BOOL, STRING, or DISTRIBUTION) | `string` | `"INT64"` | no |
| `unit` | The unit of measurement | `string` | `null` | no |
| `display_name` | The display name for the metric descriptor | `string` | `null` | no |
| `labels` | List of labels for the metric descriptor | `list(object)` | `[]` | no |
| `label_extractors` | Map of label keys to extraction expressions | `map(string)` | `{}` | no |
| `bucket_options` | Bucket options for DISTRIBUTION metrics | `object` | `null` | no |
| `wait_for_metric` | Whether to wait after creating the metric before proceeding | `bool` | `false` | no |
| `wait_duration` | How long to wait after creating the metric (e.g. '60s') | `string` | `"60s"` | no |

## Outputs

| Name | Description |
|---|---|
| `metric_id` | The fully-qualified ID of the log-based metric |
| `metric_name` | The name of the log-based metric |
| `metric_descriptor_type` | The metric descriptor type |

## Authors

Module is maintained by [Nurdsoft](https://github.com/nurdsoft).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/nurdsoft/terraform-google-log-metrics/blob/main/LICENSE) for full details.
