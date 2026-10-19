# ==============================================================================
# Harness Environment Service Overrides Module - Resource Definition (overrides.tf)
# ==============================================================================

terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
  }
}

resource "harness_platform_environment_service_overrides" "this" {
  org_id     = var.org_id
  project_id = var.project_id
  env_id     = var.env_id
  service_id = var.service_id
  identifier = var.identifier
  yaml       = var.yaml_data
}
