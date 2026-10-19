# ==============================================================================
# Harness Pipeline Module - Resource Definition (pipelines.tf)
# ==============================================================================

resource "harness_platform_pipeline" "this" {
  identifier = var.identifier
  name       = var.name
  org_id     = var.org_id
  project_id = var.project_id
  yaml       = var.yaml_data
  tags       = var.tags
}
