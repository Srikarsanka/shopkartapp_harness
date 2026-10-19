terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
  }
}

resource "harness_platform_triggers" "this" {
  identifier = var.identifier
  name       = var.name
  org_id     = var.org_id
  project_id = var.project_id
  target_id  = var.target_id
  yaml       = var.yaml_data
  tags       = var.tags
}
