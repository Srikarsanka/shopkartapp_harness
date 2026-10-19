# ==============================================================================
# Harness Service Module - Resource Definition (services.tf)
# ==============================================================================

resource "harness_platform_service" "this" {
  identifier = var.identifier
  name       = var.name
  org_id     = var.org_id
  project_id = var.project_id
  yaml       = var.yaml_data
  tags       = var.tags
}
